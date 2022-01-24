----------------------------------------------------------------------------------
-- Company:          Univerity of Massachusetts
-- Engineer:         Kevin Andryc
--
-- Create Date:      17:50:27 09/19/2010
-- Module Name:      pipeline_scalar - arch
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

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.gpgpu_package.all;

entity pipeline_execute is
  generic(SHMEM_ADDR_SIZE : integer := 14);
  port(
    reset                    : in  std_logic;
    clk_in                   : in  std_logic;
    pipeline_read_done       : in  std_logic;
    pipeline_stall_in        : in  std_logic;
    warp_id_in               : in  std_logic_vector(4 downto 0);
    warp_lane_id_in          : in  std_logic_vector(1 downto 0);
    cta_id_in                : in  std_logic_vector(3 downto 0);
    initial_mask_in          : in  std_logic_vector(31 downto 0);
    current_mask_in          : in  std_logic_vector(31 downto 0);
    shmem_base_addr_in       : in  std_logic_vector(SHMEM_ADDR_SIZE - 1 downto 0);
    gprs_size_in             : in  std_logic_vector(8 downto 0);
    gprs_base_addr_in        : in  std_logic_vector(8 downto 0);
    instr_mask_in            : in  std_logic_vector(31 downto 0);
    next_pc_in               : in  std_logic_vector(31 downto 0);
    instr_opcode_in          : in  instr_opcode_type;
    instr_subop_in           : in  std_logic_vector(2 downto 0);
    alu_opcode_in            : in  alu_opcode_type;
    flow_opcode_in           : in  flow_opcode_type;
    mov_opcode_in            : in  mov_opcode_type;
    instr_marker_in          : in  instr_marker_type;
    set_pred_in              : in  std_logic;
    set_pred_reg_in          : in  std_logic_vector(1 downto 0);
    write_pred_in            : in  std_logic;
    is_signed_in             : in  std_logic;
    w32_in                   : in  std_logic;
    f64_in                   : in  std_logic;                     -- not used
    saturate_in              : in  std_logic;
    abs_saturate_in          : in  std_logic_vector(1 downto 0);
    cvt_round_in             : in  std_logic_vector(1 downto 0);
    cvt_type_in              : in  std_logic_vector(2 downto 0);
    cvt_neg_in               : in  std_logic;
    set_cond_in              : in  std_logic_vector(2 downto 0);
    addr_hi_in               : in  std_logic;
    addr_lo_in               : in  std_logic_vector(1 downto 0);
    addr_incr_in             : in  std_logic;
    mov_size_in              : in  std_logic_vector(2 downto 0);
    mem_type_in              : in  std_logic_vector(2 downto 0);
    sm_type_in               : in  std_logic_vector(1 downto 0);
    addr_imm_in              : in  std_logic;
    dest_mem_type_in         : in  mem_type;
    dest_mem_opcode_in       : in  mem_opcode_type;
    src1_neg_in              : in  std_logic;
    src2_neg_in              : in  std_logic;
    src3_neg_in              : in  std_logic;
    target_addr_in           : in  std_logic_vector(18 downto 0);
    dest_data_type_in        : in  data_type;
    src1_in                  : in  std_logic_vector(31 downto 0);
    dest_in                  : in  std_logic_vector(31 downto 0);
    pred_flags_in            : in  vector_flag_register;
    temp_vector_register_in  : in  temp_vector_register;
    warp_div_req_out         : out std_logic;
    warp_div_ack_out         : out std_logic;
    warp_div_grant_in        : in  std_logic;
    warp_div_stack_en_out    : out warp_div_std_logic_array;
    warp_div_wr_data_out     : out warp_div_data_array;
    warp_div_rd_data_in      : in  warp_div_data_array;
    warp_div_push_en_out     : out warp_div_std_logic_array;
    warp_div_stack_full_in   : in  warp_div_std_logic_array;
    warp_div_stack_empty_in  : in  warp_div_std_logic_array;
    warp_id_out              : out std_logic_vector(4 downto 0);
    warp_lane_id_out         : out std_logic_vector(1 downto 0);
    cta_id_out               : out std_logic_vector(3 downto 0);
    initial_mask_out         : out std_logic_vector(31 downto 0);
    current_mask_out         : out std_logic_vector(31 downto 0);
    shmem_base_addr_out      : out std_logic_vector(SHMEM_ADDR_SIZE - 1 downto 0);
    gprs_size_out            : out std_logic_vector(8 downto 0);
    gprs_base_addr_out       : out std_logic_vector(8 downto 0);
    instr_mask_out           : out std_logic_vector(31 downto 0);
    next_pc_out              : out std_logic_vector(31 downto 0);
    warp_state_out           : out warp_state_type;
    instr_opcode_out         : out instr_opcode_type;
    set_pred_out             : out std_logic;
    set_pred_reg_out         : out std_logic_vector(1 downto 0);
    write_pred_out           : out std_logic;
    addr_hi_out              : out std_logic;
    addr_lo_out              : out std_logic_vector(1 downto 0);
    addr_incr_out            : out std_logic;
    mov_size_out             : out std_logic_vector(2 downto 0);
    sm_type_out              : out std_logic_vector(1 downto 0);
    addr_imm_out             : out std_logic;
    src1_out                 : out std_logic_vector(31 downto 0);
    dest_mem_type_out        : out mem_type;
    dest_mem_opcode_out      : out mem_opcode_type;
    dest_data_type_out       : out data_type;
    dest_out                 : out std_logic_vector(31 downto 0);
    pred_flags_out           : out vector_flag_register;
    temp_vector_register_out : out temp_vector_register;
    pipeline_execute_done    : out std_logic;
    pipeline_stall_out       : out std_logic
    );
