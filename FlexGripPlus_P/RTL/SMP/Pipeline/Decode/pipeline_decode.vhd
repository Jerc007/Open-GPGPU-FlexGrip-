----------------------------------------------------------------------------------
-- Company:          Univerity of Massachusetts
-- Engineer:         Kevin Andryc
--
-- Create Date:      17:50:27 09/19/2010
-- Module Name:      pipeline_decode - arch
-- Project Name:     GPGPU
-- Target Devices:
-- Tool versions:    ISE 10.1
-- Description:
--
----------------------------------------------------------------------------
-- Revisions:
--  REV:        Date:           Description:
--  0.1.a       9/13/2010       Created Top level file
----------------------------------------------------------------------------
-- [Boyang Du] [TODO]
-- 1. [DONE] Change sync reset to async
----------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.gpgpu_package.all;

entity pipeline_decode is
  generic(
    SHMEM_ADDR_SIZE : integer := 14
    );
  port(
    reset                 : in  std_logic;
    clk_in                : in  std_logic;
    pipeline_stall_in     : in  std_logic;  -- from next stage
    pipeline_fetch_done   : in  std_logic;  -- from prev stage
    -- input from fetch stage
    program_cntr_in       : in  std_logic_vector(31 downto 0);
    warp_id_in            : in  std_logic_vector(4 downto 0);
    warp_lane_id_in       : in  std_logic_vector(1 downto 0);
    cta_id_in             : in  std_logic_vector(3 downto 0);
    initial_mask_in       : in  std_logic_vector(31 downto 0);
    current_mask_in       : in  std_logic_vector(31 downto 0);
    shmem_base_addr_in    : in  std_logic_vector(SHMEM_ADDR_SIZE - 1 downto 0);
    gprs_size_in          : in  std_logic_vector(8 downto 0);
    gprs_base_addr_in     : in  std_logic_vector(8 downto 0);
    next_pc_in            : in  std_logic_vector(31 downto 0);
    instruction_in        : in  std_logic_vector(63 downto 0);
    -- outputs to read stage
    program_cntr_out      : out std_logic_vector(31 downto 0);
    warp_id_out           : out std_logic_vector(4 downto 0);
    warp_lane_id_out      : out std_logic_vector(1 downto 0);
    cta_id_out            : out std_logic_vector(3 downto 0);
    initial_mask_out      : out std_logic_vector(31 downto 0);
    current_mask_out      : out std_logic_vector(31 downto 0);
    shmem_base_addr_out   : out std_logic_vector(SHMEM_ADDR_SIZE - 1 downto 0);
    gprs_size_out         : out std_logic_vector(8 downto 0);
    gprs_base_addr_out    : out std_logic_vector(8 downto 0);
    next_pc_out           : out std_logic_vector(31 downto 0);
    -- [FIXME] outputs for read stage
    instr_opcode_out      : out instr_opcode_type;
    instr_subop_out       : out std_logic_vector(2 downto 0);
    alu_opcode_out        : out alu_opcode_type;
    mov_opcode_out        : out mov_opcode_type;
    flow_opcode_out       : out flow_opcode_type;
    instr_marker_out      : out instr_marker_type;
    instr_src1_shared_out : out std_logic;
    instr_src2_const_out  : out std_logic;
    instr_src3_const_out  : out std_logic;
    pred_reg_out          : out std_logic_vector(1 downto 0);
    pred_cond_out         : out std_logic_vector(4 downto 0);
    set_pred_out          : out std_logic;
    set_pred_reg_out      : out std_logic_vector(1 downto 0);
    output_reg_out        : out std_logic;
    write_pred_out        : out std_logic;
    is_signed_out         : out std_logic;
    w32_out               : out std_logic;
    f64_out               : out std_logic;
    saturate_out          : out std_logic;
    abs_saturate_out      : out std_logic_vector(1 downto 0);
    cvt_round_out         : out std_logic_vector(1 downto 0);
    cvt_type_out          : out std_logic_vector(2 downto 0);
    cvt_neg_out           : out std_logic;
    condition_out         : out std_logic_vector(2 downto 0);
    addr_hi_out           : out std_logic;
    addr_lo_out           : out std_logic_vector(1 downto 0);
    addr_reg_out          : out std_logic_vector(2 downto 0);
    addr_incr_out         : out std_logic;
    mov_size_out          : out std_logic_vector(2 downto 0);
    alt_out               : out std_logic;
    mem_type_out          : out std_logic_vector(2 downto 0);
    sm_type_out           : out std_logic_vector(1 downto 0);
    imm_hi_out            : out std_logic_vector(25 downto 0);
    addr_imm_out          : out std_logic;
    src1_shared_out       : out std_logic;
    src1_mem_type_out     : out mem_type;
    src2_mem_type_out     : out mem_type;
    src3_mem_type_out     : out mem_type;
    dest_mem_type_out     : out mem_type;
    src1_mem_opcode_out   : out mem_opcode_type;
    src2_mem_opcode_out   : out mem_opcode_type;
    src3_mem_opcode_out   : out mem_opcode_type;
    dest_mem_opcode_out   : out mem_opcode_type;
    src1_neg_out          : out std_logic;
    src2_neg_out          : out std_logic;
    src3_neg_out          : out std_logic;
    target_addr_out       : out std_logic_vector(18 downto 0);
    src1_data_type_out    : out data_type;
    src2_data_type_out    : out data_type;
    src3_data_type_out    : out data_type;
    dest_data_type_out    : out data_type;
    src1_out              : out std_logic_vector(31 downto 0);
    src2_out              : out std_logic_vector(31 downto 0);
    src3_out              : out std_logic_vector(31 downto 0);
    dest_out              : out std_logic_vector(31 downto 0);
    pipeline_stall_out    : out std_logic;
    pipeline_dec_done     : out std_logic
    );
end pipeline_decode;

architecture arch of pipeline_decode is

  type dec_state_type is (IDLE,  -- decode stage is either IDLE the instruction from fetch stage
                          STALL         -- or it is stalled
                          );
  signal dec_state_machine : dec_state_type;

  signal instr_opcode_i      : instr_opcode_type;
  signal alu_opcode_i        : alu_opcode_type;
  signal mov_opcode_i        : mov_opcode_type;
  signal flow_opcode_i       : flow_opcode_type;
  signal instr_marker_i      : instr_marker_type;
  signal instr_src1_shared_i : std_logic;
  signal instr_src2_const_i  : std_logic;
  signal instr_src3_const_i  : std_logic;
  signal pred_reg_i          : std_logic_vector(1 downto 0);
  signal pred_cond_i         : std_logic_vector(4 downto 0);
  signal set_pred_i          : std_logic;
  signal set_pred_reg_i      : std_logic_vector(1 downto 0);
  signal output_reg_i        : std_logic;
  signal write_pred_i        : std_logic;
  signal is_signed_i         : std_logic;
  signal w32_i               : std_logic;
  signal f64_i               : std_logic;
  signal saturate_i          : std_logic;
  signal abs_saturate_i      : std_logic_vector(1 downto 0);
  signal cvt_round_i         : std_logic_vector(1 downto 0);
  signal cvt_type_i          : std_logic_vector(2 downto 0);
  signal cvt_neg_i           : std_logic;
  signal condition_i         : std_logic_vector(2 downto 0);
  signal addr_hi_i           : std_logic;
  signal addr_lo_i           : std_logic_vector(1 downto 0);
  signal addr_reg_i          : std_logic_vector(2 downto 0);
  signal addr_incr_i         : std_logic;
  signal mov_size_i          : std_logic_vector(2 downto 0);
  signal mem_type_i          : std_logic_vector(2 downto 0);
  signal sm_type_i           : std_logic_vector(1 downto 0);
  signal imm_hi_i            : std_logic_vector(25 downto 0);
  signal addr_imm_i          : std_logic;
  signal src1_mem_type_i     : mem_type;
  signal src2_mem_type_i     : mem_type;
  signal src3_mem_type_i     : mem_type;
  signal dest_mem_type_i     : mem_type;
  signal src1_mem_opcode_i   : mem_opcode_type;
  signal src2_mem_opcode_i   : mem_opcode_type;
  signal src3_mem_opcode_i   : mem_opcode_type;
  signal dest_mem_opcode_i   : mem_opcode_type;
  signal src1_neg_i          : std_logic;
  signal src2_neg_i          : std_logic;
  signal src3_neg_i          : std_logic;
  signal target_addr_i       : std_logic_vector(18 downto 0);
  signal src1_data_type_i    : data_type;
  signal src2_data_type_i    : data_type;
  signal src3_data_type_i    : data_type;
  signal dest_data_type_i    : data_type;
  signal src1_i              : std_logic_vector(31 downto 0);
  signal src2_i              : std_logic_vector(31 downto 0);
  signal src3_i              : std_logic_vector(31 downto 0);
  signal dest_i              : std_logic_vector(31 downto 0);

  signal instr_opcode_b    : std_logic_vector(3 downto 0);
  signal instr_subop_b     : std_logic_vector(2 downto 0);
  signal instr_marker_b    : std_logic_vector(1 downto 0);
  signal instr_is_flow_b   : std_logic;
  signal instr_is_long_b   : std_logic;
  signal logic_type_b      : std_logic_vector(1 downto 0);
  signal is_carry_b        : std_logic;
  signal is_full_marker_b  : std_logic;
  signal addr_hi_i_3       : std_logic_vector(2 downto 0);
  signal src2_use_gather_b : std_logic;

  signal reg_to_data_type      : data_type;
  signal mov_size_to_data_type : data_type;
  signal data_type_mov_size_i  : data_type;
  signal sm_type_to_data_type  : data_type;
  signal cvt_type_to_data_type : data_type;
  signal subop_to_data_type    : data_type;
  signal mov_mem_type_i        : mem_type;



