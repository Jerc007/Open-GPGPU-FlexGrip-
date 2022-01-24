----------------------------------------------------------------------------------
-- Company:          Univerity of Massachusetts 
-- Engineer:         Kevin Andryc
-- 
-- Create Date:      17:50:27 09/19/2010  
-- Module Name:      streaming_multiprocessor - arch 
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

entity pipeline_read is
	generic(
		SHMEM_ADDR_SIZE : integer := 14;
		CMEM_ADDR_SIZE  : integer := 18;
		GMEM_ADDR_SIZE  : integer := 18
	);
	port(
		reset                      : in  std_logic;
		clk_in                     : in  std_logic;
		pipeline_dec_done          : in  std_logic; -- from prev stage
		pipeline_stall_in          : in  std_logic; -- from next stage
		-- From DECODE stage
		warp_id_in                 : in  std_logic_vector(4 downto 0);
		warp_lane_id_in            : in  std_logic_vector(1 downto 0);
		cta_id_in                  : in  std_logic_vector(3 downto 0);
		initial_mask_in            : in  std_logic_vector(31 downto 0);
		current_mask_in            : in  std_logic_vector(31 downto 0);
		shmem_base_addr_in         : in  std_logic_vector(SHMEM_ADDR_SIZE - 1 downto 0);
		gprs_size_in               : in  std_logic_vector(8 downto 0);
		gprs_base_addr_in          : in  std_logic_vector(8 downto 0);
		next_pc_in                 : in  std_logic_vector(31 downto 0);
		instr_opcode_in            : in  instr_opcode_type;
		instr_subop_in             : in  std_logic_vector(2 downto 0);
		alu_opcode_in              : in  alu_opcode_type;
		flow_opcode_in             : in  flow_opcode_type;
		mov_opcode_in              : in  mov_opcode_type;
		instr_marker_in            : in  instr_marker_type;
		pred_reg_in                : in  std_logic_vector(1 downto 0);
		pred_cond_in               : in  std_logic_vector(4 downto 0);
		set_pred_in                : in  std_logic;
		set_pred_reg_in            : in  std_logic_vector(1 downto 0);
		write_pred_in              : in  std_logic;
		is_signed_in               : in  std_logic;
		w32_in                     : in  std_logic;
		f64_in                     : in  std_logic;
		saturate_in                : in  std_logic;
		abs_saturate_in            : in  std_logic_vector(1 downto 0);
		cvt_round_in               : in  std_logic_vector(1 downto 0);
		cvt_type_in                : in  std_logic_vector(2 downto 0);
		cvt_neg_in                 : in  std_logic;
		condition_in               : in  std_logic_vector(2 downto 0);
		addr_hi_in                 : in  std_logic;
		addr_lo_in                 : in  std_logic_vector(1 downto 0);
		addr_incr_in               : in  std_logic;
		mov_size_in                : in  std_logic_vector(2 downto 0);
		mem_type_in                : in  std_logic_vector(2 downto 0);
		sm_type_in                 : in  std_logic_vector(1 downto 0);
		imm_hi_in                  : in  std_logic_vector(25 downto 0);
		addr_imm_in                : in  std_logic;
		src1_mem_type_in           : in  mem_type;
		src2_mem_type_in           : in  mem_type;
		src3_mem_type_in           : in  mem_type;
		dest_mem_type_in           : in  mem_type;
		src1_mem_opcode_in         : in  mem_opcode_type;
		src2_mem_opcode_in         : in  mem_opcode_type;
		src3_mem_opcode_in         : in  mem_opcode_type;
		dest_mem_opcode_in         : in  mem_opcode_type;
		src1_neg_in                : in  std_logic;
		src2_neg_in                : in  std_logic;
		src3_neg_in                : in  std_logic;
		target_addr_in             : in  std_logic_vector(18 downto 0);
		src1_data_type_in          : in  data_type;
		src2_data_type_in          : in  data_type;
		src3_data_type_in          : in  data_type;
		dest_data_type_in          : in  data_type;
		src1_in                    : in  std_logic_vector(31 downto 0);
		src2_in                    : in  std_logic_vector(31 downto 0);
		src3_in                    : in  std_logic_vector(31 downto 0);
		dest_in                    : in  std_logic_vector(31 downto 0);
		-- vector registers
		gprs_base_addr_out         : out gprs_addr_array;
		gprs_reg_num_out           : out gprs_reg_array;
		gprs_lane_id_out           : out warp_lane_id_array;
		gprs_wr_en_out             : out wr_en_array;
		gprs_wr_data_out           : out vector_register;
		gprs_rd_data_in            : in  vector_register;
		-- pred registers
		pred_regs_warp_id_out      : out warp_id_array;
		pred_regs_warp_lane_id_out : out warp_lane_id_array;
		pred_regs_reg_num_out      : out reg_num_array;
		pred_regs_wr_en_out        : out wr_en_array;
		pred_regs_wr_data_out      : out vector_flag_register;
		pred_regs_rd_data_in       : in  vector_flag_register;
		-- addr registers
		addr_regs_warp_id_out      : out warp_id_array;
		addr_regs_warp_lane_id_out : out warp_lane_id_array;
		addr_regs_reg_num_out      : out reg_num_array;
		addr_regs_wr_en_out        : out wr_en_array;
		addr_regs_wr_data_out      : out vector_register;
		addr_regs_rd_data_in       : in  vector_register;
		-- WARP
		warp_div_req_out           : out std_logic;
		warp_div_ack_out           : out std_logic;
		warp_div_grant_in          : in  std_logic;
		warp_div_stack_en          : out warp_div_std_logic_array;
		warp_div_rd_data_in        : in  warp_div_data_array;
		--warp_div_wr_data_out       : out warp_div_data_array;
		warp_div_push_en           : out warp_div_std_logic_array;
		--warp_div_stack_full        : in  warp_div_std_logic_array;
		warp_div_stack_empty       : in  warp_div_std_logic_array;
		-- shared memory
		shmem_addr_out             : out std_logic_vector(SHMEM_ADDR_SIZE - 1 downto 0);
		shmem_wr_en_out            : out std_logic;
		shmem_wr_data_out          : out std_logic_vector(7 downto 0);
		shmem_rd_data_in           : in  std_logic_vector(7 downto 0);
		-- constant memory
		cmem_addr_out              : out std_logic_vector(CMEM_ADDR_SIZE - 1 downto 0);
		cmem_wr_en_out             : out std_logic;
		cmem_wr_data_out           : out std_logic_vector(7 downto 0);
		cmem_rd_data_in            : in  std_logic_vector(7 downto 0);
		-- global memory
		gmem_addr_out              : out std_logic_vector(GMEM_ADDR_SIZE - 1 downto 0);
		gmem_wr_en_out             : out std_logic;
		gmem_wr_data_out           : out std_logic_vector(7 downto 0);
		gmem_rd_data_in            : in  std_logic_vector(7 downto 0);
		-- to EX stage
		warp_id_out                : out std_logic_vector(4 downto 0);
		warp_lane_id_out           : out std_logic_vector(1 downto 0);
		cta_id_out                 : out std_logic_vector(3 downto 0);
		initial_mask_out           : out std_logic_vector(31 downto 0);
		current_mask_out           : out std_logic_vector(31 downto 0);
		shmem_base_addr_out        : out std_logic_vector(SHMEM_ADDR_SIZE - 1 downto 0);
		gprs_size_out              : out std_logic_vector(8 downto 0);
		gprs_addr_out              : out std_logic_vector(8 downto 0);
		instruction_mask_out       : out std_logic_vector(31 downto 0);
		next_pc_out                : out std_logic_vector(31 downto 0);
		instr_opcode_type_out      : out instr_opcode_type;
		instr_subop_type_out       : out std_logic_vector(2 downto 0);
		alu_opcode_out             : out alu_opcode_type;
		flow_opcode_out            : out flow_opcode_type;
		mov_opcode_out             : out mov_opcode_type;
		instr_marker_out           : out instr_marker_type;
		set_pred_out               : out std_logic;
		set_pred_reg_out           : out std_logic_vector(1 downto 0);
		write_pred_out             : out std_logic;
		is_full_normal_out         : out std_logic;
		is_signed_out              : out std_logic;
		w32_out                    : out std_logic;
		f64_out                    : out std_logic;
		saturate_out               : out std_logic;
		abs_saturate_out           : out std_logic_vector(1 downto 0);
		cvt_round_out              : out std_logic_vector(1 downto 0);
		cvt_type_out               : out std_logic_vector(2 downto 0);
		cvt_neg_out                : out std_logic;
		condition_out              : out std_logic_vector(2 downto 0);
		addr_hi_out                : out std_logic;
		addr_lo_out                : out std_logic_vector(1 downto 0);
		addr_incr_out              : out std_logic;
		mov_size_out               : out std_logic_vector(2 downto 0);
		mem_type_out               : out std_logic_vector(2 downto 0);
		sm_type_out                : out std_logic_vector(1 downto 0);
		addr_imm_out               : out std_logic;
		dest_mem_type_out          : out mem_type;
		dest_mem_opcode_out        : out mem_opcode_type;
		src1_neg_out               : out std_logic;
		src2_neg_out               : out std_logic;
		src3_neg_out               : out std_logic;
		target_addr_out            : out std_logic_vector(18 downto 0);
		dest_data_type_out         : out data_type;
		src1_out                   : out std_logic_vector(31 downto 0);
		dest_out                   : out std_logic_vector(31 downto 0);
		pred_flags_out             : out vector_flag_register;
		temp_vector_register_out   : out temp_vector_register;
		pipeline_stall_out         : out std_logic;
		pipeline_read_done         : out std_logic
	);
end pipeline_read;

