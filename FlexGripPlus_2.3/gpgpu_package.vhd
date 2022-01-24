----------------------------------------------------------------------------------
-- Company:          Univerity of Massachusetts 
-- Engineer:         Kevin Andryc
-- 
-- Create Date:      17:50:27 09/19/2010 
-- Design Name: 
-- Module Name:      gpgpu_package - package 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
----------------------------------------------------------------------------
-- Revisions:       
--  REV:        Date:           Description:
--  0.1.a       9/13/2010       Created Top level file 
----------------------------------------------------------------------------

library ieee;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

--[BOYANG]
use work.pick_bench.all;

package gpgpu_package is
	--
	-- Constants
	--
	constant CORES               : integer                       := BENCH_CORES;     
	constant WARP_SIZE           : std_logic_vector(5 downto 0)  := "100000";        --32
	constant WARP_LANES          : integer                       := BENCH_WARP_LANES; 
	constant MAX_WARPS_PER_BLOCK : integer                       := 16;
	constant MAX_WARPS           : integer                       := 32;
	constant MAX_VGPR            : integer                       := 512;
	constant MAX_CTAS            : integer                       := 8;
	--constant MAX_THREADS         : integer                       := 1024; -- MAX_WARPS * WARP_SIZE = 1024
	constant MAX_ADDR_REGS       : integer                       := 4;
	constant MAX_PRED_REGS       : integer                       := 4;
	constant MAX_SAMPLERS        : integer                       := 16;
	constant CODE_START          : std_logic_vector(31 downto 0) := x"00000000";
	constant CORE_COUNT          : std_logic_vector(7 downto 0)  := x"01";

	-- 16 * 64 K
	constant CONST_START    : std_logic_vector(31 downto 0) := x"00000000"; -- -> 0x00100000
	constant CONST_SEG_SIZE : std_logic_vector(31 downto 0) := x"00010000"; -- integer := 64 * 1024;
	constant CONST_SEG_NUM  : integer                       := 16;

	constant SHARED_START : std_logic_vector(31 downto 0) := x"00100000"; -- -> 0x00104000
	constant SHARED_SIZE  : integer                       := 16 * 1024;

	constant LOCAL_START  : std_logic_vector(31 downto 0) := x"30000000";
	constant GLOBAL_START : std_logic_vector(31 downto 0) := x"40000000";

	constant CONFIG_PARAMS_START : std_logic_vector(31 downto 0) := x"00000020"; -- 20

	constant STACK_DEPTH      : integer := 32;
	constant STACK_DATA_WIDTH : integer := 66;

	constant TEMP_REG_COUNT : integer := 6;
	constant TEMP_REG_SRC1  : integer := 0;
	constant TEMP_REG_SRC2  : integer := 2;
	constant TEMP_REG_SRC3  : integer := 4;
	constant TEMP_REG_DEST  : integer := 0;

	constant GMEM_ADDR_SIZE   : integer := 18;
	constant CMEM_ADDR_SIZE   : integer := 13;
	constant SYSMEM_ADDR_SIZE : integer := 18;
	constant SHMEM_ADDR_SIZE  : integer := 14;
	constant SHMEM_PARAM_SIZE : integer := 16;

	-- ADDED GIANLUCA ROASCIO
	constant SYSMEM_DATA_SIZE : integer := 32;

	--
	-- Functions
	--
	function log2(n : integer) return integer;

	--
	-- Types
	--
	type instr_opcode_type is (MOV, ALU, FLOW, NOP, UNKNOWN);
	type instr_opcode_array is array (instr_opcode_type) of std_logic_vector(3 downto 0);
	constant encode_instr_opcode : instr_opcode_array := (MOV => "0000", 
														  ALU => "0001", 
														  FLOW => "0010", 
														  NOP => "0011", 
														  UNKNOWN => "0100"
	);

	type instr_marker_type is (FULL_NORM, FULL_END, FULL_JOIN, IMM, HALF, UNKNOWN);
	type instr_marker_array is array (instr_marker_type) of std_logic_vector(3 downto 0);
	constant encode_instr_marker : instr_marker_array := (FULL_NORM => "0000", 
														  FULL_END  => "0001", 
														  FULL_JOIN => "0010", 
														  IMM 		=> "0011", 
														  HALF 		=> "0100", 
														  UNKNOWN 	=> "0101"
	);

	type mov_opcode_type is (LOAD, STORE, MOV, UNKNOWN);
	type mov_opcode_array is array (mov_opcode_type) of std_logic_vector(3 downto 0);
	constant encode_mov_opcode : mov_opcode_array := (LOAD    => "0000", 
													  STORE   => "0001", 
													  MOV 	  => "0010", 
													  UNKNOWN => "0011"
	);

	type mem_type is (REG, MEM_SHARED, MEM_LOCAL, MEM_GLOBAL, MEM_CONST, ADDRESS_MEM, ADDRESS_ADDRESS, ADDRESS, FLAGS, UNKNOWN);
	type mem_type_array is array (mem_type) of std_logic_vector(3 downto 0);
	constant encode_mem_type : mem_type_array := (REG 			  => "0000", 
												  MEM_SHARED 	  => "0001", 
												  MEM_LOCAL 	  => "0010", 
												  MEM_GLOBAL 	  => "0011", 
												  MEM_CONST 	  => "0100", 
												  ADDRESS_MEM 	  => "0101", 
												  ADDRESS_ADDRESS => "0110", 
												  ADDRESS 		  => "0111", 
												  FLAGS 		  => "1000", 
												  UNKNOWN 		  => "1001"
	);

	type alu_opcode_type is (IADD, IADDC, ISUB, SET, MIN, MAX, SHL, SHR, AND_OP, OR_OP, XOR_OP, NEG_OP, IMUL24, IMAD24, IMAD24C, CVT, UNKNOWN);
	type alu_opcode_array is array (alu_opcode_type) of std_logic_vector(4 downto 0);
	constant encode_alu_opcode : alu_opcode_array := (IADD    => "00000", 
													  IADDC   => "00001", 
													  ISUB    => "00010", 
													  SET     => "00011", 
													  MIN     => "00100", 
													  MAX     => "00101", 
													  SHL     => "00110", 
													  SHR     => "00111", 
													  AND_OP  => "01000", 
													  OR_OP   => "01001", 
													  XOR_OP  => "01010", 
													  NEG_OP  => "01011", 
													  IMUL24  => "01100", 
													  IMAD24  => "01101",
		                                              IMAD24C => "01110", 
		                                              CVT  	  => "01111", 
		                                              UNKNOWN => "10000");

	type flow_opcode_type is (BRANCH, CALL, RET, PREBREAK, BREAK, BAR, JOIN, UNKNOWN);
	type flow_opcode_array is array (flow_opcode_type) of std_logic_vector(3 downto 0);
	constant encode_flow_opcode : flow_opcode_array := (BRANCH   => "0000", 
													    CALL     => "0001", 
													    RET      => "0010", 
													    PREBREAK => "0011", 
													    BREAK    => "0100", 
													    BAR      => "0101", 
													    JOIN     => "0110", 
													    UNKNOWN  => "0111"
	);

	type conv_type is (CT_U16, CT_U32, CT_U8, CT_U32U8, CT_S16, CT_S32, CT_S8, CT_NONE);
	type conv_type_array is array (conv_type) of std_logic_vector(2 downto 0);
	constant encode_conv_type : conv_type_array := (CT_U16   => "000",
													CT_U32   => "001", 
													CT_U8    => "010", 
													CT_U32U8 => "011", 
													CT_S16   => "100", 
													CT_S32   => "101", 
													CT_S8    => "110", 
													CT_NONE  => "111"
	);

	type abs_sat_type is (AS_NONE, AS_SAT, AS_ABS, AS_SSAT);
	type abs_sat_array is array (abs_sat_type) of std_logic_vector(3 downto 0);
	constant encode_abs_sat : abs_sat_array := (AS_NONE => "0000", 
												AS_SAT  => "0001", 
												AS_ABS  => "0010", 
												AS_SSAT => "0011"
	);

	type sm_type is (SM_U8, SM_U16, SM_S16, SM_U32, SM_NONE);
	type sm_type_array is array (sm_type) of std_logic_vector(2 downto 0);
	constant encode_sm_type : sm_type_array := (SM_U8   => "000", 
												SM_U16  => "001", 
												SM_S16  => "010", 
												SM_U32  => "011", 
												SM_NONE => "111"
	);

	type data_type is (DT_U8, DT_S8, DT_U16, DT_S16, DT_U64, DT_U128, DT_U32, DT_S32, DT_F32, DT_F64, DT_NONE, DT_UNKNOWN);
	type data_type_array is array (data_type) of std_logic_vector(3 downto 0);
	constant encode_data_type : data_type_array := (DT_U8      => "0000", 
													DT_S8      => "0001", 
													DT_U16     => "0010", 
													DT_S16     => "0011", 
													DT_U64     => "0100", 
													DT_U128    => "0101", 
													DT_U32     => "0110", 
													DT_S32     => "0111", 
													DT_F32 	   => "1000", 
													DT_F64     => "1001", 
													DT_NONE    => "1010", 
													DT_UNKNOWN => "1011"
	);

	type reg_type is (RT_U16, RT_U32, RT_U64, RT_NONE);
	type reg_type_array is array (reg_type) of std_logic_vector(1 downto 0);
	constant encode_reg_type : reg_type_array := (RT_U16  => "00", 
												  RT_U32  => "01", 
												  RT_U64  => "10", 
												  RT_NONE => "11"
	);

	type mem_opcode_type is (READ, READ_GATHER, WRITE, WRITE_SCATTER);
	type mem_opcode_type_array is array (mem_opcode_type) of std_logic_vector(1 downto 0);
	constant encode_mem_opcode_type : mem_opcode_type_array := (READ          => "00", 
																READ_GATHER   => "01", 
																WRITE         => "10", 
																WRITE_SCATTER => "11"
	);

	type flag_type is (FLAG_ZERO, FLAG_SIGN, FLAG_CARRY, FLAG_OVERFLOW);
	type flag_type_array is array (flag_type) of natural range 0 to 3;
	constant encode_flag_type : flag_type_array := (FLAG_ZERO => 0, 
													FLAG_SIGN => 1, 
													FLAG_CARRY => 2, 
													FLAG_OVERFLOW => 3
	);

	type warp_state_type is (READY, ACTIVE, WAITING_FENCE, FINISHED);
	type warp_state_array is array (warp_state_type) of std_logic_vector(1 downto 0);
	constant encode_warp_state : warp_state_array := (READY 		=> "00", 
													  ACTIVE 		=> "01", 
													  WAITING_FENCE => "10", 
													  FINISHED 		=> "11"
	);

	type warp_stack_token_type is (ID_SYNC, ID_DIVERGE, ID_CALL, ID_BREAK);
	type warp_stack_token_array is array (warp_stack_token_type) of std_logic_vector(1 downto 0);
	constant encode_warp_stack_token : warp_stack_token_array := (ID_SYNC 	 => "00", 
																  ID_DIVERGE => "01", 
																  ID_CALL 	 => "10", 
																  ID_BREAK 	 => "11"
	);

	type fence_regs_std_array is array (MAX_WARPS - 1 downto 0) of std_logic;
	type fence_regs_vector_array is array (MAX_WARPS - 1 downto 0) of std_logic_vector(3 downto 0);

	type warp_id_array is array (CORES - 1 downto 0) of std_logic_vector(4 downto 0);
	type warp_lane_id_array is array (CORES - 1 downto 0) of std_logic_vector(1 downto 0);
	type gprs_addr_array is array (CORES - 1 downto 0) of std_logic_vector(8 downto 0);
	type gprs_reg_array is array (CORES - 1 downto 0) of std_logic_vector(8 downto 0);
	type reg_num_array is array (CORES - 1 downto 0) of std_logic_vector(1 downto 0);
	type wr_en_array is array (CORES - 1 downto 0) of std_logic;

	type warp_div_std_logic_array is array (MAX_WARPS - 1 downto 0) of std_logic;
	type warp_div_data_array is array (MAX_WARPS - 1 downto 0) of std_logic_vector(STACK_DATA_WIDTH - 1 downto 0);

	type mask_vector_array is array (3 downto 0) of std_logic_vector(7 downto 0);

	type vector_register is array (CORES - 1 downto 0) of std_logic_vector(31 downto 0);
	type vector_word_register is array (3 downto 0) of std_logic_vector(31 downto 0);
	type vector_word_register_array is array (CORES - 1 downto 0) of vector_word_register;
	type vector_register_array is array (TEMP_REG_COUNT - 1 downto 0) of vector_word_register;
	type temp_vector_register is array (CORES - 1 downto 0) of vector_register_array;

	type vector_flag_register is array (CORES - 1 downto 0) of std_logic_vector(3 downto 0);
	type vector_pred_register is array (31 downto 0) of std_logic_vector(3 downto 0);

	-- [BOYANG] All components declaration
	component warps_done_lut is
		port(
			clk_in          : in  std_logic;
			host_reset      : in  std_logic;
			num_warps_in    : in  std_logic_vector(4 downto 0);
			warps_done_mask : out std_logic_vector(MAX_WARPS - 1 downto 0)
		);
	end component;

	component thread_id_calc is
		port(
			clk                : in  std_logic; -- NOT USED
			en                 : in  std_logic;
			block_indx_in      : in  std_logic_vector(15 downto 0);
			block_x_in         : in  std_logic_vector(15 downto 0);
			block_y_in         : in  std_logic_vector(15 downto 0);
			block_z_in         : in  std_logic_vector(15 downto 0);
			num_cores_in       : in  std_logic_vector(7 downto 0);
			warp_size_in       : in  std_logic_vector(5 downto 0);
			warps_per_block_in : in  std_logic_vector(5 downto 0);
			x_indx_in          : in  std_logic_vector(15 downto 0);
			y_indx_in          : in  std_logic_vector(15 downto 0);
			z_indx_in          : in  std_logic_vector(15 downto 0);
			data_valid         : out std_logic;
			thread_id_out      : out std_logic_vector(31 downto 0);
			thread_lane_id_out : out std_logic_vector(7 downto 0);
			warp_id_out        : out std_logic_vector(31 downto 0);
			warp_lane_id_out   : out std_logic_vector(5 downto 0)
		);
	end component;

	component warps_per_block_calc is
		port(
			clk                  : in  std_logic; -- NOT USED
			en                   : in  std_logic; --
			threads_per_block_in : in  std_logic_vector(11 downto 0);
			warp_size_in         : in  std_logic_vector(5 downto 0);
			data_valid_out       : out std_logic;
			warps_per_block_out  : out std_logic_vector(5 downto 0)
		);
	end component;

	component block_id_calc is
		port(
			clk            : in  std_logic; -- NOT USED
			en             : in  std_logic;
			block_idx_in   : in  std_logic_vector(15 downto 0);
			grid_x_in      : in  std_logic_vector(15 downto 0);
			idx_in         : in  std_logic_vector(15 downto 0);
			block_id_x_out : out std_logic_vector(15 downto 0);
			block_id_y_out : out std_logic_vector(15 downto 0);
			valid          : out std_logic
		);
	end component;

	component memory_controller is
		generic(
			ADDRESS_SIZE : integer := 32
		);
		port(
			reset           : in  std_logic;
			clk_in          : in  std_logic;
			en              : in  std_logic;
			mem_addr_in     : in  std_logic_vector(ADDRESS_SIZE - 1 downto 0);
			mem_size_in     : in  std_logic_vector(2 downto 0);
			mem_wr_data_in  : in  std_logic_vector(31 downto 0);
			mem_wr_en_in    : in  std_logic;
			mem_addr_out    : out std_logic_vector(ADDRESS_SIZE - 1 downto 0);
			mem_wr_en_out   : out std_logic;
			mem_wr_data_out : out std_logic_vector(7 downto 0);
			mem_rd_data_in  : in  std_logic_vector(7 downto 0);
			mem_rd_data_out : out std_logic_vector(31 downto 0);
			mem_rd_wr_done  : out std_logic
		);
	end component;

	component integer_add_subtract
		port(
			a_in         : in  std_logic_vector(31 downto 0);
			a_neg_in     : in  std_logic;
			b_in         : in  std_logic_vector(31 downto 0);
			b_neg_in     : in  std_logic;
			carry_in     : in  std_logic;
			saturate_in  : in  std_logic;
			sub_en       : in  std_logic;
			w32_in       : in  std_logic;
			carry_out    : out std_logic;
			overflow_out : out std_logic;
			result_out   : out std_logic_vector(31 downto 0)
		);
	end component;

	component integer_mult_24
		port(
			a_in         : in  std_logic_vector(31 downto 0);
			a_neg_in     : in  std_logic;
			b_in         : in  std_logic_vector(31 downto 0);
			b_neg_in     : in  std_logic;
			is_signed_in : in  std_logic;
			w32_in       : in  std_logic;
			result_out   : out std_logic_vector(31 downto 0)
		);
	end component;

	component shift_logical
		port(
			a_in         : in  std_logic_vector(31 downto 0);
			b_in         : in  std_logic_vector(31 downto 0);
			is_signed_in : in  std_logic;
			w32_in       : in  std_logic;
			sll_out      : out std_logic_vector(31 downto 0);
			srl_out      : out std_logic_vector(31 downto 0)
		);
	end component;

	component boolean_functions
		port(
			a_in    : in  std_logic_vector(31 downto 0);
			b_in    : in  std_logic_vector(31 downto 0);
			and_out : out std_logic_vector(31 downto 0);
			neg_out : out std_logic_vector(31 downto 0);
			or_out  : out std_logic_vector(31 downto 0);
			xor_out : out std_logic_vector(31 downto 0)
		);
	end component;

	component min_max
		port(
			a_in         : in  std_logic_vector(31 downto 0);
			b_in         : in  std_logic_vector(31 downto 0);
			is_signed_in : in  std_logic;
			w32_in       : in  std_logic;
			max_out      : out std_logic_vector(31 downto 0);
			min_out      : out std_logic_vector(31 downto 0)
		);
	end component;

	component convert_int_int
		port(
			a_in            : in  std_logic_vector(31 downto 0);
			abs_saturate_in : in  std_logic_vector(1 downto 0);
			cvt_neg_in      : in  std_logic;
			cvt_type_in     : in  std_logic_vector(2 downto 0);
			w32_in          : in  std_logic;
			result_out      : out std_logic_vector(31 downto 0)
		);
	end component;

	component compute_set_pred_i
		port(
			is_signed_in : in  std_logic;
			set_cond_in  : in  std_logic_vector(2 downto 0);
			src_1_in     : in  std_logic_vector(31 downto 0);
			src_2_in     : in  std_logic_vector(31 downto 0);
			w32_in       : in  std_logic;
			result_out   : out std_logic_vector(31 downto 0);
			sign_out     : out std_logic;
			zero_out     : out std_logic
		);
	end component;

	component convert_data_types
		port(
			mov_size_in                : in  std_logic_vector(2 downto 0);
			conv_type_in               : in  conv_type;
			reg_type_in                : in  reg_type;
			data_type_in               : in  data_type;
			sm_type_in                 : in  std_logic_vector(1 downto 0);
			mem_type_in                : in  std_logic_vector(2 downto 0);
			mv_size_to_sm_type_out     : out sm_type;
			data_type_to_sm_type_out   : out sm_type;
			sm_type_to_sm_type_out     : out sm_type;
			mem_type_to_sm_type_out    : out sm_type;
			conv_type_to_reg_type_out  : out reg_type;
			reg_type_to_data_type_out  : out data_type;
			mv_size_to_data_type_out   : out data_type;
			conv_type_to_data_type_out : out data_type;
			sm_type_to_data_type_out   : out data_type;
			mem_type_to_data_type_out  : out data_type;
			sm_type_to_cvt_type_out    : out conv_type;
			mem_type_to_cvt_type_out   : out conv_type
		);
	end component;

	component increment_address
		port(
			reset                  : in  std_logic;
			clk_in                 : in  std_logic;
			en                     : in  std_logic;
			addr_reg_in            : in  std_logic_vector(1 downto 0);
			data_type_in           : in  data_type;
			mask_in                : in  std_logic_vector(CORES - 1 downto 0);
			imm_in                 : in  std_logic_vector(31 downto 0);
			addr_regs_en_out       : out std_logic;
			addr_regs_reg_num_out  : out std_logic_vector(1 downto 0);
			addr_regs_wr_data_out  : out vector_register;
			addr_regs_mask_out     : out std_logic_vector(CORES - 1 downto 0);
			addr_regs_rd_wr_en_out : out std_logic;
			addr_regs_rd_data_in   : in  vector_register;
			addr_regs_rdy_in       : in  std_logic;
			rdy_out                : out std_logic
		);
	end component;

	component compute_pred_flags
		port(
			data_in      : in  vector_register;
			flags_in     : in  vector_flag_register;
			data_type_in : in  data_type;
			flags_out    : out vector_flag_register);
	end component;

	component vector_register_controller
		port(
			reset              : in  std_logic;
			clk_in             : in  std_logic;
			en                 : in  std_logic;
			lane_id_in         : in  std_logic_vector(1 downto 0);
			base_addr_in       : in  std_logic_vector(8 downto 0);
			reg_num_in         : in  std_logic_vector(8 downto 0);
			data_in            : in  vector_word_register_array;
			data_type_in       : in  data_type;
			mask_in            : in  std_logic_vector(CORES - 1 downto 0);
			rd_wr_en_in        : in  std_logic;
			gprs_base_addr_out : out gprs_addr_array;
			gprs_reg_num_out   : out gprs_reg_array;
			gprs_lane_id_out   : out warp_lane_id_array;
			gprs_wr_en_out     : out wr_en_array;
			gprs_wr_data_out   : out vector_register;
			gprs_rd_data_in    : in  vector_register;
			data_out           : out vector_word_register_array;
			rdy_out            : out std_logic
		);
	end component;

	component predicate_register_controller
		port(
			reset                      : in  std_logic;
			clk_in                     : in  std_logic;
			en                         : in  std_logic;
			warp_id_in                 : in  std_logic_vector(4 downto 0);
			lane_id_in                 : in  std_logic_vector(1 downto 0);
			reg_num_in                 : in  std_logic_vector(1 downto 0);
			data_in                    : in  vector_flag_register;
			mask_in                    : in  std_logic_vector(CORES - 1 downto 0);
			rd_wr_en_in                : in  std_logic;
			pred_regs_warp_id_out      : out warp_id_array;
			pred_regs_warp_lane_id_out : out warp_lane_id_array;
			pred_regs_reg_num_out      : out reg_num_array;
			pred_regs_wr_en_out        : out wr_en_array;
			pred_regs_wr_data_out      : out vector_flag_register;
			pred_regs_rd_data_in       : in  vector_flag_register;
			data_out                   : out vector_flag_register;
			rdy_out                    : out std_logic
		);
	end component;

	component address_register_controller
		port(
			reset                      : in  std_logic;
			clk_in                     : in  std_logic;
			en                         : in  std_logic;
			warp_id_in                 : in  std_logic_vector(4 downto 0);
			lane_id_in                 : in  std_logic_vector(1 downto 0);
			reg_num_in                 : in  std_logic_vector(1 downto 0);
			data_in                    : in  vector_register;
			mask_in                    : in  std_logic_vector(CORES - 1 downto 0);
			rd_wr_en_in                : in  std_logic;
			addr_regs_warp_id_out      : out warp_id_array;
			addr_regs_warp_lane_id_out : out warp_lane_id_array;
			addr_regs_reg_num_out      : out reg_num_array;
			addr_regs_wr_en_out        : out wr_en_array;
			addr_regs_wr_data_out      : out vector_register;
			addr_regs_rd_data_in       : in  vector_register;
			data_out                   : out vector_register;
			rdy_out                    : out std_logic
		);
	end component;

	component shared_memory_controller
		generic(
			ADDRESS_SIZE     : integer   := 32;
			ARB_GPRS_EN      : std_logic := '0';
			ARB_ADDR_REGS_EN : std_logic := '0'
		);
		port(
			reset                : in  std_logic;
			clk_in               : in  std_logic;
			en                   : in  std_logic;
			data_in              : in  vector_word_register_array;
			base_addr_in         : in  std_logic_vector(ADDRESS_SIZE - 1 downto 0);
			addr_in              : in  std_logic_vector(31 downto 0);
			mask_in              : in  std_logic_vector(CORES - 1 downto 0);
			rd_wr_type_in        : in  mem_opcode_type;
			sm_type_in           : in  sm_type;
			addr_lo_in           : in  std_logic_vector(1 downto 0);
			addr_hi_in           : in  std_logic;
			addr_imm_in          : in  std_logic;
			gprs_req_out         : out std_logic;
			gprs_ack_out         : out std_logic;
			gprs_grant_in        : in  std_logic;
			gprs_en_out          : out std_logic;
			gprs_reg_num_out     : out std_logic_vector(8 downto 0);
			gprs_data_type_out   : out data_type;
			-- gprs_mask_out          : out std_logic_vector(CORES - 1 downto 0);
			-- gprs_rd_wr_en_out      : out std_logic;
			gprs_rd_data_in      : in  vector_word_register_array;
			gprs_rdy_in          : in  std_logic;
			addr_regs_req_out    : out std_logic;
			addr_regs_ack_out    : out std_logic;
			addr_regs_grant_in   : in  std_logic;
			addr_regs_en_out     : out std_logic;
			addr_regs_reg_out    : out std_logic_vector(1 downto 0);
			-- addr_regs_mask_out     : out std_logic_vector(CORES - 1 downto 0);
			-- addr_regs_rd_wr_en_out : out std_logic;
			addr_regs_rd_data_in : in  vector_register;
			addr_regs_rdy_in     : in  std_logic;
			shmem_addr_out       : out std_logic_vector(ADDRESS_SIZE - 1 downto 0);
			shmem_wr_en_out      : out std_logic;
			shmem_wr_data_out    : out std_logic_vector(7 downto 0);
			shmem_rd_data_in     : in  std_logic_vector(7 downto 0);
			data_out             : out vector_word_register_array;
			rdy_out              : out std_logic
		);
	end component;

	component global_memory_controller
		generic(
			ADDRESS_SIZE     : integer   := 32;
			ARB_GPRS_EN      : std_logic := '0';
			ARB_ADDR_REGS_EN : std_logic := '0'
		);
		port(
			reset                : in  std_logic;
			clk_in               : in  std_logic;
			en                   : in  std_logic;
			data_in              : in  vector_word_register_array;
			addr_in              : in  std_logic_vector(31 downto 0);
			mask_in              : in  std_logic_vector(CORES - 1 downto 0);
			rd_wr_type_in        : in  mem_opcode_type;
			data_type_in         : in  data_type;
			addr_lo_in           : in  std_logic_vector(1 downto 0);
			addr_hi_in           : in  std_logic;
			addr_imm_in          : in  std_logic;
			gprs_req_out         : out std_logic;
			gprs_ack_out         : out std_logic;
			gprs_grant_in        : in  std_logic;
			gprs_en_out          : out std_logic;
			gprs_reg_num_out     : out std_logic_vector(8 downto 0);
			gprs_data_type_out   : out data_type;
			gprs_rd_data_in      : in  vector_word_register_array;
			gprs_rdy_in          : in  std_logic;
			addr_regs_req_out    : out std_logic;
			addr_regs_ack_out    : out std_logic;
			addr_regs_grant_in   : in  std_logic;
			addr_regs_en_out     : out std_logic;
			addr_regs_reg_out    : out std_logic_vector(1 downto 0);
			addr_regs_rd_data_in : in  vector_register;
			addr_regs_rdy_in     : in  std_logic;
			gmem_addr_out        : out std_logic_vector(ADDRESS_SIZE - 1 downto 0);
			gmem_wr_en_out       : out std_logic;
			gmem_wr_data_out     : out std_logic_vector(7 downto 0);
			gmem_rd_data_in      : in  std_logic_vector(7 downto 0);
			data_out             : out vector_word_register_array;
			rdy_out              : out std_logic
		);
	end component;

	component gpgpu_configuration
		port(
			clk_in                 : in  std_logic;
			host_reset             : in  std_logic;
			reset_registers        : in  std_logic;
			config_reg_cs          : in  std_logic;
			config_reg_rw          : in  std_logic;
			config_reg_adr         : in  std_logic_vector(31 downto 0);
			config_reg_data_in     : in  std_logic_vector(31 downto 0);
			config_reg_data_out    : out std_logic_vector(31 downto 0);
			kernel_blocks_per_core : out std_logic_vector(3 downto 0);
			kernel_num_gprs        : out std_logic_vector(8 downto 0);
			kernel_shmem_size      : out std_logic_vector(31 downto 0);
			kernel_parameter_size  : out std_logic_vector(15 downto 0);
			kernel_dyn_shmem_size  : out std_logic_vector(31 downto 0);
			kernel_block_x         : out std_logic_vector(15 downto 0);
			kernel_block_y         : out std_logic_vector(15 downto 0);
			kernel_block_z         : out std_logic_vector(15 downto 0);
			kernel_grid_x          : out std_logic_vector(15 downto 0);
			kernel_grid_y          : out std_logic_vector(15 downto 0)
		);
	end component;

	component block_scheduler
		port(
			clk_in                    : in  std_logic;
			host_reset                : in  std_logic;
			en                        : in  std_logic;
			kernel_blocks_per_core_in : in  std_logic_vector(3 downto 0);
			kernel_num_gprs_in        : in  std_logic_vector(8 downto 0);
			kernel_shmem_size_in      : in  std_logic_vector(31 downto 0);
			kernel_parameter_size_in  : in  std_logic_vector(15 downto 0);
			kernel_dyn_shmem_size_in  : in  std_logic_vector(31 downto 0);
			kernel_block_x_in         : in  std_logic_vector(15 downto 0);
			kernel_block_y_in         : in  std_logic_vector(15 downto 0);
			kernel_block_z_in         : in  std_logic_vector(15 downto 0);
			kernel_grid_x_in          : in  std_logic_vector(15 downto 0);
			kernel_grid_y_in          : in  std_logic_vector(15 downto 0);
			smp_done_in               : in  std_logic;
			threads_per_block_out     : out std_logic_vector(11 downto 0);
			num_blocks_out            : out std_logic_vector(3 downto 0);
			shmem_base_addr_out       : out std_logic_vector(31 downto 0);
			shmem_size_out            : out std_logic_vector(31 downto 0);
			parameter_size_out        : out std_logic_vector(15 downto 0);
			gprs_size_out             : out std_logic_vector(8 downto 0);
			block_x_out               : out std_logic_vector(15 downto 0);
			block_y_out               : out std_logic_vector(15 downto 0);
			block_z_out               : out std_logic_vector(15 downto 0);
			grid_x_out                : out std_logic_vector(15 downto 0);
			grid_y_out                : out std_logic_vector(15 downto 0);
			block_idx_out             : out std_logic_vector(15 downto 0);
			shmem_params_out          : out std_logic_vector(15 downto 0);
			cmem_params_out           : out std_logic_vector(15 downto 0);
			smp_reset_out             : out std_logic;
			smp_en_out                : out std_logic;
			rdy                       : out std_logic;
			kernel_done               : out std_logic
		);
	end component;

	component streaming_multiprocessor
		generic(
			STREAMING_MULTIPROCESSOR_ID : std_logic_vector(7 downto 0) := x"00";
			GMEM_ADDR_SIZE              : integer                      := 32;
			CMEM_ADDR_SIZE              : integer                      := 32;
			SYSMEM_ADDR_SIZE            : integer                      := 32
		);
		port(
			clk_in                   : in  std_logic;
			host_reset               : in  std_logic;
			threads_per_block_in     : in  std_logic_vector(11 downto 0);
			num_blocks_in            : in  std_logic_vector(3 downto 0);
			shmem_base_addr_in       : in  std_logic_vector(31 downto 0);
			shmem_size_in            : in  std_logic_vector(31 downto 0);
			parameter_size_in        : in  std_logic_vector(15 downto 0);
			gprs_size_in             : in  std_logic_vector(8 downto 0);
			block_x_in               : in  std_logic_vector(15 downto 0);
			block_y_in               : in  std_logic_vector(15 downto 0);
			block_z_in               : in  std_logic_vector(15 downto 0);
			grid_x_in                : in  std_logic_vector(15 downto 0);
			grid_y_in                : in  std_logic_vector(15 downto 0);
			block_idx_in             : in  std_logic_vector(15 downto 0);
			smp_run_en               : in  std_logic;
			gpgpu_config_reg_cs      : out std_logic;
			gpgpu_config_reg_rw      : out std_logic;
			gpgpu_config_reg_adr     : out std_logic_vector(31 downto 0);
			gpgpu_config_reg_rd_data : in  std_logic_vector(31 downto 0);
			gmem_wr_data_a           : out std_logic_vector(7 downto 0);
			gmem_addr_a              : out std_logic_vector(GMEM_ADDR_SIZE - 1 downto 0);
			gmem_wr_en_a             : out std_logic;
			gmem_rd_data_a           : in  std_logic_vector(7 downto 0);
			gmem_wr_data_b           : out std_logic_vector(7 downto 0);
			gmem_addr_b              : out std_logic_vector(GMEM_ADDR_SIZE - 1 downto 0);
			gmem_wr_en_b             : out std_logic;
			gmem_rd_data_b           : in  std_logic_vector(7 downto 0);
			cmem_wr_data_a           : out std_logic_vector(7 downto 0);
			cmem_addr_a              : out std_logic_vector(CMEM_ADDR_SIZE - 1 downto 0);
			cmem_wr_en_a             : out std_logic;
			cmem_rd_data_a           : in  std_logic_vector(7 downto 0);
			--sysmem_addr_a            : out std_logic_vector(SYSMEM_ADDR_SIZE - 1 downto 0);
			sysmem_addr              : out std_logic_vector(SYSMEM_ADDR_SIZE - 1 downto 0);
			--sysmem_wr_en_a           : out std_logic;
			--sysmem_rd_data_a         : in  std_logic_vector(7 downto 0);
			sysmem_rd_data           : in  std_logic_vector(SYSMEM_DATA_SIZE - 1 downto 0);
			--sysmem_addr_b            : out std_logic_vector(SYSMEM_ADDR_SIZE - 1 downto 0);
			--sysmem_wr_en_b           : out std_logic;
			--sysmem_rd_data_b         : in  std_logic_vector(7 downto 0);
			smp_done                 : out std_logic
		);
	end component;

	component system_memory_cntlr
    	generic ( SYSMEM_ADDR_SIZE : integer := 32);
		port(
			clk_in         : in  std_logic;
			mem_data_in_a  : in  std_logic_vector(SYSMEM_DATA_SIZE-1 downto 0);
			mem_addr_in_a  : in  std_logic_vector(SYSMEM_ADDR_SIZE-1 downto 0);
			mem_wr_en_a    : in  std_logic;
			mem_data_out_a : out std_logic_vector(SYSMEM_DATA_SIZE-1 downto 0);
			mem_data_in_b  : in  std_logic_vector(SYSMEM_DATA_SIZE-1 downto 0);
			mem_addr_in_b  : in  std_logic_vector(SYSMEM_ADDR_SIZE-1 downto 0);
			mem_wr_en_b    : in  std_logic;
			mem_data_out_b : out std_logic_vector(SYSMEM_DATA_SIZE-1 downto 0)
		);
	end component;
    
    component dp_regfile is
		generic(RAM_SIZE      : integer := 1024;
			    RAM_A_WIDTH   : integer := 10;
			    RAM_D_WIDTH   : integer := 8
		);
		port(
			clk  : in  std_logic;
			rst  : in  std_logic;
			addr_a : in  std_logic_vector(RAM_A_WIDTH - 1 downto 0);
			din_a  : in  std_logic_vector(RAM_D_WIDTH - 1 downto 0);
			we_a   : in  std_logic;
			addr_b : in  std_logic_vector(RAM_A_WIDTH - 1 downto 0);
			din_b  : in  std_logic_vector(RAM_D_WIDTH - 1 downto 0);
			we_b   : in  std_logic;
			dout_a : out std_logic_vector(RAM_D_WIDTH - 1 downto 0);
			dout_b : out std_logic_vector(RAM_D_WIDTH - 1 downto 0)
		);
	end component;


	component dp_ram is
		generic(RAM_SIZE      : integer := 1024;
			    RAM_A_WIDTH   : integer := 10;
			    RAM_D_WIDTH   : integer := 8
        -- synthesis translate_off
        ;
			    RAM_INIT_FILE : string  := "./dummy.mif"
		-- synthesis translate_on
		);
		port(
			clk  : in  std_logic;
			rst  : in  std_logic;
			addr_a : in  std_logic_vector(RAM_A_WIDTH - 1 downto 0);
			din_a  : in  std_logic_vector(RAM_D_WIDTH - 1 downto 0);
			we_a   : in  std_logic;
			addr_b : in  std_logic_vector(RAM_A_WIDTH - 1 downto 0);
			din_b  : in  std_logic_vector(RAM_D_WIDTH - 1 downto 0);
			we_b   : in  std_logic;
			dout_a : out std_logic_vector(RAM_D_WIDTH - 1 downto 0);
			dout_b : out std_logic_vector(RAM_D_WIDTH - 1 downto 0)
		);
	end component;

	component streaming_multiprocessor_configuration
		port(
			clk_in                    : in  std_logic;
			host_reset                : in  std_logic;
			reg_threads_per_block_in  : in  std_logic_vector(11 downto 0);
			reg_num_blocks_in         : in  std_logic_vector(3 downto 0);
			reg_warps_per_block_in    : in  std_logic_vector(5 downto 0);
			reg_shmem_base_addr_in    : in  std_logic_vector(31 downto 0);
			reg_shmem_size_in         : in  std_logic_vector(31 downto 0);
			reg_parameter_size_in     : in  std_logic_vector(15 downto 0);
			reg_gprs_size_in          : in  std_logic_vector(8 downto 0);
			reg_block_x_in            : in  std_logic_vector(15 downto 0);
			reg_block_y_in            : in  std_logic_vector(15 downto 0);
			reg_block_z_in            : in  std_logic_vector(15 downto 0);
			reg_grid_x_in             : in  std_logic_vector(15 downto 0);
			reg_grid_y_in             : in  std_logic_vector(15 downto 0);
			reg_block_idx_in          : in  std_logic_vector(15 downto 0);
			reg_threads_per_block_ld  : in  std_logic;
			reg_num_blocks_ld         : in  std_logic;
			reg_warps_per_block_ld    : in  std_logic;
			reg_shmem_base_addr_ld    : in  std_logic;
			reg_shmem_size_ld         : in  std_logic;
			reg_parameter_size_ld     : in  std_logic;
			reg_gprs_size_ld          : in  std_logic;
			reg_block_x_ld            : in  std_logic;
			reg_block_y_ld            : in  std_logic;
			reg_block_z_ld            : in  std_logic;
			reg_grid_x_ld             : in  std_logic;
			reg_grid_y_ld             : in  std_logic;
			reg_block_idx_ld          : in  std_logic;
			reg_threads_per_block_out : out std_logic_vector(11 downto 0);
			reg_num_blocks_out        : out std_logic_vector(3 downto 0);
			reg_warps_per_block_out   : out std_logic_vector(5 downto 0);
			reg_shmem_base_addr_out   : out std_logic_vector(31 downto 0);
			reg_shmem_size_out        : out std_logic_vector(31 downto 0);
			reg_parameter_size_out    : out std_logic_vector(15 downto 0);
			reg_gprs_size_out         : out std_logic_vector(8 downto 0);
			reg_block_x_out           : out std_logic_vector(15 downto 0);
			reg_block_y_out           : out std_logic_vector(15 downto 0);
			reg_block_z_out           : out std_logic_vector(15 downto 0);
			reg_grid_x_out            : out std_logic_vector(15 downto 0);
			reg_grid_y_out            : out std_logic_vector(15 downto 0);
			reg_block_idx_out         : out std_logic_vector(15 downto 0)
		);
	end component;

	component streaming_multiprocessor_cntlr
		generic(
			SHMEM_ADDR_SIZE : integer := 14
		);
		port(
			clk_in                      : in  std_logic;
			host_reset                  : in  std_logic;
			smp_run_en                  : in  std_logic;
			warp_generator_done         : in  std_logic;
			warp_scheduler_done         : in  std_logic;
			threads_per_block_in        : in  std_logic_vector(11 downto 0);
			num_blocks_in               : in  std_logic_vector(3 downto 0);
			shmem_base_addr_in          : in  std_logic_vector(31 downto 0);
			shmem_size_in               : in  std_logic_vector(31 downto 0);
			parameter_size_in           : in  std_logic_vector(15 downto 0);
			gprs_size_in                : in  std_logic_vector(8 downto 0);
			block_x_in                  : in  std_logic_vector(15 downto 0);
			block_y_in                  : in  std_logic_vector(15 downto 0);
			block_z_in                  : in  std_logic_vector(15 downto 0);
			grid_x_in                   : in  std_logic_vector(15 downto 0);
			grid_y_in                   : in  std_logic_vector(15 downto 0);
			block_idx_in                : in  std_logic_vector(15 downto 0);
			gpgpu_config_reg_cs_out     : out std_logic;
			gpgpu_config_reg_rw_out     : out std_logic;
			gpgpu_config_reg_adr_out    : out std_logic_vector(31 downto 0);
			gpgpu_config_reg_rd_data_in : in  std_logic_vector(31 downto 0);
			shmem_addr_out              : out std_logic_vector(SHMEM_ADDR_SIZE - 1 downto 0);
			shmem_wr_en_out             : out std_logic;
			shmem_wr_data_out           : out std_logic_vector(7 downto 0);
			gprs_base_addr_out          : out gprs_addr_array;
			gprs_reg_num_out            : out gprs_reg_array;
			gprs_lane_id_out            : out warp_lane_id_array;
			gprs_wr_en_out              : out wr_en_array;
			gprs_wr_data_out            : out vector_register;
			warps_per_block_out         : out std_logic_vector(5 downto 0);
			smp_configuration_en        : out std_logic;
			warp_generator_en           : out std_logic;
			smp_done                    : out std_logic
		);
	end component;