end pipeline_execute;

architecture p_exec_arch of pipeline_execute is

  type pipeline_execute_state_type is (IDLE, ALU_EXEC, ALU_DONE, MOV_DONE, FLOW_EXEC, FLOW_DONE, NOP);
  signal pipeline_execute_state_machine : pipeline_execute_state_type;

  signal alu_opcode_i   : alu_opcode_type;
  signal branch_exec_en : std_logic;
  signal sp_carry_o     : std_logic_vector(CORES - 1 downto 0);
  signal sp_overflow_o  : std_logic_vector(CORES - 1 downto 0);
  signal sp_sign_o      : std_logic_vector(CORES - 1 downto 0);
  signal sp_zero_o      : std_logic_vector(CORES - 1 downto 0);
  signal sp_result_o    : vector_register;

  signal branch_exec_done : std_logic;
  signal initial_mask_o   : std_logic_vector(31 downto 0);
  signal current_mask_o   : std_logic_vector(31 downto 0);
  signal instr_mask_o     : std_logic_vector(31 downto 0);
  signal next_pc_o        : std_logic_vector(31 downto 0);
  signal warp_state_o     : warp_state_type;

  signal src1_i : vector_register;
  signal src2_i : vector_register;
  signal src3_i : vector_register;

  signal cvt_type_i             : std_logic_vector(2 downto 0);
  signal w32_i                  : std_logic;
  signal is_signed_i            : std_logic;
  signal pred_flags_i           : vector_flag_register;
  signal mem_type_to_cvt_type_o : conv_type;
  signal data_type_i            : data_type;
  -- ADDED GIANLUCA ROASCIO
  signal set_pred_i             : std_logic;
  -- ADDED GIANLUCA ROASCIO - FLAGS SHOULD BE UPDATED AT THE OUTPUT ONLY WHEN THE STAGE IS DONE, NOT AT ANYTIME, SO IT IS NEEDED AN INTERMEDIATE REGISTER FOR THOSE
  signal pred_flags_o           : vector_flag_register;
  -- ADDED fpu related
  signal fpu_en                 : std_logic;
  signal fpu_work_finished      : std_logic_vector(CORES - 1 downto 0);
  signal fpu_instr              : fpu_opcode_type;
  signal fpu_instr_t             : fpu_opcode_type;   -- added JDGB
  signal fp_result_o            : vector_register;
  signal fp_overflow_o          : std_logic_vector(CORES - 1 downto 0);
  signal fp_underflow_o         : std_logic_vector(CORES - 1 downto 0);
  signal fp_inexact_o           : std_logic_vector(CORES - 1 downto 0);
  signal fp_invalid_o           : std_logic_vector(CORES - 1 downto 0);
  signal fp_except_o            : std_logic_vector(CORES - 1 downto 0);
  signal round_mode             : std_logic_vector(1 downto 0);
  signal fp_ready               : std_logic;
    
  -- SFU signals definition JDGB and JERC
  signal start_SFU_i            : std_logic;
  signal sfu_signal_start       : std_logic; 
  signal stall_SFU_o			: std_logic;
  signal Result_SFU_o           : vector_register;
  signal selop_SFU_i            : std_logic_vector(2 downto 0);
  signal sfu_reset_n			: std_logic;
  
   
  -- RRO signals definitions JDGB
  signal start_RRO			    : std_logic;
  signal rro_signal_start       : std_logic; 
  signal stall_RRO  			: std_logic;
  signal selec_phase_corrector  : std_logic;
  signal Result_RRO             : vector_register;
  signal reset_n_RRO		   	: std_logic;
  
  --RRO Quadrant registers 
  