begin



  pDecode : process(clk_in, reset)
  begin
    if (reset = '1') then
      program_cntr_out    <= (others => '0');
      warp_id_out         <= (others => '0');
      warp_lane_id_out    <= (others => '0');
      cta_id_out          <= (others => '0');
      initial_mask_out    <= (others => '0');
      current_mask_out    <= (others => '0');
      shmem_base_addr_out <= (others => '0');
      gprs_size_out       <= (others => '0');
      gprs_base_addr_out  <= (others => '0');
      next_pc_out         <= (others => '0');

      instr_opcode_out      <= NOP;
      instr_subop_out       <= (others => '0');
      alu_opcode_out        <= UNKNOWN;
      mov_opcode_out        <= UNKNOWN;
      flow_opcode_out       <= UNKNOWN;
      instr_marker_out      <= UNKNOWN;
      instr_src1_shared_out <= '0';
      instr_src2_const_out  <= '0';
      instr_src3_const_out  <= '0';
      pred_reg_out          <= (others => '0');
      pred_cond_out         <= (others => '0');
      set_pred_out          <= '0';
      set_pred_reg_out      <= (others => '0');
      output_reg_out        <= '0';
      write_pred_out        <= '0';
      is_signed_out         <= '0';
      w32_out               <= '0';
      f64_out               <= '0';
      saturate_out          <= '0';
      abs_saturate_out      <= (others => '0');
      cvt_round_out         <= (others => '0');
      cvt_type_out          <= (others => '0');
      cvt_neg_out           <= '0';
      condition_out         <= (others => '0');
      addr_hi_out           <= '0';     -- hi part of a register
      addr_lo_out           <= (others => '0');
      addr_reg_out          <= (others => '0');
      addr_incr_out         <= '0';
      mov_size_out          <= (others => '0');
      alt_out               <= '0';
      mem_type_out          <= (others => '0');
      sm_type_out           <= (others => '0');
      imm_hi_out            <= (others => '0');
      addr_imm_out          <= '0';
      src1_shared_out       <= '0';
      src1_mem_type_out     <= UNKNOWN;
      src2_mem_type_out     <= UNKNOWN;
      src3_mem_type_out     <= UNKNOWN;
      dest_mem_type_out     <= UNKNOWN;
      src1_mem_opcode_out   <= READ;
      src2_mem_opcode_out   <= READ;
      src3_mem_opcode_out   <= READ;
      dest_mem_opcode_out   <= READ;
      src1_neg_out          <= '0';
      src2_neg_out          <= '0';
      src3_neg_out          <= '0';
      target_addr_out       <= (others => '0');
      src1_data_type_out    <= DT_NONE;
      src2_data_type_out    <= DT_NONE;
      src3_data_type_out    <= DT_NONE;
      dest_data_type_out    <= DT_NONE;
      src1_out              <= (others => '0');
      src2_out              <= (others => '0');
      src3_out              <= (others => '0');
      dest_out              <= (others => '0');
      pipeline_stall_out    <= '0';

      pipeline_stall_out <= '0';
      pipeline_dec_done  <= '0';
      dec_state_machine  <= IDLE;
    elsif (rising_edge(clk_in)) then
      case dec_state_machine is
        when IDLE =>
          pipeline_dec_done <= '0';
          if(pipeline_fetch_done = '1') then
            dec_state_machine  <= STALL;  -- DECODING is done simultaneously
            pipeline_stall_out <= '1';
          else
            dec_state_machine <= IDLE;
          end if;
        when STALL =>
          if(pipeline_stall_in = '0') then
                                          -- NO STALL, register all data to output
            program_cntr_out    <= program_cntr_in;
            warp_id_out         <= warp_id_in;
            warp_lane_id_out    <= warp_lane_id_in;
            cta_id_out          <= cta_id_in;
            initial_mask_out    <= initial_mask_in;
            current_mask_out    <= current_mask_in;
            shmem_base_addr_out <= shmem_base_addr_in;
            gprs_size_out       <= gprs_size_in;
            gprs_base_addr_out  <= gprs_base_addr_in;
            next_pc_out         <= next_pc_in;

            instr_opcode_out      <= instr_opcode_i;
            instr_subop_out       <= instr_subop_b;
            alu_opcode_out        <= alu_opcode_i;
            mov_opcode_out        <= mov_opcode_i;
            flow_opcode_out       <= flow_opcode_i;
            instr_subop_out       <= instr_subop_b;
            instr_marker_out      <= instr_marker_i;
            instr_src1_shared_out <= instr_src1_shared_i;
            instr_src2_const_out  <= instr_src2_const_i;
            instr_src3_const_out  <= instr_src3_const_i;
            pred_reg_out          <= pred_reg_i;
            pred_cond_out         <= pred_cond_i;
            set_pred_out          <= set_pred_i;
            set_pred_reg_out      <= set_pred_reg_i;
            output_reg_out        <= output_reg_i;
            write_pred_out        <= write_pred_i;
            is_signed_out         <= is_signed_i;
            w32_out               <= w32_i;
            f64_out               <= f64_i;
            saturate_out          <= saturate_i;
            abs_saturate_out      <= abs_saturate_i;
            cvt_round_out         <= cvt_round_i;
            cvt_type_out          <= cvt_type_i;
            cvt_neg_out           <= cvt_neg_i;
            condition_out         <= condition_i;
            addr_hi_out           <= addr_hi_i;
            addr_lo_out           <= addr_lo_i;
            addr_reg_out          <= addr_reg_i;
            addr_incr_out         <= addr_incr_i;
            mov_size_out          <= mov_size_i;
            mem_type_out          <= mem_type_i;
            sm_type_out           <= sm_type_i;
            imm_hi_out            <= imm_hi_i;
            addr_imm_out          <= addr_imm_i;
            src1_mem_type_out     <= src1_mem_type_i;
            src2_mem_type_out     <= src2_mem_type_i;
            src3_mem_type_out     <= src3_mem_type_i;
            dest_mem_type_out     <= dest_mem_type_i;
            src1_mem_opcode_out   <= src1_mem_opcode_i;
            src2_mem_opcode_out   <= src2_mem_opcode_i;
            src3_mem_opcode_out   <= src3_mem_opcode_i;
            dest_mem_opcode_out   <= dest_mem_opcode_i;
            src1_neg_out          <= src1_neg_i;
            src2_neg_out          <= src2_neg_i;
            src3_neg_out          <= src3_neg_i;
            target_addr_out       <= target_addr_i;
            src1_data_type_out    <= src1_data_type_i;
            src2_data_type_out    <= src2_data_type_i;
            src3_data_type_out    <= src3_data_type_i;
            dest_data_type_out    <= dest_data_type_i;
            src1_out              <= src1_i;
            src2_out              <= src2_i;
            src3_out              <= src3_i;
            dest_out              <= dest_i;

            pipeline_dec_done  <= '1';  -- signal next stage
            pipeline_stall_out <= '0';  -- signal previous stage
            dec_state_machine  <= IDLE;
          else
            pipeline_stall_out <= '1';  -- signal previous stage
            dec_state_machine  <= STALL;
          end if;
      end case;
    end if;
  end process;

  instr_subop_b   <= instruction_in(63 downto 61);  -- ok
  logic_type_b    <= instruction_in(47 downto 46);  -- ok
  instr_marker_b  <= instruction_in(33 downto 32);  -- ok
  instr_opcode_b  <= instruction_in(31 downto 28);  -- ok
  instr_is_flow_b <= instruction_in(1);             -- ok
  instr_is_long_b <= instruction_in(0);             -- ok

  instr_src1_shared_i <= instruction_in(13) when ((instr_opcode_i = ALU) and(instr_marker_i = IMM) and (alu_opcode_i = IMAD24) and (instr_is_long_b = '1'))
                    -- MODIFIED GIANLUCA ROASCIO - WHEN THE INSTRUCTION SUPPORTS AN IMMEDIATE OPERAND, FLAGS FROM THE HIGHER PART OF THE INSTRUCTIONS ARE NOT TO BE READ
                    --else instruction_in(53) when (instr_is_long_b = '1')
                    else instruction_in(53) when (instr_is_long_b = '1' and instr_marker_i /= IMM)
                    --ADDED FPU
                    else instruction_in(24) when ((instr_opcode_i = ALU) and ((alu_opcode_i = FADD) or (alu_opcode_i = FMUL)) and (instr_is_long_b = '0'))  -- global memory enabler for short float instructions
                    else instruction_in(53) when ((instr_opcode_i = ALU) and ((alu_opcode_i = FADD) or (alu_opcode_i = FMUL) or (alu_opcode_i = FMAD)) and (instr_marker_i /= IMM) and (instr_is_long_b = '1'))  -- global memory enabler for long float instructions
                    else instruction_in(24);

  -- MODIFIED GIANLUCA ROASCIO - FOR MAKING IADD WORKING ALSO WITH SECOND OPERAND FROM CMEM
  --instr_src2_const_i <= instruction_in(23);                   --ok
  instr_src2_const_i <= instruction_in(24) when (instr_opcode_i = ALU and alu_opcode_i = IADD and instr_is_long_b = '1' and instr_marker_i /= IMM)
                        --ADDED FPU
                        else instruction_in(24) when ((instr_opcode_i = ALU) and (alu_opcode_i = FADD) and (instr_is_long_b = '1') and (instr_marker_i /= IMM))  -- constant memory enabler only for long/ no immediate add
                        else instruction_in(54) when ((instr_opcode_i = ALU) and ((alu_opcode_i = FMUL) or (alu_opcode_i = FMAD) or (alu_opcode_i = FSET)) and (instr_marker_i /= IMM) and (instr_is_long_b = '1'))
                        else instruction_in(23);



  instr_src3_const_i <= instruction_in(22) when ((instr_opcode_i = ALU) and (instr_marker_i = IMM) and (alu_opcode_i = IMAD24) and (instr_is_long_b = '1'))
                        --ADDED FPU
                        else (instruction_in(54) and instruction_in(24)) when ((instr_opcode_i = ALU) and (alu_opcode_i = FMAD) and (instr_marker_i /= IMM) and (instr_is_long_b = '1'))  -- in case of fmad, 3rd op cmem and 2nd op cmem are on the same enabler
                        else instruction_in(24);

  -- MODIFIED GIANLUCA ROASCIO - WHEN THE INSTRUCTION SUPPORTS AN IMMEDIATE OPERAND, ALL THOSE FLAGS ARE NOT TO BE READ
  pred_reg_i     <= instruction_in(45 downto 44) when (instr_marker_i /= IMM) else "00";
  pred_cond_i    <= instruction_in(43 downto 39) when (instr_marker_i /= IMM) else "01111";
  set_pred_i     <= instruction_in(38)           when (instr_marker_i /= IMM) else '0';
  set_pred_reg_i <= instruction_in(37 downto 36) when (instr_marker_i /= IMM) else "00";
  output_reg_i   <= instruction_in(35)           when (instr_marker_i /= IMM) else '0';

  saturate_i <= instruction_in(52) when ((instr_opcode_i = ALU) and ( ((alu_opcode_i = CVT) and (instr_subop_b = "110")) or (alu_opcode_i = FSET)))  --ADDED FPU RECYCLED for FABS
                else instruction_in(59) when (instr_marker_i /= IMM)
                else '0';

  abs_saturate_i <= instruction_in(52 downto 51) when (instr_marker_i /= IMM) else "00";

  -- UNUSED FOR INT RECYCLED FOR FPU AS ROUNDING MODE
  cvt_round_i <= instruction_in(17 downto 16) when ((instr_opcode_i = ALU) and (alu_opcode_i = FADD) and (instr_marker_i /= IMM) and (instr_is_long_b = '1'))  -- option disabled for conversions
                 else instruction_in(47 downto 46) when ((instr_opcode_i = ALU) and (alu_opcode_i = FMUL) and (instr_marker_i /= IMM) and (instr_is_long_b = '1'))
                 else instruction_in(50 downto 49) when (instr_marker_i /= IMM)
                 else "00";

  cvt_type_i  <= instruction_in(48 downto 46) when (instr_marker_i /= IMM) else "000";
  condition_i <= instruction_in(48 downto 46) when (instr_marker_i /= IMM) else "000"; -- condition used for ISET and FSET ??

  addr_hi_i     <= instruction_in(34) when (instr_is_long_b = '1' and instr_marker_i /= IMM) else '0';
  addr_lo_i     <= instruction_in(27 downto 26);  -- Address low for memory or reguister file access
  addr_incr_i   <= instruction_in(25);
  mem_type_i    <= instruction_in(48 downto 46);
  mov_size_i    <= instruction_in(55 downto 53);
  target_addr_i <= instruction_in(27 downto 9);
  imm_hi_i      <= instruction_in(59 downto 34);  -- hi part of an immediate op.

  --ADDED FPU
  src1_neg_i <= instruction_in(15) when ((instr_opcode_i = ALU) and ((alu_opcode_i = FADD) or (alu_opcode_i = FMUL)) and (instr_is_long_b = '0'))
                else instruction_in(58) when ((instr_opcode_i = ALU) and ((alu_opcode_i = FADD) or (alu_opcode_i = FMUL) or (alu_opcode_i = FMAD)) and (instr_is_long_b = '1') and instr_marker_i /= IMM)
                else instruction_in(15) when ((instr_opcode_i = ALU) and (alu_opcode_i = FMAD) and (instr_is_long_b = '1') and instr_marker_i = IMM)
                else '0'                when ((instr_opcode_i = ALU) and (alu_opcode_i = CVT) and ((instr_subop_b = "010") or (instr_subop_b = "100")))
                else '0'                when ((instr_opcode_i = ALU) and (alu_opcode_i = FSET))
                else instruction_in(48) when (instr_marker_i /= IMM)
                else '0';

  --ADDED FPU
  src2_neg_i <= instruction_in(22) when ((instr_opcode_i = ALU) and (alu_opcode_i = FADD) and (instr_is_long_b = '0'))
                else instruction_in(59) when ((instr_opcode_i = ALU) and ((alu_opcode_i = FADD) or (alu_opcode_i = FMUL)) and (instr_is_long_b = '1') and instr_marker_i /= IMM)
                else '0' when ((instr_opcode_i = ALU) and (alu_opcode_i = FSET or alu_opcode_i = FMAD ))  -- never found sign on 2nd input  with comparison and FMAD instruction and FMUL32I
                else '0' when ((instr_opcode_i = ALU) and (alu_opcode_i = FADD  or alu_opcode_i = FMUL or alu_opcode_i = FMAD) and instr_marker_i = IMM) -- sign of immediate is already encoded in the number
                else instruction_in(22) when ((alu_opcode_i = IMUL24) and (instr_marker_b /= "11"))
                else instruction_in(49);

  --ADDED FPU
  src3_neg_i <= instruction_in(59) when ((instr_opcode_i = ALU) and (alu_opcode_i = FMAD) and (instr_is_long_b = '1') and instr_marker_i /= IMM)
                else instruction_in(22);

  is_carry_b <= '1' when ((instr_opcode_b = "0011") and (instr_is_flow_b = '0') and (instruction_in(22) = '1'))  -- IADDC  ins. case
                else '1' when (((instr_opcode_b = "0110") and (instr_marker_i /= IMM) and (instruction_in(59 downto 58) = "11")) and (instr_is_flow_b = '0'))  -- IMAD24C ins. case
                else '0';               -- other ins. cases

  instr_marker_i <= HALF when (instr_is_long_b = '0')
                    else FULL_NORM when ((instr_marker_b = "00") and (instr_is_long_b = '1'))
                    else FULL_END  when ((instr_marker_b = "01") and (instr_is_long_b = '1'))
                    else FULL_JOIN when ((instr_marker_b = "10") and (instr_is_long_b = '1'))
                    else IMM       when (instr_marker_b = "11")
                    else UNKNOWN;


  -- OK
  -- decodify of inst. code
  instr_opcode_i <= MOV when (((instr_opcode_b = "0000") or (instr_opcode_b = "0001") or ((instr_opcode_b = "1101") and (instr_subop_b /= "000"))) and (instr_is_flow_b = '0'))
                    else ALU  when (((instr_opcode_b = "0010") or (instr_opcode_b = "0011") or (instr_opcode_b = "0100") or (instr_opcode_b = "0110") or (instr_opcode_b = "1010") or ((instr_opcode_b = "1101") and (instr_subop_b = "000"))) and (instr_is_flow_b = '0'))
                    --ADDED FPU
                    else ALU  when (  ((instr_opcode_b = "1011") or (instr_opcode_b = "1100") or (instr_opcode_b = "1110") or (instr_opcode_b = "1010") or (instr_opcode_b = "1011") or (instr_opcode_b = "1001")) and ((instr_is_flow_b = '0')) )           -- ADDED case for FADD, FMUL, FMAD, "FCONV", FSET, RCP, "1011"=>RRO Opcode, "1001"=>SIN, COS, LG2, EX2, RSQ Opcodes
                    --ADDED SFU JDGB
					--else ALU  when ((instr_opcode_b = "1001") or (instr_opcode_b = "1100") or (instr_opcode_b = "1110") or (instr_opcode_b = "1010") or (instr_opcode_b = "1011") or (instr_opcode_b = "1001"))  -- ADDED case for FADD, FMUL, FMAD, "FCONV", FSET, RCP
					--
					else FLOW when ((instr_is_flow_b = '1') and (instr_opcode_b /= "1111"))
                    else NOP  when (instr_opcode_b = "1111")
                    else UNKNOWN;       -- not supported

  --ok
  mov_opcode_i <= LOAD when (
    (((instr_opcode_b = "0000") and ((instr_subop_b = "001") or (instr_subop_b = "110"))) or
     ((instr_opcode_b = "0001") and ((instr_subop_b = "001") or (instr_subop_b = "010"))) or
     ((instr_opcode_b = "1101") and ((instr_subop_b = "001") or (instr_subop_b = "010") or (instr_subop_b = "100"))
      )) and (instr_is_flow_b = '0'))
                  else STORE when ((((instr_opcode_b = "0000") and ((instr_subop_b = "010") or (instr_subop_b = "101") or (instr_subop_b = "111"))) or
                                    ((instr_opcode_b = "1101") and ((instr_subop_b = "011") or (instr_subop_b = "101"))))
                                   and (instr_is_flow_b = '0'))
                  else MOV when (((instr_opcode_b = "0001") and ((instr_subop_b = "000") or (instr_is_long_b = '0'))) and (instr_is_flow_b = '0'))
                  else UNKNOWN;

  -- ok
  mov_mem_type_i <= REG when ((instr_opcode_i = MOV) and (mov_opcode_i = MOV))
                    else MEM_SHARED      when ((instr_opcode_i = MOV) and (((instr_opcode_b = "0001") and (instr_subop_b = "010")) or ((instr_opcode_b = "0000") and (instr_subop_b = "111"))))  -- R2G
                    else MEM_CONST       when ((instr_opcode_i = MOV) and ((instr_opcode_b = "0001") and (instr_subop_b = "001")))  -- MVC
                    else MEM_GLOBAL      when ((instr_opcode_i = MOV) and (((instr_opcode_b = "1101") and (instr_subop_b = "100")) or ((instr_opcode_b = "1101") and (instr_subop_b = "101"))))  -- GLD
                    else MEM_LOCAL       when ((instr_opcode_i = MOV) and (((instr_opcode_b = "1101") and (instr_subop_b = "010")) or ((instr_opcode_b = "1101") and (instr_subop_b = "011"))))  --LST, not working
                    else ADDRESS_MEM     when ((instr_opcode_i = MOV) and ((instr_opcode_b = "0000") and (instr_subop_b = "110")))  -- R2A
                    else ADDRESS_ADDRESS when ((instr_opcode_i = MOV) and ((instr_opcode_b = "1101") and (instr_subop_b = "001")))  -- ADA ???
                    else ADDRESS         when ((instr_opcode_i = MOV) and ((instr_opcode_b = "0000") and (instr_subop_b = "010")))  -- A2R
                    else FLAGS           when ((instr_opcode_i = MOV) and (((instr_opcode_b = "0000") and (instr_subop_b = "001")) or ((instr_opcode_b = "0000") and (instr_subop_b = "101"))))  -- internal ins
                    else UNKNOWN;


  --OK
  alu_opcode_i <= IADD when ((instr_opcode_b = "0010") and (instr_is_flow_b = '0'))
                  else IADDC                  when (((instr_opcode_b = "0011") and (instr_subop_b = "000") and (is_carry_b = '1')) and (instr_is_flow_b = '0'))
                  else IADDC                  when (((instr_opcode_b = "0011") and (is_carry_b = '1') and (instr_is_long_b = '0')) and (instr_is_flow_b = '0'))
                  else ISUB                   when (((instr_opcode_b = "0011") and (instr_subop_b = "000") and (is_carry_b = '0')) and (instr_is_flow_b = '0'))
                  else ISUB                   when (((instr_opcode_b = "0011") and (is_carry_b = '0') and (instr_is_long_b = '0')) and (instr_is_flow_b = '0'))
                  else SET                    when (((instr_opcode_b = "0011") and (instr_subop_b = "011")) and (instr_is_flow_b = '0'))
                  else MAX                    when (((instr_opcode_b = "0011") and (instr_subop_b = "100")) and (instr_is_flow_b = '0'))
                  else work.gpgpu_package.min when (((instr_opcode_b = "0011") and (instr_subop_b = "101")) and (instr_is_flow_b = '0'))
                  else SHL                    when (((instr_opcode_b = "0011") and (instr_subop_b = "110")) and (instr_is_flow_b = '0'))
                  else SHR                    when (((instr_opcode_b = "0011") and (instr_subop_b = "111")) and (instr_is_flow_b = '0'))
                  else IMUL24                 when ((instr_opcode_b = "0100") and (instr_is_flow_b = '0'))
                  else IMAD24                 when ((instr_opcode_b = "0110") and (is_carry_b = '0') and (instr_is_flow_b = '0'))
                  else IMAD24C                when ((instr_opcode_b = "0110") and (is_carry_b = '1') and (instr_is_flow_b = '0'))
                  else CVT                    when ((instr_opcode_b = "1010") and (instr_is_flow_b = '0'))  --I2I
                  else AND_OP                 when (((instr_opcode_b = "1101") and (instr_subop_b = "000") and (logic_type_b = "00")) and (instr_is_flow_b = '0'))
                  else OR_OP                  when (((instr_opcode_b = "1101") and (instr_subop_b = "000") and (logic_type_b = "01")) and (instr_is_flow_b = '0'))
                  else XOR_OP                 when (((instr_opcode_b = "1101") and (instr_subop_b = "000") and (logic_type_b = "10")) and (instr_is_flow_b = '0'))
                  else NEG_OP                 when (((instr_opcode_b = "1101") and (instr_subop_b = "000") and (logic_type_b = "11")) and (instr_is_flow_b = '0'))
                  --ADDED FPU
                  else FADD                   when ((instr_opcode_b = "1011") and (instr_subop_b = "000"))  -- CASE FADD, FADD32 and FADD32I
                  else FMUL                   when ((instr_opcode_b = "1100") and (instr_subop_b = "000"))  -- CASE FMUL, FUMUL32 and FMUL32I
                  else FMAD                   when ((instr_opcode_b = "1110") and (instr_subop_b = "000"))  -- CASE FMAD
                  else FSET                   when ((instr_opcode_b = "1011") and (instr_subop_b = "011")) -- CASE FSET
                  else RCP                     when ((instr_opcode_b = "1001") and (instr_subop_b = "000")) -- CASE RCP ??? RCP sub op 011???
				  -- SFU added by JDGB and JERC
				  else SIN                     when ((instr_opcode_b = "1001") and (instr_subop_b = "100")) -- CASE SIN
				  else COS                     when ((instr_opcode_b = "1001") and (instr_subop_b = "101")) -- CASE COS				  
				  else LG2                     when ((instr_opcode_b = "1001") and (instr_subop_b = "011")) -- CASE LG2
				  else EX2                     when ((instr_opcode_b = "1001") and (instr_subop_b = "110")) -- CASE EX2
				  else RSQ                     when ((instr_opcode_b = "1001") and (instr_subop_b = "010")) -- CASE RSQ
				  else RRO_SIN_OP              when ((instr_opcode_b = "1011") and (instr_subop_b = "110") and (logic_type_b = "00")) -- CASE RRO_SIN_OP
				  else RRO_EX2_OP              when ((instr_opcode_b = "1011") and (instr_subop_b = "110") and (logic_type_b = "01")) -- CASE RRO_EX2_OP
