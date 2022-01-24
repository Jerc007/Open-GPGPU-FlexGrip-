----------------------------------------------------------------------------
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
-- 1. Change synchronous reset to async ones in ALL components and sub-components
-- 2. Remove the low level register definition and instances
-- 3. Remove the bridge register among stages of the pipeline: ALL the stages
--    including the warp unit etc. should have registered output
--
--
-- [NOTE]
-- xxx_stall_in comes from next stage is used to indicate the current stage MUST NOT:
--  1. change outputs until the xxx_stall_in is '0' again
--  2. generate xxx_done pulse
-- xxx_stall_out goes to next stage has the same function as xxx_stall_in signal
-- 
----------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.gpgpu_package.all;

entity streaming_multiprocessor is
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
end streaming_multiprocessor;


architecture arch of streaming_multiprocessor is
	constant SHMEM_ADDR_SIZE : integer := 14;
	-- SMP Controller
	signal warps_per_block      : std_logic_vector(5 downto 0);
	signal smp_configuration_en : std_logic;

	-- Warp
	signal warp_generator_en      : std_logic;
	signal warp_generator_done    : std_logic;
	signal warp_scheduler_done    : std_logic;
	signal fetch_en               : std_logic;
	signal pipeline_warpunit_done : std_logic;

	-- Warp / Fetch Register
	signal program_cntr_wf     : std_logic_vector(31 downto 0);
	signal warp_id_wf          : std_logic_vector(4 downto 0);
	signal warp_lane_id_wf     : std_logic_vector(1 downto 0);
	signal cta_id_wf           : std_logic_vector(3 downto 0);
	signal initial_mask_wf     : std_logic_vector(31 downto 0);
	signal current_mask_wf     : std_logic_vector(31 downto 0);
	signal shmem_base_addr_wf  : std_logic_vector(SHMEM_ADDR_SIZE - 1 downto 0);
	signal gprs_size_wf        : std_logic_vector(8 downto 0);
	signal gprs_base_addr_wf   : std_logic_vector(8 downto 0);
	signal pipeline_warp_stall : std_logic;

	-- Fetch
	signal program_cntr_fd      : std_logic_vector(31 downto 0);
	signal warp_id_fd           : std_logic_vector(4 downto 0);
	signal warp_lane_id_fd      : std_logic_vector(1 downto 0);
	signal cta_id_fd            : std_logic_vector(3 downto 0);
	signal initial_mask_fd      : std_logic_vector(31 downto 0);
	signal current_mask_fd      : std_logic_vector(31 downto 0);
	signal shmem_base_addr_fd   : std_logic_vector(SHMEM_ADDR_SIZE - 1 downto 0);
	signal gprs_size_fd         : std_logic_vector(8 downto 0);
	signal gprs_base_addr_fd    : std_logic_vector(8 downto 0);
	signal next_pc_fd           : std_logic_vector(31 downto 0);
	signal instruction_fd       : std_logic_vector(63 downto 0);
	signal pipeline_fetch_stall : std_logic;
	signal pipeline_fd_done     : std_logic;

	-- Decode -> Read
	signal program_cntr_dr         : std_logic_vector(31 downto 0);
	signal warp_id_dr              : std_logic_vector(4 downto 0);
	signal warp_lane_id_dr         : std_logic_vector(1 downto 0);
	signal cta_id_dr               : std_logic_vector(3 downto 0);
	signal initial_mask_dr         : std_logic_vector(31 downto 0);
	signal current_mask_dr         : std_logic_vector(31 downto 0);
	signal shmem_base_addr_dr      : std_logic_vector(SHMEM_ADDR_SIZE - 1 downto 0);
	signal gprs_size_dr            : std_logic_vector(8 downto 0);
	signal gprs_base_addr_dr       : std_logic_vector(8 downto 0);
	signal next_pc_dr              : std_logic_vector(31 downto 0);
	signal instr_opcode_dr         : instr_opcode_type;
	signal instr_subop_dr          : std_logic_vector(2 downto 0);
	signal alu_opcode_dr           : alu_opcode_type;
	signal mov_opcode_dr           : mov_opcode_type;
	signal flow_opcode_dr          : flow_opcode_type;
	signal instr_marker_dr         : instr_marker_type;
	signal pred_reg_dr             : std_logic_vector(1 downto 0);
	signal pred_cond_dr            : std_logic_vector(4 downto 0);
	signal set_pred_dr             : std_logic;
	signal set_pred_reg_dr         : std_logic_vector(1 downto 0);
	signal write_pred_dr           : std_logic;
	signal is_signed_dr            : std_logic;
	signal w32_dr                  : std_logic;
	signal f64_dr                  : std_logic;
	signal saturate_dr             : std_logic;
	signal abs_saturate_dr         : std_logic_vector(1 downto 0);
	signal cvt_round_dr            : std_logic_vector(1 downto 0);
	signal cvt_type_dr             : std_logic_vector(2 downto 0);
	signal cvt_neg_dr              : std_logic;
	signal condition_dr            : std_logic_vector(2 downto 0);
	signal addr_hi_dr              : std_logic;
	signal addr_lo_dr              : std_logic_vector(1 downto 0);
	signal addr_incr_dr            : std_logic;
	signal mov_size_dr             : std_logic_vector(2 downto 0);
	signal mem_type_dr             : std_logic_vector(2 downto 0);
	signal sm_type_dr              : std_logic_vector(1 downto 0);
	signal imm_hi_dr               : std_logic_vector(25 downto 0);
	signal addr_imm_dr             : std_logic;
	signal src1_mem_type_dr        : mem_type;
	signal src2_mem_type_dr        : mem_type;
	signal src3_mem_type_dr        : mem_type;
	signal dest_mem_type_dr        : mem_type;
	signal src1_mem_opcode_type_dr : mem_opcode_type;
	signal src2_mem_opcode_type_dr : mem_opcode_type;
	signal src3_mem_opcode_type_dr : mem_opcode_type;
	signal dest_mem_opcode_type_dr : mem_opcode_type;
	signal src1_neg_dr             : std_logic;
	signal src2_neg_dr             : std_logic;
	signal src3_neg_dr             : std_logic;
	signal target_addr_dr          : std_logic_vector(18 downto 0);
	signal src1_data_type_dr       : data_type;
	signal src2_data_type_dr       : data_type;
	signal src3_data_type_dr       : data_type;
	signal dest_data_type_dr       : data_type;
	signal src1_dr                 : std_logic_vector(31 downto 0);
	signal src2_dr                 : std_logic_vector(31 downto 0);
	signal src3_dr                 : std_logic_vector(31 downto 0);
	signal dest_dr                 : std_logic_vector(31 downto 0);
	signal pipeline_decode_stall   : std_logic;
	signal pipeline_dec_done       : std_logic;

	-- Read
	signal warp_id_re              : std_logic_vector(4 downto 0);
	signal warp_lane_id_re         : std_logic_vector(1 downto 0);
	signal cta_id_re               : std_logic_vector(3 downto 0);
	signal initial_mask_re         : std_logic_vector(31 downto 0);
	signal current_mask_re         : std_logic_vector(31 downto 0);
	signal shmem_base_addr_re      : std_logic_vector(SHMEM_ADDR_SIZE - 1 downto 0);
	signal gprs_size_re            : std_logic_vector(8 downto 0);
	signal gprs_base_addr_re       : std_logic_vector(8 downto 0);
	signal instruction_mask_re     : std_logic_vector(31 downto 0);
	signal next_pc_re              : std_logic_vector(31 downto 0);
	signal instr_opcode_re         : instr_opcode_type;
	signal instr_subop_re          : std_logic_vector(2 downto 0);
	signal alu_opcode_re           : alu_opcode_type;
	signal flow_opcode_re          : flow_opcode_type;
	signal mov_opcode_re           : mov_opcode_type;
	signal instr_marker_re         : instr_marker_type;
	signal set_pred_re             : std_logic;
	signal set_pred_reg_re         : std_logic_vector(1 downto 0);
	signal write_pred_re           : std_logic;
	signal is_full_normal_re       : std_logic;
	signal is_signed_re            : std_logic;
	signal w32_re                  : std_logic;
	signal f64_re                  : std_logic;
	signal saturate_re             : std_logic;
	signal abs_saturate_re         : std_logic_vector(1 downto 0);
	signal cvt_round_re            : std_logic_vector(1 downto 0);
	signal cvt_type_re             : std_logic_vector(2 downto 0);
	signal cvt_neg_re              : std_logic;
	signal condition_re            : std_logic_vector(2 downto 0);
	signal addr_hi_re              : std_logic;
	signal addr_lo_re              : std_logic_vector(1 downto 0);
	signal addr_incr_re            : std_logic;
	signal mov_size_re             : std_logic_vector(2 downto 0);
	signal mem_type_re             : std_logic_vector(2 downto 0);
	signal sm_type_re              : std_logic_vector(1 downto 0);
	signal addr_imm_re             : std_logic;
	signal dest_mem_type_re        : mem_type;
	signal dest_mem_opcode_re      : mem_opcode_type;
	signal src1_neg_re             : std_logic;
	signal src2_neg_re             : std_logic;
	signal src3_neg_re             : std_logic;
	signal target_addr_re          : std_logic_vector(18 downto 0);
	signal dest_data_type_re       : data_type;
	signal src1_re                 : std_logic_vector(31 downto 0);
	signal dest_re                 : std_logic_vector(31 downto 0);
	signal pred_flags_re           : vector_flag_register;
	signal temp_vector_register_re : temp_vector_register;
	signal pipeline_read_stall     : std_logic;
	signal pipeline_read_done      : std_logic;

	-- Execute to Write
	signal warp_id_ew              : std_logic_vector(4 downto 0);
	signal warp_lane_id_ew         : std_logic_vector(1 downto 0);
	signal cta_id_ew               : std_logic_vector(3 downto 0);
	signal initial_mask_ew         : std_logic_vector(31 downto 0);
	signal current_mask_ew         : std_logic_vector(31 downto 0);
	signal shmem_base_addr_ew      : std_logic_vector(SHMEM_ADDR_SIZE - 1 downto 0);
	signal gprs_size_ew            : std_logic_vector(8 downto 0);
	signal gprs_base_addr_ew       : std_logic_vector(8 downto 0);
	signal instr_mask_ew           : std_logic_vector(31 downto 0);
	signal next_pc_ew              : std_logic_vector(31 downto 0);
	signal warp_state_ew           : warp_state_type;
	signal instr_opcode_type_ew    : instr_opcode_type;
	signal set_pred_ew             : std_logic;
	signal set_pred_reg_ew         : std_logic_vector(1 downto 0);
	signal write_pred_ew           : std_logic;
	signal addr_hi_ew              : std_logic;
	signal addr_lo_ew              : std_logic_vector(1 downto 0);
	signal addr_incr_ew            : std_logic;
	signal mov_size_ew             : std_logic_vector(2 downto 0);
	signal sm_type_ew              : std_logic_vector(1 downto 0);
	signal addr_imm_ew             : std_logic;
	signal src1_ew                 : std_logic_vector(31 downto 0);
	signal dest_mem_type_ew        : mem_type;
	signal dest_mem_opcode_ew      : mem_opcode_type;
	signal dest_data_type_ew       : data_type;
	signal dest_ew                 : std_logic_vector(31 downto 0);
	signal pred_flags_ew           : vector_flag_register;
	signal temp_vector_register_ew : temp_vector_register;
	signal pipeline_execute_done   : std_logic;
	signal pipeline_execute_stall  : std_logic;

	-- Write to Warp
	signal warp_id_ww           : std_logic_vector(4 downto 0);
	signal warp_lane_id_ww      : std_logic_vector(1 downto 0);
	signal cta_id_ww            : std_logic_vector(3 downto 0);
	signal initial_mask_ww      : std_logic_vector(31 downto 0);
	signal current_mask_ww      : std_logic_vector(31 downto 0);
	signal shmem_base_addr_ww   : std_logic_vector(SHMEM_ADDR_SIZE - 1 downto 0);
	signal gprs_base_addr_ww    : std_logic_vector(8 downto 0);
	signal next_pc_ww           : std_logic_vector(31 downto 0);
	signal warp_state_ww        : warp_state_type;
	signal pipeline_write_done  : std_logic;
	signal pipeline_write_stall : std_logic;

	-- Warp Divergence Stack
	constant ARB_WARP_DIV_STACK_CNT : integer := 2;
	signal arb_warp_div_stack_req   : std_logic_vector(ARB_WARP_DIV_STACK_CNT - 1 downto 0);
	signal arb_warp_div_stack_ack   : std_logic;
	signal arb_warp_div_stack_ack_o : std_logic_vector(ARB_WARP_DIV_STACK_CNT - 1 downto 0);
	signal arb_warp_div_stack_grant : std_logic_vector(ARB_WARP_DIV_STACK_CNT - 1 downto 0);

	signal warp_div_stack_en    : warp_div_std_logic_array;
	signal warp_div_data_i      : warp_div_data_array;
	signal warp_div_data_o      : warp_div_data_array;
	signal warp_div_push_en     : warp_div_std_logic_array;
	signal warp_div_stack_full  : warp_div_std_logic_array;
	signal warp_div_stack_empty : warp_div_std_logic_array;

	signal pipeline_read_warp_div_stack_en : warp_div_std_logic_array;
	signal pipeline_read_warp_div_rd_data  : warp_div_data_array;
	signal pipeline_read_warp_div_push_en  : warp_div_std_logic_array;

	signal pipeline_exec_warp_div_stack_en : warp_div_std_logic_array;
	signal pipeline_exec_warp_div_rd_data  : warp_div_data_array;
	signal pipeline_exec_warp_div_wr_data  : warp_div_data_array;
	signal pipeline_exec_warp_div_push_en  : warp_div_std_logic_array;

	-- Vector Register File
	signal gprs_lane_id_a              : warp_lane_id_array;
	signal gprs_addr_a                 : gprs_addr_array;
	signal gprs_reg_num_a              : gprs_reg_array;
	signal gprs_wr_en_a                : wr_en_array;
	signal gprs_wr_data_a              : vector_register; -- bloque dependiente del numero de cores, generalmente son vectores de (#cores vs 32 bits)
	signal gprs_rd_data_a              : vector_register;
	signal smp_controller_gprs_lane_id : warp_lane_id_array;
	signal smp_controller_gprs_addr    : gprs_addr_array;
	signal smp_controller_gprs_reg_num : gprs_reg_array;
	signal smp_controller_gprs_wr_en   : wr_en_array;
	signal smp_controller_gprs_wr_data : vector_register;
	signal smp_controller_gprs_rd_data : vector_register;
	signal pipeline_read_gprs_lane_id  : warp_lane_id_array;
	signal pipeline_read_gprs_addr     : gprs_addr_array;
	signal pipeline_read_gprs_reg_num  : gprs_reg_array;
	signal pipeline_read_gprs_wr_en    : wr_en_array;
	signal pipeline_read_gprs_wr_data  : vector_register;
	signal pipeline_read_gprs_rd_data  : vector_register;
	signal gprs_lane_id_b              : warp_lane_id_array;
	signal gprs_addr_b                 : gprs_addr_array;
	signal gprs_reg_num_b              : gprs_reg_array;
	signal gprs_wr_en_b                : wr_en_array;
	signal gprs_wr_data_b              : vector_register;
	signal gprs_rd_data_b              : vector_register;

	-- Address Registers
	signal addr_regs_warp_id_a      : warp_id_array;
	signal addr_regs_warp_lane_id_a : warp_lane_id_array;
	signal addr_regs_addr_a         : reg_num_array;
	signal addr_regs_wr_en_a        : wr_en_array;
	signal addr_regs_wr_data_a      : vector_register;
	signal addr_regs_rd_data_a      : vector_register;
	signal addr_regs_warp_id_b      : warp_id_array;
	signal addr_regs_warp_lane_id_b : warp_lane_id_array;
	signal addr_regs_addr_b         : reg_num_array;
	signal addr_regs_wr_en_b        : wr_en_array;
	signal addr_regs_wr_data_b      : vector_register;
	signal addr_regs_rd_data_b      : vector_register;

	-- Predicate Flag Registers
	signal pred_regs_warp_id_a      : warp_id_array;
	signal pred_regs_warp_lane_id_a : warp_lane_id_array;
	signal pred_regs_addr_a         : reg_num_array;
	signal pred_regs_wr_en_a        : wr_en_array;
	signal pred_regs_wr_data_a      : vector_flag_register;
	signal pred_regs_rd_data_a      : vector_flag_register;
	signal pred_regs_warp_id_b      : warp_id_array;
	signal pred_regs_warp_lane_id_b : warp_lane_id_array;
	signal pred_regs_addr_b         : reg_num_array;
	signal pred_regs_wr_en_b        : wr_en_array;
	signal pred_regs_wr_data_b      : vector_flag_register;
	signal pred_regs_rd_data_b      : vector_flag_register;

	signal smp_controller_shmem_addr    : std_logic_vector(SHMEM_ADDR_SIZE - 1 downto 0);
	signal smp_controller_shmem_wr_en   : std_logic;
	signal smp_controller_shmem_wr_data : std_logic_vector(7 downto 0);
	signal smp_controller_shmem_rd_data : std_logic_vector(7 downto 0);
	signal pipeline_read_shmem_addr     : std_logic_vector(SHMEM_ADDR_SIZE - 1 downto 0);
	signal pipeline_read_shmem_wr_en    : std_logic;
	signal pipeline_read_shmem_wr_data  : std_logic_vector(7 downto 0);
	signal pipeline_read_shmem_rd_data  : std_logic_vector(7 downto 0);

	-- Shared Memory
	signal shmem_addr_a    : std_logic_vector(SHMEM_ADDR_SIZE - 1 downto 0);
	signal shmem_wr_en_a   : std_logic;
	signal shmem_wr_data_a : std_logic_vector(7 downto 0);
	signal shmem_rd_data_a : std_logic_vector(7 downto 0);
	signal shmem_addr_b    : std_logic_vector(SHMEM_ADDR_SIZE - 1 downto 0);
	signal shmem_wr_en_b   : std_logic;
	signal shmem_wr_data_b : std_logic_vector(7 downto 0);
	signal shmem_rd_data_b : std_logic_vector(7 downto 0);
	
	
begin


	uSMPController : streaming_multiprocessor_cntlr
		generic map(
			SHMEM_ADDR_SIZE => SHMEM_ADDR_SIZE
		)
		port map(
			clk_in                      => clk_in,
			host_reset                  => host_reset,
			smp_run_en                  => smp_run_en,
			warp_generator_done         => warp_generator_done,
			warp_scheduler_done         => warp_scheduler_done,
			threads_per_block_in        => threads_per_block_in,
			num_blocks_in               => num_blocks_in,
			shmem_base_addr_in          => shmem_base_addr_in,
			shmem_size_in               => shmem_size_in,
			parameter_size_in           => parameter_size_in,
			gprs_size_in                => gprs_size_in,
			block_x_in                  => block_x_in,
			block_y_in                  => block_y_in,
			block_z_in                  => block_z_in,
			grid_x_in                   => grid_x_in,
			grid_y_in                   => grid_y_in,
			block_idx_in                => block_idx_in,
			gpgpu_config_reg_cs_out     => gpgpu_config_reg_cs,
			gpgpu_config_reg_rw_out     => gpgpu_config_reg_rw,
			gpgpu_config_reg_adr_out    => gpgpu_config_reg_adr,
			gpgpu_config_reg_rd_data_in => gpgpu_config_reg_rd_data,
			shmem_addr_out              => smp_controller_shmem_addr,
			shmem_wr_en_out             => smp_controller_shmem_wr_en,
			shmem_wr_data_out           => smp_controller_shmem_wr_data,
			gprs_base_addr_out          => smp_controller_gprs_addr,
			gprs_reg_num_out            => smp_controller_gprs_reg_num,
			gprs_lane_id_out            => smp_controller_gprs_lane_id,
			gprs_wr_en_out              => smp_controller_gprs_wr_en,
			gprs_wr_data_out            => smp_controller_gprs_wr_data,
			warps_per_block_out         => warps_per_block,
			smp_configuration_en        => smp_configuration_en,
			warp_generator_en           => warp_generator_en,
			smp_done                    => smp_done
		);

	--
	-- Warp Unit
	--
	uWarpUnit : warp_unit		-- warp_unit_rtl
		generic map(				-- in the syn form
			SHMEM_ADDR_SIZE => SHMEM_ADDR_SIZE
		)
		port map( -- MODIFIED GIANLUCA ROASCIO
			clk_in                   => clk_in,
			host_reset               => host_reset,
			warp_scheduler_reset     => smp_configuration_en,
			warp_generator_en        => warp_generator_en,
			pipeline_write_done      => pipeline_write_done,
			pipeline_stall_in        => pipeline_fetch_stall,
			--threads_per_block_in     => threads_per_block_in,
			num_blocks_in            => num_blocks_in,
			warps_per_block_in       => warps_per_block,
			shared_mem_base_addr_in  => shmem_base_addr_in,
			shared_mem_size_in       => shmem_size_in,
			gprs_size_in             => gprs_size_in,
			--block_x_in               => block_x_in,
			--block_y_in               => block_y_in,
			--block_z_in               => block_z_in,
			--grid_x_in                => grid_x_in,
			--grid_y_in                => grid_y_in,
			--block_idx_in             => block_idx_in,
			warp_id_in               => warp_id_ww,
			warp_lane_id_in          => warp_lane_id_ww,
			cta_id_in                => cta_id_ww,
			initial_mask_in          => initial_mask_ww,
			current_mask_in          => current_mask_ww,
			shmem_base_addr_in       => shmem_base_addr_ww,
			gprs_base_addr_in        => gprs_base_addr_ww,
			next_pc_in               => next_pc_ww,
			warp_state_in            => warp_state_ww,
			program_cntr_out         => program_cntr_wf,
			warp_id_out              => warp_id_wf,
			warp_lane_id_out         => warp_lane_id_wf,
			cta_id_out               => cta_id_wf,
			initial_mask_out         => initial_mask_wf,
			current_mask_out         => current_mask_wf,
			shmem_base_addr_out      => shmem_base_addr_wf,
			gprs_size_out            => gprs_size_wf,
			gprs_base_addr_out       => gprs_base_addr_wf,
			-- num_warps_out not listed  
			warp_generator_done      => warp_generator_done,
			pipeline_stall_out       => pipeline_warp_stall,
			warp_scheduler_done      => warp_scheduler_done,
			pipeline_warpunit_done   => pipeline_warpunit_done,
			fetch_en                 => fetch_en
		);

	--
	-- Fetch Stage
	--
	uPipelineFetch : pipeline_fetch
		generic map(
			MEM_ADDR_SIZE => SYSMEM_ADDR_SIZE
		)
		port map(
			reset               => host_reset,
			clk_in              => clk_in,
			fetch_en            => fetch_en,
			pass_en             => pipeline_warpunit_done,
			pipeline_stall_in   => pipeline_decode_stall,
			program_cntr_in     => program_cntr_wf,
			warp_id_in          => warp_id_wf,
			warp_lane_id_in     => warp_lane_id_wf,
			cta_id_in           => cta_id_wf,
			initial_mask_in     => initial_mask_wf,
			current_mask_in     => current_mask_wf,
			shmem_base_addr_in  => shmem_base_addr_wf,
			gprs_size_in        => gprs_size_wf,
			gprs_base_addr_in   => gprs_base_addr_wf,
			--mem_wr_data_a_out   => open,
			--mem_addr_a_out      => sysmem_addr_a,
			mem_addr_out        => sysmem_addr,
			--mem_wr_en_a_out     => sysmem_wr_en_a,
			--mem_rd_data_a_in    => sysmem_rd_data_a,
			mem_rd_data_in      => sysmem_rd_data,
			--mem_wr_data_b_out   => open,
			--mem_addr_b_out      => sysmem_addr_b,
			--mem_wr_en_b_out     => sysmem_wr_en_b,
			--mem_rd_data_b_in    => sysmem_rd_data_b,
			program_cntr_out    => program_cntr_fd,
			warp_id_out         => warp_id_fd,
			warp_lane_id_out    => warp_lane_id_fd,
			cta_id_out          => cta_id_fd,
			initial_mask_out    => initial_mask_fd,
			current_mask_out    => current_mask_fd,
			shmem_base_addr_out => shmem_base_addr_fd,
			gprs_size_out       => gprs_size_fd,
			gprs_base_addr_out  => gprs_base_addr_fd,
			next_pc_out         => next_pc_fd,
			instruction_out     => instruction_fd,
			pipeline_stall_out  => pipeline_fetch_stall,
			pipeline_fetch_done => pipeline_fd_done
		);

	--
	-- Decode Stage
	--
	uPipelineDecode : pipeline_decode
		port map(
			reset                 => host_reset,
			clk_in                => clk_in,
			pipeline_fetch_done   => pipeline_fd_done,
			pipeline_stall_in     => pipeline_read_stall,
			program_cntr_in       => program_cntr_fd,
			warp_id_in            => warp_id_fd,
			warp_lane_id_in       => warp_lane_id_fd,
			cta_id_in             => cta_id_fd,
			initial_mask_in       => initial_mask_fd,
			current_mask_in       => current_mask_fd,
			shmem_base_addr_in    => shmem_base_addr_fd,
			gprs_size_in          => gprs_size_fd,
			gprs_base_addr_in     => gprs_base_addr_fd,
			next_pc_in            => next_pc_fd,
			instruction_in        => instruction_fd,
			program_cntr_out      => program_cntr_dr,
			warp_id_out           => warp_id_dr,
			warp_lane_id_out      => warp_lane_id_dr,
			cta_id_out            => cta_id_dr,
			initial_mask_out      => initial_mask_dr,
			current_mask_out      => current_mask_dr,
			shmem_base_addr_out   => shmem_base_addr_dr,
			gprs_size_out         => gprs_size_dr,
			gprs_base_addr_out    => gprs_base_addr_dr,
			next_pc_out           => next_pc_dr,
			instr_opcode_out 	  => instr_opcode_dr,
			instr_subop_out  	  => instr_subop_dr,
			alu_opcode_out        => alu_opcode_dr,
			mov_opcode_out        => mov_opcode_dr,
			flow_opcode_out       => flow_opcode_dr,
			instr_marker_out      => instr_marker_dr,
			instr_src1_shared_out => open,
			instr_src2_const_out  => open,
			instr_src3_const_out  => open,
			pred_reg_out          => pred_reg_dr,
			pred_cond_out         => pred_cond_dr,
			set_pred_out          => set_pred_dr,
			set_pred_reg_out      => set_pred_reg_dr,
			output_reg_out        => open,
			write_pred_out        => write_pred_dr,
			is_signed_out         => is_signed_dr,
			w32_out               => w32_dr,
			f64_out               => f64_dr,
			saturate_out          => saturate_dr,
			abs_saturate_out      => abs_saturate_dr,
			cvt_round_out         => cvt_round_dr,
			cvt_type_out          => cvt_type_dr,
			cvt_neg_out           => cvt_neg_dr,
			condition_out         => condition_dr,
			addr_hi_out           => addr_hi_dr,
			addr_lo_out           => addr_lo_dr,
			addr_reg_out          => open,
			addr_incr_out         => addr_incr_dr,
			mov_size_out          => mov_size_dr,
			-- alt_out not even listed
			mem_type_out          => mem_type_dr,
			sm_type_out           => sm_type_dr,
			imm_hi_out            => imm_hi_dr,
			addr_imm_out          => addr_imm_dr,
			-- src1_shared_out not even listed
			src1_mem_type_out     => src1_mem_type_dr,
			src2_mem_type_out     => src2_mem_type_dr,
			src3_mem_type_out     => src3_mem_type_dr,
			dest_mem_type_out     => dest_mem_type_dr,
			src1_mem_opcode_out   => src1_mem_opcode_type_dr,
			src2_mem_opcode_out   => src2_mem_opcode_type_dr,
			src3_mem_opcode_out   => src3_mem_opcode_type_dr,
			dest_mem_opcode_out   => dest_mem_opcode_type_dr,
			src1_neg_out          => src1_neg_dr,
			src2_neg_out          => src2_neg_dr,
			src3_neg_out          => src3_neg_dr,
			target_addr_out       => target_addr_dr,
			src1_data_type_out    => src1_data_type_dr,
			src2_data_type_out    => src2_data_type_dr,
			src3_data_type_out    => src3_data_type_dr,
			dest_data_type_out    => dest_data_type_dr,
			src1_out              => src1_dr,
			src2_out              => src2_dr,
			src3_out              => src3_dr,
			dest_out              => dest_dr,
			pipeline_stall_out    => pipeline_decode_stall,
			pipeline_dec_done     => pipeline_dec_done
		);

	--
	-- Read Stage
	--
	uPipelineRead : pipeline_read
		generic map(
			SHMEM_ADDR_SIZE => SHMEM_ADDR_SIZE,
			CMEM_ADDR_SIZE  => CMEM_ADDR_SIZE,
			GMEM_ADDR_SIZE  => GMEM_ADDR_SIZE
		)
		port map(
			reset                      => host_reset,
			clk_in                     => clk_in,
			pipeline_dec_done          => pipeline_dec_done,
			pipeline_stall_in          => pipeline_execute_stall,
			warp_id_in                 => warp_id_dr,
			warp_lane_id_in            => warp_lane_id_dr,
			cta_id_in                  => cta_id_dr,
			initial_mask_in            => initial_mask_dr,
			current_mask_in            => current_mask_dr,
			shmem_base_addr_in         => shmem_base_addr_dr,
			gprs_size_in               => gprs_size_dr,
			gprs_base_addr_in          => gprs_base_addr_dr,
			next_pc_in                 => next_pc_dr,
			instr_opcode_in            => instr_opcode_dr,
			instr_subop_in             => instr_subop_dr,
			alu_opcode_in              => alu_opcode_dr,
			flow_opcode_in             => flow_opcode_dr,
			mov_opcode_in              => mov_opcode_dr,
			instr_marker_in            => instr_marker_dr,
			pred_reg_in                => pred_reg_dr,
			pred_cond_in               => pred_cond_dr,
			set_pred_in                => set_pred_dr,
			set_pred_reg_in            => set_pred_reg_dr,
			write_pred_in              => write_pred_dr,
			is_signed_in               => is_signed_dr,
			w32_in                     => w32_dr,
			f64_in                     => f64_dr,
			saturate_in                => saturate_dr,
			abs_saturate_in            => abs_saturate_dr,
			cvt_round_in               => cvt_round_dr,
			cvt_type_in                => cvt_type_dr,
			cvt_neg_in                 => cvt_neg_dr,
			condition_in               => condition_dr,
			addr_hi_in                 => addr_hi_dr,
			addr_lo_in                 => addr_lo_dr,
			-- addr_reg_in                => addr_reg_dr,
			addr_incr_in               => addr_incr_dr,
			mov_size_in                => mov_size_dr,
			mem_type_in                => mem_type_dr,
			sm_type_in                 => sm_type_dr,
			imm_hi_in                  => imm_hi_dr,
			addr_imm_in                => addr_imm_dr,
			src1_mem_type_in           => src1_mem_type_dr,
			src2_mem_type_in           => src2_mem_type_dr,
			src3_mem_type_in           => src3_mem_type_dr,
			dest_mem_type_in           => dest_mem_type_dr,
			src1_mem_opcode_in         => src1_mem_opcode_type_dr,
			src2_mem_opcode_in         => src2_mem_opcode_type_dr,
			src3_mem_opcode_in         => src3_mem_opcode_type_dr,
			dest_mem_opcode_in         => dest_mem_opcode_type_dr,
			src1_neg_in                => src1_neg_dr,
			src2_neg_in                => src2_neg_dr,
			src3_neg_in                => src3_neg_dr,
			target_addr_in             => target_addr_dr,
			src1_data_type_in          => src1_data_type_dr,
			src2_data_type_in          => src2_data_type_dr,
			src3_data_type_in          => src3_data_type_dr,
			dest_data_type_in          => dest_data_type_dr,
			src1_in                    => src1_dr,
			src2_in                    => src2_dr,
			src3_in                    => src3_dr,
			dest_in                    => dest_dr,
			-- vector register
			gprs_base_addr_out         => pipeline_read_gprs_addr,
			gprs_reg_num_out           => pipeline_read_gprs_reg_num,
			gprs_lane_id_out           => pipeline_read_gprs_lane_id,
			gprs_wr_en_out             => pipeline_read_gprs_wr_en,
			gprs_wr_data_out           => pipeline_read_gprs_wr_data,
			gprs_rd_data_in            => pipeline_read_gprs_rd_data,
			-- predict register
			pred_regs_warp_id_out      => pred_regs_warp_id_a,
			pred_regs_warp_lane_id_out => pred_regs_warp_lane_id_a,
			pred_regs_reg_num_out      => pred_regs_addr_a,
			pred_regs_wr_en_out        => pred_regs_wr_en_a,
			pred_regs_wr_data_out      => pred_regs_wr_data_a,
			pred_regs_rd_data_in       => pred_regs_rd_data_a,
			-- addr register
			addr_regs_warp_id_out      => addr_regs_warp_id_a,
			addr_regs_warp_lane_id_out => addr_regs_warp_lane_id_a,
			addr_regs_reg_num_out      => addr_regs_addr_a,
			addr_regs_wr_en_out        => addr_regs_wr_en_a,
			addr_regs_wr_data_out      => addr_regs_wr_data_a,
			addr_regs_rd_data_in       => addr_regs_rd_data_a,
			warp_div_req_out           => arb_warp_div_stack_req(0),
			warp_div_ack_out           => arb_warp_div_stack_ack_o(0),
			warp_div_grant_in          => arb_warp_div_stack_grant(0),
			warp_div_stack_en          => pipeline_read_warp_div_stack_en,
			warp_div_rd_data_in        => pipeline_read_warp_div_rd_data,
			--warp_div_wr_data_out       => pipeline_read_warp_div_wr_data,
			warp_div_push_en           => pipeline_read_warp_div_push_en,
			--warp_div_stack_full        => warp_div_stack_full,
			warp_div_stack_empty       => warp_div_stack_empty,
			shmem_addr_out             => pipeline_read_shmem_addr,
			shmem_wr_en_out            => pipeline_read_shmem_wr_en,
			shmem_wr_data_out          => pipeline_read_shmem_wr_data,
			shmem_rd_data_in           => pipeline_read_shmem_rd_data,
			cmem_addr_out              => cmem_addr_a,
			cmem_wr_en_out             => cmem_wr_en_a,
			cmem_wr_data_out           => cmem_wr_data_a,
			cmem_rd_data_in            => cmem_rd_data_a,
			gmem_addr_out              => gmem_addr_a,
			gmem_wr_en_out             => gmem_wr_en_a,
			gmem_wr_data_out           => gmem_wr_data_a,
			gmem_rd_data_in            => gmem_rd_data_a,
			-- outputs to ex stage
			warp_id_out                => warp_id_re,
			warp_lane_id_out           => warp_lane_id_re,
			cta_id_out                 => cta_id_re,
			initial_mask_out           => initial_mask_re,
			current_mask_out           => current_mask_re,
			shmem_base_addr_out        => shmem_base_addr_re,
			gprs_size_out              => gprs_size_re,
			gprs_addr_out              => gprs_base_addr_re,
			instruction_mask_out       => instruction_mask_re,
			next_pc_out                => next_pc_re,
			instr_opcode_type_out      => instr_opcode_re,
			instr_subop_type_out       => instr_subop_re,
			alu_opcode_out             => alu_opcode_re,
			flow_opcode_out            => flow_opcode_re,
			mov_opcode_out             => mov_opcode_re,
			instr_marker_out           => instr_marker_re,
			set_pred_out               => set_pred_re,
			set_pred_reg_out           => set_pred_reg_re,
			write_pred_out             => write_pred_re,
			is_full_normal_out         => is_full_normal_re,
			is_signed_out              => is_signed_re,
			w32_out                    => w32_re,
			f64_out                    => f64_re,
			saturate_out               => saturate_re,
			abs_saturate_out           => abs_saturate_re,
			cvt_round_out              => cvt_round_re,
			cvt_type_out               => cvt_type_re,
			cvt_neg_out                => cvt_neg_re,
			condition_out              => condition_re,
			addr_hi_out                => addr_hi_re,
			addr_lo_out                => addr_lo_re,
			addr_incr_out              => addr_incr_re,
			mov_size_out               => mov_size_re,
			mem_type_out               => mem_type_re,
			sm_type_out                => sm_type_re,
			addr_imm_out               => addr_imm_re,
			dest_mem_type_out          => dest_mem_type_re,
			dest_mem_opcode_out        => dest_mem_opcode_re,
			src1_neg_out               => src1_neg_re,
			src2_neg_out               => src2_neg_re,
			src3_neg_out               => src3_neg_re,
			target_addr_out            => target_addr_re,
			dest_data_type_out         => dest_data_type_re,
			src1_out                   => src1_re,
			dest_out                   => dest_re,
			pred_flags_out             => pred_flags_re,
			temp_vector_register_out   => temp_vector_register_re,
			pipeline_stall_out         => pipeline_read_stall,
			pipeline_read_done         => pipeline_read_done
		);

	--
	-- Execute Stage
	--
	uPipelineExecute : pipeline_execute
		port map(
			reset                    => host_reset,
			clk_in                   => clk_in,
			pipeline_read_done       => pipeline_read_done,
			pipeline_stall_in        => pipeline_write_stall,
			warp_id_in               => warp_id_re,
			warp_lane_id_in          => warp_lane_id_re,
			cta_id_in                => cta_id_re,
			initial_mask_in          => initial_mask_re,
			current_mask_in          => current_mask_re,
			shmem_base_addr_in       => shmem_base_addr_re,
			gprs_size_in             => gprs_size_re,
			gprs_base_addr_in        => gprs_base_addr_re,
			instr_mask_in            => instruction_mask_re,
			next_pc_in               => next_pc_re,
			instr_opcode_in          => instr_opcode_re,
			instr_subop_in           => instr_subop_re,
			alu_opcode_in            => alu_opcode_re,
			flow_opcode_in           => flow_opcode_re,
			mov_opcode_in            => mov_opcode_re,
			instr_marker_in          => instr_marker_re,
			set_pred_in              => set_pred_re,
			set_pred_reg_in          => set_pred_reg_re,
			write_pred_in            => write_pred_re,
			is_signed_in             => is_signed_re,
			w32_in                   => w32_re,
			f64_in                   => f64_re,
			saturate_in              => saturate_re,
			abs_saturate_in          => abs_saturate_re,
			cvt_round_in             => abs_saturate_re,
			cvt_type_in              => cvt_type_re,
			cvt_neg_in               => cvt_neg_re,
			set_cond_in              => condition_re,
			addr_hi_in               => addr_hi_re,
			addr_lo_in               => addr_lo_re,
			addr_incr_in             => addr_incr_re,
			mov_size_in              => mov_size_re,
			mem_type_in              => mem_type_re,
			sm_type_in               => sm_type_re,
			addr_imm_in              => addr_imm_re,
			dest_mem_type_in         => dest_mem_type_re,
			dest_mem_opcode_in       => dest_mem_opcode_re,
			src1_neg_in              => src1_neg_re,
			src2_neg_in              => src2_neg_re,
			src3_neg_in              => src3_neg_re,
			target_addr_in           => target_addr_re,
			dest_data_type_in        => dest_data_type_re,
			src1_in                  => src1_re,
			dest_in                  => dest_re,
			pred_flags_in            => pred_flags_re,
			temp_vector_register_in  => temp_vector_register_re,
			warp_div_req_out         => arb_warp_div_stack_req(1),
			warp_div_ack_out         => arb_warp_div_stack_ack_o(1),
			warp_div_grant_in        => arb_warp_div_stack_grant(1),
			warp_div_stack_en_out    => pipeline_exec_warp_div_stack_en,
			warp_div_wr_data_out     => pipeline_exec_warp_div_wr_data,
			warp_div_rd_data_in      => pipeline_exec_warp_div_rd_data,
			warp_div_push_en_out     => pipeline_exec_warp_div_push_en,
			warp_div_stack_full_in   => warp_div_stack_full,
			warp_div_stack_empty_in  => warp_div_stack_empty,
			warp_id_out              => warp_id_ew,
			warp_lane_id_out         => warp_lane_id_ew,
			cta_id_out               => cta_id_ew,
			initial_mask_out         => initial_mask_ew,
			current_mask_out         => current_mask_ew,
			shmem_base_addr_out      => shmem_base_addr_ew,
			gprs_size_out            => gprs_size_ew,
			gprs_base_addr_out       => gprs_base_addr_ew,
			instr_mask_out           => instr_mask_ew,
			next_pc_out              => next_pc_ew,
			warp_state_out           => warp_state_ew,
			instr_opcode_out         => instr_opcode_type_ew,
			set_pred_out             => set_pred_ew,
			set_pred_reg_out         => set_pred_reg_ew,
			write_pred_out           => write_pred_ew,
			addr_hi_out              => addr_hi_ew,
			addr_lo_out              => addr_lo_ew,
			addr_incr_out            => addr_incr_ew,
			mov_size_out             => mov_size_ew,
			sm_type_out              => sm_type_ew,
			addr_imm_out             => addr_imm_ew,
			src1_out                 => src1_ew,
			dest_mem_type_out        => dest_mem_type_ew,
			dest_mem_opcode_out      => dest_mem_opcode_ew,
			dest_data_type_out       => dest_data_type_ew,
			dest_out                 => dest_ew,
			pred_flags_out           => pred_flags_ew,
			temp_vector_register_out => temp_vector_register_ew,
			pipeline_stall_out       => pipeline_execute_stall,
			pipeline_execute_done    => pipeline_execute_done
		);

	--
	-- Write Stage
	--
	uPipelineWrite : pipeline_write
		generic map(
			SHMEM_ADDR_SIZE => SHMEM_ADDR_SIZE,
			GMEM_ADDR_SIZE  => GMEM_ADDR_SIZE
		)
		port map(
			reset                      => host_reset,
			clk_in                     => clk_in,
			pipeline_stall_in          => pipeline_warp_stall,
			pipeline_execute_done      => pipeline_execute_done,
			warp_id_in                 => warp_id_ew,
			warp_lane_id_in            => warp_lane_id_ew,
			cta_id_in                  => cta_id_ew,
			initial_mask_in            => initial_mask_ew,
			current_mask_in            => current_mask_ew,
			shmem_base_addr_in         => shmem_base_addr_ew,
			gprs_base_addr_in          => gprs_base_addr_ew,
			next_pc_in                 => next_pc_ew,
			warp_state_in              => warp_state_ew,
			instr_opcode_in            => instr_opcode_type_ew,
			temp_vector_register_in    => temp_vector_register_ew,
			dest_in                    => dest_ew,
			instruction_mask_in        => instr_mask_ew,
			instruction_flags_in       => pred_flags_ew,
			dest_data_type_in          => dest_data_type_ew,
			dest_mem_type_in           => dest_mem_type_ew,
			dest_mem_opcode_in         => dest_mem_opcode_ew,
			addr_hi_in                 => addr_hi_ew,
			addr_lo_in                 => addr_lo_ew,
			addr_imm_in                => addr_imm_ew,
			addr_inc_in                => addr_incr_ew,
			mov_size_in                => mov_size_ew,
			write_pred_in              => write_pred_ew,
			set_pred_in                => set_pred_ew,
			set_pred_reg_in            => set_pred_reg_ew,
			sm_type_in                 => sm_type_ew,
			gprs_base_addr_out         => gprs_addr_b,
			gprs_reg_num_out           => gprs_reg_num_b,
			gprs_lane_id_out           => gprs_lane_id_b,
			gprs_wr_en_out             => gprs_wr_en_b,
			gprs_wr_data_out           => gprs_wr_data_b,
			gprs_rd_data_in            => gprs_rd_data_b,
			pred_regs_warp_id_out      => pred_regs_warp_id_b,
			pred_regs_warp_lane_id_out => pred_regs_warp_lane_id_b,
			pred_regs_reg_num_out      => pred_regs_addr_b,
			pred_regs_wr_en_out        => pred_regs_wr_en_b,
			pred_regs_wr_data_out      => pred_regs_wr_data_b,
			pred_regs_rd_data_in       => pred_regs_rd_data_b,
			addr_regs_warp_id_out      => addr_regs_warp_id_b,
			addr_regs_warp_lane_id_out => addr_regs_warp_lane_id_b,
			addr_regs_reg_num_out      => addr_regs_addr_b,
			addr_regs_wr_en_out        => addr_regs_wr_en_b,
			addr_regs_wr_data_out      => addr_regs_wr_data_b,
			addr_regs_rd_data_in       => addr_regs_rd_data_b,
			shmem_addr_out             => shmem_addr_b,
			shmem_wr_en_out            => shmem_wr_en_b,
			shmem_wr_data_out          => shmem_wr_data_b,
			shmem_rd_data_in           => shmem_rd_data_b,
			gmem_addr_out              => gmem_addr_b,
			gmem_wr_en_out             => gmem_wr_en_b,
			gmem_wr_data_out           => gmem_wr_data_b,
			gmem_rd_data_in            => gmem_rd_data_b,
			warp_id_out                => warp_id_ww,
			warp_lane_id_out           => warp_lane_id_ww,
			cta_id_out                 => cta_id_ww,
			initial_mask_out           => initial_mask_ww,
			current_mask_out           => current_mask_ww,
			shmem_base_addr_out        => shmem_base_addr_ww,
			gprs_addr_out              => gprs_base_addr_ww,
			next_pc_out                => next_pc_ww,
			warp_state_out             => warp_state_ww,
			pipeline_stall_out         => pipeline_write_stall,
			pipeline_write_done        => pipeline_write_done
		);

	--
	-- Vector Register File
	--
	gprs_lane_id_a <= smp_controller_gprs_lane_id when (smp_configuration_en = '1') else pipeline_read_gprs_lane_id;
	gprs_addr_a    <= smp_controller_gprs_addr when (smp_configuration_en = '1') else pipeline_read_gprs_addr;
	gprs_reg_num_a <= smp_controller_gprs_reg_num when (smp_configuration_en = '1') else pipeline_read_gprs_reg_num;
	gprs_wr_en_a   <= smp_controller_gprs_wr_en when (smp_configuration_en = '1') else pipeline_read_gprs_wr_en;
	gprs_wr_data_a <= smp_controller_gprs_wr_data when (smp_configuration_en = '1') else pipeline_read_gprs_wr_data;

	smp_controller_gprs_rd_data <= gprs_rd_data_a when (smp_configuration_en = '1') else (others => (others => '0'));
	pipeline_read_gprs_rd_data  <= gprs_rd_data_a when (smp_configuration_en = '0') else (others => (others => '0'));

	--
	-- Vector Register File
	--
	gRegisterFile : for i in 0 to CORES - 1 generate
		uRegisterFile : vector_register_file generic map(NCORES => CORES)
			port map(
				clk          => clk_in,
				warp_lane_id_a => gprs_lane_id_a(i),
				base_addr_a    => gprs_addr_a(i),
				reg_num_a      => gprs_reg_num_a(i),
				we_a           => gprs_wr_en_a(i),
				din_a          => gprs_wr_data_a(i),
				dout_a         => gprs_rd_data_a(i),
				warp_lane_id_b => gprs_lane_id_b(i),
				base_addr_b    => gprs_addr_b(i),
				reg_num_b      => gprs_reg_num_b(i),
				we_b           => gprs_wr_en_b(i),
				din_b          => gprs_wr_data_b(i),
				dout_b         => gprs_rd_data_b(i)
			);
	end generate gRegisterFile;

	--
	-- Warp Stack Arbiter
	--
	uWarpDivergenceStackArbiter : arbiter
		generic map(
			CNT => ARB_WARP_DIV_STACK_CNT
		)
		port map(
			clk   => clk_in,
			rst   => host_reset,
			req   => arb_warp_div_stack_req,
			ack   => arb_warp_div_stack_ack,
			grant => arb_warp_div_stack_grant
		);

	arb_warp_div_stack_ack <= arb_warp_div_stack_ack_o(0) or arb_warp_div_stack_ack_o(1);

	--
	-- Warp Stack
	--
	gWarpDivergenceStack : for i in 0 to MAX_WARPS - 1 generate
		uWarpDivergenceStack : stack
			generic map(
				STACK_DEPTH => STACK_DEPTH,
				DATA_WIDTH  => STACK_DATA_WIDTH
			)
			port map(
				clk_in      => clk_in,
				reset       => host_reset,
				stack_en    => warp_div_stack_en(i),
				data_in     => warp_div_data_i(i),
				data_out    => warp_div_data_o(i),
				push_en     => warp_div_push_en(i),
				stack_full  => warp_div_stack_full(i),
				stack_empty => warp_div_stack_empty(i)
			);
	end generate;

	warp_div_stack_en <= pipeline_read_warp_div_stack_en when (arb_warp_div_stack_grant(0) = '1') else pipeline_exec_warp_div_stack_en when (arb_warp_div_stack_grant(1) = '1') else (others => '0');

	warp_div_data_i <= pipeline_exec_warp_div_wr_data when (arb_warp_div_stack_grant(0) = '1') else pipeline_exec_warp_div_wr_data when (arb_warp_div_stack_grant(1) = '1') else (others => (others => '0'));

	pipeline_read_warp_div_rd_data <= warp_div_data_o when (arb_warp_div_stack_grant(0) = '1') else (others => (others => '0'));
	pipeline_exec_warp_div_rd_data <= warp_div_data_o when (arb_warp_div_stack_grant(1) = '1') else (others => (others => '0'));

	warp_div_push_en <= pipeline_exec_warp_div_push_en when (arb_warp_div_stack_grant(0) = '1') else pipeline_exec_warp_div_push_en when (arb_warp_div_stack_grant(1) = '1') else (others => '0');

	--
	-- Address Registers
	--
	gAddressRegisters : for i in 0 to CORES - 1 generate
		uAddressRegisters : address_register_file generic map(NCORES => CORES)
			port map(
				clk          => clk_in,
				warp_id_a      => addr_regs_warp_id_a(i),
				warp_lane_id_a => addr_regs_warp_lane_id_a(i),
				reg_addr_a     => addr_regs_addr_a(i),
				wr_en_a        => addr_regs_wr_en_a(i),
				din_a          => addr_regs_wr_data_a(i),
				dout_a         => addr_regs_rd_data_a(i),
				warp_id_b      => addr_regs_warp_id_b(i),
				warp_lane_id_b => addr_regs_warp_lane_id_b(i),
				reg_addr_b     => addr_regs_addr_b(i),
				wr_en_b        => addr_regs_wr_en_b(i),
				din_b          => addr_regs_wr_data_b(i),
				dout_b         => addr_regs_rd_data_b(i)
			);
	end generate gAddressRegisters;

	--
	-- Predicate Registers
	--
	gPredicateRegisters : for i in 0 to CORES - 1 generate
		uPredicateRegisters : predicate_register_file generic map(NCORES => CORES)
			port map(
				clk          => clk_in,
				warp_id_a      => pred_regs_warp_id_a(i),
				warp_lane_id_a => pred_regs_warp_lane_id_a(i),
				reg_addr_a     => pred_regs_addr_a(i),
				wr_en_a        => pred_regs_wr_en_a(i),
				din_a          => pred_regs_wr_data_a(i),
				dout_a         => pred_regs_rd_data_a(i),
				warp_id_b      => pred_regs_warp_id_b(i),
				warp_lane_id_b => pred_regs_warp_lane_id_b(i),
				reg_addr_b     => pred_regs_addr_b(i),
				wr_en_b        => pred_regs_wr_en_b(i),
				din_b          => pred_regs_wr_data_b(i),
				dout_b         => pred_regs_rd_data_b(i)
			);
	end generate gPredicateRegisters;

	--
	-- Shared Memory
	--
	shmem_addr_a <= smp_controller_shmem_addr when (smp_configuration_en = '1') else pipeline_read_shmem_addr;
	shmem_wr_en_a <= smp_controller_shmem_wr_en when (smp_configuration_en = '1') else pipeline_read_shmem_wr_en;
	shmem_wr_data_a <= smp_controller_shmem_wr_data when (smp_configuration_en = '1') else pipeline_read_shmem_wr_data;

	smp_controller_shmem_rd_data <= shmem_rd_data_a when (smp_configuration_en = '1') else (others => '0');
	pipeline_read_shmem_rd_data  <= shmem_rd_data_a when (smp_configuration_en = '0') else (others => '0');


		--
		-- Shared Memory
		--
		uSharedMemory : dp_regfile generic map(RAM_SIZE => 16384, RAM_A_WIDTH => SHMEM_ADDR_SIZE, RAM_D_WIDTH => 8)
			port map(
				rst => host_reset,
				clk => clk_in,
				addr_a => shmem_addr_a,
				we_a => shmem_wr_en_a,
				din_a => shmem_wr_data_a,
				dout_a => shmem_rd_data_a,
				addr_b => shmem_addr_b,
				we_b => shmem_wr_en_b,
				din_b => shmem_wr_data_b,
				dout_b => shmem_rd_data_b
			);

	
end arch;