architecture arch of pipeline_read is
	
	type read_state_type is (IDLE, 
							 PRED_REGS_MASK_REQUEST, 
							 READ_PRED_REGS_MASK, 
							 WAIT_PRED_LUT_DATA, 
							 GET_PRED_REGS_MASK, 
							 CALC_MASK, 
							 CHECK_JOIN, 
							 REQUEST_STACK, 
							 READ_STACK_WAIT, 
							 READ_STACK, 
							 CHECK_PRED_FLAGS, 
							 PRED_REGS_FLAGS_REQUEST, 
							 READ_PRED_REGS_FLAGS, 
							 READ_OPS, 
							 READ_OPS_WAIT, 
							 READ_OPS_DONE
	);
	
	signal read_state_machine : read_state_type;

	constant ARB_GPRS_CNT      : integer := 9;
	constant ARB_ADDR_REGS_CNT : integer := 9;
	constant ARB_PRED_REGS_CNT : integer := 4;
	constant ARB_SHMEM_CNT     : integer := 3;
	constant ARB_CMEM_CNT      : integer := 3;
	constant ARB_GMEM_CNT      : integer := 3;

	signal current_mask_i : std_logic_vector(31 downto 0);
	signal mask_i         : std_logic_vector(CORES - 1 downto 0);
	signal addr_reg_i     : std_logic_vector(2 downto 0);
	signal addr_hi_i_3    : std_logic_vector(2 downto 0);

	signal pred_regs_en : std_logic;

	signal pred_regs_reg_num  : std_logic_vector(1 downto 0);
	signal pred_regs_rd_data  : vector_flag_register;
	signal pred_regs_wr_data  : vector_flag_register;
	signal pred_regs_rd_wr_en : std_logic;
	signal pred_regs_cntr     : std_logic_vector(2 downto 0);
	signal pred_regs_data     : vector_pred_register;
	signal pred_lut_data_o    : std_logic_vector(31 downto 0);
	signal instruction_mask_i : std_logic_vector(31 downto 0);
	signal warp_id_addr       : integer range 0 to MAX_WARPS;
	signal next_pc            : std_logic_vector(31 downto 0);
	signal pred_flags_i       : vector_flag_register;

	signal arb_gprs_req   : std_logic_vector(ARB_GPRS_CNT - 1 downto 0);
	signal arb_gprs_ack   : std_logic;
	signal arb_gprs_ack_o : std_logic_vector(ARB_GPRS_CNT - 1 downto 0);
	signal arb_gprs_grant : std_logic_vector(ARB_GPRS_CNT - 1 downto 0);

	signal arb_addr_regs_req   : std_logic_vector(ARB_ADDR_REGS_CNT - 1 downto 0);
	signal arb_addr_regs_ack   : std_logic;
	signal arb_addr_regs_ack_o : std_logic_vector(ARB_ADDR_REGS_CNT - 1 downto 0);
	signal arb_addr_regs_grant : std_logic_vector(ARB_ADDR_REGS_CNT - 1 downto 0);

	signal arb_pred_regs_req   : std_logic_vector(ARB_PRED_REGS_CNT - 1 downto 0);
	signal arb_pred_regs_ack   : std_logic;
	signal arb_pred_regs_ack_o : std_logic_vector(ARB_PRED_REGS_CNT - 1 downto 0);
	signal arb_pred_regs_grant : std_logic_vector(ARB_PRED_REGS_CNT - 1 downto 0);

	signal arb_shmem_req   : std_logic_vector(ARB_SHMEM_CNT - 1 downto 0);
	signal arb_shmem_ack   : std_logic;
	signal arb_shmem_ack_o : std_logic_vector(ARB_SHMEM_CNT - 1 downto 0);
	signal arb_shmem_grant : std_logic_vector(ARB_SHMEM_CNT - 1 downto 0);

	signal arb_cmem_req   : std_logic_vector(ARB_CMEM_CNT - 1 downto 0);
	signal arb_cmem_ack   : std_logic;
	signal arb_cmem_ack_o : std_logic_vector(ARB_CMEM_CNT - 1 downto 0);
	signal arb_cmem_grant : std_logic_vector(ARB_CMEM_CNT - 1 downto 0);

	signal arb_gmem_req   : std_logic_vector(ARB_GMEM_CNT - 1 downto 0);
	signal arb_gmem_ack   : std_logic;
	signal arb_gmem_ack_o : std_logic_vector(ARB_GMEM_CNT - 1 downto 0);
	signal arb_gmem_grant : std_logic_vector(ARB_GMEM_CNT - 1 downto 0);

	signal gprs_en_i        : std_logic;
	signal gprs_reg_num_i   : std_logic_vector(8 downto 0);
	signal gprs_data_type_i : data_type;
	signal gprs_mask_i      : std_logic_vector(CORES - 1 downto 0);
	signal gprs_data_o      : vector_word_register_array;
	signal gprs_rdy_o       : std_logic;

	signal pred_regs_en_i      : std_logic;
	signal pred_regs_reg_num_i : std_logic_vector(1 downto 0);
	signal pred_mask           : std_logic_vector(31 downto 0);
	--	signal pred_regs_mask_i    : std_logic_vector(CORES - 1 downto 0);
	signal pred_regs_data_o    : vector_flag_register;
	signal pred_regs_rdy_o     : std_logic;

	signal addr_regs_en_i   : std_logic;
	signal addr_regs_num_i  : std_logic_vector(1 downto 0);
	signal addr_regs_data_o : vector_register;
	signal addr_regs_rdy_o  : std_logic;

	signal shmem_gprs_en : std_logic;
	signal cmem_gprs_en  : std_logic;
	signal gmem_gprs_en  : std_logic;

	signal shmem_gprs_reg_num : std_logic_vector(8 downto 0);
	signal cmem_gprs_reg_num  : std_logic_vector(8 downto 0);
	signal gmem_gprs_reg_num  : std_logic_vector(8 downto 0);

	signal shmem_gprs_data_type : data_type;
	signal cmem_gprs_data_type  : data_type;
	signal gmem_gprs_data_type  : data_type;

	signal shmem_gprs_rd_data : vector_word_register_array;
	signal cmem_gprs_rd_data  : vector_word_register_array;
	signal gmem_gprs_rd_data  : vector_word_register_array;

	signal shmem_gprs_rdy : std_logic;
	signal cmem_gprs_rdy  : std_logic;
	signal gmem_gprs_rdy  : std_logic;

	signal shmem_addr_regs_en : std_logic;
	signal cmem_addr_regs_en  : std_logic;
	signal gmem_addr_regs_en  : std_logic;

	signal shmem_addr_regs_reg : std_logic_vector(1 downto 0);
	signal cmem_addr_regs_reg  : std_logic_vector(1 downto 0);
	signal gmem_addr_regs_reg  : std_logic_vector(1 downto 0);

	signal shmem_addr_regs_rd_data : vector_register;
	signal cmem_addr_regs_rd_data  : vector_register;
	signal gmem_addr_regs_rd_data  : vector_register;

	signal shmem_addr_regs_rdy : std_logic;
	signal cmem_addr_regs_rdy  : std_logic;
	signal gmem_addr_regs_rdy  : std_logic;

	signal shmem_en_i : std_logic;
	signal cmem_en_i  : std_logic;
	signal gmem_en_i  : std_logic;

	signal shmem_rd_wr_type_i : mem_opcode_type;
	signal shmem_addr_i       : std_logic_vector(31 downto 0);
	signal shmem_mask_i       : std_logic_vector(CORES - 1 downto 0);
	signal shmem_sm_type_i    : sm_type;

	signal cmem_rd_wr_type_i : mem_opcode_type;
	signal cmem_addr_i       : vector_register;
	signal cmem_mask_i       : std_logic_vector(CORES - 1 downto 0);
	signal cmem_sm_type_i    : sm_type;

	signal gmem_wr_data_i    : vector_word_register_array;
	signal gmem_rd_wr_type_i : mem_opcode_type;
	signal gmem_addr_i       : std_logic_vector(31 downto 0);
	signal gmem_mask_i       : std_logic_vector(CORES - 1 downto 0);

	signal shmem_rd_data_o : vector_word_register_array;
	signal shmem_rdy_o     : std_logic;

	signal cmem_rd_data_o : vector_word_register_array;
	signal cmem_rdy_o     : std_logic;

	signal gmem_rd_data_o : vector_word_register_array;
	signal gmem_rdy_o     : std_logic;

	signal gmem_data_type_i : data_type;

	signal src1_read_en                   : std_logic;
	signal src1_gprs_en                   : std_logic;
	signal src1_gprs_reg_num              : std_logic_vector(8 downto 0);
	signal src1_gprs_data_type            : data_type;
	signal src1_gprs_mask                 : std_logic_vector(CORES - 1 downto 0);
	signal src1_gprs_rd_data              : vector_word_register_array;
	signal src1_gprs_rdy                  : std_logic;
	signal src1_addr_regs_en              : std_logic;
	signal src1_addr_regs_reg_num         : std_logic_vector(1 downto 0);
	signal src1_addr_regs_rd_data         : vector_register;
	signal src1_addr_regs_rdy             : std_logic;
	signal src1_pred_regs_en              : std_logic;
	signal src1_pred_regs_reg_num         : std_logic_vector(1 downto 0);
	signal src1_pred_regs_rd_data         : vector_flag_register;
	signal src1_pred_regs_rdy             : std_logic;
	signal src1_shmem_en                  : std_logic;
	signal src1_shmem_addr                : std_logic_vector(31 downto 0);
	signal src1_shmem_sm_type             : sm_type;
	signal src1_shmem_rd_wr_type          : mem_opcode_type;
	signal src1_shmem_mask                : std_logic_vector(CORES - 1 downto 0);
	signal src1_shmem_rd_data             : vector_word_register_array;
	signal src1_shmem_rdy                 : std_logic;
	signal src1_cmem_en                   : std_logic;
	signal src1_cmem_addr                 : std_logic_vector(31 downto 0);
	signal src1_cmem_sm_type              : sm_type;
	signal src1_cmem_rd_wr_type           : mem_opcode_type;
	signal src1_cmem_mask                 : std_logic_vector(CORES - 1 downto 0);
	signal src1_cmem_rd_data              : vector_word_register_array;
	signal src1_cmem_rdy                  : std_logic;
	signal src1_gmem_en                   : std_logic;
	signal src1_gmem_addr                 : std_logic_vector(31 downto 0);
	signal src1_gmem_rd_wr_type           : mem_opcode_type;
	signal src1_gmem_data_type            : data_type;
	signal src1_gmem_mask                 : std_logic_vector(CORES - 1 downto 0);
	signal src1_gmem_rd_data              : vector_word_register_array;
	signal src1_gmem_rdy                  : std_logic;
	signal src1_effaddr_gprs_en           : std_logic;
	signal src1_effaddr_gprs_reg_num      : std_logic_vector(8 downto 0);
	signal src1_effaddr_gprs_data_type    : data_type;
	signal src1_effaddr_gprs_rd_data      : vector_word_register_array;
	signal src1_effaddr_gprs_rdy          : std_logic;
	signal src1_effaddr_addr_regs_en      : std_logic;
	signal src1_effaddr_addr_regs_reg     : std_logic_vector(1 downto 0);
	signal src1_effaddr_addr_regs_rd_data : vector_register;
	signal src1_effaddr_addr_regs_rdy     : std_logic;
	signal src1_data_o                    : vector_word_register_array;
	signal src1_rdy_o                     : std_logic;

	signal src2_read_en                   : std_logic;
	signal src2_gprs_en                   : std_logic;
	signal src2_gprs_reg_num              : std_logic_vector(8 downto 0);
	signal src2_gprs_data_type            : data_type;
	signal src2_gprs_mask                 : std_logic_vector(CORES - 1 downto 0);
	signal src2_gprs_rd_data              : vector_word_register_array;
	signal src2_gprs_rdy                  : std_logic;
	signal src2_addr_regs_en              : std_logic;
	signal src2_addr_regs_reg_num         : std_logic_vector(1 downto 0);
	signal src2_addr_regs_rd_data         : vector_register;
	signal src2_addr_regs_rdy             : std_logic;
	signal src2_pred_regs_en              : std_logic;
	signal src2_pred_regs_reg_num         : std_logic_vector(1 downto 0);
	signal src2_pred_regs_rd_data         : vector_flag_register;
	signal src2_pred_regs_rdy             : std_logic;
	signal src2_shmem_en                  : std_logic;
	signal src2_shmem_addr                : std_logic_vector(31 downto 0);
	signal src2_shmem_sm_type             : sm_type;
	signal src2_shmem_rd_wr_type          : mem_opcode_type;
	signal src2_shmem_mask                : std_logic_vector(CORES - 1 downto 0);
	signal src2_shmem_rd_data             : vector_word_register_array;
	signal src2_shmem_rdy                 : std_logic;
	signal src2_cmem_en                   : std_logic;
	signal src2_cmem_addr                 : std_logic_vector(31 downto 0);
	signal src2_cmem_sm_type              : sm_type;
	signal src2_cmem_rd_wr_type           : mem_opcode_type;
	signal src2_cmem_mask                 : std_logic_vector(CORES - 1 downto 0);
	signal src2_cmem_rd_data              : vector_word_register_array;
	signal src2_cmem_rdy                  : std_logic;
	signal src2_gmem_en                   : std_logic;
	signal src2_gmem_addr                 : std_logic_vector(31 downto 0);
	signal src2_gmem_rd_wr_type           : mem_opcode_type;
	signal src2_gmem_data_type            : data_type;
	signal src2_gmem_mask                 : std_logic_vector(CORES - 1 downto 0);
	signal src2_gmem_rd_data              : vector_word_register_array;
	signal src2_gmem_rdy                  : std_logic;
	signal src2_effaddr_gprs_en           : std_logic;
	signal src2_effaddr_gprs_reg_num      : std_logic_vector(8 downto 0);
	signal src2_effaddr_gprs_data_type    : data_type;
	signal src2_effaddr_gprs_rd_data      : vector_word_register_array;
	signal src2_effaddr_gprs_rdy          : std_logic;
	signal src2_effaddr_addr_regs_en      : std_logic;
	signal src2_effaddr_addr_regs_reg     : std_logic_vector(1 downto 0);
	signal src2_effaddr_addr_regs_rd_data : vector_register;
	signal src2_effaddr_addr_regs_rdy     : std_logic;
	signal src2_data_o                    : vector_word_register_array;
	signal src2_rdy_o                     : std_logic;

	signal src3_read_en                   : std_logic;
	signal src3_gprs_en                   : std_logic;
	signal src3_gprs_reg_num              : std_logic_vector(8 downto 0);
	signal src3_gprs_data_type            : data_type;
	signal src3_gprs_mask                 : std_logic_vector(CORES - 1 downto 0);
	signal src3_gprs_rd_data              : vector_word_register_array;
	signal src3_gprs_rdy                  : std_logic;
	signal src3_addr_regs_en              : std_logic;
	signal src3_addr_regs_reg_num         : std_logic_vector(1 downto 0);
	signal src3_addr_regs_rd_data         : vector_register;
	signal src3_addr_regs_rdy             : std_logic;
	signal src3_pred_regs_en              : std_logic;
	signal src3_pred_regs_reg_num         : std_logic_vector(1 downto 0);
	signal src3_pred_regs_rd_data         : vector_flag_register;
	signal src3_pred_regs_rdy             : std_logic;
	signal src3_shmem_en                  : std_logic;
	signal src3_shmem_addr                : std_logic_vector(31 downto 0);
	signal src3_shmem_sm_type             : sm_type;
	signal src3_shmem_rd_wr_type          : mem_opcode_type;
	signal src3_shmem_mask                : std_logic_vector(CORES - 1 downto 0);
	signal src3_shmem_rd_data             : vector_word_register_array;
	signal src3_shmem_rdy                 : std_logic;
	signal src3_cmem_en                   : std_logic;
	signal src3_cmem_addr                 : std_logic_vector(31 downto 0);
	signal src3_cmem_sm_type              : sm_type;
	signal src3_cmem_rd_wr_type           : mem_opcode_type;
	signal src3_cmem_mask                 : std_logic_vector(CORES - 1 downto 0);
	signal src3_cmem_rd_data              : vector_word_register_array;
	signal src3_cmem_rdy                  : std_logic;
	signal src3_gmem_en                   : std_logic;
	signal src3_gmem_addr                 : std_logic_vector(31 downto 0);
	signal src3_gmem_rd_wr_type           : mem_opcode_type;
	signal src3_gmem_data_type            : data_type;
	signal src3_gmem_mask                 : std_logic_vector(CORES - 1 downto 0);
	signal src3_gmem_rd_data              : vector_word_register_array;
	signal src3_gmem_rdy                  : std_logic;
	signal src3_effaddr_gprs_en           : std_logic;
	signal src3_effaddr_gprs_reg_num      : std_logic_vector(8 downto 0);
	signal src3_effaddr_gprs_data_type    : data_type;
	signal src3_effaddr_gprs_rd_data      : vector_word_register_array;
	signal src3_effaddr_gprs_rdy          : std_logic;
	signal src3_effaddr_addr_regs_en      : std_logic;
	signal src3_effaddr_addr_regs_reg     : std_logic_vector(1 downto 0);
	signal src3_effaddr_addr_regs_rd_data : vector_register;
	signal src3_effaddr_addr_regs_rdy     : std_logic;
	signal src3_data_o                    : vector_word_register_array;
	signal src3_rdy_o                     : std_logic;

	signal src1_rdy_reg : std_logic;
	signal src2_rdy_reg : std_logic;
	signal src3_rdy_reg : std_logic;

	signal temp_vector_register_i : temp_vector_register;

	signal warp_lane_id_i       : std_logic_vector(1 downto 0);