-- cases already covered by CVT
--else FNEG when ((instr_opcode_b = "1010") and (instr_subop_b = "111")) -- CASE F2F + NEG
--else FABS when ((instr_opcode_b = "1010") and (instr_subop_b = "110") and instruction_in(58) = '1') -- CASE F2F + FTRANSF/ABSO
--else F2I  when ((instr_opcode_b = "1010") and (instr_subop_b = "100") and instruction_in(58) = '1') -- CASE F2U, F2S
--else I2F  when ((instr_opcode_b = "1010") and (instr_subop_b = "010") and instruction_in(58) = '1') -- CASE U2F, S2F
else UNKNOWN;

  --OK
  flow_opcode_i <= BRANCH when ((instr_opcode_b = "0001") and (instr_is_flow_b = '1'))  -- BRANCH
                   else CALL     when ((instr_opcode_b = "0010") and (instr_is_flow_b = '1'))
                   else RET      when ((instr_opcode_b = "0011") and (instr_is_flow_b = '1'))
                   else PREBREAK when ((instr_opcode_b = "0100") and (instr_is_flow_b = '1'))
                   else BREAK    when ((instr_opcode_b = "0101") and (instr_is_flow_b = '1'))
                   else BAR      when ((instr_opcode_b = "1000") and (instr_is_flow_b = '1'))  -- Barrier Warp sync
                   else JOIN     when ((instr_opcode_b = "1010") and (instr_is_flow_b = '1'))  -- SSY
                   else UNKNOWN;

  is_full_marker_b <= '1' when ((instr_marker_i = FULL_NORM) or (instr_marker_i = FULL_END) or (instr_marker_i = FULL_JOIN))
                      else '0';

  is_signed_i <= instruction_in(15) when (((instr_opcode_i = ALU) and (alu_opcode_i = IMUL24)) and ((instr_marker_i = IMM) or (instr_marker_i = HALF)))
