----------------------------------------------------------------------------------
-- Company:          Univerity of Massachusetts 
-- Engineer:         Kevin Andryc
-- 
-- Create Date:      17:50:27 09/19/2010  
-- Module Name:      gpgpu_top_level - arch 
-- Project Name:     GPGPU
-- Target Devices: 
-- Tool versions:    ISE 10.1/// sohuld i try to use the compiler for rtl description!!!! 
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

entity gpgpu_ml605_top_level is
	generic(
		GMEM_ADDR_SIZE   : integer := 18;
		CMEM_ADDR_SIZE   : integer := 13;
		SYSMEM_ADDR_SIZE : integer := 18;
		SHMEM_ADDR_SIZE	 : integer := 14
	);
	port(
		sys_clk                  : in  std_logic;
		host_reset               : in  std_logic;
		block_scheduler_en       : in  std_logic;
		kernel_done              : out std_logic;
		smp_done_signal          : out std_logic;
		gmem_cntrl_en_in         : in  std_logic;
		cmem_cntrl_en_in         : in  std_logic;
		sysmem_cntrl_en_in       : in  std_logic;
		gpgpu_config_cntrl_en_in : in  std_logic;
		gpgpu_config_top_cs      : in  std_logic;
		gpgpu_config_top_rw      : in  std_logic;
		gpgpu_config_top_adr     : in  std_logic_vector(31 downto 0);
		gpgpu_config_top_rd_data : out std_logic_vector(31 downto 0);
		gpgpu_config_top_wr_data : in  std_logic_vector(31 downto 0);
		gmem_wr_data_a_in        : in  std_logic_vector(7 downto 0);
		gmem_addr_a_in           : in  std_logic_vector(GMEM_ADDR_SIZE - 1 downto 0);
		gmem_wr_en_a_in          : in  std_logic;
		gmem_rd_data_a_out       : out std_logic_vector(7 downto 0);
		gmem_wr_data_b_in        : in  std_logic_vector(7 downto 0);
		gmem_addr_b_in           : in  std_logic_vector(GMEM_ADDR_SIZE - 1 downto 0);
		gmem_wr_en_b_in          : in  std_logic;
		gmem_rd_data_b_out       : out std_logic_vector(7 downto 0);
		cmem_wr_data_a_in        : in  std_logic_vector(7 downto 0);
		cmem_addr_a_in           : in  std_logic_vector(CMEM_ADDR_SIZE - 1 downto 0);
		cmem_wr_en_a_in          : in  std_logic;
		cmem_rd_data_a_out       : out std_logic_vector(7 downto 0);
		cmem_wr_data_b_in        : in  std_logic_vector(7 downto 0);
		cmem_addr_b_in           : in  std_logic_vector(CMEM_ADDR_SIZE - 1 downto 0);
		cmem_wr_en_b_in          : in  std_logic;
		cmem_rd_data_b_out       : out std_logic_vector(7 downto 0);
		sysmem_wr_data_a_in      : in  std_logic_vector(SYSMEM_DATA_SIZE-1 downto 0);
		sysmem_addr_a_in         : in  std_logic_vector(SYSMEM_ADDR_SIZE - 1 downto 0);
		sysmem_wr_en_a_in        : in  std_logic;
		sysmem_rd_data_a_out     : out std_logic_vector(SYSMEM_DATA_SIZE-1 downto 0);
		sysmem_wr_data_b_in      : in  std_logic_vector(SYSMEM_DATA_SIZE-1 downto 0);
		sysmem_addr_b_in         : in  std_logic_vector(SYSMEM_ADDR_SIZE - 1 downto 0);
		sysmem_wr_en_b_in        : in  std_logic;
		sysmem_rd_data_b_out     : out std_logic_vector(SYSMEM_DATA_SIZE-1 downto 0)
	);
end gpgpu_ml605_top_level;