begin


	addr_hi_i_3 <= "00" & addr_hi_in;
	addr_reg_i  <= (to_stdlogicvector(to_bitvector(addr_hi_i_3) sll 2)) or ("0" & addr_lo_in);
	
	
	is_full_normal_out       <= '0';

	pPipelineRead : process(clk_in, reset)
	begin
		if (reset = '1') then
			warp_id_addr             <= 0;
			instruction_mask_i       <= (others => '0');
			next_pc                  <= (others => '0');
			warp_lane_id_i           <= (others => '0');
			warp_div_req_out         <= '0';
			warp_div_ack_out         <= '0';
			arb_pred_regs_req(0)     <= '0';
			arb_pred_regs_ack_o(0)   <= '0';
			pred_regs_en             <= '0';
			pred_regs_reg_num        <= (others => '0');
			pred_regs_data           <= (others => (others => '0'));
			pred_regs_wr_data        <= (others => (others => '0'));
			pred_regs_rd_wr_en       <= '0';
			pred_regs_cntr           <= (others => '0');
			pred_mask                <= (others => '0');
			pred_flags_i             <= (others => (others => '0'));
			src1_rdy_reg             <= '0';
			src2_rdy_reg             <= '0';
			src3_rdy_reg             <= '0';
			current_mask_i           <= (others => '0');
			warp_id_out              <= (others => '0');
			warp_lane_id_out         <= (others => '0');
			cta_id_out               <= (others => '0');
			initial_mask_out         <= (others => '0');
			current_mask_out         <= (others => '0');
			shmem_base_addr_out      <= (others => '0');
			gprs_size_out            <= (others => '0');
			gprs_addr_out            <= (others => '0');
			instruction_mask_out     <= (others => '0');
			next_pc_out              <= (others => '0');
			instr_opcode_type_out    <= UNKNOWN;
			instr_subop_type_out     <= (others => '0');
			alu_opcode_out           <= UNKNOWN;
			flow_opcode_out          <= UNKNOWN;
			mov_opcode_out           <= UNKNOWN;
			instr_marker_out         <= UNKNOWN;
			set_pred_out             <= '0';
			set_pred_reg_out         <= (others => '0');
			write_pred_out           <= '0';
			warp_div_push_en         <= (others => '0');
			warp_div_stack_en        <= (others => '0');
			is_signed_out            <= '0';
			w32_out                  <= '0';
			f64_out                  <= '0';
			saturate_out             <= '0';
			abs_saturate_out         <= (others => '0');
			cvt_round_out            <= (others => '0');
			cvt_type_out             <= (others => '0');
			cvt_neg_out              <= '0';
			addr_hi_out              <= '0';
			addr_lo_out              <= (others => '0');
			addr_incr_out            <= '0';
			mov_size_out             <= (others => '0');
			mem_type_out             <= (others => '0');
			sm_type_out              <= (others => '0');
			addr_imm_out             <= '0';
			dest_mem_type_out        <= UNKNOWN;
			dest_mem_opcode_out      <= READ;
			src1_neg_out             <= '0';
			src2_neg_out             <= '0';
			src3_neg_out             <= '0';
			target_addr_out          <= (others => '0');
			dest_data_type_out       <= DT_UNKNOWN;
			src1_out                 <= (others => '0');
			dest_out                 <= (others => '0');
			pred_flags_out           <= (others => (others => '0'));
			temp_vector_register_out <= (others => (others => (others => (others => '0'))));
			pipeline_stall_out       <= '0';
			pipeline_read_done       <= '0';
			condition_out            <= (others => '0');
			src1_read_en             <= '0';
			src2_read_en             <= '0';
			src3_read_en             <= '0';
			for i in 0 to CORES - 1 loop
				temp_vector_register_i(i)(0) <= (others => (others =>'0'));
				temp_vector_register_i(i)(2) <= (others => (others =>'0'));
				temp_vector_register_i(i)(4) <= (others => (others =>'0'));
			end loop;
			read_state_machine			<= IDLE;
		elsif rising_edge(clk_in) then
			case read_state_machine is
				when IDLE =>
					pipeline_read_done <= '0';
					src1_read_en       <= '0';
					src2_read_en       <= '0';
					src3_read_en       <= '0';

					if(pipeline_dec_done = '1') then
						pipeline_stall_out <= '1';
						if (instr_opcode_in = NOP and instr_marker_in /= FULL_JOIN) then
							warp_lane_id_i   <= warp_lane_id_in;
							warp_id_addr     <= to_integer(unsigned(warp_id_in));
							warp_div_req_out <= '0';
							warp_div_ack_out <= '0';
							pred_flags_i     <= (others => (others => '0'));
							if (warp_lane_id_in = "00") then
								current_mask_i <= current_mask_in;
								next_pc        <= next_pc_in;
							end if;
							read_state_machine <= READ_OPS_DONE;
						else
							warp_lane_id_i   <= warp_lane_id_in;
							warp_id_addr     <= to_integer(unsigned(warp_id_in));
							warp_div_req_out <= '0';
							warp_div_ack_out <= '0';
							pred_flags_i     <= (others => (others => '0'));
							if (warp_lane_id_in = "00") then
								current_mask_i <= current_mask_in;
								next_pc        <= next_pc_in;
								if (instr_opcode_in = FLOW) then
									if (pred_cond_in = "01111") then -- COND: always true    BRA 0x1b0, RET, ISET.S32.C0 o [0x7f], R2, c [0x1] [0x4], EQ;
										arb_pred_regs_req(0) <= '0';
										pred_mask            <= x"FFFFFFFF";		-- by defect mask
										read_state_machine   <= CALC_MASK;
									else
										arb_pred_regs_req(0) <= '1';
										pred_regs_cntr       <= std_logic_vector(unsigned(pred_regs_cntr) + 1);
										read_state_machine   <= PRED_REGS_MASK_REQUEST;
									end if;
								else  -- case of the ADA instruction.
									if ((instr_marker_in = IMM) or (instr_marker_in = HALF)) then
										arb_pred_regs_req(0) <= '0';
										pred_mask            <= x"FFFFFFFF";
										read_state_machine   <= CALC_MASK;
									-- Added Elsif condition to implement the selection of operands in the Address register memory for each thread. (ADA Instruction) JERC
									elsif ( (src1_mem_type_in = ADDRESS_ADDRESS) and (instr_opcode_in = MOV) and (instr_marker_in = FULL_NORM) ) then
										arb_pred_regs_req(0) <= '0';
										pred_mask            <= x"FFFFFFFF";		-- ADA does not generate divergence, so it is coherent
										read_state_machine   <= CALC_MASK;			-- The same state machine state can be employed 
									-- End of the added routine.
										
									else
										arb_pred_regs_req(0) <= '1';
										pred_regs_cntr       <= std_logic_vector(unsigned(pred_regs_cntr) + 1);
										read_state_machine   <= PRED_REGS_MASK_REQUEST;
									end if;
								end if;
							else
								arb_pred_regs_req(0) <= '0';
								read_state_machine   <= CHECK_PRED_FLAGS;
							end if;
						end if;
					else
						pipeline_stall_out <= '0';
					end if;

				when PRED_REGS_MASK_REQUEST =>
					if (arb_pred_regs_grant(0) = '1') then
						arb_pred_regs_req(0) <= '0';
						pred_regs_en         <= '1';
						pred_regs_reg_num    <= pred_reg_in;
						pred_regs_rd_wr_en   <= '0';
						pred_regs_wr_data    <= (others => (others => '0'));
						read_state_machine   <= READ_PRED_REGS_MASK;
					end if;

				when READ_PRED_REGS_MASK =>
					if (pred_regs_rdy_o = '1') then
						if (warp_lane_id_i = "00") then
							for i in 0 to CORES - 1 loop
								pred_regs_data(i) <= pred_regs_rd_data(i);
							end loop;
							if (CORES = 16) then
								pred_regs_en   <= '1';
								warp_lane_id_i <= pred_regs_cntr(1 downto 0);
								pred_regs_cntr <= std_logic_vector(unsigned(pred_regs_cntr) + 1);
							elsif (CORES = 32) then
								pred_regs_en           <= '0';
								arb_pred_regs_ack_o(0) <= '1';
								pred_regs_cntr         <= (others => '0');
								warp_lane_id_i         <= warp_lane_id_in;
								read_state_machine     <= WAIT_PRED_LUT_DATA;
							else
								pred_regs_en   <= '1';
								warp_lane_id_i <= pred_regs_cntr(1 downto 0);
								pred_regs_cntr <= std_logic_vector(unsigned(pred_regs_cntr) + 1);
							end if;
						elsif (warp_lane_id_i = "01") then
							if (CORES = 16) then
								for i in 0 to 15 loop
									pred_regs_data(16 + i) <= pred_regs_rd_data(i);
								end loop;
								pred_regs_en           <= '0';
								arb_pred_regs_ack_o(0) <= '1';
								pred_regs_cntr         <= (others => '0');
								warp_lane_id_i         <= warp_lane_id_in;
								read_state_machine     <= WAIT_PRED_LUT_DATA;
							else
								for i in 0 to 7 loop
									pred_regs_data(8 + i) <= pred_regs_rd_data(i);
								end loop;
								pred_regs_en   <= '1';
								warp_lane_id_i <= pred_regs_cntr(1 downto 0);
								pred_regs_cntr <= std_logic_vector(unsigned(pred_regs_cntr) + 1);
							end if;
						elsif (warp_lane_id_i = "10") then
							for i in 0 to 7 loop
								pred_regs_data(16 + i) <= pred_regs_rd_data(i);
							end loop;
							pred_regs_en   <= '1';
							warp_lane_id_i <= pred_regs_cntr(1 downto 0);
							pred_regs_cntr <= std_logic_vector(unsigned(pred_regs_cntr) + 1);
						else
							for i in 0 to 7 loop
								pred_regs_data(24 + i) <= pred_regs_rd_data(i);
							end loop;
							pred_regs_en           <= '0';
							arb_pred_regs_ack_o(0) <= '1';
							pred_regs_cntr         <= (others => '0');
							warp_lane_id_i         <= warp_lane_id_in;
							read_state_machine     <= WAIT_PRED_LUT_DATA;
						end if;
					else
						pred_regs_en <= '0';
					end if;

				when WAIT_PRED_LUT_DATA =>
					read_state_machine <= GET_PRED_REGS_MASK;

				when GET_PRED_REGS_MASK =>
					arb_pred_regs_ack_o(0) <= '0';
					pred_mask              <= pred_lut_data_o;
					read_state_machine     <= CALC_MASK;

				when CALC_MASK =>
					instruction_mask_i <= current_mask_i and pred_mask;  -- in the case of branch, ret o iset, it is not affected by the pred_mask (0xfffffff)
					read_state_machine <= CHECK_JOIN;

				when CHECK_JOIN =>
					if (instr_marker_in = FULL_JOIN) then
						if (warp_div_stack_empty(warp_id_addr) = '1') then
							current_mask_i     <= initial_mask_in;
							instruction_mask_i <= initial_mask_in;
							read_state_machine <= CHECK_PRED_FLAGS;
						else
							warp_div_req_out   <= '1';
							read_state_machine <= REQUEST_STACK;
						end if;
					else
						read_state_machine <= CHECK_PRED_FLAGS;
					end if;

				when REQUEST_STACK =>
					if (warp_div_grant_in = '1') then
						warp_div_req_out                <= '0';
						warp_div_stack_en(warp_id_addr) <= '1';
						warp_div_push_en(warp_id_addr)  <= '0';
						read_state_machine              <= READ_STACK_WAIT;
					end if;

				when READ_STACK_WAIT =>
					warp_div_stack_en(warp_id_addr) <= '0';
					read_state_machine              <= READ_STACK;

				when READ_STACK =>
					warp_div_ack_out                <= '1';
					warp_div_stack_en(warp_id_addr) <= '0';
					current_mask_i                  <= warp_div_rd_data_in(warp_id_addr)(65 downto 34);
					-- MODIFIED GIANLUCA ROASCIO - REWRITING THE INSTRUCTION MASK DEPENDING ON THE STACK INFOS LEADS THE INSTRUCTION EXECUTION TO FAIL
											 -- INSTRUCTION MASK IS COMPUTED STARTING FROM THE PREDICATE REGISTER AND MUST REMAIN UNCHANGED, TO BE CHANGED IS ONLY CURRENT MASK
					--if (warp_div_rd_data_in(warp_id_addr)(33 downto 32) = encode_warp_stack_token(ID_SYNC)) then
					--	instruction_mask_i <= warp_div_rd_data_in(warp_id_addr)(65 downto 34);
											 -- INSTEAD, WHAT IS TO BE DONE WHEN A SYNC POINT IS POPPED, IS TO RESTORE THE NORMAL FLOW FOR THAT SUBSET OF THREADS WHICH WHERE
											 -- THERE SYNCHRONIZED. THE SUBSET OF THREAD WHICH POPS THE SYNC POINT IS THE LAST ONE WHICH HAS TO EXECUTE THE .S INSTRUCTION,
											 -- SO AFTER THAT THE PROGRAM COUNTER SHALL RETURN TO NORMAL VALUE OF NEXT PC FOR THAT SUBSET
					if (warp_div_stack_empty(warp_id_addr) = '0' and warp_div_rd_data_in(warp_id_addr)(33 downto 32) /= encode_warp_stack_token(ID_SYNC)) then 	  
					--elsif (warp_div_stack_empty(warp_id_addr) = '0') then --MM: Modified to pop the diverged branch addresses.
						next_pc            <= warp_div_rd_data_in(warp_id_addr)(31 downto 0);
					--	instruction_mask_i <= warp_div_rd_data_in(warp_id_addr)(65 downto 34);
					--else
					--	instruction_mask_i <= x"00000000";
					end if;
					read_state_machine <= CHECK_PRED_FLAGS;

				when CHECK_PRED_FLAGS =>
					warp_div_ack_out <= '0';
					if (alu_opcode_in = IADDC) then
						pred_regs_reg_num    <= "00";
						arb_pred_regs_req(0) <= '1';
						read_state_machine   <= PRED_REGS_FLAGS_REQUEST;
					elsif (alu_opcode_in = IMAD24C) then
						pred_regs_reg_num    <= "01";
						arb_pred_regs_req(0) <= '1';
						read_state_machine   <= PRED_REGS_FLAGS_REQUEST;
					else
						arb_pred_regs_req(0) <= '0';
						if (instr_opcode_in = FLOW) then
							read_state_machine <= READ_OPS_DONE;
						else
							read_state_machine <= READ_OPS;
						end if;
					end if;

				when PRED_REGS_FLAGS_REQUEST =>
					if (arb_pred_regs_grant(0) = '1') then
						arb_pred_regs_req(0) <= '0';
						pred_regs_en         <= '1';
						pred_regs_rd_wr_en   <= '0';
						pred_regs_wr_data    <= (others => (others => '0'));
						read_state_machine   <= READ_PRED_REGS_FLAGS;
					end if;

				when READ_PRED_REGS_FLAGS =>
					if (pred_regs_rdy_o = '1') then
						pred_flags_i           <= pred_regs_rd_data;
						pred_regs_en           <= '0';
						arb_pred_regs_ack_o(0) <= '1';
						if (instr_opcode_in = FLOW) then
							read_state_machine <= READ_OPS_DONE;
						else
							read_state_machine <= READ_OPS;
						end if;
					end if;

				when READ_OPS =>
					arb_pred_regs_ack_o(0) <= '0';
					src1_read_en           <= '1';
					src2_read_en           <= '1';
					src3_read_en           <= '1';
					read_state_machine     <= READ_OPS_WAIT;

				when READ_OPS_WAIT =>
					src1_read_en <= '0';
					src2_read_en <= '0';
					src3_read_en <= '0';
					if (src1_rdy_o = '1') then
						src1_rdy_reg <= '1';
					end if;
					if (src2_rdy_o = '1') then
						src2_rdy_reg <= '1';
					end if;
					if (src3_rdy_o = '1') then
						src3_rdy_reg <= '1';
					end if;
					if (src1_rdy_reg = '1' and src2_rdy_reg = '1' and src3_rdy_reg = '1') then
						src1_rdy_reg <= '0';
						src2_rdy_reg <= '0';
						src3_rdy_reg <= '0';
						for i in 0 to CORES - 1 loop
							temp_vector_register_i(i)(0) <= src1_data_o(i);
							temp_vector_register_i(i)(2) <= src2_data_o(i);
							temp_vector_register_i(i)(4) <= src3_data_o(i);
						end loop;
						read_state_machine <= READ_OPS_DONE;
					end if;

				when READ_OPS_DONE =>
					if (pipeline_stall_in = '0') then
						warp_id_out              <= warp_id_in;
						warp_lane_id_out         <= warp_lane_id_i;
						cta_id_out               <= cta_id_in;
						current_mask_out         <= current_mask_i;
						initial_mask_out         <= initial_mask_in;
						shmem_base_addr_out      <= shmem_base_addr_in;
						gprs_size_out            <= gprs_size_in;
						gprs_addr_out            <= gprs_base_addr_in;
						next_pc_out              <= next_pc;
						arb_pred_regs_ack_o(0)   <= '0';
						instruction_mask_out     <= instruction_mask_i;
						instr_opcode_type_out    <= instr_opcode_in;
						instr_subop_type_out     <= instr_subop_in;
						alu_opcode_out           <= alu_opcode_in;
						flow_opcode_out          <= flow_opcode_in;
						mov_opcode_out           <= mov_opcode_in;
						instr_marker_out         <= instr_marker_in;
						set_pred_out             <= set_pred_in;
						set_pred_reg_out         <= set_pred_reg_in;
						write_pred_out           <= write_pred_in;
						is_signed_out            <= is_signed_in;
						w32_out                  <= w32_in;
						f64_out                  <= f64_in;
						saturate_out             <= saturate_in;
						abs_saturate_out         <= abs_saturate_in;
						cvt_round_out            <= cvt_round_in;
						cvt_type_out             <= cvt_type_in;
						cvt_neg_out              <= cvt_neg_in;
						condition_out            <= condition_in;
						addr_hi_out              <= addr_hi_in;
						addr_lo_out              <= addr_lo_in;
						addr_incr_out            <= addr_incr_in;
						mov_size_out             <= mov_size_in;
						mem_type_out             <= mem_type_in;
						sm_type_out              <= sm_type_in;
						addr_imm_out             <= addr_imm_in;
						dest_mem_type_out        <= dest_mem_type_in;
						dest_mem_opcode_out      <= dest_mem_opcode_in;
						src1_neg_out             <= src1_neg_in;
						src2_neg_out             <= src2_neg_in;
						src3_neg_out             <= src3_neg_in;
						target_addr_out          <= target_addr_in;
						dest_data_type_out       <= dest_data_type_in;
						src1_out                 <= src1_in;
						dest_out                 <= dest_in;
						pred_flags_out           <= pred_flags_i;
						temp_vector_register_out <= temp_vector_register_i;
						read_state_machine       <= IDLE;

						pipeline_stall_out <= '0';
						pipeline_read_done <= '1';
					end if;
			--when OTHERS =>
			--	read_state_machine <= IDLE;
			end case;
		end if;
	end process;

	gMask8 : if (CORES = 8) generate
		pMask8 : process(warp_lane_id_in, instruction_mask_i)
		begin
			case warp_lane_id_in is
				when "00"   => mask_i(7 downto 0) <= instruction_mask_i(7 downto 0);
				when "01"   => mask_i(7 downto 0) <= instruction_mask_i(15 downto 8);
				when "10"   => mask_i(7 downto 0) <= instruction_mask_i(23 downto 16);
				when "11"   => mask_i(7 downto 0) <= instruction_mask_i(31 downto 24);
				when others => mask_i(7 downto 0) <= instruction_mask_i(7 downto 0);
			end case;
		end process;
	end generate;

	gMask16 : if (CORES = 16) generate
		pMask16 : process(warp_lane_id_in, instruction_mask_i)
		begin
			case warp_lane_id_in is
				when "00" =>
					for i in 0 to CORES - 1 loop
						mask_i(i) <= instruction_mask_i(i);
					end loop;
				when "01" =>
					for i in 0 to CORES - 1 loop
						mask_i(i) <= instruction_mask_i(i + 16);
					end loop;
				when others =>
					for i in 0 to CORES - 1 loop
						mask_i(i) <= instruction_mask_i(i);
					end loop;
			end case;
		end process;
	end generate;

	gMask32 : if (CORES = 32) generate
		mask_i <= instruction_mask_i(CORES - 1 downto 0);
	end generate;

	uReadSource1 : read_source_ops
		generic map(
			SRC_NUM => 1
		)
		port map(
			reset                        => reset,
			clk_in                       => clk_in,
			en                           => src1_read_en,
			instr_opcode_in              => instr_opcode_in,
			alu_opcode_in                => alu_opcode_in,
			instr_marker_in              => instr_marker_in,
			addr_in                      => src1_in,
			mask_in                      => mask_i,
			addr_reg_in                  => addr_reg_i,
			addr_imm_in                  => addr_imm_in,
			pred_reg_in                  => pred_reg_in,
			mov_size_in                  => mov_size_in,
			sm_type_in                   => sm_type_in,
			mem_type_in                  => mem_type_in,
			imm_hi_in                    => imm_hi_in,
			src_mem_type_in              => src1_mem_type_in,
			src_data_type_in             => src1_data_type_in,
			src_mem_opcode_in            => src1_mem_opcode_in,
			dest_mem_type_in             => dest_mem_type_in,
			gprs_req_out                 => arb_gprs_req(0),
			gprs_ack_out                 => arb_gprs_ack_o(0),
			gprs_grant_in                => arb_gprs_grant(0),
			addr_regs_req_out            => arb_addr_regs_req(0),
			addr_regs_ack_out            => arb_addr_regs_ack_o(0),
			addr_regs_grant_in           => arb_addr_regs_grant(0),
			pred_regs_req_out            => arb_pred_regs_req(1),
			pred_regs_ack_out            => arb_pred_regs_ack_o(1),
			pred_regs_grant_in           => arb_pred_regs_grant(1),
			shmem_req_out                => arb_shmem_req(0),
			shmem_ack_out                => arb_shmem_ack_o(0),
			shmem_grant_in               => arb_shmem_grant(0),
			cmem_req_out                 => arb_cmem_req(0),
			cmem_ack_out                 => arb_cmem_ack_o(0),
			cmem_grant_in                => arb_cmem_grant(0),
			gmem_req_out                 => arb_gmem_req(0),
			gmem_ack_out                 => arb_gmem_ack_o(0),
			gmem_grant_in                => arb_gmem_grant(0),
			effaddr_gprs_req_out         => arb_gprs_req(3),
			effaddr_gprs_ack_out         => arb_gprs_ack_o(3),
			effaddr_gprs_grant_in        => arb_gprs_grant(3),
			effaddr_addr_regs_req_out    => arb_addr_regs_req(3),
			effaddr_addr_regs_ack_out    => arb_addr_regs_ack_o(3),
			effaddr_addr_regs_grant_in   => arb_addr_regs_grant(3),
			gprs_en_out                  => src1_gprs_en,
			gprs_reg_num_out             => src1_gprs_reg_num,
			gprs_data_type_out           => src1_gprs_data_type,
			gprs_mask_out                => src1_gprs_mask,
			gprs_rd_data_in              => src1_gprs_rd_data,
			gprs_rdy_in                  => src1_gprs_rdy,
			addr_regs_en_out             => src1_addr_regs_en,
			addr_regs_reg_num_out        => src1_addr_regs_reg_num,
			addr_regs_rd_data_in         => src1_addr_regs_rd_data,
			addr_regs_rdy_in             => src1_addr_regs_rdy,
			pred_regs_en_out             => src1_pred_regs_en,
			pred_regs_reg_num_out        => src1_pred_regs_reg_num,
			pred_regs_rd_data_in         => src1_pred_regs_rd_data,
			pred_regs_rdy_in             => src1_pred_regs_rdy,
			shmem_en_out                 => src1_shmem_en,
			shmem_addr_out               => src1_shmem_addr,
			shmem_rd_wr_type_out         => src1_shmem_rd_wr_type,
			shmem_sm_type_out            => src1_shmem_sm_type,
			shmem_mask_out               => src1_shmem_mask,
			shmem_rd_data_in             => src1_shmem_rd_data,
			shmem_rdy_in                 => src1_shmem_rdy,
			cmem_en_out                  => src1_cmem_en,
			cmem_addr_out                => src1_cmem_addr,
			cmem_rd_wr_type_out          => src1_cmem_rd_wr_type,
			cmem_sm_type_out             => src1_cmem_sm_type,
			cmem_mask_out                => src1_cmem_mask,
			cmem_rd_data_in              => src1_cmem_rd_data,
			cmem_rdy_in                  => src1_cmem_rdy,
			gmem_en_out                  => src1_gmem_en,
			gmem_addr_out                => src1_gmem_addr,
			gmem_rd_wr_type_out          => src1_gmem_rd_wr_type,
			gmem_data_type_out           => src1_gmem_data_type,
			gmem_mask_out                => src1_gmem_mask,
			gmem_rd_data_in              => src1_gmem_rd_data,
			gmem_rdy_in                  => src1_gmem_rdy,
			effaddr_gprs_en_out          => src1_effaddr_gprs_en,
			effaddr_gprs_reg_num_out     => src1_effaddr_gprs_reg_num,
			effaddr_gprs_data_type_out   => src1_effaddr_gprs_data_type,
			effaddr_gprs_rd_data_in      => src1_effaddr_gprs_rd_data,
			effaddr_gprs_rdy_in          => src1_effaddr_gprs_rdy,
			effaddr_addr_regs_en_out     => src1_effaddr_addr_regs_en,
			effaddr_addr_regs_reg_out    => src1_effaddr_addr_regs_reg,
			effaddr_addr_regs_rd_data_in => src1_effaddr_addr_regs_rd_data,
			effaddr_addr_regs_rdy_in     => src1_effaddr_addr_regs_rdy,
			data_out                     => src1_data_o,
			rdy_out                      => src1_rdy_o
		);

	uReadSource2 : read_source_ops
		generic map(
			SRC_NUM => 2
		)
		port map(
			reset                        => reset,
			clk_in                       => clk_in,
			en                           => src2_read_en,
			instr_opcode_in              => instr_opcode_in,
			alu_opcode_in                => alu_opcode_in,
			instr_marker_in              => instr_marker_in,
			addr_in                      => src2_in,
			mask_in                      => mask_i,
			addr_reg_in                  => addr_reg_i,
			addr_imm_in                  => addr_imm_in,
			pred_reg_in                  => pred_reg_in,
			mov_size_in                  => mov_size_in,
			sm_type_in                   => sm_type_in,
			mem_type_in                  => mem_type_in,
			imm_hi_in                    => imm_hi_in,
			src_mem_type_in              => src2_mem_type_in,
			src_data_type_in             => src2_data_type_in,
			src_mem_opcode_in            => src2_mem_opcode_in,
			dest_mem_type_in             => dest_mem_type_in,
			gprs_req_out                 => arb_gprs_req(1),
			gprs_ack_out                 => arb_gprs_ack_o(1),
			gprs_grant_in                => arb_gprs_grant(1),
			addr_regs_req_out            => arb_addr_regs_req(1),
			addr_regs_ack_out            => arb_addr_regs_ack_o(1),
			addr_regs_grant_in           => arb_addr_regs_grant(1),
			pred_regs_req_out            => arb_pred_regs_req(2),
			pred_regs_ack_out            => arb_pred_regs_ack_o(2),
			pred_regs_grant_in           => arb_pred_regs_grant(2),
			shmem_req_out                => arb_shmem_req(1),
			shmem_ack_out                => arb_shmem_ack_o(1),
			shmem_grant_in               => arb_shmem_grant(1),
			cmem_req_out                 => arb_cmem_req(1),
			cmem_ack_out                 => arb_cmem_ack_o(1),
			cmem_grant_in                => arb_cmem_grant(1),
			gmem_req_out                 => arb_gmem_req(1),
			gmem_ack_out                 => arb_gmem_ack_o(1),
			gmem_grant_in                => arb_gmem_grant(1),
			effaddr_gprs_req_out         => arb_gprs_req(4),
			effaddr_gprs_ack_out         => arb_gprs_ack_o(4),
			effaddr_gprs_grant_in        => arb_gprs_grant(4),
			effaddr_addr_regs_req_out    => arb_addr_regs_req(4),
			effaddr_addr_regs_ack_out    => arb_addr_regs_ack_o(4),
			effaddr_addr_regs_grant_in   => arb_addr_regs_grant(4),
			gprs_en_out                  => src2_gprs_en,
			gprs_reg_num_out             => src2_gprs_reg_num,
			gprs_data_type_out           => src2_gprs_data_type,
			gprs_mask_out                => src2_gprs_mask,
			gprs_rd_data_in              => src2_gprs_rd_data,
			gprs_rdy_in                  => src2_gprs_rdy,
			addr_regs_en_out             => src2_addr_regs_en,
			addr_regs_reg_num_out        => src2_addr_regs_reg_num,
			addr_regs_rd_data_in         => src2_addr_regs_rd_data,
			addr_regs_rdy_in             => src2_addr_regs_rdy,
			pred_regs_en_out             => src2_pred_regs_en,
			pred_regs_reg_num_out        => src2_pred_regs_reg_num,
			pred_regs_rd_data_in         => src2_pred_regs_rd_data,
			pred_regs_rdy_in             => src2_pred_regs_rdy,
			shmem_en_out                 => src2_shmem_en,
			shmem_addr_out               => src2_shmem_addr,
			shmem_rd_wr_type_out         => src2_shmem_rd_wr_type,
			shmem_sm_type_out            => src2_shmem_sm_type,
			shmem_mask_out               => src2_shmem_mask,
			shmem_rd_data_in             => src2_shmem_rd_data,
			shmem_rdy_in                 => src2_shmem_rdy,
			cmem_en_out                  => src2_cmem_en,
			cmem_addr_out                => src2_cmem_addr,
			cmem_rd_wr_type_out          => src2_cmem_rd_wr_type,
			cmem_sm_type_out             => src2_cmem_sm_type,
			cmem_mask_out                => src2_cmem_mask,
			cmem_rd_data_in              => src2_cmem_rd_data,
			cmem_rdy_in                  => src2_cmem_rdy,
			gmem_en_out                  => src2_gmem_en,
			gmem_addr_out                => src2_gmem_addr,
			gmem_rd_wr_type_out          => src2_gmem_rd_wr_type,
			gmem_data_type_out           => src2_gmem_data_type,
			gmem_mask_out                => src2_gmem_mask,
			gmem_rd_data_in              => src2_gmem_rd_data,
			gmem_rdy_in                  => src2_gmem_rdy,
			effaddr_gprs_en_out          => src2_effaddr_gprs_en,
			effaddr_gprs_reg_num_out     => src2_effaddr_gprs_reg_num,
			effaddr_gprs_data_type_out   => src2_effaddr_gprs_data_type,
			effaddr_gprs_rd_data_in      => src2_effaddr_gprs_rd_data,
			effaddr_gprs_rdy_in          => src2_effaddr_gprs_rdy,
			effaddr_addr_regs_en_out     => src2_effaddr_addr_regs_en,
			effaddr_addr_regs_reg_out    => src2_effaddr_addr_regs_reg,
			effaddr_addr_regs_rd_data_in => src2_effaddr_addr_regs_rd_data,
			effaddr_addr_regs_rdy_in     => src2_effaddr_addr_regs_rdy,
			data_out                     => src2_data_o,
			rdy_out                      => src2_rdy_o
		);

	uReadSource3 : read_source_ops
		generic map(
			SRC_NUM => 3
		)
		port map(
			reset                        => reset,
			clk_in                       => clk_in,
			en                           => src3_read_en,
			instr_opcode_in              => instr_opcode_in,
			alu_opcode_in                => alu_opcode_in,
			instr_marker_in              => instr_marker_in,
			addr_in                      => src3_in,
			mask_in                      => mask_i,
			addr_reg_in                  => addr_reg_i,
			addr_imm_in                  => addr_imm_in,
			pred_reg_in                  => pred_reg_in,
			mov_size_in                  => mov_size_in,
			sm_type_in                   => sm_type_in,
			mem_type_in                  => mem_type_in,
			imm_hi_in                    => imm_hi_in,
			src_mem_type_in              => src3_mem_type_in,
			src_data_type_in             => src3_data_type_in,
			src_mem_opcode_in            => src3_mem_opcode_in,
			dest_mem_type_in             => dest_mem_type_in,
			gprs_req_out                 => arb_gprs_req(2),
			gprs_ack_out                 => arb_gprs_ack_o(2),
			gprs_grant_in                => arb_gprs_grant(2),
			addr_regs_req_out            => arb_addr_regs_req(2),
			addr_regs_ack_out            => arb_addr_regs_ack_o(2),
			addr_regs_grant_in           => arb_addr_regs_grant(2),
			pred_regs_req_out            => arb_pred_regs_req(3),
			pred_regs_ack_out            => arb_pred_regs_ack_o(3),
			pred_regs_grant_in           => arb_pred_regs_grant(3),
			shmem_req_out                => arb_shmem_req(2),
			shmem_ack_out                => arb_shmem_ack_o(2),
			shmem_grant_in               => arb_shmem_grant(2),
			cmem_req_out                 => arb_cmem_req(2),
			cmem_ack_out                 => arb_cmem_ack_o(2),
			cmem_grant_in                => arb_cmem_grant(2),
			gmem_req_out                 => arb_gmem_req(2),
			gmem_ack_out                 => arb_gmem_ack_o(2),
			gmem_grant_in                => arb_gmem_grant(2),
			effaddr_gprs_req_out         => arb_gprs_req(5),
			effaddr_gprs_ack_out         => arb_gprs_ack_o(5),
			effaddr_gprs_grant_in        => arb_gprs_grant(5),
			effaddr_addr_regs_req_out    => arb_addr_regs_req(5),
			effaddr_addr_regs_ack_out    => arb_addr_regs_ack_o(5),
			effaddr_addr_regs_grant_in   => arb_addr_regs_grant(5),
			gprs_en_out                  => src3_gprs_en,
			gprs_reg_num_out             => src3_gprs_reg_num,
			gprs_data_type_out           => src3_gprs_data_type,
			gprs_mask_out                => src3_gprs_mask,
			gprs_rd_data_in              => src3_gprs_rd_data,
			gprs_rdy_in                  => src3_gprs_rdy,
			addr_regs_en_out             => src3_addr_regs_en,
			addr_regs_reg_num_out        => src3_addr_regs_reg_num,
			addr_regs_rd_data_in         => src3_addr_regs_rd_data,
			addr_regs_rdy_in             => src3_addr_regs_rdy,
			pred_regs_en_out             => src3_pred_regs_en,
			pred_regs_reg_num_out        => src3_pred_regs_reg_num,
			pred_regs_rd_data_in         => src3_pred_regs_rd_data,
			pred_regs_rdy_in             => src3_pred_regs_rdy,
			shmem_en_out                 => src3_shmem_en,
			shmem_addr_out               => src3_shmem_addr,
			shmem_rd_wr_type_out         => src3_shmem_rd_wr_type,
			shmem_sm_type_out            => src3_shmem_sm_type,
			shmem_mask_out               => src3_shmem_mask,
			shmem_rd_data_in             => src3_shmem_rd_data,
			shmem_rdy_in                 => src3_shmem_rdy,
			cmem_en_out                  => src3_cmem_en,
			cmem_addr_out                => src3_cmem_addr,
			cmem_rd_wr_type_out          => src3_cmem_rd_wr_type,
			cmem_sm_type_out             => src3_cmem_sm_type,
			cmem_mask_out                => src3_cmem_mask,
			cmem_rd_data_in              => src3_cmem_rd_data,
			cmem_rdy_in                  => src3_cmem_rdy,
			gmem_en_out                  => src3_gmem_en,
			gmem_addr_out                => src3_gmem_addr,
			gmem_rd_wr_type_out          => src3_gmem_rd_wr_type,
			gmem_data_type_out           => src3_gmem_data_type,
			gmem_mask_out                => src3_gmem_mask,
			gmem_rd_data_in              => src3_gmem_rd_data,
			gmem_rdy_in                  => src3_gmem_rdy,
			effaddr_gprs_en_out          => src3_effaddr_gprs_en,
			effaddr_gprs_reg_num_out     => src3_effaddr_gprs_reg_num,
			effaddr_gprs_data_type_out   => src3_effaddr_gprs_data_type,
			effaddr_gprs_rd_data_in      => src3_effaddr_gprs_rd_data,
			effaddr_gprs_rdy_in          => src3_effaddr_gprs_rdy,
			effaddr_addr_regs_en_out     => src3_effaddr_addr_regs_en,
			effaddr_addr_regs_reg_out    => src3_effaddr_addr_regs_reg,
			effaddr_addr_regs_rd_data_in => src3_effaddr_addr_regs_rd_data,
			effaddr_addr_regs_rdy_in     => src3_effaddr_addr_regs_rdy,
			data_out                     => src3_data_o,
			rdy_out                      => src3_rdy_o
		);

	uVectorRegisterArbiter : arbiter
		generic map(
			CNT => ARB_GPRS_CNT
		)
		port map(
			clk   => clk_in,
			rst   => reset,
			req   => arb_gprs_req,
			ack   => arb_gprs_ack,
			grant => arb_gprs_grant
		);

	arb_gprs_ack <= arb_gprs_ack_o(0) or arb_gprs_ack_o(1) or arb_gprs_ack_o(2) or arb_gprs_ack_o(3) or arb_gprs_ack_o(4) or arb_gprs_ack_o(5) or arb_gprs_ack_o(6) or arb_gprs_ack_o(7) or arb_gprs_ack_o(8);

	uVectorRegisterFileController : vector_register_controller
		port map(
			reset              => reset,
			clk_in             => clk_in,
			en                 => gprs_en_i,
			lane_id_in         => warp_lane_id_i,
			base_addr_in       => gprs_base_addr_in,
			reg_num_in         => gprs_reg_num_i,
			data_in            => (others => (others => (others => '0'))), -- gprs_data_i,
			data_type_in       => gprs_data_type_i,
			mask_in            => gprs_mask_i,
			rd_wr_en_in        => '0',  -- gprs_rd_wr_en_i,
			gprs_base_addr_out => gprs_base_addr_out,
			gprs_reg_num_out   => gprs_reg_num_out,
			gprs_lane_id_out   => gprs_lane_id_out,
			gprs_wr_en_out     => gprs_wr_en_out,
			gprs_wr_data_out   => gprs_wr_data_out,
			gprs_rd_data_in    => gprs_rd_data_in,
			data_out           => gprs_data_o,
			rdy_out            => gprs_rdy_o
		);

	gprs_en_i <= src1_gprs_en when (arb_gprs_grant(0) = '1')
		else src2_gprs_en when (arb_gprs_grant(1) = '1')
		else src3_gprs_en when (arb_gprs_grant(2) = '1')
		else src1_effaddr_gprs_en when (arb_gprs_grant(3) = '1')
		else src2_effaddr_gprs_en when (arb_gprs_grant(4) = '1')
		else src3_effaddr_gprs_en when (arb_gprs_grant(5) = '1')
		else shmem_gprs_en when (arb_gprs_grant(6) = '1')
		else cmem_gprs_en when (arb_gprs_grant(7) = '1')
		else gmem_gprs_en when (arb_gprs_grant(8) = '1')
		else '0';

	gprs_reg_num_i <= src1_gprs_reg_num when (arb_gprs_grant(0) = '1')
		else src2_gprs_reg_num when (arb_gprs_grant(1) = '1')
		else src3_gprs_reg_num when (arb_gprs_grant(2) = '1')
		else src1_effaddr_gprs_reg_num when (arb_gprs_grant(3) = '1')
		else src2_effaddr_gprs_reg_num when (arb_gprs_grant(4) = '1')
		else src3_effaddr_gprs_reg_num when (arb_gprs_grant(5) = '1')
		else shmem_gprs_reg_num when (arb_gprs_grant(6) = '1')
		else cmem_gprs_reg_num when (arb_gprs_grant(7) = '1')
		else gmem_gprs_reg_num when (arb_gprs_grant(8) = '1')
		else (others => '0');

	gprs_data_type_i <= src1_gprs_data_type when (arb_gprs_grant(0) = '1')
		else src2_gprs_data_type when (arb_gprs_grant(1) = '1')
		else src3_gprs_data_type when (arb_gprs_grant(2) = '1')
		else src1_effaddr_gprs_data_type when (arb_gprs_grant(3) = '1')
		else src2_effaddr_gprs_data_type when (arb_gprs_grant(4) = '1')
		else src3_effaddr_gprs_data_type when (arb_gprs_grant(5) = '1')
		else shmem_gprs_data_type when (arb_gprs_grant(6) = '1')
		else cmem_gprs_data_type when (arb_gprs_grant(7) = '1')
		else gmem_gprs_data_type when (arb_gprs_grant(8) = '1')
		else DT_U32;

	gprs_mask_i <= src1_gprs_mask when (arb_gprs_grant(0) = '1')
		else src2_gprs_mask when (arb_gprs_grant(1) = '1')
		else src3_gprs_mask when (arb_gprs_grant(2) = '1')
		else (others => '1') when (arb_gprs_grant(3) = '1')
		else (others => '1') when (arb_gprs_grant(4) = '1')
		else (others => '1') when (arb_gprs_grant(5) = '1')
		else (others => '1') when (arb_gprs_grant(6) = '1')
		else (others => '1') when (arb_gprs_grant(7) = '1')
		else (others => '1') when (arb_gprs_grant(8) = '1')
		else (others => '0');

	--gprs_mask_i <= src1_gprs_mask when (arb_gprs_grant(0) = '1') else src2_gprs_mask when (arb_gprs_grant(1) = '1') else src3_gprs_mask when (arb_gprs_grant(2) = '1') else src1_effaddr_gprs_mask when (arb_gprs_grant(3) = '1') else src2_effaddr_gprs_mask when (arb_gprs_grant(4) = '1'
	--	) else src3_effaddr_gprs_mask when (arb_gprs_grant(5) = '1') else shmem_gprs_mask when (arb_gprs_grant(6) = '1') else cmem_gprs_mask when (arb_gprs_grant(7) = '1') else gmem_gprs_mask when (arb_gprs_grant(8) = '1') else
	--	(others => '0');


	src1_gprs_rd_data         <= gprs_data_o when (arb_gprs_grant(0) = '1') else (others => (others => (others => '0')));
	src2_gprs_rd_data         <= gprs_data_o when (arb_gprs_grant(1) = '1') else (others => (others => (others => '0')));
	src3_gprs_rd_data         <= gprs_data_o when (arb_gprs_grant(2) = '1') else (others => (others => (others => '0')));
	src1_effaddr_gprs_rd_data <= gprs_data_o when (arb_gprs_grant(3) = '1') else (others => (others => (others => '0')));
	src2_effaddr_gprs_rd_data <= gprs_data_o when (arb_gprs_grant(4) = '1') else (others => (others => (others => '0')));
	src3_effaddr_gprs_rd_data <= gprs_data_o when (arb_gprs_grant(5) = '1') else (others => (others => (others => '0')));
	shmem_gprs_rd_data        <= gprs_data_o when (arb_gprs_grant(6) = '1') else (others => (others => (others => '0')));
	cmem_gprs_rd_data         <= gprs_data_o when (arb_gprs_grant(7) = '1') else (others => (others => (others => '0')));
	gmem_gprs_rd_data         <= gprs_data_o when (arb_gprs_grant(8) = '1') else (others => (others => (others => '0')));

	src1_gprs_rdy         <= gprs_rdy_o when (arb_gprs_grant(0) = '1') else '0';
	src2_gprs_rdy         <= gprs_rdy_o when (arb_gprs_grant(1) = '1') else '0';
	src3_gprs_rdy         <= gprs_rdy_o when (arb_gprs_grant(2) = '1') else '0';
	src1_effaddr_gprs_rdy <= gprs_rdy_o when (arb_gprs_grant(3) = '1') else '0';
	src2_effaddr_gprs_rdy <= gprs_rdy_o when (arb_gprs_grant(4) = '1') else '0';
	src3_effaddr_gprs_rdy <= gprs_rdy_o when (arb_gprs_grant(5) = '1') else '0';
	shmem_gprs_rdy        <= gprs_rdy_o when (arb_gprs_grant(6) = '1') else '0';
	cmem_gprs_rdy         <= gprs_rdy_o when (arb_gprs_grant(7) = '1') else '0';
	gmem_gprs_rdy         <= gprs_rdy_o when (arb_gprs_grant(8) = '1') else '0';

	uPredicateRegisterArbiter : arbiter
		generic map(
			CNT => ARB_PRED_REGS_CNT
		)
		port map(
			clk   => clk_in,
			rst   => reset,
			req   => arb_pred_regs_req,
			ack   => arb_pred_regs_ack,
			grant => arb_pred_regs_grant
		);

	arb_pred_regs_ack <= arb_pred_regs_ack_o(0) or arb_pred_regs_ack_o(1) or arb_pred_regs_ack_o(2) or arb_pred_regs_ack_o(3);

	uPredicateRegsiterController : predicate_register_controller
		port map(
			reset                      => reset,
			clk_in                     => clk_in,
			en                         => pred_regs_en_i,
			warp_id_in                 => warp_id_in,
			lane_id_in                 => warp_lane_id_i,
			reg_num_in                 => pred_regs_reg_num_i,
			data_in                    => (others => (others => '0')), -- pred_regs_data_i,
			mask_in                    => mask_i,
			rd_wr_en_in                => '0', -- pred_regs_rd_wr_en_i,
			pred_regs_warp_id_out      => pred_regs_warp_id_out,
			pred_regs_warp_lane_id_out => pred_regs_warp_lane_id_out,
			pred_regs_reg_num_out      => pred_regs_reg_num_out,
			pred_regs_wr_en_out        => pred_regs_wr_en_out,
			pred_regs_wr_data_out      => pred_regs_wr_data_out,
			pred_regs_rd_data_in       => pred_regs_rd_data_in,
			data_out                   => pred_regs_data_o,
			rdy_out                    => pred_regs_rdy_o
		);

	pred_regs_en_i <= pred_regs_en when (arb_pred_regs_grant(0) = '1')
		else src1_pred_regs_en when (arb_pred_regs_grant(1) = '1')
		else src2_pred_regs_en when (arb_pred_regs_grant(2) = '1')
		else src3_pred_regs_en when (arb_pred_regs_grant(3) = '1')
		else '0';

	pred_regs_reg_num_i <= pred_regs_reg_num when (arb_pred_regs_grant(0) = '1')
		else src1_pred_regs_reg_num when (arb_pred_regs_grant(1) = '1')
		else src2_pred_regs_reg_num when (arb_pred_regs_grant(2) = '1')
		else src3_pred_regs_reg_num when (arb_pred_regs_grant(3) = '1')
		else (others => '0');

	src1_pred_regs_rdy <= pred_regs_rdy_o when (arb_pred_regs_grant(1) = '1') else '0';
	src2_pred_regs_rdy <= pred_regs_rdy_o when (arb_pred_regs_grant(2) = '1') else '0';
	src3_pred_regs_rdy <= pred_regs_rdy_o when (arb_pred_regs_grant(3) = '1') else '0';

	pred_regs_rd_data      <= pred_regs_data_o when (arb_pred_regs_grant(0) = '1') else (others => (others => '0'));
	src1_pred_regs_rd_data <= pred_regs_data_o when (arb_pred_regs_grant(1) = '1') else (others => (others => '0'));
	src2_pred_regs_rd_data <= pred_regs_data_o when (arb_pred_regs_grant(2) = '1') else (others => (others => '0'));
	src3_pred_regs_rd_data <= pred_regs_data_o when (arb_pred_regs_grant(3) = '1') else (others => (others => '0'));

	uAddressRegisterArbiter : arbiter
		generic map(
			CNT => ARB_ADDR_REGS_CNT
		)
		port map(
			clk   => clk_in,
			rst   => reset,
			req   => arb_addr_regs_req,
			ack   => arb_addr_regs_ack,
			grant => arb_addr_regs_grant
		);

	arb_addr_regs_ack <= arb_addr_regs_ack_o(0) or arb_addr_regs_ack_o(1) or arb_addr_regs_ack_o(2) or arb_addr_regs_ack_o(3) or arb_addr_regs_ack_o(4) or arb_addr_regs_ack_o(5) or arb_addr_regs_ack_o(6) or arb_addr_regs_ack_o(7) or arb_addr_regs_ack_o(8);

	uAddressRegisterController : address_register_controller
		port map(
			reset                      => reset,
			clk_in                     => clk_in,
			en                         => addr_regs_en_i,
			warp_id_in                 => warp_id_in,
			lane_id_in                 => warp_lane_id_i,
			reg_num_in                 => addr_regs_num_i,
			data_in                    => (others => (others => '0')), -- addr_regs_data_i,
			mask_in                    => mask_i,
			rd_wr_en_in                => '0', -- addr_regs_rd_wr_en_i,
			addr_regs_warp_id_out      => addr_regs_warp_id_out,
			addr_regs_warp_lane_id_out => addr_regs_warp_lane_id_out,
			addr_regs_reg_num_out      => addr_regs_reg_num_out,
			addr_regs_wr_en_out        => addr_regs_wr_en_out,
			addr_regs_wr_data_out      => addr_regs_wr_data_out,
			addr_regs_rd_data_in       => addr_regs_rd_data_in,
			data_out                   => addr_regs_data_o,
			rdy_out                    => addr_regs_rdy_o
		);

	addr_regs_en_i <= src1_addr_regs_en when (arb_addr_regs_grant(0) = '1')
		else src2_addr_regs_en when (arb_addr_regs_grant(1) = '1')
		else src3_addr_regs_en when (arb_addr_regs_grant(2) = '1')
		else src1_effaddr_addr_regs_en when (arb_addr_regs_grant(3) = '1')
		else src2_effaddr_addr_regs_en when (arb_addr_regs_grant(4) = '1')
		else src3_effaddr_addr_regs_en when (arb_addr_regs_grant(5) = '1')
		else shmem_addr_regs_en when (arb_addr_regs_grant(6) = '1')
		else cmem_addr_regs_en when (arb_addr_regs_grant(7) = '1')
		else gmem_addr_regs_en when (arb_addr_regs_grant(8) = '1')
		else '0';

	addr_regs_num_i <= src1_addr_regs_reg_num when (arb_addr_regs_grant(0) = '1')
		else src2_addr_regs_reg_num when (arb_addr_regs_grant(1) = '1')
		else src3_addr_regs_reg_num when (arb_addr_regs_grant(2) = '1')
		else src1_effaddr_addr_regs_reg when (arb_addr_regs_grant(3) = '1')
		else src2_effaddr_addr_regs_reg when (arb_addr_regs_grant(4) = '1')
		else src3_effaddr_addr_regs_reg when (arb_addr_regs_grant(5) = '1')
		else shmem_addr_regs_reg when (arb_addr_regs_grant(6) = '1')
		else cmem_addr_regs_reg when (arb_addr_regs_grant(7) = '1')
		else gmem_addr_regs_reg when (arb_addr_regs_grant(8) = '1')
		else (others => '0');

	src1_addr_regs_rd_data         <= addr_regs_data_o when (arb_addr_regs_grant(0) = '1') else (others => (others => '0'));
	src2_addr_regs_rd_data         <= addr_regs_data_o when (arb_addr_regs_grant(1) = '1') else (others => (others => '0'));
	src3_addr_regs_rd_data         <= addr_regs_data_o when (arb_addr_regs_grant(2) = '1') else (others => (others => '0'));
	src1_effaddr_addr_regs_rd_data <= addr_regs_data_o when (arb_addr_regs_grant(3) = '1') else (others => (others => '0'));
	src2_effaddr_addr_regs_rd_data <= addr_regs_data_o when (arb_addr_regs_grant(4) = '1') else (others => (others => '0'));
	src3_effaddr_addr_regs_rd_data <= addr_regs_data_o when (arb_addr_regs_grant(5) = '1') else (others => (others => '0'));
	shmem_addr_regs_rd_data        <= addr_regs_data_o when (arb_addr_regs_grant(6) = '1') else (others => (others => '0'));
	cmem_addr_regs_rd_data         <= addr_regs_data_o when (arb_addr_regs_grant(7) = '1') else (others => (others => '0'));
	gmem_addr_regs_rd_data         <= addr_regs_data_o when (arb_addr_regs_grant(8) = '1') else (others => (others => '0'));

	src1_addr_regs_rdy         <= addr_regs_rdy_o when (arb_addr_regs_grant(0) = '1') else '0';
	src2_addr_regs_rdy         <= addr_regs_rdy_o when (arb_addr_regs_grant(1) = '1') else '0';
	src3_addr_regs_rdy         <= addr_regs_rdy_o when (arb_addr_regs_grant(2) = '1') else '0';
	src1_effaddr_addr_regs_rdy <= addr_regs_rdy_o when (arb_addr_regs_grant(3) = '1') else '0';
	src2_effaddr_addr_regs_rdy <= addr_regs_rdy_o when (arb_addr_regs_grant(4) = '1') else '0';
	src3_effaddr_addr_regs_rdy <= addr_regs_rdy_o when (arb_addr_regs_grant(5) = '1') else '0';
	shmem_addr_regs_rdy        <= addr_regs_rdy_o when (arb_addr_regs_grant(6) = '1') else '0';
	cmem_addr_regs_rdy         <= addr_regs_rdy_o when (arb_addr_regs_grant(7) = '1') else '0';
	gmem_addr_regs_rdy         <= addr_regs_rdy_o when (arb_addr_regs_grant(8) = '1') else '0';

	uSharedMemoryArbiter : arbiter
		generic map(
			CNT => ARB_SHMEM_CNT
		)
		port map(
			clk   => clk_in,
			rst   => reset,
			req   => arb_shmem_req,
			ack   => arb_shmem_ack,
			grant => arb_shmem_grant
		);

	arb_shmem_ack <= arb_shmem_ack_o(0) or arb_shmem_ack_o(1) or arb_shmem_ack_o(2);

	uSharedMemoryController : shared_memory_controller
		generic map(
			ADDRESS_SIZE     => SHMEM_ADDR_SIZE,
			ARB_GPRS_EN      => '1',
			ARB_ADDR_REGS_EN => '1'
		)
		port map(
			reset                => reset,
			clk_in               => clk_in,
			en                   => shmem_en_i,
			data_in              => (others => (others => (others => '0'))), -- shmem_wr_data_i,
			base_addr_in         => shmem_base_addr_in,
			addr_in              => shmem_addr_i,
			mask_in              => shmem_mask_i,
			rd_wr_type_in        => shmem_rd_wr_type_i,
			sm_type_in           => shmem_sm_type_i,
			addr_lo_in           => addr_lo_in,
			addr_hi_in           => addr_hi_in,
			addr_imm_in          => addr_imm_in,
			gprs_req_out         => arb_gprs_req(6),
			gprs_ack_out         => arb_gprs_ack_o(6),
			gprs_grant_in        => arb_gprs_grant(6),
			gprs_en_out          => shmem_gprs_en,
			gprs_reg_num_out     => shmem_gprs_reg_num,
			gprs_data_type_out   => shmem_gprs_data_type,
			gprs_rd_data_in      => shmem_gprs_rd_data,
			gprs_rdy_in          => shmem_gprs_rdy,
			addr_regs_req_out    => arb_addr_regs_req(6),
			addr_regs_ack_out    => arb_addr_regs_ack_o(6),
			addr_regs_grant_in   => arb_addr_regs_grant(6),
			addr_regs_en_out     => shmem_addr_regs_en,
			addr_regs_reg_out    => shmem_addr_regs_reg,
			addr_regs_rd_data_in => shmem_addr_regs_rd_data,
			addr_regs_rdy_in     => shmem_addr_regs_rdy,
			shmem_addr_out       => shmem_addr_out,
			shmem_wr_en_out      => shmem_wr_en_out,
			shmem_wr_data_out    => shmem_wr_data_out,
			shmem_rd_data_in     => shmem_rd_data_in,
			data_out             => shmem_rd_data_o,
			rdy_out              => shmem_rdy_o
		);

	shmem_en_i <= src1_shmem_en when (arb_shmem_grant(0) = '1')
		else src2_shmem_en when (arb_shmem_grant(1) = '1')
		else src3_shmem_en when (arb_shmem_grant(2) = '1')
		else '0';

	shmem_rd_wr_type_i <= src1_shmem_rd_wr_type when (arb_shmem_grant(0) = '1')
		else src2_shmem_rd_wr_type when (arb_shmem_grant(1) = '1')
		else src3_shmem_rd_wr_type when (arb_shmem_grant(2) = '1')
		else READ;

	shmem_addr_i <= src1_shmem_addr when (arb_shmem_grant(0) = '1')
		else src2_shmem_addr when (arb_shmem_grant(1) = '1')
		else src3_shmem_addr when (arb_shmem_grant(2) = '1')
		else (others => '0');

	shmem_mask_i <= src1_shmem_mask when (arb_shmem_grant(0) = '1')
		else src2_shmem_mask when (arb_shmem_grant(1) = '1')
		else src3_shmem_mask when (arb_shmem_grant(2) = '1')
		else (others => '0');

	shmem_sm_type_i <= src1_shmem_sm_type when (arb_shmem_grant(0) = '1')
		else src2_shmem_sm_type when (arb_shmem_grant(1) = '1')
		else src3_shmem_sm_type when (arb_shmem_grant(2) = '1')
		else SM_NONE;

	src1_shmem_rd_data <= shmem_rd_data_o when (arb_shmem_grant(0) = '1') else (others => (others => (others => '0')));
	src2_shmem_rd_data <= shmem_rd_data_o when (arb_shmem_grant(1) = '1') else (others => (others => (others => '0')));
	src3_shmem_rd_data <= shmem_rd_data_o when (arb_shmem_grant(2) = '1') else (others => (others => (others => '0')));

	src1_shmem_rdy <= shmem_rdy_o when (arb_shmem_grant(0) = '1') else '0';
	src2_shmem_rdy <= shmem_rdy_o when (arb_shmem_grant(1) = '1') else '0';
	src3_shmem_rdy <= shmem_rdy_o when (arb_shmem_grant(2) = '1') else '0';

	uConstantMemoryArbiter : arbiter
		generic map(
			CNT => ARB_CMEM_CNT
		)
		port map(
			clk   => clk_in,
			rst   => reset,
			req   => arb_cmem_req,
			ack   => arb_cmem_ack,
			grant => arb_cmem_grant
		);

	arb_cmem_ack <= arb_cmem_ack_o(0) or arb_cmem_ack_o(1) or arb_cmem_ack_o(2);

	uConstantMemoryController : constant_memory_controller
		generic map(
			ADDRESS_SIZE     => CMEM_ADDR_SIZE,
			ARB_GPRS_EN      => '1',
			ARB_ADDR_REGS_EN => '1'
		)
		port map(
			reset                => reset,
			clk_in               => clk_in,
			en                   => cmem_en_i,
			addr_in              => cmem_addr_i,
			mask_in              => cmem_mask_i,
			rd_wr_type_in        => cmem_rd_wr_type_i,
			sm_type_in           => cmem_sm_type_i,
			addr_lo_in           => addr_lo_in,
			addr_hi_in           => addr_hi_in,
			addr_imm_in          => addr_imm_in,
			gprs_req_out         => arb_gprs_req(7),
			gprs_ack_out         => arb_gprs_ack_o(7),
			gprs_grant_in        => arb_gprs_grant(7),
			gprs_en_out          => cmem_gprs_en,
			gprs_reg_num_out     => cmem_gprs_reg_num,
			gprs_data_type_out   => cmem_gprs_data_type,
			gprs_rd_data_in      => cmem_gprs_rd_data,
			gprs_rdy_in          => cmem_gprs_rdy,
			addr_regs_req_out    => arb_addr_regs_req(7),
			addr_regs_ack_out    => arb_addr_regs_ack_o(7),
			addr_regs_grant_in   => arb_addr_regs_grant(7),
			addr_regs_en_out     => cmem_addr_regs_en,
			addr_regs_reg_out    => cmem_addr_regs_reg,
			addr_regs_rd_data_in => cmem_addr_regs_rd_data,
			addr_regs_rdy_in     => cmem_addr_regs_rdy,
			cmem_addr_out        => cmem_addr_out,
			cmem_wr_en_out       => cmem_wr_en_out,
			cmem_wr_data_out     => cmem_wr_data_out,
			cmem_rd_data_in      => cmem_rd_data_in,
			data_out             => cmem_rd_data_o,
			rdy_out              => cmem_rdy_o
		);

	cmem_en_i <= src1_cmem_en when (arb_cmem_grant(0) = '1')
		else src2_cmem_en when (arb_cmem_grant(1) = '1')
		else src3_cmem_en when (arb_cmem_grant(2) = '1')
		else '0';

	cmem_rd_wr_type_i <= src1_cmem_rd_wr_type when (arb_cmem_grant(0) = '1')
		else src2_cmem_rd_wr_type when (arb_cmem_grant(1) = '1')
		else src3_cmem_rd_wr_type when (arb_cmem_grant(2) = '1')
		else READ;

	cmem_addr_i(0) <= src1_cmem_addr when (arb_cmem_grant(0) = '1')
		else src2_cmem_addr when (arb_cmem_grant(1) = '1')
		else src3_cmem_addr when (arb_cmem_grant(2) = '1')
		else (others => '0');

	cmem_sm_type_i <= src1_cmem_sm_type when (arb_cmem_grant(0) = '1')
		else src2_cmem_sm_type when (arb_cmem_grant(1) = '1')
		else src3_cmem_sm_type when (arb_cmem_grant(2) = '1')
		else SM_NONE;

	cmem_mask_i <= src1_cmem_mask when (arb_cmem_grant(0) = '1')
		else src2_cmem_mask when (arb_cmem_grant(1) = '1')
		else src3_cmem_mask when (arb_cmem_grant(2) = '1')
		else (others => '0');

	src1_cmem_rd_data <= cmem_rd_data_o when (arb_cmem_grant(0) = '1') else (others => (others => (others => '0')));
	src2_cmem_rd_data <= cmem_rd_data_o when (arb_cmem_grant(1) = '1') else (others => (others => (others => '0')));
	src3_cmem_rd_data <= cmem_rd_data_o when (arb_cmem_grant(2) = '1') else (others => (others => (others => '0')));

	src1_cmem_rdy <= cmem_rdy_o when (arb_cmem_grant(0) = '1') else '0';
	src2_cmem_rdy <= cmem_rdy_o when (arb_cmem_grant(1) = '1') else '0';
	src3_cmem_rdy <= cmem_rdy_o when (arb_cmem_grant(2) = '1') else '0';

	uGlobalMemoryArbiter : arbiter
		generic map(
			CNT => ARB_GMEM_CNT
		)
		port map(
			clk   => clk_in,
			rst   => reset,
			req   => arb_gmem_req,
			ack   => arb_gmem_ack,
			grant => arb_gmem_grant
		);

	arb_gmem_ack <= arb_gmem_ack_o(0) or arb_gmem_ack_o(1) or arb_gmem_ack_o(2);

	uGlobalMemoryController : global_memory_controller
		generic map(
			ADDRESS_SIZE     => GMEM_ADDR_SIZE,
			ARB_GPRS_EN      => '1',
			ARB_ADDR_REGS_EN => '1'
		)
		port map(
			reset                => reset,
			clk_in               => clk_in,
			en                   => gmem_en_i,
			data_in              => gmem_wr_data_i,
			addr_in              => gmem_addr_i,
			mask_in              => gmem_mask_i,
			rd_wr_type_in        => gmem_rd_wr_type_i,
			data_type_in         => gmem_data_type_i,
			addr_lo_in           => addr_lo_in,
			addr_hi_in           => addr_hi_in,
			addr_imm_in          => addr_imm_in,
			gprs_req_out         => arb_gprs_req(8),
			gprs_ack_out         => arb_gprs_ack_o(8),
			gprs_grant_in        => arb_gprs_grant(8),
			gprs_en_out          => gmem_gprs_en,
			gprs_reg_num_out     => gmem_gprs_reg_num,
			gprs_data_type_out   => gmem_gprs_data_type,
			gprs_rd_data_in      => gmem_gprs_rd_data,
			gprs_rdy_in          => gmem_gprs_rdy,
			addr_regs_req_out    => arb_addr_regs_req(8),
			addr_regs_ack_out    => arb_addr_regs_ack_o(8),
			addr_regs_grant_in   => arb_addr_regs_grant(8),
			addr_regs_en_out     => gmem_addr_regs_en,
			addr_regs_reg_out    => gmem_addr_regs_reg,
			addr_regs_rd_data_in => gmem_addr_regs_rd_data,
			addr_regs_rdy_in     => gmem_addr_regs_rdy,
			gmem_addr_out        => gmem_addr_out,
			gmem_wr_en_out       => gmem_wr_en_out,
			gmem_wr_data_out     => gmem_wr_data_out,
			gmem_rd_data_in      => gmem_rd_data_in,
			data_out             => gmem_rd_data_o,
			rdy_out              => gmem_rdy_o
		);

	gmem_en_i <= src1_gmem_en when (arb_gmem_grant(0) = '1')
		else src2_gmem_en when (arb_gmem_grant(1) = '1')
		else src3_gmem_en when (arb_gmem_grant(2) = '1')
		else '0';

	gmem_rd_wr_type_i <= src1_gmem_rd_wr_type when (arb_gmem_grant(0) = '1')
		else src2_gmem_rd_wr_type when (arb_gmem_grant(1) = '1')
		else src3_gmem_rd_wr_type when (arb_gmem_grant(2) = '1')
		else READ;

	gmem_addr_i <= src1_gmem_addr when (arb_gmem_grant(0) = '1')
		else src2_gmem_addr when (arb_gmem_grant(1) = '1')
		else src3_gmem_addr when (arb_gmem_grant(2) = '1')
		else (others => '0');

	gmem_mask_i <= src1_gmem_mask when (arb_gmem_grant(0) = '1')
		else src2_gmem_mask when (arb_gmem_grant(1) = '1')
		else src3_gmem_mask when (arb_gmem_grant(2) = '1')
		else (others => '0');

	gmem_data_type_i <= src1_gmem_data_type when (arb_gmem_grant(0) = '1')
		else src2_gmem_data_type when (arb_gmem_grant(1) = '1')
		else src3_gmem_data_type when (arb_gmem_grant(2) = '1')
		else DT_NONE;

	src1_gmem_rd_data <= gmem_rd_data_o when (arb_gmem_grant(0) = '1') else (others => (others => (others => '0')));
	src2_gmem_rd_data <= gmem_rd_data_o when (arb_gmem_grant(1) = '1') else (others => (others => (others => '0')));
	src3_gmem_rd_data <= gmem_rd_data_o when (arb_gmem_grant(2) = '1') else (others => (others => (others => '0')));

	src1_gmem_rdy <= gmem_rdy_o when (arb_gmem_grant(0) = '1') else '0';
	src2_gmem_rdy <= gmem_rdy_o when (arb_gmem_grant(1) = '1') else '0';
	src3_gmem_rdy <= gmem_rdy_o when (arb_gmem_grant(2) = '1') else '0';

	gPredicateLUT : for n in 0 to 31 generate    -- 32 warps????  possibly
	begin
		uPredicateLUT : predicate_lut
			port map(
				clk_in            => clk_in,
				host_reset        => reset,
				pred_reg_lut_addr => pred_cond_in,
				pred_reg_lut_bit  => pred_regs_data(n),
				pred_reg_lut_data => pred_lut_data_o(n)
			);
	end generate;
end arch;