-- MODIFIED GIANLUCA ROASCIO : SHL WAS REPEATED TWICE AND SET CASE WAS MISSING
--else instruction_in(59) when ((instr_opcode_i = ALU) and ((alu_opcode_i = SHL) or (alu_opcode_i = SHL) or (alu_opcode_i = CVT)))
else instruction_in(59) when ((instr_opcode_i = ALU) and ((alu_opcode_i = SHL) or (alu_opcode_i = SHR) or (alu_opcode_i = SET)))
                 else instruction_in(47) when (((instr_opcode_i = ALU) and (alu_opcode_i = IMUL24)) and ((instr_marker_i = FULL_NORM) or (instr_marker_i = FULL_END) or (instr_marker_i = FULL_JOIN)))
                 -- ADDED GIANLUCA ROASCIO
                 else instruction_in(8)  when (((instr_opcode_i = ALU) and (alu_opcode_i = IMAD24)) and ((instr_marker_i = IMM)))
                 --ADDED FPU
                 else instruction_in(59) when ((instr_opcode_i = ALU) and (alu_opcode_i = CVT) and (instr_subop_b = "100"))  -- F2S
                 else instruction_in(48) when ((instr_opcode_i = ALU) and (alu_opcode_i = CVT) and (instr_subop_b = "010"))  -- S2F
                 else '0';

  w32_i <= instruction_in(22) when ((instr_opcode_i = ALU) and (alu_opcode_i = IMUL24) and (instr_marker_i = IMM))
           else instruction_in(48) when ((instr_opcode_i = ALU) and (alu_opcode_i = IMUL24) and (instr_marker_i /= IMM))
           else instruction_in(58) when ((instr_opcode_i = ALU) and (alu_opcode_i = CVT))
           else instruction_in(58) when ((instr_opcode_i = ALU) and (alu_opcode_i = SHL))
           else instruction_in(58) when ((instr_opcode_i = ALU) and (alu_opcode_i = SHR))
           else instruction_in(58) when ((instr_opcode_i = ALU) and (alu_opcode_i = IADD) and (is_full_marker_b = '1'))
           else instruction_in(58) when ((instr_opcode_i = ALU) and (alu_opcode_i = ISUB) and (is_full_marker_b = '1'))
           -- ADDED GIANLUCA ROASCIO : LOPS WERE MISSING
           else instruction_in(58) when ((instr_opcode_i = ALU) and (alu_opcode_i = AND_OP
                                                                     or alu_opcode_i = OR_OP
                                                                     or alu_opcode_i = XOR_OP
                                                                     or alu_opcode_i = NEG_OP))
           -- ADDED GIANLUCA ROASCIO : ISET WAS MISSING
           else instruction_in(58) when ((instr_opcode_i = ALU) and (alu_opcode_i = SET))
           else instruction_in(58) when (((instr_opcode_i = MOV) and (mov_opcode_i = MOV) and (mov_mem_type_i = REG)) and (is_full_marker_b = '1'))
           else instruction_in(58) when (instr_opcode_i = MOV) and ((mov_opcode_i = LOAD) or (mov_opcode_i = STORE)) and (mov_mem_type_i = MEM_SHARED)
           else instruction_in(58) when (instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = MEM_CONST)
           else instruction_in(58) when (instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = ADDRESS_MEM)
           else instruction_in(15) when (((instr_opcode_i = ALU) and (alu_opcode_i = IADD)) and (is_full_marker_b = '0'))
           else instruction_in(15) when (((instr_opcode_i = ALU) and (alu_opcode_i = ISUB)) and (is_full_marker_b = '0'))
           else instruction_in(15) when (((instr_opcode_i = MOV) and (mov_mem_type_i = REG)) and (is_full_marker_b = '0'))
           else '0';

  f64_i <= instruction_in(54) when (((instr_opcode_i = ALU) and (alu_opcode_i = CVT) and (instr_subop_b = "010")) and (is_full_marker_b = '1'))  -- Conversion to float ?????
           else instruction_in(22) when (((instr_opcode_i = ALU) and (alu_opcode_i = CVT) and (instr_subop_b = "001")) and (is_full_marker_b = '1'))
           else instruction_in(22) when (instr_opcode_i = MOV)
           else '0';

  --alt_i <= instruction_in(57) when ((instr_opcode_i = MOV) and (instr_is_long_b = '1'))
  --    else instruction_in(17) when ((instr_opcode_i = MOV) and (instr_is_long_b = '0'))
  --    else '0';

  -- MODIFIED GIANLUCA ROASCIO - ADDED CONDITION FOR R2G
  --addr_imm_i <= instruction_in(58) when (is_full_marker_b = '1' and (src1_mem_type_i = MEM_SHARED or dest_mem_type_i = MEM_SHARED) and (addr_reg_i /= "000"))
  addr_imm_i <= '1' when ((instr_opcode_b = "0000") and (instr_subop_b = "111"))  -- R2G
-- MODIFIED GIANLUCA ROASCIO - GENERALIZED IMMEDIATE MARKER FOR CORRECT BEHAVIOR OF ALL THE INSTRUCTION WITH SHARED MEMORY OPERAND AND ADDRESS REGISTER IMPLIED
--else instruction_in(58) when (is_full_marker_b = '1' and (src1_mem_type_i = MEM_SHARED or dest_mem_type_i = MEM_SHARED) and (addr_reg_i /= "000"))
else '1' when (is_full_marker_b = '1' and (src1_mem_type_i = MEM_SHARED or dest_mem_type_i = MEM_SHARED) and (addr_reg_i /= "000"))
                else instruction_in(15) when (is_full_marker_b = '0' and (src1_mem_type_i = MEM_SHARED) and (addr_reg_i /= "000"))  -- MM: For SHARED memory scatter and gather operations
                else instruction_in(52) when (is_full_marker_b = '1')  -- MM: For SHARED memory gather operations (half instr.)
                else instruction_in(25);

  write_pred_i <= set_pred_i when ((instr_is_flow_b = '0') and (instr_is_long_b = '1'))  -- access to write predicate memory in warp
                  else '0'        when ((instr_is_flow_b = '0') and (instr_is_long_b = '0'))
                  else set_pred_i when ((instr_is_flow_b = '1') and (instr_is_long_b = '1'))
                  else '0';

  -- MODIFIED GIANLUCA ROASCIO
  --cvt_neg_i <= '0';
  cvt_neg_i <= '1' when (instr_opcode_i = ALU and alu_opcode_i = CVT and instr_subop_b = "001") else '0';

  sm_type_i <= instruction_in(15 downto 14) when ((instr_src1_shared_i = '1') and (is_full_marker_b = '1') and (instr_is_flow_b = '0'))
               else instruction_in(14 downto 13) when ((instr_src1_shared_i = '1') and (is_full_marker_b = '0') and (instr_is_flow_b = '0'))
               else "00";

  src1_i <=                             -- ADDED FPU
             x"000000" & "00" & instruction_in(14 downto 9)        when ((instr_opcode_i = ALU) and ((alu_opcode_i = FADD) or (alu_opcode_i = FMUL)) and (instr_src1_shared_i = '0') and (instr_is_long_b = '0'))  -- FADD32
             else x"000000" & "00" & instruction_in(14 downto 9)   when ((instr_opcode_i = ALU) and (alu_opcode_i = FMAD) and (instr_src1_shared_i = '0') and (instr_is_long_b = '1'))  --FMAD32I
             else x"0000000" & instruction_in(12 downto 9)         when ((instr_opcode_i = ALU) and ((alu_opcode_i = FADD) or (alu_opcode_i = FMUL)) and (instr_src1_shared_i = '1') and (instr_is_long_b = '0'))  -- FADD32, FMUL32 + gmem (offset)
             else x"000000" & "0" & instruction_in(15 downto 9)    when ((instr_opcode_i = ALU) and ((alu_opcode_i = FADD) or (alu_opcode_i = FMUL) or (alu_opcode_i = FMAD) or (alu_opcode_i = FSET)) and (instr_src1_shared_i = '0') and (instr_is_long_b = '1'))  -- FADD, FMUL, FMAD, FSET and 32I
             else x"000000" & "0" & instruction_in(15 downto 9)    when ((instr_opcode_i = ALU) and ((alu_opcode_i = CVT) and (instr_subop_b = "111" or instr_subop_b = "110" or instr_subop_b = "100" or instr_subop_b = "010")) and (instr_is_long_b = '1'))  -- FCONV
             else x"000000" & "000" & instruction_in(13 downto 9)  when ((instr_opcode_i = ALU) and ((alu_opcode_i = FADD) or (alu_opcode_i = FMUL) or (alu_opcode_i = FMAD)) and (instr_src1_shared_i = '1') and (instr_is_long_b = '1'))  -- FADD, FMUL, FMAD + gmem (offset)
             else x"000000" & "0" & instruction_in(15 downto 9)    when ((instr_opcode_i = ALU) and (alu_opcode_i = RCP)) -- RCP and RCP32
             -- SFU added by JDGB and JERC
			 else x"000000" & "0" & instruction_in(15 downto 9)    when ((instr_opcode_i = ALU) and ((alu_opcode_i = SIN) or (alu_opcode_i = COS) or (alu_opcode_i = RRO_SIN_OP) or (alu_opcode_i = RRO_EX2_OP)or (alu_opcode_i = LG2) or (alu_opcode_i = EX2) or (alu_opcode_i = RSQ))) -- SIN, COS, RRO, LG2, EX2, RSQ
			 --
             else x"000000" & "00" & instruction_in(14 downto 9)   when (((instr_opcode_i = ALU) and (instr_src1_shared_i = '0')) and (instr_is_long_b = '0'))
             else x"000000" & "0" & instruction_in(15 downto 9)    when (((instr_opcode_i = ALU) and (instr_src1_shared_i = '0')) and (instr_is_long_b = '1') and (instr_marker_i /= IMM))
             else x"000000" & "00" & instruction_in(14 downto 9)   when (((instr_opcode_i = ALU) and (instr_src1_shared_i = '0')) and (instr_is_long_b = '1') and (instr_marker_i = IMM))
             else x"000000" & "0000" & instruction_in(12 downto 9) when (((instr_opcode_i = ALU) and (instr_src1_shared_i = '1')) and ((instr_is_long_b = '0') or ((instr_marker_i = IMM) and (alu_opcode_i = IMAD24))))
             -- ADDED GIANLUCA ROASCIO - CASE IADD32I Rz, g [0x..], 0x.. WAS NOT CONSIDERED
             else x"000000" & "0000" & instruction_in(12 downto 9) when (((instr_opcode_i = ALU) and (instr_src1_shared_i = '1')) and ((instr_is_long_b = '1') or ((instr_marker_i = IMM) and (alu_opcode_i = IADD))))
             else x"000000" & "000" & instruction_in(13 downto 9)  when (((instr_opcode_i = ALU) and (instr_src1_shared_i = '1')) and (instr_is_long_b = '1'))
             else x"0000" & "00" & instruction_in(22 downto 9)     when (((instr_opcode_i = MOV) and (mov_opcode_i = LOAD)) and ((mov_mem_type_i = MEM_SHARED) or (mov_mem_type_i = MEM_LOCAL)))
             else x"0000" & "00" & instruction_in(22 downto 9)     when (((instr_opcode_i = MOV) and (mov_opcode_i = STORE)) and (mov_mem_type_i = MEM_LOCAL))
             
			-- modified to consider (ADA) JERC
			else x"000000" & "000000" & instruction_in(27 downto 26) when (((instr_opcode_i = MOV) and (mov_opcode_i = LOAD)) and (mov_mem_type_i = ADDRESS_ADDRESS))
			-- original line:
--			else x"0000" & "00" & instruction_in(22 downto 9) when (((instr_opcode_i = MOV) and (mov_opcode_i = LOAD)) and (mov_mem_type_i = ADDRESS_ADDRESS))		 
             else x"000000" & "00" & instruction_in(14 downto 9)   when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = ADDRESS_MEM))