architecture arch of gpgpu_ml605_top_level is

	signal kernel_blocks_per_core : std_logic_vector(3 downto 0);
	signal kernel_num_gprs        : std_logic_vector(8 downto 0);
	signal kernel_shmem_size      : std_logic_vector(31 downto 0);
	signal kernel_parameter_size  : std_logic_vector(15 downto 0);
	signal kernel_dyn_shmem_size  : std_logic_vector(31 downto 0);
	signal kernel_block_x         : std_logic_vector(15 downto 0);
	signal kernel_block_y         : std_logic_vector(15 downto 0);
	signal kernel_block_z         : std_logic_vector(15 downto 0);
	signal kernel_grid_x          : std_logic_vector(15 downto 0);
	signal kernel_grid_y          : std_logic_vector(15 downto 0);

	signal smp_done : std_logic;

	signal threads_per_block : std_logic_vector(11 downto 0);
	signal num_blocks        : std_logic_vector(3 downto 0);
	signal shmem_base_addr   : std_logic_vector(31 downto 0);
	signal shmem_size        : std_logic_vector(31 downto 0);
	signal parameter_size    : std_logic_vector(15 downto 0);
	signal gprs_size         : std_logic_vector(8 downto 0);
	signal block_x           : std_logic_vector(15 downto 0);
	signal block_y           : std_logic_vector(15 downto 0);
	signal block_z           : std_logic_vector(15 downto 0);
	signal grid_x            : std_logic_vector(15 downto 0);
	signal grid_y            : std_logic_vector(15 downto 0);
	signal block_idx         : std_logic_vector(15 downto 0);

	signal smp_run_en : std_logic;
	
	-- ADDED GIANLUCA ROASCIO
	signal smp_reset : std_logic;
	
	signal block_scheduler_rdy : std_logic;

	signal kernel_done_i : std_logic;
	--
	-- Configuration
	--
	signal gpgpu_config_reg_cs       : std_logic;
	signal gpgpu_config_reg_rw       : std_logic;
	signal gpgpu_config_reg_adr      : std_logic_vector(31 downto 0);
	signal gpgpu_config_reg_data_in  : std_logic_vector(31 downto 0);
	signal gpgpu_config_reg_data_out : std_logic_vector(31 downto 0);

	signal gpgpu_config_smp_cs      : std_logic;
	signal gpgpu_config_smp_rw      : std_logic;
	signal gpgpu_config_smp_adr     : std_logic_vector(31 downto 0);
	signal gpgpu_config_smp_rd_data : std_logic_vector(31 downto 0);
	signal gpgpu_config_smp_wr_data : std_logic_vector(31 downto 0) :=(others=>'0');

	--
	-- Memory
	--
	signal gmem_wr_data_a : std_logic_vector(7 downto 0);
	signal gmem_addr_a    : std_logic_vector(GMEM_ADDR_SIZE - 1 downto 0);
	signal gmem_wr_en_a   : std_logic;
	signal gmem_rd_data_a : std_logic_vector(7 downto 0);

	signal gmem_wr_data_b : std_logic_vector(7 downto 0);
	signal gmem_addr_b    : std_logic_vector(GMEM_ADDR_SIZE - 1 downto 0);
	signal gmem_wr_en_b   : std_logic;
	signal gmem_rd_data_b : std_logic_vector(7 downto 0);

	signal smp_gmem_wr_data_a : std_logic_vector(7 downto 0);
	signal smp_gmem_addr_a    : std_logic_vector(GMEM_ADDR_SIZE - 1 downto 0);
	signal smp_gmem_wr_en_a   : std_logic;
	signal smp_gmem_rd_data_a : std_logic_vector(7 downto 0);

	signal smp_gmem_wr_data_b : std_logic_vector(7 downto 0);
	signal smp_gmem_addr_b    : std_logic_vector(GMEM_ADDR_SIZE - 1 downto 0);
	signal smp_gmem_wr_en_b   : std_logic;
	signal smp_gmem_rd_data_b : std_logic_vector(7 downto 0);

	signal cmem_wr_data_a : std_logic_vector(7 downto 0);
	signal cmem_addr_a    : std_logic_vector(CMEM_ADDR_SIZE - 1 downto 0);
	signal cmem_wr_en_a   : std_logic;
	signal cmem_rd_data_a : std_logic_vector(7 downto 0);

	signal cmem_wr_data_b : std_logic_vector(7 downto 0);
	signal cmem_addr_b    : std_logic_vector(CMEM_ADDR_SIZE - 1 downto 0);
	signal cmem_wr_en_b   : std_logic;
	signal cmem_rd_data_b : std_logic_vector(7 downto 0);

	signal smp_cmem_wr_data_a : std_logic_vector(7 downto 0);
	signal smp_cmem_addr_a    : std_logic_vector(CMEM_ADDR_SIZE - 1 downto 0);
	signal smp_cmem_wr_en_a   : std_logic;
	signal smp_cmem_rd_data_a : std_logic_vector(7 downto 0);

	signal sysmem_wr_data_a : std_logic_vector(SYSMEM_DATA_SIZE-1 downto 0);
	signal sysmem_addr_a    : std_logic_vector(SYSMEM_ADDR_SIZE - 1 downto 0);
	signal sysmem_wr_en_a   : std_logic;
	signal sysmem_rd_data_a : std_logic_vector(SYSMEM_DATA_SIZE-1 downto 0);

	signal sysmem_wr_data_b : std_logic_vector(SYSMEM_DATA_SIZE-1 downto 0);
	signal sysmem_addr_b    : std_logic_vector(SYSMEM_ADDR_SIZE - 1 downto 0);
	signal sysmem_wr_en_b   : std_logic;
	signal sysmem_rd_data_b : std_logic_vector(SYSMEM_DATA_SIZE-1 downto 0);

	signal smp_sysmem_addr    : std_logic_vector(SYSMEM_ADDR_SIZE - 1 downto 0);
	signal smp_sysmem_rd_data : std_logic_vector(SYSMEM_DATA_SIZE - 1 downto 0);
	signal smp_sysmem_addr_a    : std_logic_vector(SYSMEM_ADDR_SIZE - 1 downto 0);
	signal smp_sysmem_wr_en_a   : std_logic;
	signal smp_sysmem_rd_data_a : std_logic_vector(SYSMEM_DATA_SIZE-1 downto 0);
	signal smp_sysmem_addr_b    : std_logic_vector(SYSMEM_ADDR_SIZE - 1 downto 0);
	signal smp_sysmem_wr_en_b   : std_logic;
	signal smp_sysmem_rd_data_b : std_logic_vector(SYSMEM_DATA_SIZE-1 downto 0);