-------------------------------------------
-------------------------------------------
-------------------------------------------
-------------------------------------------
------------------------------------------- warp unit post syn
-------------------------------------------
		
	component warp_unit				
		generic(										--			
		SHMEM_ADDR_SIZE : integer := 14				--
		);												--
		port( -- MODIFIED GIANLUCA ROASCIO
			clk_in                   : in  std_logic;
			host_reset               : in  std_logic;
			warp_scheduler_reset     : in  std_logic;
			warp_generator_en        : in  std_logic;
			pipeline_write_done      : in  std_logic;
			pipeline_stall_in        : in  std_logic;
			--threads_per_block_in     : in  std_logic_vector(11 downto 0);
			num_blocks_in            : in  std_logic_vector(3 downto 0);
			warps_per_block_in       : in  std_logic_vector(5 downto 0);
			shared_mem_base_addr_in  : in  std_logic_vector(31 downto 0);
			shared_mem_size_in       : in  std_logic_vector(31 downto 0);
			gprs_size_in             : in  std_logic_vector(8 downto 0);
			--block_x_in               : in  std_logic_vector(15 downto 0);
			--block_y_in               : in  std_logic_vector(15 downto 0);
			--block_z_in               : in  std_logic_vector(15 downto 0);
			--grid_x_in                : in  std_logic_vector(15 downto 0);
			--grid_y_in                : in  std_logic_vector(15 downto 0);
			--block_idx_in             : in  std_logic_vector(15 downto 0);
			warp_id_in               : in  std_logic_vector(4 downto 0);
			warp_lane_id_in          : in  std_logic_vector(1 downto 0);
			cta_id_in                : in  std_logic_vector(3 downto 0);
			initial_mask_in          : in  std_logic_vector(31 downto 0);
			current_mask_in          : in  std_logic_vector(31 downto 0);
			shmem_base_addr_in       : in  std_logic_vector(SHMEM_ADDR_SIZE - 1 downto 0);
			gprs_base_addr_in        : in  std_logic_vector(8 downto 0);
			next_pc_in               : in  std_logic_vector(31 downto 0);
			warp_state_in            : in  warp_state_type;			--- changed for the purpose of sym warp        std_logic_vector(1 downto 0)  
			program_cntr_out         : out std_logic_vector(31 downto 0);
			warp_id_out              : out std_logic_vector(4 downto 0);
			warp_lane_id_out         : out std_logic_vector(1 downto 0);
			cta_id_out               : out std_logic_vector(3 downto 0);
			initial_mask_out         : out std_logic_vector(31 downto 0);
			current_mask_out         : out std_logic_vector(31 downto 0);
			shmem_base_addr_out      : out std_logic_vector(SHMEM_ADDR_SIZE - 1 downto 0);
			gprs_size_out            : out std_logic_vector(8 downto 0);
			gprs_base_addr_out       : out std_logic_vector(8 downto 0);
			num_warps_out            : out std_logic_vector(4 downto 0);
			warp_generator_done      : out std_logic;
			pipeline_stall_out       : out std_logic;
			warp_scheduler_done      : out std_logic;
			pipeline_warpunit_done   : out std_logic;
			fetch_en                 : out std_logic
		);
	end component;
	
	