-- MODIFIED GIANLUCA ROASCIO - MOVEMENT FROM MEM_CONST (MVC) WAS NOT CONSIDERED
--else x"000000" & "0" & instruction_in(15 downto 9) when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = MEM_GLOBAL))
else x"000000" & "0" & instruction_in(15 downto 9) when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = MEM_GLOBAL or mov_mem_type_i = MEM_CONST))
             else
             x"000000" & "0" & instruction_in(8 downto 2)         when ((instr_opcode_i = MOV) and (mov_opcode_i = STORE) and (mov_mem_type_i = MEM_GLOBAL))  -- GST
             else x"000000" & "000" & instruction_in(13 downto 9) when (((instr_opcode_i = MOV) and (instr_src1_shared_i = '1')) and (instr_is_long_b = '1'))
             else                       --MM: MOV.U16 R0H, g [0x1].U16;
             x"000000" & "0000" & instruction_in(12 downto 9)     when (((instr_opcode_i = MOV) and (mov_opcode_i = MOV) and (instr_src1_shared_i = '1')) and (instr_is_long_b = '0'))
             else  --MM: MOV32 R1, g [A1+0x8] (half instr.);
             x"000000" & "0" & instruction_in(15 downto 9)        when ((instr_opcode_i = MOV) and (mov_opcode_i = MOV) and (instr_src1_shared_i = '0') and (instr_is_long_b = '1'))
             else                       --MM: MOV R6, R124
             x"000000" & "00" & instruction_in(14 downto 9)       when ((instr_opcode_i = MOV) and (mov_opcode_i = MOV) and (instr_src1_shared_i = '0') and (instr_is_long_b = '0'))
             else                       --MM: MOV32 R0, R1
             (others => '0');

  src2_i <= x"000000" & "00" & instruction_in(21 downto 16) when ((instr_opcode_i = ALU) and ((instr_marker_i = IMM) or (instr_marker_i = HALF)))
-- MODIFIED GIANLUCA ROASCIO - ALSO ISUB IS TAKES ITS SOURCE 2 FROM instruction_in(52 downto 46)
--else x"000000" & "0" & instruction_in(52 downto 46) when ((instr_opcode_i = ALU) and (alu_opcode_i = IADD) and (instr_is_long_b = '1') and (instr_marker_i /= IMM))
else x"000000" & "0" & instruction_in(52 downto 46) when ((instr_opcode_i = ALU) and (alu_opcode_i = IADD or alu_opcode_i = ISUB) and (instr_is_long_b = '1') and (instr_marker_i /= IMM))
            --ADDED FPU
            else x"000000" & instruction_in(53 downto 46)        when ((instr_opcode_i = ALU) and (alu_opcode_i = FADD) and (instr_src2_const_i = '1') and (instr_marker_i /= IMM))  -- second part of Cmem
            else x"000000" & "0" & instruction_in(22 downto 16)  when ((instr_opcode_i = ALU) and ((alu_opcode_i = FMUL) or (alu_opcode_i = FMAD) or (alu_opcode_i = FSET)) and (instr_src2_const_i = '1') and (instr_marker_i /= IMM))
            else x"000000" & "00" & instruction_in(21 downto 16) when ((instr_opcode_i = ALU) and (alu_opcode_i = FADD) and (instr_is_long_b = '0'))  --FADD32
            else x"000000" & "00" & instruction_in(21 downto 16) when ((instr_opcode_i = ALU) and ((alu_opcode_i = FADD) or (alu_opcode_i = FMUL) or (alu_opcode_i = FMAD)) and (instr_is_long_b = '1') and (instr_marker_i = IMM))  --low part of imm for FADD32I, FMUL32I, FMAD32I
            else x"000000" & "0" & instruction_in(52 downto 46)  when ((instr_opcode_i = ALU) and (alu_opcode_i = FADD) and (instr_is_long_b = '1') and (instr_marker_i /= IMM))  -- FADD
            else x"000000" & "0" & instruction_in(22 downto 16)  when ((instr_opcode_i = ALU) and ((alu_opcode_i = FMUL) or (alu_opcode_i = FMAD) or (alu_opcode_i = FSET)) and (instr_is_long_b = '1') and (instr_marker_i /= IMM))  --FMUL, FMAD FMUL32, FSET
            --
            else x"000000" & "0" & instruction_in(22 downto 16)  when ((instr_opcode_i = ALU) and (instr_is_long_b = '1'))
-- REMOVED GIANLUCA ROASCIO - WRONG SOURCE ASSIGNMENT FOR MVC
--else x"0000" & "00" & instruction_in(22 downto 9) when (((instr_opcode_i = MOV) and (mov_opcode_i = LOAD)) and (mov_mem_type_i = MEM_CONST))
else x"000000" & "0" & instruction_in(22 downto 16) when (((instr_opcode_i = MOV) and (mov_opcode_i = LOAD)) and (mov_mem_type_i = ADDRESS_MEM))
            else x"000000" & "00" & instruction_in(21 downto 16) when (((instr_opcode_i = MOV) and (mov_opcode_i = MOV)) and (instr_marker_i = IMM))
			
			--Added condition to consider (ADA instruction) JERC
			else x"0000" & "00" & instruction_in(22 downto 9) when (((instr_opcode_i = MOV) and (mov_opcode_i = LOAD)) and (mov_mem_type_i = ADDRESS_ADDRESS))				
			-- end added line
            else                        --MM: MVI R4, 0x2;
            (others => '0');

  -- MODIFIED GIANLUCA ROASCIO - THIS ASSIGNMENT WAS WRONG, 27 downto 23 IS NEVER WRITTEN WITH SOURCE INDICATORS, IN IMAD32 CASE THE SOURCE IS EQUAL TO THE DESTINATION
  --src3_i <= x"000000" & "000" & instruction_in(27 downto 23) when ((instr_opcode_i = ALU) and (instr_marker_i = IMM) and (alu_opcode_i = IMAD24) and (instr_is_long_b = '1'))
  src3_i <= dest_i when ((instr_opcode_i = ALU) and (instr_marker_i = IMM) and (alu_opcode_i = IMAD24) and (instr_is_long_b = '1'))  -- IMAD32I
            else dest_i                                          when ((instr_opcode_i = ALU) and (instr_marker_i = HALF) and (alu_opcode_i = IMAD24) and (instr_is_long_b = '0'))  -- IMAD32
            --ADDED FPU
            else x"000000" & "0" & instruction_in(52 downto 46)  when ((instr_opcode_i = ALU) and (alu_opcode_i = FMAD) and (instr_src3_const_i = '1') and (instr_marker_i /= IMM))  --second part Cmem
            else dest_i    when ((instr_opcode_i = ALU) and (alu_opcode_i = FMAD) and (instr_is_long_b = '1') and (instr_marker_i = IMM))  --FMAD32I R3 = DEST
            else x"000000" & "00" & instruction_in(51 downto 46) when ((instr_opcode_i = ALU) and (alu_opcode_i = FMAD) and (instr_is_long_b = '1') and (instr_marker_i /= IMM))  -- FMAD
            --
            else x"000000" & "0" & instruction_in(52 downto 46)  when (instr_opcode_i = ALU) or ((instr_opcode_i = MOV) and (mov_opcode_i = STORE) and (mov_mem_type_i = MEM_SHARED))
            else (others => '0');

  dest_i <= x"000000" & "00" & instruction_in(7 downto 2) when ((instr_opcode_i = ALU) and (instr_is_long_b = '0'))
            -- ADDED GIANLUCA ROASCIO - DESTINATION FOR IMAD32I IS RESTRICTED TO 6 BITS, instruction_in(8) SEEMS TO INDICATE THE is_signed FLAG
            else x"000000" & "00" & instruction_in(7 downto 2) when ((instr_opcode_i = ALU) and (alu_opcode_i = IMAD24) and (instr_is_long_b = '1') and (instr_marker_i = IMM))
            -- ADDED GIANLUCA ROASCIO - IMUL32I CASE
            else x"000000" & "00" & instruction_in(7 downto 2) when ((instr_opcode_i = ALU) and (alu_opcode_i = IMUL24) and (instr_is_long_b = '1') and (instr_marker_i = IMM))
            else x"000000" & "0" & instruction_in(8 downto 2)  when ((instr_opcode_i = ALU) and (instr_is_long_b = '1'))
            else x"0000" & "000" & instruction_in(21 downto 9) when ((instr_opcode_i = MOV) and (mov_opcode_i = STORE) and (mov_mem_type_i = MEM_SHARED))
-- MODIFIED GIANLUCA ROASCIO - MVC CASE
--else x"000000" & "0" & instruction_in(8 downto 2) when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = MEM_GLOBAL))
else x"000000" & "0" & instruction_in(8 downto 2) when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = MEM_GLOBAL or mov_mem_type_i = MEM_CONST))
            else x"000000" & "0" & instruction_in(15 downto 9)  when ((instr_opcode_i = MOV) and (mov_opcode_i = STORE) and (mov_mem_type_i = MEM_GLOBAL))
            else x"000000" & "0" & instruction_in(8 downto 2)   when ((instr_opcode_i = MOV) and ((mov_opcode_i = LOAD) or (mov_opcode_i = STORE)) and (mov_mem_type_i = MEM_LOCAL))
            else x"000000" & "0" & instruction_in(8 downto 2)   when (((instr_opcode_i = MOV) and (mov_opcode_i = LOAD)) and (mov_mem_type_i = ADDRESS_MEM))
            else x"000000" & "0" & instruction_in(8 downto 2)   when (((instr_opcode_i = MOV) and (mov_opcode_i = LOAD)) and (mov_mem_type_i = ADDRESS_ADDRESS))
            else x"000000" & "0" & instruction_in(8 downto 2)   when (((instr_opcode_i = MOV) and (mov_opcode_i = STORE)) and (mov_mem_type_i = ADDRESS))
            else x"000000" & "0" & instruction_in(8 downto 2) when (instr_opcode_i = MOV) and (mov_opcode_i = MOV) -- Modified to extend the destiny for registers from R0 to R63 JERC
         -- else x"000000" & "000" & instruction_in(6 downto 2) when (instr_opcode_i = MOV) and (mov_opcode_i = MOV)
          
            --ADDED FPU
			else x"000000" & "0" & instruction_in(8 downto 2) when ((instr_opcode_i = ALU) and ((alu_opcode_i = FADD) or (alu_opcode_i = FMUL) or (alu_opcode_i = FMAD) or (alu_opcode_i = FSET)
                                                                                                or ((alu_opcode_i = CVT) and (instr_subop_b = "111" or instr_subop_b = "110" or instr_subop_b = "100" or instr_subop_b = "010"))))  -- same for all FP
            -- SFU added by JDGB and JERC
			else x"000000" & "0" & instruction_in(8 downto 2) when ((instr_opcode_i = ALU) and ((alu_opcode_i = SIN) or (alu_opcode_i = COS) or (alu_opcode_i = RRO_SIN_OP) or (alu_opcode_i = RRO_EX2_OP) or (alu_opcode_i = LG2) or (alu_opcode_i = EX2) or (alu_opcode_i = RSQ)) 
																						   and (instr_subop_b = "100" or instr_subop_b = "101" or instr_subop_b = "110" or instr_subop_b = "011" or instr_subop_b = "010"))
			--
			else (others => '0');



  addr_hi_i_3 <= "00" & addr_hi_i;  --???????????????????????????????????????






  addr_reg_i <= (to_stdlogicvector(to_bitvector(addr_hi_i_3) sll 2)) or ("0" & addr_lo_i);

  src2_use_gather_b <= '1' when ((addr_reg_i /= "000") or (instr_src1_shared_i = '1'))
                       else '0';  --MM: addr_reg_i /= "000" (added "/" (not) condition)

  src1_mem_type_i <= REG when ((instr_opcode_i = ALU) and (instr_src1_shared_i = '0'))
                     else MEM_SHARED      when ((instr_opcode_i = ALU) and (instr_src1_shared_i = '1'))
                     else MEM_SHARED      when ((instr_opcode_i = MOV) and (mov_opcode_i = MOV) and (instr_src1_shared_i = '1'))
                     else REG             when ((instr_opcode_i = MOV) and (mov_opcode_i = MOV) and (mov_mem_type_i = REG))  -- MM: Added condition for first MOV instruction
                     else MEM_SHARED      when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = MEM_SHARED))
                     else REG             when ((instr_opcode_i = MOV) and (mov_opcode_i = STORE) and (mov_mem_type_i = MEM_SHARED) and (instr_src1_shared_i = '0'))
                     else MEM_SHARED      when ((instr_opcode_i = MOV) and (mov_opcode_i = STORE) and (mov_mem_type_i = MEM_SHARED) and (instr_src1_shared_i = '1'))
                     else MEM_CONST       when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = MEM_CONST))
                     else REG             when ((instr_opcode_i = MOV) and (mov_opcode_i = STORE) and (mov_mem_type_i = MEM_GLOBAL))
                     else MEM_GLOBAL      when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = MEM_GLOBAL))
                     else REG             when ((instr_opcode_i = MOV) and (mov_opcode_i = STORE) and (mov_mem_type_i = MEM_LOCAL))
                     else MEM_LOCAL       when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = MEM_LOCAL))
                     else REG             when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = ADDRESS_MEM) and (instr_src1_shared_i = '0'))
                     else MEM_SHARED      when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = ADDRESS_MEM) and (instr_src1_shared_i = '1'))
                     else ADDRESS_ADDRESS when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = ADDRESS_ADDRESS))
                     else ADDRESS         when ((instr_opcode_i = MOV) and (mov_opcode_i = STORE) and (mov_mem_type_i = ADDRESS))
                     else FLAGS           when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = FLAGS))
                     else REG             when ((instr_opcode_i = MOV) and (mov_opcode_i = STORE) and (mov_mem_type_i = FLAGS) and (instr_src1_shared_i = '0'))
                     else MEM_SHARED      when ((instr_opcode_i = MOV) and (mov_opcode_i = STORE) and (mov_mem_type_i = FLAGS) and (instr_src1_shared_i = '1'))
                     else UNKNOWN;

  src2_mem_type_i <= REG when ((instr_opcode_i = ALU) and (instr_src2_const_i = '0'))
                     else MEM_CONST  when ((instr_opcode_i = ALU) and (instr_src2_const_i = '1'))
                     else REG        when ((instr_opcode_i = MOV) and (mov_opcode_i = MOV) and (mov_mem_type_i = REG))
                     else MEM_SHARED when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = MEM_SHARED))
                     else REG        when ((instr_opcode_i = MOV) and (mov_opcode_i = STORE) and (mov_mem_type_i = MEM_SHARED) and (instr_src2_const_i = '0'))
                     else MEM_CONST  when ((instr_opcode_i = MOV) and (mov_opcode_i = STORE) and (mov_mem_type_i = MEM_SHARED) and (instr_src2_const_i = '1'))