begin
  --fpu opcode cast
  with alu_opcode_in select
  fpu_instr_t <= FADD when FADD,
                 FMUL when FMUL,
                 FMAD when FMAD,
                 CONV when CVT,
                 FSET when FSET,
				 UNKNOWN when others;
  
  --this signal enables the SFU when any SFU opcode occurs
  with alu_opcode_in select
  sfu_signal_start <= '1' when SIN|COS|LG2|EX2|RSQ|RCP,
					  '0' when others;
					  
					  
  --this signal start RRO hardware operation when alu_opcode_in is equal to RRO declaration	
  with alu_opcode_in select
  rro_signal_start <= '1' when RRO_SIN_OP|RRO_EX2_OP,
					  '0' when others;
					  
  --
  pPipelineExecute : process(clk_in, reset)
  begin
    if (reset = '1') then
	  start_SFU_i <= '0';   -- JERC SFU
	  start_RRO <= '0';
      warp_lane_id_out               <= (others => '0');
      warp_id_out                    <= (others => '0');
      branch_exec_en                 <= '0';
      cta_id_out                     <= (others => '0');
      initial_mask_out               <= (others => '0');
      current_mask_out               <= (others => '0');
      shmem_base_addr_out            <= (others => '0');
      gprs_size_out                  <= (others => '0');
      gprs_base_addr_out             <= (others => '0');
      instr_mask_out                 <= (others => '0');
      next_pc_out                    <= (others => '0');
      instr_opcode_out               <= UNKNOWN;
      set_pred_out                   <= '0';
      set_pred_reg_out               <= (others => '0');
      write_pred_out                 <= '0';
      addr_hi_out                    <= '0';
      addr_lo_out                    <= (others => '0');
      addr_incr_out                  <= '0';
      mov_size_out                   <= (others => '0');
      sm_type_out                    <= (others => '0');
      addr_imm_out                   <= '0';
      src1_out                       <= (others => '0');
      dest_mem_type_out              <= UNKNOWN;
      dest_mem_opcode_out            <= READ;
      dest_data_type_out             <= DT_UNKNOWN;
      dest_out                       <= (others => '0');
      temp_vector_register_out       <= (others => (others => (others => (others => '0'))));
      src1_i                         <= (others => (others => '0'));
      src2_i                         <= (others => (others => '0'));
      src3_i                         <= (others => (others => '0'));
      cvt_type_i                     <= (others => '0');
      w32_i                          <= '0';
      is_signed_i                    <= '0';
      pred_flags_i                   <= (others => (others => '0'));
      pipeline_stall_out             <= '0';
      pipeline_execute_done          <= '0';
      pipeline_execute_state_machine <= IDLE;
      warp_state_out                 <= READY;
      alu_opcode_i                   <= UNKNOWN;
      fpu_en                         <= '0';
      fpu_instr                      <= UNKNOWN;
      round_mode                     <= "00";
    elsif (rising_edge(clk_in)) then
      case pipeline_execute_state_machine is
        when IDLE =>
          pipeline_execute_done <= '0';
          branch_exec_en        <= '0';
          if(pipeline_read_done = '1') then
            -- REMOVED GIANLUCA ROASCIO - BAD PROGRAMMING, DON'T WANT TO DO THIS WHEN MOVING TO ALU EXEC, SO NEED TO ADD IT CASE PER CASE AFTER
            --temp_vector_register_out <= temp_vector_register_in;
            pipeline_stall_out <= '1';
            for i in 0 to CORES - 1 loop
              src1_i(i) <= temp_vector_register_in(i)(0)(0);
              src2_i(i) <= temp_vector_register_in(i)(2)(0);
              src3_i(i) <= temp_vector_register_in(i)(4)(0);
            end loop;
                                        -- ADDED GIANLUCA ROASCIO
            set_pred_i <= set_pred_in;
            if (instr_opcode_in = ALU) then
              alu_opcode_i <= alu_opcode_in;
              cvt_type_i   <= cvt_type_in;
              round_mode   <= cvt_round_in;
              w32_i        <= w32_in;
              is_signed_i  <= is_signed_in;
              pred_flags_i <= pred_flags_in;
			  fpu_instr	   <= fpu_instr_t;
              -- fpu_instr    <= FADD when alu_opcode_in = FADD
                           -- else FMUL when alu_opcode_in = FMUL
                           -- else FMAD when alu_opcode_in = FMAD
                           -- else CONV when alu_opcode_in = CVT
                           -- else FSET when alu_opcode_in = FSET
                           -- else RCP when alu_opcode_in = RCP;
              fpu_en <= '1' when (alu_opcode_in = FADD or alu_opcode_in = FMUL or  alu_opcode_in = FMAD or alu_opcode_in = FSET
                  or (alu_opcode_in = CVT and (instr_subop_in = "111" or instr_subop_in = "110" or instr_subop_in = "100" or instr_subop_in = "010")))
                else '0';
			  start_SFU_i <= sfu_signal_start; --SFU Start
			  start_RRO <= rro_signal_start; --RRO start
              pipeline_execute_state_machine <= ALU_EXEC;
            elsif (instr_opcode_in = MOV) then
              if (mov_opcode_in = MOV) then
                if (dest_mem_type_in = REG) then
                  if (instr_marker_in = IMM) then
                    pred_flags_i <= pred_flags_in;
                    for i in 0 to CORES - 1 loop
                      temp_vector_register_out(i)(TEMP_REG_DEST) <= temp_vector_register_in(i)(TEMP_REG_SRC2);
                      temp_vector_register_out(i)(TEMP_REG_SRC2) <= temp_vector_register_in(i)(TEMP_REG_SRC2);
                      temp_vector_register_out(i)(TEMP_REG_SRC3) <= temp_vector_register_in(i)(TEMP_REG_SRC3);
                    end loop;
                    pipeline_execute_state_machine <= MOV_DONE;
                  else
                                        -- ADDED GIANLUCA ROASCIO
                    temp_vector_register_out       <= temp_vector_register_in;
                    pred_flags_i                   <= pred_flags_in;
                    pipeline_execute_state_machine <= NOP;
                  end if;
                else
                  pred_flags_i                   <= pred_flags_in;
                  pipeline_execute_state_machine <= NOP;
                end if;
              elsif (mov_opcode_in = LOAD) then
                if ((dest_mem_type_in = MEM_SHARED) or (dest_mem_type_in = MEM_CONST)) then
                  cvt_type_i                     <= encode_conv_type(mem_type_to_cvt_type_o);
                  w32_i                          <= w32_in;
                  is_signed_i                    <= is_signed_in;
                  pred_flags_i                   <= pred_flags_in;
                  alu_opcode_i                   <= CVT;
                  pipeline_execute_state_machine <= ALU_EXEC;


				-- Modified condition JERC
				-- Original line:
--				elsif ((dest_mem_type_in = ADDRESS) and (temp_vector_register_in(0)(2)(0) /= x"00000000") ) then

				-- New line:
                elsif ((dest_mem_type_in = ADDRESS) and (temp_vector_register_in(0)(2)(0) /= x"00000000") and (instr_subop_in /= "001")   ) then  -- Modified TO, JERC
				-- End of change
				
                  w32_i                          <= '1';
                  is_signed_i                    <= '0';
                  pred_flags_i                   <= pred_flags_in;
                  alu_opcode_i                   <= SHL;
                  pipeline_execute_state_machine <= ALU_EXEC;
				  
				-- New condition targeting the evaluation of the ADA instruction: JERC  
				elsif ( (dest_mem_type_in = ADDRESS) and (instr_subop_in = "001") ) then
					w32_i                          <= '1';
					is_signed_i                    <= '0';
					pred_flags_i                   <= pred_flags_in;
					alu_opcode_i                   <= IADD;		-- it should be the process of addition in the ALU
					pipeline_execute_state_machine <= ALU_EXEC;
				-- End of added routine


                elsif ((dest_mem_type_in = ADDRESS_ADDRESS) or (dest_mem_type_in = FLAGS)) then
                  pred_flags_i                   <= pred_flags_in;
                                        -- ADDED GIANLUCA ROASCIO
                  temp_vector_register_out       <= temp_vector_register_in;
                  pipeline_execute_state_machine <= NOP;
                else
                                        -- ADDED GIANLUCA ROASCIO
                  temp_vector_register_out       <= temp_vector_register_in;
                  pipeline_execute_state_machine <= NOP;
                end if;
              elsif (mov_opcode_in = STORE) then
                if (dest_mem_type_in = MEM_SHARED) then
                  pred_flags_i <= pred_flags_in;
                  for i in 0 to CORES - 1 loop
                    temp_vector_register_out(i)(TEMP_REG_DEST) <= temp_vector_register_in(i)(TEMP_REG_SRC3);
                    temp_vector_register_out(i)(TEMP_REG_SRC2) <= temp_vector_register_in(i)(TEMP_REG_SRC2);
                    temp_vector_register_out(i)(TEMP_REG_SRC3) <= temp_vector_register_in(i)(TEMP_REG_SRC3);
                  end loop;
                  pipeline_execute_state_machine <= MOV_DONE;
                elsif ((dest_mem_type_in = MEM_GLOBAL) or (dest_mem_type_in = MEM_LOCAL) or (dest_mem_type_in = ADDRESS)) then
                  pred_flags_i                   <= pred_flags_in;
                                        -- ADDED GIANLUCA ROASCIO
                  temp_vector_register_out       <= temp_vector_register_in;
                  pipeline_execute_state_machine <= NOP;
                elsif (dest_mem_type_in = FLAGS) then
                  for i in 0 to CORES - 1 loop
                    pred_flags_i(i) <= temp_vector_register_in(i)(TEMP_REG_SRC2)(0)(3 downto 0);
                  end loop;
                  temp_vector_register_out       <= temp_vector_register_in;
                  pipeline_execute_state_machine <= MOV_DONE;
                else
                  pred_flags_i                   <= pred_flags_in;
                                        -- ADDED GIANLUCA ROASCIO
                  temp_vector_register_out       <= temp_vector_register_in;
                  pipeline_execute_state_machine <= NOP;
                end if;
              else
                                        -- ADDED GIANLUCA ROASCIO
                temp_vector_register_out       <= temp_vector_register_in;
                pred_flags_i                   <= pred_flags_in;
                pipeline_execute_state_machine <= NOP;
              end if;
            elsif (instr_opcode_in = FLOW) then
              branch_exec_en                 <= '1';
              pred_flags_i                   <= pred_flags_in;
              pipeline_execute_state_machine <= FLOW_EXEC;
            else
              pred_flags_i                   <= pred_flags_in;
                                        -- ADDED GIANLUCA ROASCIO
              temp_vector_register_out       <= temp_vector_register_in;
              pipeline_execute_state_machine <= NOP;
            end if;
          else
            pipeline_stall_out <= '0';
			start_SFU_i <= '0'; -- Not SFU start
			start_RRO <= '0'; -- Not RRO start
          end if;

        when ALU_EXEC =>
		-- added next line for SFU operation JDGB and JERC
		  start_SFU_i <= '0'; -- SFU its working, so the start signal shoud be turn off here;
		  start_RRO <= '0'; -- RRO its working, so the start signal shoud be turn off here;
        --  
		  if(fpu_en = '1') then         -- fpu work cannot be done in 1 cycle
            if(and_reduce(fpu_work_finished) = '1') then  -- CARE this suppose that all fpu are working
              pipeline_execute_state_machine <= ALU_DONE;
			else
			  pipeline_execute_state_machine <= ALU_EXEC;
            end if;
        -- added next "if" branch for waiting the SFU finish operation JDGB and JERC
		  elsif (sfu_signal_start = '1')  then--  SFU
				if(stall_SFU_o = '0') then
					pipeline_execute_state_machine <= ALU_DONE;
				else
					pipeline_execute_state_machine <= ALU_EXEC;
				end if;
		-- added next "if" branch for waiting the RRO finish operation JDGB
		  elsif (rro_signal_start = '1')  then-- RRO
				if(stall_RRO = '0') then
					pipeline_execute_state_machine <= ALU_DONE;
				else
					pipeline_execute_state_machine <= ALU_EXEC;
				end if;
          else
            pipeline_execute_state_machine <= ALU_DONE;
			
          end if;
        when ALU_DONE =>
		-- added next line, the SFU and RRO remains stopped JDGB and JERC
		start_SFU_i <= '0';
		start_RRO <= '0';
          if (pipeline_stall_in = '0') then
            warp_id_out         <= warp_id_in;
            warp_lane_id_out    <= warp_lane_id_in;
            cta_id_out          <= cta_id_in;
            initial_mask_out    <= initial_mask_in;
            current_mask_out    <= current_mask_in;
            shmem_base_addr_out <= shmem_base_addr_in;
            gprs_size_out       <= gprs_size_in;
            gprs_base_addr_out  <= gprs_base_addr_in;
            instr_mask_out      <= instr_mask_in;
            next_pc_out         <= next_pc_in;
            warp_state_out      <= ACTIVE;
            instr_opcode_out    <= instr_opcode_in;
            set_pred_out        <= set_pred_in;
            set_pred_reg_out    <= set_pred_reg_in;
            write_pred_out      <= write_pred_in;
            addr_hi_out         <= addr_hi_in;
            addr_lo_out         <= addr_lo_in;
            addr_incr_out       <= addr_incr_in;
            mov_size_out        <= mov_size_in;
            sm_type_out         <= sm_type_in;
            addr_imm_out        <= addr_imm_in;
            dest_mem_type_out   <= dest_mem_type_in;
            dest_mem_opcode_out <= dest_mem_opcode_in;
            dest_data_type_out  <= dest_data_type_in;
            src1_out            <= src1_in;
            dest_out            <= dest_in;
            if(fpu_en = '1') then       --select source for outputs
              for i in 0 to CORES - 1 loop
                temp_vector_register_out(i)(TEMP_REG_DEST)(0) <= fp_result_o(i);
                temp_vector_register_out(i)(1)                <= temp_vector_register_in(i)(1);
                temp_vector_register_out(i)(2)                <= temp_vector_register_in(i)(2);
                temp_vector_register_out(i)(3)                <= temp_vector_register_in(i)(3);
                temp_vector_register_out(i)(4)                <= temp_vector_register_in(i)(4);
                temp_vector_register_out(i)(5)                <= temp_vector_register_in(i)(5);
              end loop;
              fpu_en <= '0';
			-- added next "if" branch for copy the SFU result to the outputs, JDGB and JERC  
			elsif (sfu_signal_start = '1') then
			  for i in 0 to CORES - 1 loop
				temp_vector_register_out(i)(TEMP_REG_DEST)(0) <= Result_SFU_o(i);
				temp_vector_register_out(i)(1)                <= temp_vector_register_in(i)(1);
				temp_vector_register_out(i)(2)                <= temp_vector_register_in(i)(2);
				temp_vector_register_out(i)(3)                <= temp_vector_register_in(i)(3);
				temp_vector_register_out(i)(4)                <= temp_vector_register_in(i)(4);
				temp_vector_register_out(i)(5)                <= temp_vector_register_in(i)(5);
			  end loop;
			-- added next "if" branch for copy the RRO result to the outputs, JDGB  
			elsif (rro_signal_start = '1') then
			  for i in 0 to CORES - 1 loop
				temp_vector_register_out(i)(TEMP_REG_DEST)(0) <= Result_RRO(i);
				temp_vector_register_out(i)(1)                <= temp_vector_register_in(i)(1);
				temp_vector_register_out(i)(2)                <= temp_vector_register_in(i)(2);
				temp_vector_register_out(i)(3)                <= temp_vector_register_in(i)(3);
				temp_vector_register_out(i)(4)                <= temp_vector_register_in(i)(4);
				temp_vector_register_out(i)(5)                <= temp_vector_register_in(i)(5);
			  end loop;
            else
              for i in 0 to CORES - 1 loop
                temp_vector_register_out(i)(TEMP_REG_DEST)(0) <= sp_result_o(i);
                temp_vector_register_out(i)(1)                <= temp_vector_register_in(i)(1);
                temp_vector_register_out(i)(2)                <= temp_vector_register_in(i)(2);
                temp_vector_register_out(i)(3)                <= temp_vector_register_in(i)(3);
                temp_vector_register_out(i)(4)                <= temp_vector_register_in(i)(4);
                temp_vector_register_out(i)(5)                <= temp_vector_register_in(i)(5);
              end loop;
            end if;

            -- ADDED GIANLUCA ROASCIO
            pred_flags_out                 <= pred_flags_o;
            pipeline_execute_done          <= '1';
            pipeline_execute_state_machine <= IDLE;
          end if;

        when FLOW_EXEC =>
          branch_exec_en <= '0';
          if (branch_exec_done = '1') then
            pipeline_execute_state_machine <= FLOW_DONE;
          end if;

        when FLOW_DONE =>
          if (pipeline_stall_in = '0') then
            warp_id_out                    <= warp_id_in;
            warp_lane_id_out               <= warp_lane_id_in;
            cta_id_out                     <= cta_id_in;
            initial_mask_out               <= initial_mask_o;
            current_mask_out               <= current_mask_o;
            shmem_base_addr_out            <= shmem_base_addr_in;
            gprs_base_addr_out             <= gprs_base_addr_in;
            instr_mask_out                 <= instr_mask_o;
            next_pc_out                    <= next_pc_o;
            warp_state_out                 <= warp_state_o;
            instr_opcode_out               <= instr_opcode_in;
            set_pred_out                   <= set_pred_in;
            set_pred_reg_out               <= set_pred_reg_in;
            write_pred_out                 <= write_pred_in;
            addr_hi_out                    <= addr_hi_in;
            addr_lo_out                    <= addr_lo_in;
            addr_incr_out                  <= addr_incr_in;
            mov_size_out                   <= mov_size_in;
            sm_type_out                    <= sm_type_in;
            addr_imm_out                   <= addr_imm_in;
            dest_mem_type_out              <= dest_mem_type_in;
            dest_mem_opcode_out            <= dest_mem_opcode_in;
            dest_data_type_out             <= dest_data_type_in;
            src1_out                       <= src1_in;
            dest_out                       <= dest_in;
            temp_vector_register_out       <= temp_vector_register_in;
                                        -- ADDED GIANLUCA ROASCIO
            pred_flags_out                 <= pred_flags_o;
            pipeline_execute_done          <= '1';
            pipeline_execute_state_machine <= IDLE;
          end if;
        when MOV_DONE | NOP =>
          if (pipeline_stall_in = '0') then
            warp_id_out                    <= warp_id_in;
            warp_lane_id_out               <= warp_lane_id_in;
            cta_id_out                     <= cta_id_in;
            initial_mask_out               <= initial_mask_in;
            current_mask_out               <= current_mask_in;
            instr_mask_out                 <= instr_mask_in;
            shmem_base_addr_out            <= shmem_base_addr_in;
            gprs_base_addr_out             <= gprs_base_addr_in;
            next_pc_out                    <= next_pc_in;
            warp_state_out                 <= ACTIVE;
            instr_opcode_out               <= instr_opcode_in;
            set_pred_out                   <= set_pred_in;
            set_pred_reg_out               <= set_pred_reg_in;
            write_pred_out                 <= write_pred_in;
            addr_hi_out                    <= addr_hi_in;
            addr_lo_out                    <= addr_lo_in;
            addr_incr_out                  <= addr_incr_in;
            mov_size_out                   <= mov_size_in;
            sm_type_out                    <= sm_type_in;
            addr_imm_out                   <= addr_imm_in;
            dest_mem_type_out              <= dest_mem_type_in;
            dest_mem_opcode_out            <= dest_mem_opcode_in;
            dest_data_type_out             <= dest_data_type_in;
            src1_out                       <= src1_in;
            dest_out                       <= dest_in;
                                        -- temp_vector_register_out       <= temp_vector_register_in; -- assign is done in the IDLE state with conditions, this one here will override the correct assignment above
                                        -- ADDED GIANLUCA ROASCIO
            pred_flags_out                 <= pred_flags_o;
            pipeline_execute_done          <= '1';
            pipeline_execute_state_machine <= IDLE;
          end if;
      --when others =>
      --        pipeline_execute_state_machine <= IDLE;
      end case;
    end if;
  end process;

  uConvertDataTypes : convert_data_types
    port map(
      mov_size_in                => (others => '0'),
      conv_type_in               => CT_NONE,
      reg_type_in                => RT_NONE,
      data_type_in               => data_type_i,
      sm_type_in                 => (others => '0'),
      mem_type_in                => mem_type_in,
      mv_size_to_sm_type_out     => open,
      data_type_to_sm_type_out   => open,
      sm_type_to_sm_type_out     => open,
      mem_type_to_sm_type_out    => open,
      conv_type_to_reg_type_out  => open,
      reg_type_to_data_type_out  => open,
      mv_size_to_data_type_out   => open,
      conv_type_to_data_type_out => open,
      sm_type_to_data_type_out   => open,
      mem_type_to_data_type_out  => open,
      sm_type_to_cvt_type_out    => open,
      mem_type_to_cvt_type_out   => mem_type_to_cvt_type_o
      );

  uBranchExecuteUnit : branch_exec_unit
    port map(
      clk_in                  => clk_in,
      host_reset              => reset,
      branch_exec_en          => branch_exec_en,
      flow_opcode_in          => flow_opcode_in,
      warp_id_in              => warp_id_in,
      warp_lane_id_in         => warp_lane_id_in,
      initial_mask_in         => initial_mask_in,
      current_mask_in         => current_mask_in,
      instr_mask_in           => instr_mask_in,
      next_pc_in              => next_pc_in,
      target_address_in       => target_addr_in,
      warp_div_req_out        => warp_div_req_out,
      warp_div_ack_out        => warp_div_ack_out,
      warp_div_grant_in       => warp_div_grant_in,
      warp_div_stack_en_out   => warp_div_stack_en_out,
      warp_div_wr_data_out    => warp_div_wr_data_out,
      warp_div_rd_data_in     => warp_div_rd_data_in,
      warp_div_push_en_out    => warp_div_push_en_out,
      warp_div_stack_full_in  => warp_div_stack_full_in,
      warp_div_stack_empty_in => warp_div_stack_empty_in,
      initial_mask_out        => initial_mask_o,
      current_mask_out        => current_mask_o,
      instr_mask_out          => instr_mask_o,
      next_pc_out             => next_pc_o,
      warp_state_out          => warp_state_o,
      branch_exec_done        => branch_exec_done
      );

  gScalarProcessor : for i in 0 to CORES - 1 generate
    uScalarProcessor : scalar_processor
      port map(
        alu_opcode_in   => alu_opcode_i,
        instr_subop_in  => instr_subop_in,
        instr_marker_in => instr_marker_in,  -- ADDED GIANLUCA ROASCIO
        src1_in         => src1_i(i),
        src2_in         => src2_i(i),
        src3_in         => src3_i(i),
        src1_neg_in     => src1_neg_in,
        src2_neg_in     => src2_neg_in,
        src3_neg_in     => src3_neg_in,
        carry_in        => pred_flags_i(i)(2),
        saturate_in     => saturate_in,
        w32_in          => w32_i,
        is_signed_in    => is_signed_i,
        abs_saturate_in => abs_saturate_in,
        cvt_neg_in      => cvt_neg_in,
        cvt_type_in     => cvt_type_i,
        set_cond_in     => set_cond_in,
        carry_out       => sp_carry_o(i),
        overflow_out    => sp_overflow_o(i),
        sign_out        => sp_sign_o(i),
        zero_out        => sp_zero_o(i),
        result_out      => sp_result_o(i)
        );
  end generate;

  gFloatingPointUnit : for i in 0 to CORES - 1 generate -- ADDED FPU Generation
    uFLoatingPointUnit : fpu_single
      port map(
        clk              => clk_in,
        rst              => reset,
        enable           => fpu_en,
        rmode            => round_mode,
        S32              => is_signed_i,
        abs_en           => saturate_in,
        set_cond_in      => set_cond_in,
        fpu_opcode_in    => fpu_instr,
        fpu_subopcode_in => instr_subop_in,
        src1_in          => src1_i(i),
        src2_in          => src2_i(i),
        src3_in          => src3_i(i),
        src1_neg_in      => src1_neg_in,
        src2_neg_in      => src2_neg_in,
        src3_neg_in      => src3_neg_in,
        out_fp           => fp_result_o(i),
        stall_in         => pipeline_stall_in,
        finished         => fpu_work_finished(i),
        underflow        => fp_underflow_o(i),
        overflow         => fp_overflow_o(i),
        inexact          => fp_inexact_o(i),
        exception        => fp_except_o(i),
        invalid          => fp_invalid_o(i)
        );
  end generate;