-----------------------------------------
-----------------------------------------
-----------------------------------------
-----------------------------------------
----------------------------------------- mask for the warp unit
-----------------------------------------
	-- component warp_unit_rtl				
		-- generic(
			-- SHMEM_ADDR_SIZE : integer := 14
		-- );
		-- port(
			-- clk_in                   : in  std_logic;
			-- host_reset               : in  std_logic;
			-- warp_scheduler_reset     : in  std_logic;
			-- warp_generator_en        : in  std_logic;
			-- pipeline_write_done      : in  std_logic;
			-- pipeline_stall_in        : in  std_logic;
			-- threads_per_block_in     : in  std_logic_vector(11 downto 0);
			-- num_blocks_in            : in  std_logic_vector(3 downto 0);
			-- warps_per_block_in       : in  std_logic_vector(5 downto 0);
			-- shared_mem_base_addr_in  : in  std_logic_vector(31 downto 0);
			-- shared_mem_size_in       : in  std_logic_vector(31 downto 0);
			-- gprs_size_in             : in  std_logic_vector(8 downto 0);
			-- block_x_in               : in  std_logic_vector(15 downto 0);
			-- block_y_in               : in  std_logic_vector(15 downto 0);
			-- block_z_in               : in  std_logic_vector(15 downto 0);
			-- grid_x_in                : in  std_logic_vector(15 downto 0);
			-- grid_y_in                : in  std_logic_vector(15 downto 0);
			-- block_idx_in             : in  std_logic_vector(15 downto 0);
			-- warp_id_in               : in  std_logic_vector(4 downto 0);
			-- warp_lane_id_in          : in  std_logic_vector(1 downto 0);
			-- cta_id_in                : in  std_logic_vector(3 downto 0);
			-- initial_mask_in          : in  std_logic_vector(31 downto 0);
			-- current_mask_in          : in  std_logic_vector(31 downto 0);
			-- shmem_base_addr_in       : in  std_logic_vector(SHMEM_ADDR_SIZE - 1 downto 0);
			-- gprs_base_addr_in        : in  std_logic_vector(8 downto 0);
			-- next_pc_in               : in  std_logic_vector(31 downto 0);
			-- warp_state_in            : in  warp_state_type;
			-- program_cntr_out         : out std_logic_vector(31 downto 0);
			-- warp_id_out              : out std_logic_vector(4 downto 0);
			-- warp_lane_id_out         : out std_logic_vector(1 downto 0);
			-- cta_id_out               : out std_logic_vector(3 downto 0);
			-- initial_mask_out         : out std_logic_vector(31 downto 0);
			-- current_mask_out         : out std_logic_vector(31 downto 0);
			-- shmem_base_addr_out      : out std_logic_vector(SHMEM_ADDR_SIZE - 1 downto 0);
			-- gprs_size_out            : out std_logic_vector(8 downto 0);
			-- gprs_base_addr_out       : out std_logic_vector(8 downto 0);
			-- num_warps_out            : out std_logic_vector(4 downto 0);
			-- warp_generator_done      : out std_logic;
			-- pipeline_stall_out       : out std_logic;
			-- warp_scheduler_done      : out std_logic;
			-- pipeline_warpunit_done   : out std_logic;
			-- fetch_en                 : out std_logic
		-- );
	-- end component;