-- REMOVED GIANLUCA ROASCIO - SOURCE 2 IS NOT PRESENT IN MVC
--else MEM_CONST when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = MEM_CONST))
else REG when ((instr_opcode_i = MOV) and (mov_opcode_i = STORE) and (mov_mem_type_i = MEM_GLOBAL))
                     else MEM_GLOBAL      when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = MEM_GLOBAL))
                     else REG             when ((instr_opcode_i = MOV) and (mov_opcode_i = STORE) and (mov_mem_type_i = MEM_LOCAL))
                     else MEM_LOCAL       when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = MEM_LOCAL))
                     else REG             when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = ADDRESS_MEM) and (instr_src2_const_i = '0'))
                     else MEM_CONST       when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = ADDRESS_MEM) and (instr_src2_const_i = '1'))
                     else ADDRESS_ADDRESS when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = ADDRESS_ADDRESS))
                     else ADDRESS         when ((instr_opcode_i = MOV) and (mov_opcode_i = STORE) and (mov_mem_type_i = ADDRESS))
                     else FLAGS           when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = FLAGS))
                     else REG             when ((instr_opcode_i = MOV) and (mov_opcode_i = STORE) and (mov_mem_type_i = FLAGS) and (instr_src2_const_i = '0'))
                     else MEM_CONST       when ((instr_opcode_i = MOV) and (mov_opcode_i = STORE) and (mov_mem_type_i = FLAGS) and (instr_src2_const_i = '1'))
                     else UNKNOWN;

  src3_mem_type_i <= REG when ((instr_opcode_i = ALU) and (instr_src3_const_i = '0'))
                     else MEM_CONST       when ((instr_opcode_i = ALU) and (instr_src3_const_i = '1'))
                     else REG             when ((instr_opcode_i = MOV) and (mov_opcode_i = MOV) and (mov_mem_type_i = REG))
                     else MEM_SHARED      when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = MEM_SHARED))
                     else REG             when ((instr_opcode_i = MOV) and (mov_opcode_i = STORE) and (mov_mem_type_i = MEM_SHARED) and (instr_src3_const_i = '0'))
                     else MEM_CONST       when ((instr_opcode_i = MOV) and (mov_opcode_i = STORE) and (mov_mem_type_i = MEM_SHARED) and (instr_src3_const_i = '1'))
                     else MEM_CONST       when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = MEM_CONST))
                     else REG             when ((instr_opcode_i = MOV) and (mov_opcode_i = STORE) and (mov_mem_type_i = MEM_GLOBAL))
                     else MEM_GLOBAL      when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = MEM_GLOBAL))
                     else REG             when ((instr_opcode_i = MOV) and (mov_opcode_i = STORE) and (mov_mem_type_i = MEM_LOCAL))
                     else MEM_LOCAL       when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = MEM_LOCAL))
                     else REG             when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = ADDRESS_MEM) and (instr_src3_const_i = '0'))
                     else MEM_CONST       when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = ADDRESS_MEM) and (instr_src3_const_i = '1'))
                     else ADDRESS_ADDRESS when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = ADDRESS_ADDRESS))
                     else ADDRESS         when ((instr_opcode_i = MOV) and (mov_opcode_i = STORE) and (mov_mem_type_i = ADDRESS))
                     else FLAGS           when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = FLAGS))
                     else REG             when ((instr_opcode_i = MOV) and (mov_opcode_i = STORE) and (mov_mem_type_i = FLAGS) and (instr_src3_const_i = '0'))
                     else MEM_CONST       when ((instr_opcode_i = MOV) and (mov_opcode_i = STORE) and (mov_mem_type_i = FLAGS) and (instr_src3_const_i = '1'))
                     else UNKNOWN;

  dest_mem_type_i <= REG when (instr_opcode_i = ALU)
                     else REG        when ((instr_opcode_i = MOV) and (mov_opcode_i = MOV) and (mov_mem_type_i = REG))
                     else REG        when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = MEM_SHARED))
                     else MEM_SHARED when ((instr_opcode_i = MOV) and (mov_opcode_i = STORE) and (mov_mem_type_i = MEM_SHARED))
                     else REG        when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = MEM_CONST))
                     else MEM_GLOBAL when ((instr_opcode_i = MOV) and (mov_opcode_i = STORE) and (mov_mem_type_i = MEM_GLOBAL))
                     else REG        when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = MEM_GLOBAL))
                     else MEM_LOCAL  when ((instr_opcode_i = MOV) and (mov_opcode_i = STORE) and (mov_mem_type_i = MEM_LOCAL))
                     else REG        when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = MEM_LOCAL))
                     else ADDRESS    when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = ADDRESS_MEM))
                     else ADDRESS    when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = ADDRESS_ADDRESS))
                     else REG        when ((instr_opcode_i = MOV) and (mov_opcode_i = STORE) and (mov_mem_type_i = ADDRESS))
                     else REG        when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = FLAGS))
                     else REG        when ((instr_opcode_i = MOV) and (mov_opcode_i = STORE) and (mov_mem_type_i = FLAGS))
                     else REG        when ((instr_opcode_i = MOV) and (mov_opcode_i = STORE) and (mov_mem_type_i = FLAGS) and (instr_src3_const_i = '1'))
                     else UNKNOWN;

  src1_mem_opcode_i <= READ when ((instr_opcode_i = ALU) and (instr_src1_shared_i = '0'))
                       else READ        when ((instr_opcode_i = ALU) and (instr_src1_shared_i = '1') and (addr_reg_i = "000"))
                       else READ_GATHER when ((instr_opcode_i = ALU) and (instr_src1_shared_i = '1') and (addr_reg_i /= "000"))
                       else READ        when ((instr_opcode_i = MOV) and (mov_opcode_i = MOV) and (mov_mem_type_i = REG) and (addr_reg_i = "000"))
                       else READ_GATHER when ((instr_opcode_i = MOV) and (mov_opcode_i = MOV) and (mov_mem_type_i = REG) and (addr_reg_i /= "000"))
                       else READ_GATHER when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = MEM_SHARED))
                       else READ        when ((instr_opcode_i = MOV) and (mov_opcode_i = STORE) and (mov_mem_type_i = MEM_SHARED) and (instr_src1_shared_i = '0'))
                       else READ_GATHER when ((instr_opcode_i = MOV) and (mov_opcode_i = STORE) and (mov_mem_type_i = MEM_SHARED) and (instr_src1_shared_i = '1'))
-- MODIFIED GIANLUCA ROASCIO - MVC IS A READ INSTRUCTION, NOT A READ_GATHER
--else READ_GATHER when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = MEM_CONST))
else READ when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = MEM_CONST))
                       else READ        when ((instr_opcode_i = MOV) and (mov_opcode_i = STORE) and (mov_mem_type_i = MEM_GLOBAL))
                       else READ_GATHER when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = MEM_GLOBAL))
                       else READ        when ((instr_opcode_i = MOV) and (mov_opcode_i = STORE) and (mov_mem_type_i = MEM_LOCAL))
                       else READ_GATHER when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = MEM_LOCAL))
                       else READ        when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = ADDRESS_MEM) and (instr_src1_shared_i = '0'))
                       else READ_GATHER when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = ADDRESS_MEM) and (instr_src1_shared_i = '1'))
                       else READ        when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = ADDRESS_ADDRESS))
                       else READ        when ((instr_opcode_i = MOV) and (mov_opcode_i = STORE) and (mov_mem_type_i = ADDRESS))
                       else READ        when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = FLAGS))
                       else READ        when ((instr_opcode_i = MOV) and (mov_opcode_i = STORE) and (mov_mem_type_i = FLAGS) and (instr_src1_shared_i = '0'))
                       else READ_GATHER when ((instr_opcode_i = MOV) and (mov_opcode_i = STORE) and (mov_mem_type_i = FLAGS) and (instr_src1_shared_i = '1'))
                       else READ;

  src2_mem_opcode_i <= READ when ((instr_opcode_i = ALU) and (instr_src2_const_i = '0'))
                       else READ when ((instr_opcode_i = ALU) and (instr_src2_const_i = '1') and (src2_use_gather_b = '0'))
                       else READ when ((instr_opcode_i = ALU) and (instr_src2_const_i = '1') and (src2_use_gather_b = '1'))  --      READ_GATHER       when ((instr_opcode_i = ALU) and (instr_src2_const_i = '1') and (src2_use_gather_b = '1')) else