-- ADDED SFU Generation JDGB and JERC
uSpecialFunctionUnitProcessor : sfu_proc
	port map (
	clk_i	   => clk_in,							-- input clock
	rst_n	   => sfu_reset_n,						-- reset signal active low
	start_i    => start_SFU_i,						-- start operation, one clock cycle pulse
	src1_i	   => src1_i, 						-- IEE754 input data single precision
	selop_i    => selop_SFU_i,    		            -- operation selection
	Result_o   => Result_SFU_o, 					-- IEE754 result data output single precision
	stall_o    => stall_SFU_o  						-- stall signal: 1=SFU is bussy, 0=SFU finish or ready
	);

	sfu_reset_n <= not reset; --reset signal for SFU, to guarantee reset active low signal JDGB and JERC
	
	-- assign equivalent operation selection code acording to SFU opcode definitions JDGB and JERC
	with alu_opcode_in select                      
		selop_SFU_i <= "000" when SIN,
					   "001" when COS,
					   "010" when RSQ,
					   "011" when LG2,
					   "100" when EX2,
					   "101" when RCP,
					   "111" when others;


	-- assign equivalent operation selection code acording to SFU opcode definitions JDGB and JERC                    
		selec_phase_corrector <= '1' when alu_opcode_in=RRO_EX2_OP else '0';