begin

	-- Dummy smp_done output for top-level design
	smp_done_signal <= smp_done;
	kernel_done     <= kernel_done_i;

	--
	-- Configuration
	--
	gpgpu_config_reg_cs      <= gpgpu_config_top_cs when (gpgpu_config_cntrl_en_in = '1') else gpgpu_config_smp_cs;
	gpgpu_config_reg_rw      <= gpgpu_config_top_rw when (gpgpu_config_cntrl_en_in = '1') else gpgpu_config_smp_rw;
	gpgpu_config_reg_adr     <= gpgpu_config_top_adr when (gpgpu_config_cntrl_en_in = '1') else gpgpu_config_smp_adr;
	gpgpu_config_reg_data_in <= gpgpu_config_top_wr_data when (gpgpu_config_cntrl_en_in = '1') else gpgpu_config_smp_wr_data;

	gpgpu_config_top_rd_data <= gpgpu_config_reg_data_out when (gpgpu_config_cntrl_en_in = '1') else (others => '0');
	gpgpu_config_smp_rd_data <= gpgpu_config_reg_data_out when (gpgpu_config_cntrl_en_in = '0') else (others => '0');

	-- instantiation of the config part of GPU module.
	uGPGPUConfiguration : gpgpu_configuration				
		port map(
			clk_in                 => sys_clk,
			host_reset             => host_reset,
			reset_registers        => host_reset,
			config_reg_cs          => gpgpu_config_reg_cs,
			config_reg_rw          => gpgpu_config_reg_rw,
			config_reg_adr         => gpgpu_config_reg_adr,
			config_reg_data_in     => gpgpu_config_reg_data_in,
			config_reg_data_out    => gpgpu_config_reg_data_out,
			kernel_blocks_per_core => kernel_blocks_per_core,
			kernel_num_gprs        => kernel_num_gprs,
			kernel_shmem_size      => kernel_shmem_size,
			kernel_parameter_size  => kernel_parameter_size,
			kernel_dyn_shmem_size  => kernel_dyn_shmem_size,
			kernel_block_x         => kernel_block_x,
			kernel_block_y         => kernel_block_y,
			kernel_block_z         => kernel_block_z,
			kernel_grid_x          => kernel_grid_x,
			kernel_grid_y          => kernel_grid_y
		);

	--
	-- Block Scheduler					-- how is designed?? is it structural or behavioral???
	--
	uBlockScheduler : block_scheduler
		port map(
			clk_in                    => sys_clk,
			host_reset                => host_reset,
			en                        => block_scheduler_en,
			kernel_blocks_per_core_in => kernel_blocks_per_core,
			kernel_num_gprs_in        => kernel_num_gprs,
			kernel_shmem_size_in      => kernel_shmem_size,
			kernel_parameter_size_in  => kernel_parameter_size,
			kernel_dyn_shmem_size_in  => kernel_dyn_shmem_size,
			kernel_block_x_in         => kernel_block_x,
			kernel_block_y_in         => kernel_block_y,
			kernel_block_z_in         => kernel_block_z,
			kernel_grid_x_in          => kernel_grid_x,
			kernel_grid_y_in          => kernel_grid_y,
			smp_done_in               => smp_done,
			threads_per_block_out     => threads_per_block,
			num_blocks_out            => num_blocks,
			shmem_base_addr_out       => shmem_base_addr,
			shmem_size_out            => shmem_size,
			parameter_size_out        => parameter_size,
			gprs_size_out             => gprs_size,
			block_x_out               => block_x,
			block_y_out               => block_y,
			block_z_out               => block_z,
			grid_x_out                => grid_x,
			grid_y_out                => grid_y,
			block_idx_out             => block_idx,
			--smp_reset_out             => open,
			smp_reset_out			  => smp_reset,
			smp_en_out                => smp_run_en,
			rdy                       => block_scheduler_rdy,
			kernel_done               => kernel_done_i
		);

	--
	-- Streaming Multiprocessor - for the moment, there is just one of them
	--
	uStreamingMultiProcessor : streaming_multiprocessor
		generic map(
			STREAMING_MULTIPROCESSOR_ID => x"00",
			GMEM_ADDR_SIZE              => GMEM_ADDR_SIZE,
			CMEM_ADDR_SIZE              => CMEM_ADDR_SIZE,
			SYSMEM_ADDR_SIZE            => SYSMEM_ADDR_SIZE
		)
		port map(
			clk_in                   => sys_clk,
			--host_reset               => host_reset,
			host_reset				 => smp_reset,
			threads_per_block_in     => threads_per_block,
			num_blocks_in            => num_blocks,
			shmem_base_addr_in       => shmem_base_addr,
			shmem_size_in            => shmem_size,
			parameter_size_in        => parameter_size,
			gprs_size_in             => gprs_size,
			block_x_in               => block_x,
			block_y_in               => block_y,
			block_z_in               => block_z,
			grid_x_in                => grid_x,
			grid_y_in                => grid_y,
			block_idx_in             => block_idx,
			smp_run_en               => smp_run_en,
			gpgpu_config_reg_cs      => gpgpu_config_smp_cs,
			gpgpu_config_reg_rw      => gpgpu_config_smp_rw,
			gpgpu_config_reg_adr     => gpgpu_config_smp_adr,
			gpgpu_config_reg_rd_data => gpgpu_config_smp_rd_data,
			gmem_wr_data_a           => smp_gmem_wr_data_a,
			gmem_addr_a              => smp_gmem_addr_a,
			gmem_wr_en_a             => smp_gmem_wr_en_a,
			gmem_rd_data_a           => smp_gmem_rd_data_a,
			gmem_wr_data_b           => smp_gmem_wr_data_b,
			gmem_addr_b              => smp_gmem_addr_b,
			gmem_wr_en_b             => smp_gmem_wr_en_b,
			gmem_rd_data_b           => smp_gmem_rd_data_b,
			cmem_wr_data_a           => smp_cmem_wr_data_a,
			cmem_addr_a              => smp_cmem_addr_a,
			cmem_wr_en_a             => smp_cmem_wr_en_a,
			cmem_rd_data_a           => smp_cmem_rd_data_a,
			sysmem_addr 			 => smp_sysmem_addr_a,
			sysmem_rd_data  		 => smp_sysmem_rd_data_a,
			--sysmem_addr_a            => smp_sysmem_addr_a,
			--sysmem_wr_en_a           => smp_sysmem_wr_en_a,
			--sysmem_rd_data_a         => smp_sysmem_rd_data_a,
			--sysmem_addr_b            => smp_sysmem_addr_b,
			--sysmem_wr_en_b           => smp_sysmem_wr_en_b,
			--sysmem_rd_data_b         => smp_sysmem_rd_data_b,
			smp_done				 => smp_done
		);

	-- WAITING FOR 2ND SMP INSERTION
	smp_sysmem_addr_b <= (others => '0');

	--
	-- Global Memory
	--
	gmem_wr_data_a     <= gmem_wr_data_a_in when (gmem_cntrl_en_in = '1') else smp_gmem_wr_data_a;
	gmem_addr_a        <= gmem_addr_a_in when (gmem_cntrl_en_in = '1') else smp_gmem_addr_a;
	gmem_wr_en_a       <= gmem_wr_en_a_in when (gmem_cntrl_en_in = '1') else smp_gmem_wr_en_a;
	gmem_rd_data_a_out <= gmem_rd_data_a when (gmem_cntrl_en_in = '1') else (others => '0');
	smp_gmem_rd_data_a <= gmem_rd_data_a when (gmem_cntrl_en_in = '0') else (others => '0');

	gmem_wr_data_b     <= gmem_wr_data_b_in when (gmem_cntrl_en_in = '1') else smp_gmem_wr_data_b;
	gmem_addr_b        <= gmem_addr_b_in when (gmem_cntrl_en_in = '1') else smp_gmem_addr_b;
	gmem_wr_en_b       <= gmem_wr_en_b_in when (gmem_cntrl_en_in = '1') else smp_gmem_wr_en_b;
	gmem_rd_data_b_out <= gmem_rd_data_b when (gmem_cntrl_en_in = '1') else (others => '0');
	smp_gmem_rd_data_b <= gmem_rd_data_b when (gmem_cntrl_en_in = '0') else (others => '0');

	uGlobalMemory : dp_ram 
	generic map(
		RAM_SIZE => 262144, 
		RAM_A_WIDTH => GMEM_ADDR_SIZE, 
		RAM_D_WIDTH => 8
		-- synthesis translate_off
	    ,
	    RAM_INIT_FILE => "./global_mem.mif" 					--check this one !!!!!
		-- synthesis translate_on
	)
	port map(
		rst  => host_reset,
		clk  => sys_clk,
		addr_a => gmem_addr_a,
		we_a   => gmem_wr_en_a,
		din_a  => gmem_wr_data_a,
		dout_a => gmem_rd_data_a,
		addr_b => gmem_addr_b,
		we_b   => gmem_wr_en_b,
		din_b  => gmem_wr_data_b,
		dout_b => gmem_rd_data_b
	);

	--
	-- Constant Memory
	--
	cmem_wr_data_a     <= cmem_wr_data_a_in when (cmem_cntrl_en_in = '1') else (others => '0');
	cmem_addr_a        <= cmem_addr_a_in when (cmem_cntrl_en_in = '1') else smp_cmem_addr_a;
	cmem_wr_en_a       <= cmem_wr_en_a_in when (cmem_cntrl_en_in = '1') else '0';
	cmem_rd_data_a_out <= cmem_rd_data_a when (cmem_cntrl_en_in = '1') else (others => '0');
	smp_cmem_rd_data_a <= cmem_rd_data_a when (cmem_cntrl_en_in = '0') else (others => '0');

	
	cmem_wr_data_b     <= cmem_wr_data_b_in when (cmem_cntrl_en_in = '1') else (others => '0');   -- port b is not used by SMP
	cmem_addr_b        <= cmem_addr_b_in when (cmem_cntrl_en_in = '1') else (others => '0');
	cmem_wr_en_b       <= cmem_wr_en_b_in when (cmem_cntrl_en_in = '1') else  '0';
	cmem_rd_data_b_out <= cmem_rd_data_b when (cmem_cntrl_en_in = '1') else (others => '0');

	uConstantMemory : dp_ram generic map(RAM_SIZE => 8192, RAM_A_WIDTH => CMEM_ADDR_SIZE, RAM_D_WIDTH => 8
		-- synthesis translate_off
	    ,
	    RAM_INIT_FILE => "./constant_mem.mif" 							-- check this one again, which constants it has??
		-- synthesis translate_on
	)
	port map(
		rst  => host_reset,
		clk  => sys_clk,
		addr_a => cmem_addr_a,
		we_a   => cmem_wr_en_a,
		din_a  => cmem_wr_data_a,
		dout_a => cmem_rd_data_a,
		addr_b => cmem_addr_b,
		we_b   => cmem_wr_en_b,
		din_b  => cmem_wr_data_b,
		dout_b => cmem_rd_data_b
	);

	--
	-- System Memory
	--
	sysmem_wr_data_a     <= sysmem_wr_data_a_in when (sysmem_cntrl_en_in = '1') else (others => '0');
	sysmem_addr_a        <= sysmem_addr_a_in when (sysmem_cntrl_en_in = '1') else smp_sysmem_addr_a;
	sysmem_wr_en_a       <= sysmem_wr_en_a_in when (sysmem_cntrl_en_in = '1') else '0';
	sysmem_rd_data_a_out <= sysmem_rd_data_a when (sysmem_cntrl_en_in = '1') else (others => '0');
	smp_sysmem_rd_data_a <= sysmem_rd_data_a when (sysmem_cntrl_en_in = '0') else (others => '0');

	sysmem_wr_data_b     <= sysmem_wr_data_b_in when (sysmem_cntrl_en_in = '1') else (others => '0');
	sysmem_addr_b        <= sysmem_addr_b_in when (sysmem_cntrl_en_in = '1') else smp_sysmem_addr_b;
	sysmem_wr_en_b       <= sysmem_wr_en_b_in when (sysmem_cntrl_en_in = '1') else '0';
	sysmem_rd_data_b_out <= sysmem_rd_data_b when (sysmem_cntrl_en_in = '1') else (others => '0');
	smp_sysmem_rd_data_b <= sysmem_rd_data_b when (sysmem_cntrl_en_in = '0') else (others => '0');

	uSystemMemoryController : system_memory_cntlr
    generic map(SYSMEM_ADDR_SIZE => SYSMEM_ADDR_SIZE)
	port map(
		clk_in         => sys_clk,
		mem_data_in_a  => sysmem_wr_data_a,
		mem_addr_in_a  => sysmem_addr_a,
		mem_wr_en_a    => sysmem_wr_en_a,
		mem_data_out_a => sysmem_rd_data_a,
		mem_data_in_b  => sysmem_wr_data_b,
		mem_addr_in_b  => sysmem_addr_b,
		mem_wr_en_b    => sysmem_wr_en_b,
		mem_data_out_b => sysmem_rd_data_b
	);

end arch;