else READ when ((instr_opcode_i = MOV) and (mov_opcode_i = MOV) and (mov_mem_type_i = REG))  -- Removed READ_GATHER condition altogether for constant memory
                       else READ_GATHER when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = MEM_SHARED))
                       else READ        when ((instr_opcode_i = MOV) and (mov_opcode_i = STORE) and (mov_mem_type_i = MEM_SHARED) and (instr_src2_const_i = '0'))
                       else READ        when ((instr_opcode_i = MOV) and (mov_opcode_i = STORE) and (mov_mem_type_i = MEM_SHARED) and (instr_src2_const_i = '1') and (src2_use_gather_b = '0'))
                       else READ_GATHER when ((instr_opcode_i = MOV) and (mov_opcode_i = STORE) and (mov_mem_type_i = MEM_SHARED) and (instr_src2_const_i = '1') and (src2_use_gather_b = '1'))
                       else READ_GATHER when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = MEM_CONST))
                       else READ        when ((instr_opcode_i = MOV) and (mov_opcode_i = STORE) and (mov_mem_type_i = MEM_GLOBAL))
                       else READ_GATHER when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = MEM_GLOBAL))
                       else READ        when ((instr_opcode_i = MOV) and (mov_opcode_i = STORE) and (mov_mem_type_i = MEM_LOCAL))
                       else READ_GATHER when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = MEM_LOCAL))
                       else READ        when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = ADDRESS_MEM) and (instr_src2_const_i = '0'))
                       else READ        when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = ADDRESS_MEM) and (instr_src2_const_i = '1') and (src2_use_gather_b = '0'))
                       else READ_GATHER when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = ADDRESS_MEM) and (instr_src2_const_i = '1') and (src2_use_gather_b = '1'))
                       else READ        when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = ADDRESS_ADDRESS))
                       else READ        when ((instr_opcode_i = MOV) and (mov_opcode_i = STORE) and (mov_mem_type_i = ADDRESS))
                       else READ        when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = FLAGS))
                       else READ        when ((instr_opcode_i = MOV) and (mov_opcode_i = STORE) and (mov_mem_type_i = FLAGS) and (instr_src2_const_i = '0'))
                       else READ        when ((instr_opcode_i = MOV) and (mov_opcode_i = STORE) and (mov_mem_type_i = FLAGS) and (instr_src2_const_i = '1'))
                       else READ;

  src3_mem_opcode_i <= READ when ((instr_opcode_i = ALU) and (instr_src3_const_i = '0'))
                       else READ        when ((instr_opcode_i = ALU) and (instr_src3_const_i = '1') and (addr_reg_i = "000"))
                       else READ_GATHER when ((instr_opcode_i = ALU) and (instr_src3_const_i = '1') and (addr_reg_i /= "000"))
                       else READ        when ((instr_opcode_i = MOV) and (mov_opcode_i = MOV) and (mov_mem_type_i = REG))
                       else READ_GATHER when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = MEM_SHARED))
                       else READ        when ((instr_opcode_i = MOV) and (mov_opcode_i = STORE) and (mov_mem_type_i = MEM_SHARED) and (instr_src3_const_i = '0'))
                       else READ        when ((instr_opcode_i = MOV) and (mov_opcode_i = STORE) and (mov_mem_type_i = MEM_SHARED) and (instr_src3_const_i = '1') and (addr_reg_i = "000"))
                       else READ_GATHER when ((instr_opcode_i = MOV) and (mov_opcode_i = STORE) and (mov_mem_type_i = MEM_SHARED) and (instr_src3_const_i = '1') and (addr_reg_i /= "000"))
                       else READ_GATHER when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = MEM_CONST))
                       else READ        when ((instr_opcode_i = MOV) and (mov_opcode_i = STORE) and (mov_mem_type_i = MEM_GLOBAL))
                       else READ_GATHER when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = MEM_GLOBAL))
                       else READ        when ((instr_opcode_i = MOV) and (mov_opcode_i = STORE) and (mov_mem_type_i = MEM_LOCAL))
                       else READ_GATHER when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = MEM_LOCAL))
                       else READ        when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = ADDRESS_MEM) and (instr_src3_const_i = '0'))
                       else READ        when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = ADDRESS_MEM) and (instr_src3_const_i = '1') and (addr_reg_i = "000"))
                       else READ_GATHER when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = ADDRESS_MEM) and (instr_src3_const_i = '1') and (addr_reg_i /= "000"))
                       else READ        when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = ADDRESS_ADDRESS))
                       else READ        when ((instr_opcode_i = MOV) and (mov_opcode_i = STORE) and (mov_mem_type_i = ADDRESS))
                       else READ        when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = FLAGS))
                       else READ        when ((instr_opcode_i = MOV) and (mov_opcode_i = STORE) and (mov_mem_type_i = FLAGS) and (instr_src3_const_i = '0'))
                       else READ        when ((instr_opcode_i = MOV) and (mov_opcode_i = STORE) and (mov_mem_type_i = FLAGS) and (instr_src3_const_i = '1'))
                       else READ;

  dest_mem_opcode_i <= WRITE when (instr_opcode_i = ALU)
                       else WRITE         when ((instr_opcode_i = MOV) and (mov_opcode_i = MOV) and (mov_mem_type_i = REG))
                       else WRITE         when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = MEM_SHARED))
                       else WRITE_SCATTER when ((instr_opcode_i = MOV) and (mov_opcode_i = STORE) and (mov_mem_type_i = MEM_SHARED))
                       else WRITE         when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = MEM_CONST))
                       else WRITE_SCATTER when ((instr_opcode_i = MOV) and (mov_opcode_i = STORE) and (mov_mem_type_i = MEM_GLOBAL))
                       else WRITE         when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = MEM_GLOBAL))
                       else WRITE_SCATTER when ((instr_opcode_i = MOV) and (mov_opcode_i = STORE) and (mov_mem_type_i = MEM_LOCAL))
                       else WRITE         when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = MEM_LOCAL))
                       else WRITE         when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = ADDRESS_MEM))
                       else WRITE         when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = ADDRESS_ADDRESS))
                       else WRITE         when ((instr_opcode_i = MOV) and (mov_opcode_i = STORE) and (mov_mem_type_i = ADDRESS))
                       else WRITE         when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = FLAGS))
                       else WRITE         when ((instr_opcode_i = MOV) and (mov_opcode_i = STORE) and (mov_mem_type_i = FLAGS))
                       else WRITE         when ((instr_opcode_i = MOV) and (mov_opcode_i = STORE) and (mov_mem_type_i = FLAGS) and (instr_src3_const_i = '1'))
                       else WRITE;

  -- MODIFIED GIANLUCA ROASCIO - PREVIOUS LIST OF TYPES WAS INCOMPLETE
  --reg_to_data_type <= DT_U16 when (w32_i = '0')
  --    else DT_U32;
  reg_to_data_type <= DT_U16 when (w32_i = '0') and (is_signed_i = '0')
                      else DT_S16 when (w32_i = '0') and (is_signed_i = '1')
                      else DT_S32 when (w32_i = '1') and (is_signed_i = '1')
                      else DT_U32;

  mov_size_to_data_type <= DT_U16 when (mov_size_i = "000")
                           else DT_U32 when (mov_size_i = "001")
                           else DT_U8  when (mov_size_i = "010")
                           else DT_U32;

  with mov_size_i select data_type_mov_size_i <=
    DT_U8   when "000",
    DT_S8   when "001",
    DT_U16  when "010",
    DT_S16  when "011",
    DT_U64  when "100",
    DT_U128 when "101",
    DT_U32  when "110",
    DT_S32  when others;

  with mem_type_i select sm_type_to_data_type <=
    DT_U8  when "000",
    DT_U16 when "001",
    DT_S16 when "010",
    DT_U32 when "011",
    DT_U32 when others;

  with cvt_type_i select cvt_type_to_data_type <=
    DT_U16 when "000",
    DT_U32 when "001",
    DT_U8  when "010",
    DT_U32 when "011",
    DT_S16 when "100",
    DT_S32 when "101",
    DT_S8  when "110",
    DT_U32 when others;

  with instr_subop_b select subop_to_data_type <=
    DT_U16 when "000",
    DT_S16 when "001",
    DT_S16 when "010",
    DT_U32 when "011",
    DT_S32 when "100",
    DT_S32 when "101",
    DT_U32 when "110",
    DT_S32 when others;

  src1_data_type_i <= DT_NONE when ((instr_opcode_i = FLOW) or (instr_opcode_i = NOP))
                      else subop_to_data_type when ((instr_opcode_i = ALU) and ((alu_opcode_i = IMAD24) or (alu_opcode_i = IMAD24C)) and (instr_marker_i /= IMM))
                      else subop_to_data_type when ((instr_opcode_i = ALU) and ((alu_opcode_i = IMAD24) or (alu_opcode_i = IMAD24C)) and (instr_marker_i = IMM))
                      else reg_to_data_type   when ((instr_opcode_i = ALU) and (alu_opcode_i = IMUL24))
                      -- ADDED GIANLUCA ROASCIO - THE FOLLOWING LINE WAS PRESENT FOR src2_data_type_i BUT NOT HERE, MAYBE A FORGETFULNESS
                      else reg_to_data_type   when ((instr_opcode_i = ALU) and (alu_opcode_i = IADD))
-- MODIFIED GIANLUCA ROASCIO
--else subop_to_data_type when ((instr_opcode_i = ALU) and (src2_mem_type_i = MEM_CONST) and ((alu_opcode_i = AND_OP) or (alu_opcode_i = OR_OP) or (alu_opcode_i = XOR_OP) or (alu_opcode_i = NEG_OP)))
else DT_U32 when ((instr_opcode_i = ALU) and ((alu_opcode_i = AND_OP) or (alu_opcode_i = OR_OP) or (alu_opcode_i = XOR_OP) or (alu_opcode_i = NEG_OP)) and w32_i = '1')
                      else DT_U16                when ((instr_opcode_i = ALU) and ((alu_opcode_i = AND_OP) or (alu_opcode_i = OR_OP) or (alu_opcode_i = XOR_OP) or (alu_opcode_i = NEG_OP)) and w32_i = '0')
                      else cvt_type_to_data_type when ((instr_opcode_i = ALU) and (alu_opcode_i = CVT))
                      else subop_to_data_type    when ((instr_opcode_i = ALU) and (alu_opcode_i = SET))
                      -- ADDED FPU
                    else DT_F32 when ((instr_opcode_i = ALU) and ((alu_opcode_i = FADD) or (alu_opcode_i = FMUL) or (alu_opcode_i = FMAD) or (alu_opcode_i = FSET) or (alu_opcode_i = RCP)
                                                                    or ((alu_opcode_i = CVT) and (instr_subop_b = "111" or instr_subop_b = "110" or instr_subop_b = "100" or instr_subop_b = "010"))))
                      else reg_to_data_type     when ((instr_opcode_i = MOV) and (mov_opcode_i = MOV) and (mov_mem_type_i = REG) and (is_full_marker_b = '1'))
                      else DT_NONE              when ((instr_opcode_i = MOV) and (mov_opcode_i = MOV) and (mov_mem_type_i = REG) and (instr_marker_i = IMM))
                      else reg_to_data_type     when ((instr_opcode_i = MOV) and (mov_opcode_i = MOV) and (mov_mem_type_i = REG) and (instr_marker_i = HALF))
                      else sm_type_to_data_type when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = MEM_SHARED))
                      else DT_NONE              when ((instr_opcode_i = MOV) and (mov_opcode_i = STORE) and (mov_mem_type_i = MEM_SHARED))
-- MODIFIED GIANLUCA ROASCIO - MVC SOURCE TYPE WAS DT_NONE, CAUSING NO READ REQUEST FORWARDING TO THE CONSTANT MEMORY
--else DT_NONE when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = MEM_CONST))
else DT_U32 when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = MEM_CONST))
-- MODIFIED GIANLUCA ROASCIO - GST ALWAYS ADDRESSES 32-BIT REGISTERS
--else data_type_mov_size_i when ((instr_opcode_i = MOV) and (mov_opcode_i = STORE) and (mov_mem_type_i = MEM_GLOBAL))
else DT_U32 when ((instr_opcode_i = MOV) and (mov_opcode_i = STORE) and (mov_mem_type_i = MEM_GLOBAL))
                      else data_type_mov_size_i when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = MEM_GLOBAL))
                      else data_type_mov_size_i when ((instr_opcode_i = MOV) and (mov_opcode_i = STORE) and (mov_mem_type_i = MEM_LOCAL))
                      else data_type_mov_size_i when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = MEM_LOCAL))
                      else DT_U32               when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = ADDRESS_MEM))
                      else DT_U32               when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = ADDRESS_ADDRESS))
                      else DT_U32               when ((instr_opcode_i = MOV) and (mov_opcode_i = STORE) and (mov_mem_type_i = ADDRESS))
                      else DT_U32               when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = FLAGS))
                      else DT_U32               when ((instr_opcode_i = MOV) and (mov_opcode_i = STORE) and (mov_mem_type_i = FLAGS))
                      -- ADDED GIANLUCA ROASCIO : PARTICULAR CASE FOR THE SHIFT INSTRUCTIONS
                      else DT_U16               when (instr_opcode_i = ALU and (alu_opcode_i = SHL or alu_opcode_i = SHR) and is_signed_i = '0' and w32_i = '0')
                      else DT_U32               when (instr_opcode_i = ALU and (alu_opcode_i = SHL or alu_opcode_i = SHR) and is_signed_i = '0' and w32_i = '1')
                      else DT_S16               when (instr_opcode_i = ALU and (alu_opcode_i = SHL or alu_opcode_i = SHR) and is_signed_i = '1' and w32_i = '0')
                      else DT_S32               when (instr_opcode_i = ALU and (alu_opcode_i = SHL or alu_opcode_i = SHR) and is_signed_i = '1' and w32_i = '1')
                      else DT_U32;

  src2_data_type_i <= DT_NONE when ((instr_opcode_i = FLOW) or (instr_opcode_i = NOP))
                      else subop_to_data_type when ((instr_opcode_i = ALU) and ((alu_opcode_i = IMAD24) or (alu_opcode_i = IMAD24C)) and (instr_marker_i /= IMM))
                      else subop_to_data_type when ((instr_opcode_i = ALU) and ((alu_opcode_i = IMAD24) or (alu_opcode_i = IMAD24C)) and (instr_marker_i = IMM))
                      else reg_to_data_type   when ((instr_opcode_i = ALU) and (alu_opcode_i = IMUL24))
                      else reg_to_data_type   when ((instr_opcode_i = ALU) and (alu_opcode_i = IADD))
                      -- ADDED GIANLUCA ROASCIO - ISUB WAS NOT LISTED
                      else reg_to_data_type   when ((instr_opcode_i = ALU) and (alu_opcode_i = ISUB))