-- ADDED RRO Generation JDGB 
uRangeReductionOp : rro_proc
	port map (
	clk_i		=> clk_in,
	rst_n		=> sfu_reset_n,
	start_i		=> start_RRO,
	selec_phase	=> selec_phase_corrector,
	src1_i     	=> src1_i,
	stall_o  	=> stall_RRO,
	Result     	=> Result_RRO);

  --gPredicateFlags : for i in 0 to CORES - 1 generate
  --    pred_flags_out(i)(2) <= sp_carry_o(i) when (alu_opcode_i = IADD or alu_opcode_i = IADDC or alu_opcode_i = ISUB or alu_opcode_i = IMAD24 or alu_opcode_i = IMAD24C)
  --            else pred_flags_i(i)(2);

  --    pred_flags_out(i)(3) <= sp_overflow_o(i) when (alu_opcode_i = IADD or alu_opcode_i = IADDC or alu_opcode_i = ISUB or alu_opcode_i = IMAD24 or alu_opcode_i = IMAD24C)
  --            else pred_flags_i(i)(3);

  --    -- MODIFIED GIANLUCA ROASCIO - ZERO AND SIGN FLAGS CAN BE SET ALSO BY OTHER INSTRUCTIONS DIFFERENT FROM ISET
  --    --pred_flags_out(i)(1) <= sp_sign_o(i) when (alu_opcode_i = SET) else pred_flags_i(i)(1);
  --    pred_flags_out(i)(1) <= sp_sign_o(i) when (set_pred_i = '1') else pred_flags_i(i)(1);

  --    --pred_flags_out(i)(0) <= sp_zero_o(i) when (alu_opcode_i = SET) else pred_flags_i(i)(0);
  --    pred_flags_out(i)(0) <= sp_zero_o(i) when (set_pred_i = '1') else pred_flags_i(i)(0);
  --end generate;

  -- REWRITTEN GIANLUCA ROASCIO - FLAGS SHOULD BE UPDATED AT THE OUTPUT ONLY WHEN THE STAGE IS DONE, NOT AT ANYTIME, SO IT IS NEEDED AN INTERMEDIATE REGISTER FOR THOSE
  gPredicateFlags : for i in 0 to CORES - 1 generate
    pred_flags_o(i)(3) <= sp_overflow_o(i) when (alu_opcode_i = IADD or alu_opcode_i = IADDC or alu_opcode_i = ISUB or alu_opcode_i = IMAD24 or alu_opcode_i = IMAD24C)
                          else pred_flags_i(i)(3);

    pred_flags_o(i)(2) <= sp_carry_o(i) when (alu_opcode_i = IADD or alu_opcode_i = IADDC or alu_opcode_i = ISUB or alu_opcode_i = IMAD24 or alu_opcode_i = IMAD24C)
                          else pred_flags_i(i)(2);

    pred_flags_o(i)(1) <=  fp_result_o(i)(29) when (alu_opcode_i = FSET and set_pred_i = '1') -- ADDED CASE FSET, when comparison is true, pred_flags_o(i)(1) should be '1' else '0'
                          else sp_sign_o(i) when (set_pred_i = '1') -- move down bc overlapping
                          else pred_flags_i(i)(1);

    pred_flags_o(i)(0) <= (not fp_result_o(i)(29)) when (alu_opcode_i = FSET and set_pred_i = '1')  -- ADDED CASE FSET, when comparison is true, pred_flags_o(i)(0) should be '0' else '1'
                          else sp_zero_o(i) when (set_pred_i = '1') -- move down bc overlapping
                          else pred_flags_i(i)(0);
  end generate;


end p_exec_arch;