-----------------------------------------
-----------------------------------------
-----------------------------------------
-----------------------------------------
-----------------------------------------
-----------------------------------------
-----------------------------------------
	
	
	component pipeline_fetch
		generic(
			MEM_ADDR_SIZE   : integer := 32;
			SHMEM_ADDR_SIZE : integer := 14
		);
		port(
			reset               : in  std_logic;
			clk_in              : in  std_logic;
			fetch_en            : in  std_logic;
			pass_en             : in  std_logic;
			pipeline_stall_in   : in  std_logic;
			program_cntr_in     : in  std_logic_vector(31 downto 0);
			warp_id_in          : in  std_logic_vector(4 downto 0);
			warp_lane_id_in     : in  std_logic_vector(1 downto 0);
			cta_id_in           : in  std_logic_vector(3 downto 0);
			initial_mask_in     : in  std_logic_vector(31 downto 0);
			current_mask_in     : in  std_logic_vector(31 downto 0);
			shmem_base_addr_in  : in  std_logic_vector(SHMEM_ADDR_SIZE - 1 downto 0);
			gprs_size_in        : in  std_logic_vector(8 downto 0);
			gprs_base_addr_in   : in  std_logic_vector(8 downto 0);
			--mem_wr_data_a_out   : out std_logic_vector(7 downto 0);
			--mem_addr_a_out      : out std_logic_vector(MEM_ADDR_SIZE - 1 downto 0);
			mem_addr_out        : out std_logic_vector(MEM_ADDR_SIZE - 1 downto 0);
			--mem_wr_en_a_out     : out std_logic;
			--mem_rd_data_a_in    : in  std_logic_vector(SYSMEM_DATA_SIZE-1 downto 0);
			mem_rd_data_in      : in  std_logic_vector(SYSMEM_DATA_SIZE-1 downto 0);
			--mem_wr_data_b_out   : out std_logic_vector(7 downto 0);
			--mem_addr_b_out      : out std_logic_vector(MEM_ADDR_SIZE - 1 downto 0);
			--mem_wr_en_b_out     : out std_logic;
			--mem_rd_data_b_in    : in  std_logic_vector(7 downto 0);
			program_cntr_out    : out std_logic_vector(31 downto 0);
			warp_id_out         : out std_logic_vector(4 downto 0);
			warp_lane_id_out    : out std_logic_vector(1 downto 0);
			cta_id_out          : out std_logic_vector(3 downto 0);
			initial_mask_out    : out std_logic_vector(31 downto 0);
			current_mask_out    : out std_logic_vector(31 downto 0);
			shmem_base_addr_out : out std_logic_vector(SHMEM_ADDR_SIZE - 1 downto 0);
			gprs_size_out       : out std_logic_vector(8 downto 0);
			gprs_base_addr_out  : out std_logic_vector(8 downto 0);
			next_pc_out         : out std_logic_vector(31 downto 0);
			instruction_out     : out std_logic_vector(63 downto 0);
			pipeline_stall_out  : out std_logic;
			pipeline_fetch_done : out std_logic
		);
	end component;

	component pipeline_decode
		generic(
			SHMEM_ADDR_SIZE : integer := 14
		);
		port(
			reset                 : in  std_logic;
			clk_in                : in  std_logic;
			pipeline_stall_in     : in  std_logic; -- from next stage
			pipeline_fetch_done   : in  std_logic; -- from prev stage
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
	end component;

	component pipeline_read
		generic(
			SHMEM_ADDR_SIZE : integer := 32;
			CMEM_ADDR_SIZE  : integer := 32;
			GMEM_ADDR_SIZE  : integer := 32
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
			-- share memory
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
	end component;

	component read_source_ops
		generic(
			SRC_NUM : integer range 1 to 3 := 1
		);
		port(
			reset                        : in  std_logic;
			clk_in                       : in  std_logic;
			en                           : in  std_logic;
			instr_opcode_in              : in  instr_opcode_type;
			alu_opcode_in                : in  alu_opcode_type;
			instr_marker_in              : in  instr_marker_type;
			addr_in                      : in  std_logic_vector(31 downto 0);
			mask_in                      : in  std_logic_vector(CORES - 1 downto 0);
			addr_reg_in                  : in  std_logic_vector(2 downto 0);
			addr_imm_in                  : in  std_logic;
			pred_reg_in                  : in  std_logic_vector(1 downto 0);
			mov_size_in                  : in  std_logic_vector(2 downto 0);
			sm_type_in                   : in  std_logic_vector(1 downto 0);
			mem_type_in                  : in  std_logic_vector(2 downto 0);
			imm_hi_in                    : in  std_logic_vector(25 downto 0);
			src_mem_type_in              : in  mem_type;
			src_data_type_in             : in  data_type;
			src_mem_opcode_in            : in  mem_opcode_type;
			dest_mem_type_in             : in  mem_type;
			gprs_req_out                 : out std_logic;
			gprs_ack_out                 : out std_logic;
			gprs_grant_in                : in  std_logic;
			addr_regs_req_out            : out std_logic;
			addr_regs_ack_out            : out std_logic;
			addr_regs_grant_in           : in  std_logic;
			pred_regs_req_out            : out std_logic;
			pred_regs_ack_out            : out std_logic;
			pred_regs_grant_in           : in  std_logic;
			shmem_req_out                : out std_logic;
			shmem_ack_out                : out std_logic;
			shmem_grant_in               : in  std_logic;
			cmem_req_out                 : out std_logic;
			cmem_ack_out                 : out std_logic;
			cmem_grant_in                : in  std_logic;
			gmem_req_out                 : out std_logic;
			gmem_ack_out                 : out std_logic;
			gmem_grant_in                : in  std_logic;
			effaddr_gprs_req_out         : out std_logic;
			effaddr_gprs_ack_out         : out std_logic;
			effaddr_gprs_grant_in        : in  std_logic;
			effaddr_addr_regs_req_out    : out std_logic;
			effaddr_addr_regs_ack_out    : out std_logic;
			effaddr_addr_regs_grant_in   : in  std_logic;
			gprs_en_out                  : out std_logic;
			gprs_reg_num_out             : out std_logic_vector(8 downto 0);
			--gprs_rd_wr_en_out              : out std_logic;
			--gprs_wr_data_out               : out vector_word_register_array;
			gprs_data_type_out           : out data_type;
			gprs_mask_out                : out std_logic_vector(CORES - 1 downto 0);
			gprs_rd_data_in              : in  vector_word_register_array;
			gprs_rdy_in                  : in  std_logic;
			addr_regs_en_out             : out std_logic;
			addr_regs_reg_num_out        : out std_logic_vector(1 downto 0);
			--addr_regs_rd_wr_en_out         : out std_logic;
			--addr_regs_wr_data_out          : out vector_register;
			addr_regs_rd_data_in         : in  vector_register;
			addr_regs_rdy_in             : in  std_logic;
			pred_regs_en_out             : out std_logic;
			pred_regs_reg_num_out        : out std_logic_vector(1 downto 0);
			--pred_regs_rd_wr_en_out         : out std_logic;
			--pred_regs_wr_data_out          : out vector_flag_register;
			pred_regs_rd_data_in         : in  vector_flag_register;
			pred_regs_rdy_in             : in  std_logic;
			shmem_en_out                 : out std_logic;
			shmem_addr_out               : out std_logic_vector(31 downto 0);
			shmem_rd_wr_type_out         : out mem_opcode_type;
			shmem_sm_type_out            : out sm_type;
			shmem_mask_out               : out std_logic_vector(CORES - 1 downto 0);
			shmem_rd_data_in             : in  vector_word_register_array;
			shmem_rdy_in                 : in  std_logic;
			cmem_en_out                  : out std_logic;
			cmem_addr_out                : out std_logic_vector(31 downto 0);
			cmem_rd_wr_type_out          : out mem_opcode_type;
			cmem_sm_type_out             : out sm_type;
			cmem_mask_out                : out std_logic_vector(CORES - 1 downto 0);
			cmem_rd_data_in              : in  vector_word_register_array;
			cmem_rdy_in                  : in  std_logic;
			gmem_en_out                  : out std_logic;
			gmem_addr_out                : out std_logic_vector(31 downto 0);
			gmem_rd_wr_type_out          : out mem_opcode_type;
			gmem_data_type_out           : out data_type;
			gmem_mask_out                : out std_logic_vector(CORES - 1 downto 0);
			gmem_rd_data_in              : in  vector_word_register_array;
			gmem_rdy_in                  : in  std_logic;
			effaddr_gprs_en_out          : out std_logic;
			effaddr_gprs_reg_num_out     : out std_logic_vector(8 downto 0);
			effaddr_gprs_data_type_out   : out data_type;
			--effaddr_gprs_mask_out          : out std_logic_vector(CORES - 1 downto 0);
			--effaddr_gprs_rd_wr_en_out      : out std_logic;
			effaddr_gprs_rd_data_in      : in  vector_word_register_array;
			effaddr_gprs_rdy_in          : in  std_logic;
			effaddr_addr_regs_en_out     : out std_logic;
			effaddr_addr_regs_reg_out    : out std_logic_vector(1 downto 0);
			--effaddr_addr_regs_mask_out     : out std_logic_vector(CORES - 1 downto 0);
			--effaddr_addr_regs_rd_wr_en_out : out std_logic;
			effaddr_addr_regs_rd_data_in : in  vector_register;
			effaddr_addr_regs_rdy_in     : in  std_logic;
			data_out                     : out vector_word_register_array;
			rdy_out                      : out std_logic
		);
	end component;

	component arbiter
		generic(
			CNT : integer := 7
		);
		port(
			clk   : in  std_logic;
			rst   : in  std_logic;
			req   : in  std_logic_vector(CNT - 1 downto 0);
			ack   : in  std_logic;
			grant : out std_logic_vector(CNT - 1 downto 0)
		);
	end component;

	component constant_memory_controller
		generic(
			ADDRESS_SIZE     : integer   := 32;
			ARB_GPRS_EN      : std_logic := '0';
			ARB_ADDR_REGS_EN : std_logic := '0'
		);
		port(
			reset                : in  std_logic;
			clk_in               : in  std_logic;
			en                   : in  std_logic;
			addr_in              : in  vector_register;
			mask_in              : in  std_logic_vector(CORES - 1 downto 0);
			rd_wr_type_in        : in  mem_opcode_type;
			sm_type_in           : in  sm_type;
			addr_lo_in           : in  std_logic_vector(1 downto 0);
			addr_hi_in           : in  std_logic;
			addr_imm_in          : in  std_logic;
			gprs_req_out         : out std_logic;
			gprs_ack_out         : out std_logic;
			gprs_grant_in        : in  std_logic;
			gprs_en_out          : out std_logic;
			gprs_reg_num_out     : out std_logic_vector(8 downto 0);
			gprs_data_type_out   : out data_type;
			gprs_rd_data_in      : in  vector_word_register_array;
			gprs_rdy_in          : in  std_logic;
			addr_regs_req_out    : out std_logic;
			addr_regs_ack_out    : out std_logic;
			addr_regs_grant_in   : in  std_logic;
			addr_regs_en_out     : out std_logic;
			addr_regs_reg_out    : out std_logic_vector(1 downto 0);
			addr_regs_rd_data_in : in  vector_register;
			addr_regs_rdy_in     : in  std_logic;
			cmem_addr_out        : out std_logic_vector(ADDRESS_SIZE - 1 downto 0);
			cmem_wr_en_out       : out std_logic;
			cmem_wr_data_out     : out std_logic_vector(7 downto 0);
			cmem_rd_data_in      : in  std_logic_vector(7 downto 0);
			data_out             : out vector_word_register_array;
			rdy_out              : out std_logic
		);
	end component;

	component predicate_lut
		port(
			clk_in            : in  std_logic;
			host_reset        : in  std_logic;
			pred_reg_lut_addr : in  std_logic_vector(4 downto 0);
			pred_reg_lut_bit  : in  std_logic_vector(3 downto 0);
			pred_reg_lut_data : out std_logic
		);
	end component;
	component pipeline_execute
		generic(
			SHMEM_ADDR_SIZE : integer := 14
		);
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
			f64_in                   : in  std_logic; -- not used
			saturate_in              : in  std_logic;
			abs_saturate_in          : in  std_logic_vector(1 downto 0);
			cvt_round_in             : in  std_logic_vector(1 downto 0); -- not used
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
	end component;

	component pipeline_write
		generic(
			SHMEM_ADDR_SIZE : integer := 32;
			GMEM_ADDR_SIZE  : integer := 32
		);
		port(
			reset                      : in  std_logic;
			clk_in                     : in  std_logic;
			pipeline_execute_done      : in  std_logic;
			pipeline_stall_in          : in  std_logic;
			warp_id_in                 : in  std_logic_vector(4 downto 0);
			warp_lane_id_in            : in  std_logic_vector(1 downto 0);
			cta_id_in                  : in  std_logic_vector(3 downto 0);
			initial_mask_in            : in  std_logic_vector(31 downto 0);
			current_mask_in            : in  std_logic_vector(31 downto 0);
			shmem_base_addr_in         : in  std_logic_vector(SHMEM_ADDR_SIZE - 1 downto 0);
			gprs_base_addr_in          : in  std_logic_vector(8 downto 0);
			next_pc_in                 : in  std_logic_vector(31 downto 0);
			warp_state_in              : in  warp_state_type;
			instr_opcode_in            : in  instr_opcode_type;
			temp_vector_register_in    : in  temp_vector_register;
			dest_in                    : in  std_logic_vector(31 downto 0);
			instruction_mask_in        : in  std_logic_vector(31 downto 0);
			instruction_flags_in       : in  vector_flag_register;
			dest_data_type_in          : in  data_type;
			dest_mem_type_in           : in  mem_type;
			dest_mem_opcode_in         : in  mem_opcode_type;
			addr_hi_in                 : in  std_logic;
			addr_lo_in                 : in  std_logic_vector(1 downto 0);
			addr_imm_in                : in  std_logic;
			addr_inc_in                : in  std_logic;
			mov_size_in                : in  std_logic_vector(2 downto 0);
			write_pred_in              : in  std_logic;
			set_pred_in                : in  std_logic;
			set_pred_reg_in            : in  std_logic_vector(1 downto 0);
			sm_type_in                 : in  std_logic_vector(1 downto 0);
			gprs_base_addr_out         : out gprs_addr_array;
			gprs_reg_num_out           : out gprs_reg_array;
			gprs_lane_id_out           : out warp_lane_id_array;
			gprs_wr_en_out             : out wr_en_array;
			gprs_wr_data_out           : out vector_register;
			gprs_rd_data_in            : in  vector_register;
			pred_regs_warp_id_out      : out warp_id_array;
			pred_regs_warp_lane_id_out : out warp_lane_id_array;
			pred_regs_reg_num_out      : out reg_num_array;
			pred_regs_wr_en_out        : out wr_en_array;
			pred_regs_wr_data_out      : out vector_flag_register;
			pred_regs_rd_data_in       : in  vector_flag_register;
			addr_regs_warp_id_out      : out warp_id_array;
			addr_regs_warp_lane_id_out : out warp_lane_id_array;
			addr_regs_reg_num_out      : out reg_num_array;
			addr_regs_wr_en_out        : out wr_en_array;
			addr_regs_wr_data_out      : out vector_register;
			addr_regs_rd_data_in       : in  vector_register;
			shmem_addr_out             : out std_logic_vector(SHMEM_ADDR_SIZE - 1 downto 0);
			shmem_wr_en_out            : out std_logic;
			shmem_wr_data_out          : out std_logic_vector(7 downto 0);
			shmem_rd_data_in           : in  std_logic_vector(7 downto 0);
			gmem_addr_out              : out std_logic_vector(GMEM_ADDR_SIZE - 1 downto 0);
			gmem_wr_en_out             : out std_logic;
			gmem_wr_data_out           : out std_logic_vector(7 downto 0);
			gmem_rd_data_in            : in  std_logic_vector(7 downto 0);
			warp_id_out                : out std_logic_vector(4 downto 0);
			warp_lane_id_out           : out std_logic_vector(1 downto 0);
			cta_id_out                 : out std_logic_vector(3 downto 0);
			initial_mask_out           : out std_logic_vector(31 downto 0);
			current_mask_out           : out std_logic_vector(31 downto 0);
			shmem_base_addr_out        : out std_logic_vector(SHMEM_ADDR_SIZE - 1 downto 0);
			gprs_addr_out              : out std_logic_vector(8 downto 0);
			next_pc_out                : out std_logic_vector(31 downto 0);
			warp_state_out             : out warp_state_type;
			pipeline_stall_out         : out std_logic;
			pipeline_write_done        : out std_logic
		);
	end component;

	component stack
		generic(
			STACK_DEPTH : integer := 256;
			DATA_WIDTH  : integer := 64
		);
		port(
			clk_in      : in  std_logic; --Clock for the stack.
			reset       : in  std_logic;
			stack_en    : in  std_logic; --Enable the stack. Otherwise neither push nor pop will happen.
			data_in     : in  std_logic_vector(DATA_WIDTH - 1 downto 0); --Data to be pushed to stack
			data_out    : out std_logic_vector(DATA_WIDTH - 1 downto 0); --Data popped from the stack.
			push_en     : in  std_logic; --active low for POP and active high for PUSH.
			stack_full  : out std_logic; --Goes high when the stack is full.
			stack_empty : out std_logic --Goes high when the stack is empty.
		);
	end component;

	component effective_address
		generic(
			ARB_GPRS_EN      : std_logic := '0';
			ARB_ADDR_REGS_EN : std_logic := '0'
		);
		port(
			reset                : in  std_logic;
			clk_in               : in  std_logic;
			en                   : in  std_logic;
			reg_in               : in  std_logic_vector(31 downto 0);
			addr_reg_in          : in  std_logic_vector(2 downto 0);
			addr_imm_in          : in  std_logic;
			shift_in             : in  std_logic_vector(4 downto 0);
			gprs_req_out         : out std_logic;
			gprs_ack_out         : out std_logic;
			gprs_grant_in        : in  std_logic;
			gprs_en_out          : out std_logic;
			gprs_reg_num_out     : out std_logic_vector(8 downto 0);
			gprs_data_type_out   : out data_type;
			--gprs_mask_out          : out std_logic_vector(CORES - 1 downto 0); -- (others => '1')
			--gprs_rd_wr_en_out      : out std_logic;								-- '0'
			gprs_rd_data_in      : in  vector_word_register_array;
			gprs_rdy_in          : in  std_logic;
			addr_regs_req_out    : out std_logic;
			addr_regs_ack_out    : out std_logic;
			addr_regs_grant_in   : in  std_logic;
			addr_regs_en_out     : out std_logic;
			addr_regs_reg_out    : out std_logic_vector(1 downto 0);
			--addr_regs_mask_out     : out std_logic_vector(CORES - 1 downto 0);  -- (others => '1')
			--addr_regs_rd_wr_en_out : out std_logic;								-- '0'
			addr_regs_rd_data_in : in  vector_register;
			addr_regs_rdy_in     : in  std_logic;
			addr_out             : out vector_register;
			rdy_out              : out std_logic
		);
	end component;

	component calculate_address
		port(
			address_in   : in  std_logic_vector(31 downto 0);
			data_type_in : in  std_logic_vector(3 downto 0);
			address_out  : out std_logic_vector(31 downto 0)
		);
	end component;

	component vector_register_file
		generic(NCORES : integer := 8);
		port(
			base_addr_a    : in  std_logic_vector(8 downto 0);
			base_addr_b    : in  std_logic_vector(8 downto 0);
			clk          : in  std_logic;
			din_a          : in  std_logic_vector(31 downto 0);
			din_b          : in  std_logic_vector(31 downto 0);
			reg_num_a      : in  std_logic_vector(8 downto 0);
			reg_num_b      : in  std_logic_vector(8 downto 0);
			warp_lane_id_a : in  std_logic_vector(1 downto 0);
			warp_lane_id_b : in  std_logic_vector(1 downto 0);
			we_a           : in  std_logic;
			we_b           : in  std_logic;
			dout_a         : out std_logic_vector(31 downto 0);
			dout_b         : out std_logic_vector(31 downto 0)
		);
	end component;

	component predicate_register_file
		generic(NCORES : integer := 8);
		port(
			clk          : in  std_logic;
			warp_id_a      : in  std_logic_vector(4 downto 0);
			warp_lane_id_a : in  std_logic_vector(1 downto 0);
			reg_addr_a     : in  std_logic_vector(1 downto 0);
			wr_en_a        : in  std_logic;
			din_a          : in  std_logic_vector(3 downto 0);
			dout_a         : out std_logic_vector(3 downto 0);
			warp_id_b      : in  std_logic_vector(4 downto 0);
			warp_lane_id_b : in  std_logic_vector(1 downto 0);
			reg_addr_b     : in  std_logic_vector(1 downto 0);
			wr_en_b        : in  std_logic;
			din_b          : in  std_logic_vector(3 downto 0);
			dout_b         : out std_logic_vector(3 downto 0)
		);
	end component;

	component address_register_file
		generic(NCORES : integer := 8);
		port(
			clk          : in  std_logic;
			warp_id_a      : in  std_logic_vector(4 downto 0);
			warp_lane_id_a : in  std_logic_vector(1 downto 0);
			reg_addr_a     : in  std_logic_vector(1 downto 0);
			wr_en_a        : in  std_logic;
			din_a          : in  std_logic_vector(31 downto 0);
			dout_a         : out std_logic_vector(31 downto 0);
			warp_id_b      : in  std_logic_vector(4 downto 0);
			warp_lane_id_b : in  std_logic_vector(1 downto 0);
			reg_addr_b     : in  std_logic_vector(1 downto 0);
			wr_en_b        : in  std_logic;
			din_b          : in  std_logic_vector(31 downto 0);
			dout_b         : out std_logic_vector(31 downto 0)
		);
	end component;

	component branch_exec_unit
		port(
			clk_in                  : in  std_logic;
			host_reset              : in  std_logic;
			branch_exec_en          : in  std_logic;
			flow_opcode_in          : in  flow_opcode_type;
			warp_id_in              : in  std_logic_vector(4 downto 0);
			warp_lane_id_in         : in  std_logic_vector(1 downto 0);
			initial_mask_in         : in  std_logic_vector(31 downto 0);
			current_mask_in         : in  std_logic_vector(31 downto 0);
			instr_mask_in           : in  std_logic_vector(31 downto 0);
			next_pc_in              : in  std_logic_vector(31 downto 0);
			target_address_in       : in  std_logic_vector(18 downto 0);
			warp_div_req_out        : out std_logic;
			warp_div_ack_out        : out std_logic;
			warp_div_grant_in       : in  std_logic;
			warp_div_stack_en_out   : out warp_div_std_logic_array;
			warp_div_wr_data_out    : out warp_div_data_array;
			warp_div_rd_data_in     : in  warp_div_data_array;
			warp_div_push_en_out    : out warp_div_std_logic_array;
			warp_div_stack_full_in  : in  warp_div_std_logic_array;
			warp_div_stack_empty_in : in  warp_div_std_logic_array;
			initial_mask_out        : out std_logic_vector(31 downto 0);
			current_mask_out        : out std_logic_vector(31 downto 0);
			instr_mask_out          : out std_logic_vector(31 downto 0);
			next_pc_out             : out std_logic_vector(31 downto 0);
			warp_state_out          : out warp_state_type;
			branch_exec_done        : out std_logic
		);
	end component;

	component scalar_processor
		port(
			alu_opcode_in   : in  alu_opcode_type;
			instr_subop_in  : in  std_logic_vector(2 downto 0);
			instr_marker_in	: in  instr_marker_type; -- ADDED GIANLUCA ROASCIO
			src1_in         : in  std_logic_vector(31 downto 0);
			src2_in         : in  std_logic_vector(31 downto 0);
			src3_in         : in  std_logic_vector(31 downto 0);
			src1_neg_in     : in  std_logic; -- NOT USED
			src2_neg_in     : in  std_logic; -- NOT USED
			src3_neg_in     : in  std_logic;
			carry_in        : in  std_logic;
			saturate_in     : in  std_logic;
			w32_in          : in  std_logic;
			is_signed_in    : in  std_logic;
			abs_saturate_in : in  std_logic_vector(1 downto 0);
			cvt_neg_in      : in  std_logic;
			cvt_type_in     : in  std_logic_vector(2 downto 0);
			set_cond_in     : in  std_logic_vector(2 downto 0);
			carry_out       : out std_logic;
			overflow_out    : out std_logic;
			sign_out        : out std_logic;
			zero_out        : out std_logic;
			result_out      : out std_logic_vector(31 downto 0)
		);
	end component;

	component warp_configuration is
		port(
			clk_in            : in  std_logic;
			host_reset        : in  std_logic;
			reg_num_warps_in  : in  std_logic_vector(4 downto 0);
			reg_num_warps_ld  : in  std_logic;
			reg_num_warps_out : out std_logic_vector(4 downto 0)
		);
	end component;

	component warp_generator
		generic(
			SHMEM_ADDR_SIZE : integer := 14
		);
		port(
			clk_in                  : in  std_logic;
			host_reset              : in  std_logic;
			en                      : in  std_logic;
			num_blocks_in           : in  std_logic_vector(3 downto 0);
			warps_per_block_in      : in  std_logic_vector(5 downto 0);
			shmem_base_addr_in      : in  std_logic_vector(31 downto 0);
			shmem_size_in           : in  std_logic_vector(31 downto 0);
			gprs_size_in            : in  std_logic_vector(8 downto 0);
			warp_pool_addr_out      : out std_logic_vector(4 downto 0);
			warp_pool_wr_en_out     : out std_logic;
			warp_pool_wr_data_out   : out std_logic_vector(127 downto 0);
			warp_state_addr_out     : out std_logic_vector(4 downto 0);
			warp_state_wr_en_out    : out std_logic;
			warp_state_wr_data_out  : out std_logic_vector(1 downto 0);
			fence_regs_cta_id_out   : out fence_regs_vector_array;
			fence_regs_cta_id_ld    : out fence_regs_std_array;
			fence_regs_fence_en_out : out fence_regs_std_array;
			fence_regs_fence_en_ld  : out fence_regs_std_array;
			num_warps_out           : out std_logic_vector(4 downto 0);
			warp_gen_done           : out std_logic
		);
	end component;

	component warp_scheduler
		generic(								-- erased for syn
			SHMEM_ADDR_SIZE : integer := 14
		);
		port( 
			clk_in                 : in  std_logic;
			host_reset             : in  std_logic;
			reset                  : in  std_logic;
			pipeline_stall_in      : in  std_logic;
			--num_blocks_in          : in  std_logic_vector(3 downto 0); -- REMOVED GIANLUCA ROASCIO
			num_warps_in           : in  std_logic_vector(4 downto 0);
			gprs_size_in           : in  std_logic_vector(8 downto 0);
			warps_done_mask_in     : in  std_logic_vector(MAX_WARPS - 1 downto 0);
			warp_pool_addr_out     : out std_logic_vector(4 downto 0);
			warp_pool_wr_en_out    : out std_logic;
			warp_pool_wr_data_out  : out std_logic_vector(127 downto 0);
			warp_pool_rd_data_in   : in  std_logic_vector(127 downto 0);
			warp_state_addr_out    : out std_logic_vector(4 downto 0);
			warp_state_wr_en_out   : out std_logic;
			warp_state_wr_data_out : out std_logic_vector(1 downto 0);
			warp_state_rd_data_in  : in  std_logic_vector(1 downto 0);
			program_cntr_out       : out std_logic_vector(31 downto 0);
			warp_id_out            : out std_logic_vector(4 downto 0);
			warp_lane_id_out       : out std_logic_vector(1 downto 0);
			cta_id_out             : out std_logic_vector(3 downto 0);
			initial_mask_out       : out std_logic_vector(31 downto 0);
			current_mask_out       : out std_logic_vector(31 downto 0);
			shmem_base_addr_out    : out std_logic_vector(SHMEM_ADDR_SIZE - 1 downto 0);
			gprs_size_out          : out std_logic_vector(8 downto 0);
			gprs_base_addr_out     : out std_logic_vector(8 downto 0);
			done                   : out std_logic;
			pipeline_warpunit_done : out std_logic;
			fetch_en               : out std_logic
		);
	end component;

	component warp_checker
		generic(
			SHMEM_ADDR_SIZE : integer := 14
		);
		port(
			clk_in                  : in  std_logic;
			host_reset              : in  std_logic;
			reset                   : in  std_logic;
			en                      : in  std_logic;
			warp_id_in              : in  std_logic_vector(4 downto 0);
			warp_lane_id_in         : in  std_logic_vector(1 downto 0);
			cta_id_in               : in  std_logic_vector(3 downto 0);
			initial_mask_in         : in  std_logic_vector(31 downto 0);
			current_mask_in         : in  std_logic_vector(31 downto 0);
			shmem_base_addr_in      : in  std_logic_vector(SHMEM_ADDR_SIZE - 1 downto 0);
			gprs_base_addr_in       : in  std_logic_vector(8 downto 0);
			next_pc_in              : in  std_logic_vector(31 downto 0);
			warp_state_in           : in  warp_state_type;
			warps_per_block_in      : in  std_logic_vector(5 downto 0);
			warp_pool_addr_out      : out std_logic_vector(4 downto 0);
			warp_pool_wr_en_out     : out std_logic;
			warp_pool_wr_data_out   : out std_logic_vector(127 downto 0);
			warp_state_addr_out     : out std_logic_vector(4 downto 0);
			warp_state_wr_en_out    : out std_logic;
			warp_state_wr_data_out  : out std_logic_vector(1 downto 0);
			fence_regs_fence_en_out : out fence_regs_std_array;
			fence_regs_fence_en_ld  : out fence_regs_std_array;
			fence_regs_cta_id_in    : in  fence_regs_vector_array;
			fence_regs_fence_en_in  : in  fence_regs_std_array;
			warps_done_mask_out     : out std_logic_vector(MAX_WARPS - 1 downto 0);
			pipeline_stall_out      : out std_logic
		);
	end component;

	component warp_id_calc is						-- syn 
		port(
			clk                : in  std_logic; -- [FIXME] The following signals are not used
			reset              : in  std_logic; -- since we use only sim multi and div
			en                 : in  std_logic;
			block_num_in       : in  std_logic_vector(3 downto 0);
			gprs_size_in       : in  std_logic_vector(8 downto 0);
			warp_num_in        : in  std_logic_vector(4 downto 0);
			warps_per_block_in : in  std_logic_vector(5 downto 0);
			data_valid_out     : out std_logic;
			gprs_base_addr_out : out std_logic_vector(8 downto 0);
			warp_id_out        : out std_logic_vector(4 downto 0)
		);
	end component;
end gpgpu_package;

package body gpgpu_package is
	
	function log2(n : integer) return integer is
		variable i : integer := 0;
	begin
		while (2 ** i <= n) loop
			i := i + 1;
		end loop;
		return i - 1;
	end log2;

	function maximum(left, right : std_logic_vector) return std_logic_vector is
	begin                               -- function max
		if unsigned(LEFT) > unsigned(RIGHT) then
			return LEFT;
		else
			return RIGHT;
		end if;
	end function maximum;

	function minimum(left, right : std_logic_vector) return std_logic_vector is
	begin                               -- function minimum
		if unsigned(LEFT) < unsigned(RIGHT) then
			return LEFT;
		else
			return RIGHT;
		end if;
	end function minimum;

end gpgpu_package;