-- MODIFIED GIANLUCA ROASCIO
--else subop_to_data_type when ((instr_opcode_i = ALU) and (src2_mem_type_i = MEM_CONST) and ((alu_opcode_i = AND_OP) or (alu_opcode_i = OR_OP) or (alu_opcode_i = XOR_OP) or (alu_opcode_i = NEG_OP)))
else DT_U32 when ((instr_opcode_i = ALU) and ((alu_opcode_i = AND_OP) or (alu_opcode_i = OR_OP) or (alu_opcode_i = XOR_OP) or (alu_opcode_i = NEG_OP)) and w32_i = '1')
                      else DT_U16             when ((instr_opcode_i = ALU) and ((alu_opcode_i = AND_OP) or (alu_opcode_i = OR_OP) or (alu_opcode_i = XOR_OP) or (alu_opcode_i = NEG_OP)) and w32_i = '0')
                      else DT_NONE            when ((instr_opcode_i = ALU) and (alu_opcode_i = CVT))
                      else subop_to_data_type when ((instr_opcode_i = ALU) and (alu_opcode_i = SET))
                      else DT_U32             when ((instr_opcode_i = ALU) and ((alu_opcode_i = AND_OP) or (alu_opcode_i = OR_OP) or (alu_opcode_i = XOR_OP)))
                      -- ADDED FPU
                      else DT_F32 when ((instr_opcode_i = ALU) and ((alu_opcode_i = FADD) or (alu_opcode_i = FMUL) or (alu_opcode_i = FMAD) or (alu_opcode_i = FSET)
                                                                    or ((alu_opcode_i = CVT) and (instr_subop_b = "111" or instr_subop_b = "110" or instr_subop_b = "100" or instr_subop_b = "010"))))
                      else DT_NONE              when ((instr_opcode_i = MOV) and (mov_opcode_i = MOV) and (mov_mem_type_i = REG) and (is_full_marker_b = '1'))
                      else reg_to_data_type     when ((instr_opcode_i = MOV) and (mov_opcode_i = MOV) and (mov_mem_type_i = REG) and (instr_marker_i = IMM))
                      else DT_NONE              when ((instr_opcode_i = MOV) and (mov_opcode_i = MOV) and (mov_mem_type_i = REG) and (instr_marker_i = HALF))
                      else DT_NONE              when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = MEM_SHARED))
                      else DT_NONE              when ((instr_opcode_i = MOV) and (mov_opcode_i = STORE) and (mov_mem_type_i = MEM_SHARED))
                      else sm_type_to_data_type when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = MEM_CONST))
                      else DT_NONE              when ((instr_opcode_i = MOV) and (mov_opcode_i = STORE) and (mov_mem_type_i = MEM_GLOBAL))
                      else DT_NONE              when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = MEM_GLOBAL))
                      else DT_NONE              when ((instr_opcode_i = MOV) and (mov_opcode_i = STORE) and (mov_mem_type_i = MEM_LOCAL))
                      else DT_NONE              when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = MEM_LOCAL))
                      else DT_NONE              when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = ADDRESS_MEM))
                      else DT_NONE              when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = ADDRESS_ADDRESS))
                      else DT_NONE              when ((instr_opcode_i = MOV) and (mov_opcode_i = STORE) and (mov_mem_type_i = ADDRESS))
                      else DT_NONE              when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = FLAGS))
                      else DT_NONE              when ((instr_opcode_i = MOV) and (mov_opcode_i = STORE) and (mov_mem_type_i = FLAGS))
                      -- ADDED GIANLUCA ROASCIO : PARTICULAR CASE FOR THE SHIFT INSTRUCTIONS
                      else DT_U32               when (instr_opcode_i = ALU and (alu_opcode_i = SHL or alu_opcode_i = SHR))
                      else reg_to_data_type when((instr_opcode_i = ALU) and ((alu_opcode_i = FADD) or (alu_opcode_i = FMUL) or (alu_opcode_i = FMAD)
                                                                             or ((alu_opcode_i = CVT) and (instr_subop_b = "111" or instr_subop_b = "110" or instr_subop_b = "100" or instr_subop_b = "010"))))
                      else DT_NONE;

  src3_data_type_i <= DT_NONE when ((instr_opcode_i = FLOW) or (instr_opcode_i = NOP))
                      else DT_U32           when ((instr_opcode_i = ALU) and ((alu_opcode_i = IMAD24) or (alu_opcode_i = IMAD24C)) and (instr_marker_i /= IMM))
                      else DT_U32           when ((instr_opcode_i = ALU) and ((alu_opcode_i = IMAD24) or (alu_opcode_i = IMAD24C)) and (instr_marker_i = IMM))
                      else DT_NONE          when ((instr_opcode_i = ALU) and (alu_opcode_i = IMUL24))
                      else DT_NONE          when ((instr_opcode_i = ALU) and (alu_opcode_i = CVT))
                      -- ADDED FPU
                      else DT_F32           when ((instr_opcode_i = ALU) and (alu_opcode_i = FMAD))
                      else DT_NONE          when ((instr_opcode_i = MOV) and (mov_opcode_i = MOV) and (mov_mem_type_i = REG) and (is_full_marker_b = '1'))
                      else DT_NONE          when ((instr_opcode_i = MOV) and (mov_opcode_i = MOV) and (mov_mem_type_i = REG) and (instr_marker_i = IMM))
                      else DT_NONE          when ((instr_opcode_i = MOV) and (mov_opcode_i = MOV) and (mov_mem_type_i = REG) and (instr_marker_i = HALF))
                      else DT_NONE          when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = MEM_SHARED))
                      -- ADDED GIANLUCA ROASCIO - SPECIAL CASE FOR R2G.U16.U8
                      else DT_U32           when ((instr_opcode_i = MOV) and (mov_opcode_i = STORE) and (mov_mem_type_i = MEM_SHARED) and dest_data_type_i = DT_U8)
                      else reg_to_data_type when ((instr_opcode_i = MOV) and (mov_opcode_i = STORE) and (mov_mem_type_i = MEM_SHARED))
                      else DT_NONE          when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = MEM_CONST))
                      else DT_NONE          when ((instr_opcode_i = MOV) and (mov_opcode_i = STORE) and (mov_mem_type_i = MEM_GLOBAL))
                      else DT_NONE          when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = MEM_GLOBAL))
                      else DT_NONE          when ((instr_opcode_i = MOV) and (mov_opcode_i = STORE) and (mov_mem_type_i = MEM_LOCAL))
                      else DT_NONE          when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = MEM_LOCAL))
                      else DT_NONE          when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = ADDRESS_MEM))
                      else DT_NONE          when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = ADDRESS_ADDRESS))
                      else DT_NONE          when ((instr_opcode_i = MOV) and (mov_opcode_i = STORE) and (mov_mem_type_i = ADDRESS))
                      else DT_NONE          when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = FLAGS))
                      else DT_NONE          when ((instr_opcode_i = MOV) and (mov_opcode_i = STORE) and (mov_mem_type_i = FLAGS))
                      else DT_NONE;

  dest_data_type_i <= DT_NONE when ((instr_opcode_i = FLOW) or (instr_opcode_i = NOP))
                      else DT_U32           when ((instr_opcode_i = ALU) and ((alu_opcode_i = IMAD24) or (alu_opcode_i = IMAD24C)) and (instr_marker_i /= IMM))
                      else DT_U32           when ((instr_opcode_i = ALU) and ((alu_opcode_i = IMAD24) or (alu_opcode_i = IMAD24C)) and (instr_marker_i = IMM))
                      else DT_U32           when ((instr_opcode_i = ALU) and (alu_opcode_i = IMUL24))
                      -- ADDED GIANLUCA ROASCIO - TO MAKE IADD32.U16 WORKING, LOOK AT MODIFICATIONS MADE AT LINE 855
                      else reg_to_data_type when ((instr_opcode_i = ALU) and (alu_opcode_i = IADD))
                      else reg_to_data_type when ((instr_opcode_i = ALU) and (alu_opcode_i = CVT))
-- MODIFIED GIANLUCA ROASCIO
--else subop_to_data_type when ((instr_opcode_i = ALU) and (src2_mem_type_i = MEM_CONST) and ((alu_opcode_i = AND_OP) or (alu_opcode_i = OR_OP) or (alu_opcode_i = XOR_OP) or (alu_opcode_i = NEG_OP)))
else DT_U32 when ((instr_opcode_i = ALU) and ((alu_opcode_i = AND_OP) or (alu_opcode_i = OR_OP) or (alu_opcode_i = XOR_OP) or (alu_opcode_i = NEG_OP)) and w32_i = '1')
                      else DT_U16 when ((instr_opcode_i = ALU) and ((alu_opcode_i = AND_OP) or (alu_opcode_i = OR_OP) or (alu_opcode_i = XOR_OP) or (alu_opcode_i = NEG_OP)) and w32_i = '0')
                      -- ADDED FPU
                      else DT_F32 when ((instr_opcode_i = ALU) and ((alu_opcode_i = FADD) or (alu_opcode_i = FMUL) or (alu_opcode_i = FMAD) or (alu_opcode_i = FSET) or (alu_opcode_i = RCP)
                                                                    or ((alu_opcode_i = CVT) and (instr_subop_b = "111" or instr_subop_b = "110" or instr_subop_b = "100" or instr_subop_b = "010"))))
                      else reg_to_data_type      when ((instr_opcode_i = MOV) and (mov_opcode_i = MOV) and (mov_mem_type_i = REG) and (is_full_marker_b = '1'))
                      else reg_to_data_type      when ((instr_opcode_i = MOV) and (mov_opcode_i = MOV) and (mov_mem_type_i = REG) and (instr_marker_i = IMM))
                      else reg_to_data_type      when ((instr_opcode_i = MOV) and (mov_opcode_i = MOV) and (mov_mem_type_i = REG) and (instr_marker_i = HALF))
                      else reg_to_data_type      when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = MEM_SHARED))
                      else mov_size_to_data_type when ((instr_opcode_i = MOV) and (mov_opcode_i = STORE) and (mov_mem_type_i = MEM_SHARED))
                      else reg_to_data_type      when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = MEM_CONST))
                      else data_type_mov_size_i  when ((instr_opcode_i = MOV) and (mov_opcode_i = STORE) and (mov_mem_type_i = MEM_GLOBAL))
-- MODIFIED GIANLUCA ROASCIO - GLD IS ALWAYS TARGETTED ON 32-BIT REGISTERS
--else data_type_mov_size_i when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = MEM_GLOBAL))
else DT_U32 when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = MEM_GLOBAL))
                      else data_type_mov_size_i when ((instr_opcode_i = MOV) and (mov_opcode_i = STORE) and (mov_mem_type_i = MEM_LOCAL))
                      else data_type_mov_size_i when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = MEM_LOCAL))
                      else DT_U32               when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = ADDRESS_MEM))
                      else DT_U32               when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = ADDRESS_ADDRESS))
                      else DT_U32               when ((instr_opcode_i = MOV) and (mov_opcode_i = STORE) and (mov_mem_type_i = ADDRESS))
                      else DT_U32               when ((instr_opcode_i = MOV) and (mov_opcode_i = LOAD) and (mov_mem_type_i = FLAGS))
                      else DT_NONE              when ((instr_opcode_i = MOV) and (mov_opcode_i = STORE) and (mov_mem_type_i = FLAGS))
                      -- ADDED GIANLUCA ROASCIO : PARTICULAR CASE FOR THE SHIFT INSTRUCTIONS
                      else src1_data_type_i     when (instr_opcode_i = ALU and (alu_opcode_i = SHL or alu_opcode_i = SHR))
                      else DT_U32;

end arch;
