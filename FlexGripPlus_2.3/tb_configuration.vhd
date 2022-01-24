--------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:02:25 03/22/2013 
-- Design Name: 
-- Module Name:    tb_configuration - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.gpgpu_package.all;

entity tb_configuration is
	generic(
		APPLICATION : string := "MATRIX_MULT"
	);
	port(
		clk                   : in  std_logic;
		reset                 : in  std_logic;
		reset_registers       : in  std_logic;
		cmem_reg_cs           : in  std_logic;
		cmem_reg_rw           : in  std_logic;
		cmem_reg_adr          : in  std_logic_vector(5 downto 0);
		cmem_reg_data_in      : in  std_logic_vector(7 downto 0);
		cmem_reg_data_out     : out std_logic_vector(7 downto 0);
		kernel_reg_cs         : in  std_logic;
		kernel_reg_rw         : in  std_logic;
		kernel_reg_adr        : in  std_logic_vector(3 downto 0);
		kernel_reg_data_in    : in  std_logic_vector(31 downto 0);
		kernel_reg_data_out   : out std_logic_vector(31 downto 0);
		cmem_param_size_out   : out std_logic_vector(5 downto 0);
		kernel_param_size_out : out std_logic_vector(3 downto 0);
		kernel_block_x_out    : out std_logic_vector(15 downto 0);
		kernel_block_y_out    : out std_logic_vector(15 downto 0);
		kernel_block_z_out    : out std_logic_vector(15 downto 0);
		kernel_grid_x_out     : out std_logic_vector(15 downto 0);
		kernel_grid_y_out     : out std_logic_vector(15 downto 0);
		kernel_gprs_out       : out std_logic_vector(8 downto 0);
		kernel_shmem_size_out : out std_logic_vector(31 downto 0);
		blocks_per_core_out   : out std_logic_vector(3 downto 0)
	);
end tb_configuration;

architecture Behavioral of tb_configuration is

	component autocor_configuration
		port(
			clk                   : in  std_logic;
			reset                 : in  std_logic;
			reset_registers       : in  std_logic;
			cmem_reg_cs           : in  std_logic;
			cmem_reg_rw           : in  std_logic;
			cmem_reg_adr          : in  std_logic_vector(5 downto 0);
			cmem_reg_data_in      : in  std_logic_vector(7 downto 0);
			cmem_reg_data_out     : out std_logic_vector(7 downto 0);
			kernel_reg_cs         : in  std_logic;
			kernel_reg_rw         : in  std_logic;
			kernel_reg_adr        : in  std_logic_vector(3 downto 0);
			kernel_reg_data_in    : in  std_logic_vector(31 downto 0);
			kernel_reg_data_out   : out std_logic_vector(31 downto 0);
			cmem_param_size_out   : out std_logic_vector(5 downto 0);
			kernel_param_size_out : out std_logic_vector(3 downto 0);
			kernel_block_x_out    : out std_logic_vector(15 downto 0);
			kernel_block_y_out    : out std_logic_vector(15 downto 0);
			kernel_block_z_out    : out std_logic_vector(15 downto 0);
			kernel_grid_x_out     : out std_logic_vector(15 downto 0);
			kernel_grid_y_out     : out std_logic_vector(15 downto 0);
			kernel_gprs_out       : out std_logic_vector(8 downto 0);
			kernel_shmem_size_out : out std_logic_vector(31 downto 0);
			blocks_per_core_out   : out std_logic_vector(3 downto 0)
		);
	end component;
    
    component tp_configuration
		port(
			clk                   : in  std_logic;
			reset                 : in  std_logic;
			reset_registers       : in  std_logic;
			cmem_reg_cs           : in  std_logic;
			cmem_reg_rw           : in  std_logic;
			cmem_reg_adr          : in  std_logic_vector(5 downto 0);
			cmem_reg_data_in      : in  std_logic_vector(7 downto 0);
			cmem_reg_data_out     : out std_logic_vector(7 downto 0);
			kernel_reg_cs         : in  std_logic;
			kernel_reg_rw         : in  std_logic;
			kernel_reg_adr        : in  std_logic_vector(3 downto 0);
			kernel_reg_data_in    : in  std_logic_vector(31 downto 0);
			kernel_reg_data_out   : out std_logic_vector(31 downto 0);
			cmem_param_size_out   : out std_logic_vector(5 downto 0);
			kernel_param_size_out : out std_logic_vector(3 downto 0);
			kernel_block_x_out    : out std_logic_vector(15 downto 0);
			kernel_block_y_out    : out std_logic_vector(15 downto 0);
			kernel_block_z_out    : out std_logic_vector(15 downto 0);
			kernel_grid_x_out     : out std_logic_vector(15 downto 0);
			kernel_grid_y_out     : out std_logic_vector(15 downto 0);
			kernel_gprs_out       : out std_logic_vector(8 downto 0);
			kernel_shmem_size_out : out std_logic_vector(31 downto 0);
			blocks_per_core_out   : out std_logic_vector(3 downto 0)
		);
	end component;



    component TP_SHORT_configuration
		port(
			clk                   : in  std_logic;
			reset                 : in  std_logic;
			reset_registers       : in  std_logic;
			cmem_reg_cs           : in  std_logic;
			cmem_reg_rw           : in  std_logic;
			cmem_reg_adr          : in  std_logic_vector(5 downto 0);
			cmem_reg_data_in      : in  std_logic_vector(7 downto 0);
			cmem_reg_data_out     : out std_logic_vector(7 downto 0);
			kernel_reg_cs         : in  std_logic;
			kernel_reg_rw         : in  std_logic;
			kernel_reg_adr        : in  std_logic_vector(3 downto 0);
			kernel_reg_data_in    : in  std_logic_vector(31 downto 0);
			kernel_reg_data_out   : out std_logic_vector(31 downto 0);
			cmem_param_size_out   : out std_logic_vector(5 downto 0);
			kernel_param_size_out : out std_logic_vector(3 downto 0);
			kernel_block_x_out    : out std_logic_vector(15 downto 0);
			kernel_block_y_out    : out std_logic_vector(15 downto 0);
			kernel_block_z_out    : out std_logic_vector(15 downto 0);
			kernel_grid_x_out     : out std_logic_vector(15 downto 0);
			kernel_grid_y_out     : out std_logic_vector(15 downto 0);
			kernel_gprs_out       : out std_logic_vector(8 downto 0);
			kernel_shmem_size_out : out std_logic_vector(31 downto 0);
			blocks_per_core_out   : out std_logic_vector(3 downto 0)
		);
	end component;
	

    component TP_LONG_configuration
		port(
			clk                   : in  std_logic;
			reset                 : in  std_logic;
			reset_registers       : in  std_logic;
			cmem_reg_cs           : in  std_logic;
			cmem_reg_rw           : in  std_logic;
			cmem_reg_adr          : in  std_logic_vector(5 downto 0);
			cmem_reg_data_in      : in  std_logic_vector(7 downto 0);
			cmem_reg_data_out     : out std_logic_vector(7 downto 0);
			kernel_reg_cs         : in  std_logic;
			kernel_reg_rw         : in  std_logic;
			kernel_reg_adr        : in  std_logic_vector(3 downto 0);
			kernel_reg_data_in    : in  std_logic_vector(31 downto 0);
			kernel_reg_data_out   : out std_logic_vector(31 downto 0);
			cmem_param_size_out   : out std_logic_vector(5 downto 0);
			kernel_param_size_out : out std_logic_vector(3 downto 0);
			kernel_block_x_out    : out std_logic_vector(15 downto 0);
			kernel_block_y_out    : out std_logic_vector(15 downto 0);
			kernel_block_z_out    : out std_logic_vector(15 downto 0);
			kernel_grid_x_out     : out std_logic_vector(15 downto 0);
			kernel_grid_y_out     : out std_logic_vector(15 downto 0);
			kernel_gprs_out       : out std_logic_vector(8 downto 0);
			kernel_shmem_size_out : out std_logic_vector(31 downto 0);
			blocks_per_core_out   : out std_logic_vector(3 downto 0)
		);
	end component;
	
	
	
	
	
	
	
	
	
	
	
	component bitonic_sort_configuration
		port(
			clk                   : in  std_logic;
			reset                 : in  std_logic;
			reset_registers       : in  std_logic;
			cmem_reg_cs           : in  std_logic;
			cmem_reg_rw           : in  std_logic;
			cmem_reg_adr          : in  std_logic_vector(5 downto 0);
			cmem_reg_data_in      : in  std_logic_vector(7 downto 0);
			cmem_reg_data_out     : out std_logic_vector(7 downto 0);
			kernel_reg_cs         : in  std_logic;
			kernel_reg_rw         : in  std_logic;
			kernel_reg_adr        : in  std_logic_vector(3 downto 0);
			kernel_reg_data_in    : in  std_logic_vector(31 downto 0);
			kernel_reg_data_out   : out std_logic_vector(31 downto 0);
			cmem_param_size_out   : out std_logic_vector(5 downto 0);
			kernel_param_size_out : out std_logic_vector(3 downto 0);
			kernel_block_x_out    : out std_logic_vector(15 downto 0);
			kernel_block_y_out    : out std_logic_vector(15 downto 0);
			kernel_block_z_out    : out std_logic_vector(15 downto 0);
			kernel_grid_x_out     : out std_logic_vector(15 downto 0);
			kernel_grid_y_out     : out std_logic_vector(15 downto 0);
			kernel_gprs_out       : out std_logic_vector(8 downto 0);
			kernel_shmem_size_out : out std_logic_vector(31 downto 0);
			blocks_per_core_out   : out std_logic_vector(3 downto 0)
		);
	end component;

	component matrix_mult_configuration
		port(
			clk                   : in  std_logic;
			reset                 : in  std_logic;
			reset_registers       : in  std_logic;
			cmem_reg_cs           : in  std_logic;
			cmem_reg_rw           : in  std_logic;
			cmem_reg_adr          : in  std_logic_vector(5 downto 0);
			cmem_reg_data_in      : in  std_logic_vector(7 downto 0);
			cmem_reg_data_out     : out std_logic_vector(7 downto 0);
			kernel_reg_cs         : in  std_logic;
			kernel_reg_rw         : in  std_logic;
			kernel_reg_adr        : in  std_logic_vector(3 downto 0);
			kernel_reg_data_in    : in  std_logic_vector(31 downto 0);
			kernel_reg_data_out   : out std_logic_vector(31 downto 0);
			cmem_param_size_out   : out std_logic_vector(5 downto 0);
			kernel_param_size_out : out std_logic_vector(3 downto 0);
			kernel_block_x_out    : out std_logic_vector(15 downto 0);
			kernel_block_y_out    : out std_logic_vector(15 downto 0);
			kernel_block_z_out    : out std_logic_vector(15 downto 0);
			kernel_grid_x_out     : out std_logic_vector(15 downto 0);
			kernel_grid_y_out     : out std_logic_vector(15 downto 0);
			kernel_gprs_out       : out std_logic_vector(8 downto 0);
			kernel_shmem_size_out : out std_logic_vector(31 downto 0);
			blocks_per_core_out   : out std_logic_vector(3 downto 0)
		);
	end component;

	component reduction_configuration
		port(
			clk                   : in  std_logic;
			reset                 : in  std_logic;
			reset_registers       : in  std_logic;
			cmem_reg_cs           : in  std_logic;
			cmem_reg_rw           : in  std_logic;
			cmem_reg_adr          : in  std_logic_vector(5 downto 0);
			cmem_reg_data_in      : in  std_logic_vector(7 downto 0);
			cmem_reg_data_out     : out std_logic_vector(7 downto 0);
			kernel_reg_cs         : in  std_logic;
			kernel_reg_rw         : in  std_logic;
			kernel_reg_adr        : in  std_logic_vector(3 downto 0);
			kernel_reg_data_in    : in  std_logic_vector(31 downto 0);
			kernel_reg_data_out   : out std_logic_vector(31 downto 0);
			cmem_param_size_out   : out std_logic_vector(5 downto 0);
			kernel_param_size_out : out std_logic_vector(3 downto 0);
			kernel_block_x_out    : out std_logic_vector(15 downto 0);
			kernel_block_y_out    : out std_logic_vector(15 downto 0);
			kernel_block_z_out    : out std_logic_vector(15 downto 0);
			kernel_grid_x_out     : out std_logic_vector(15 downto 0);
			kernel_grid_y_out     : out std_logic_vector(15 downto 0);
			kernel_gprs_out       : out std_logic_vector(8 downto 0);
			kernel_shmem_size_out : out std_logic_vector(31 downto 0);
			blocks_per_core_out   : out std_logic_vector(3 downto 0)
		);
	end component;

	component transpose_configuration
		port(
			clk                   : in  std_logic;
			reset                 : in  std_logic;
			reset_registers       : in  std_logic;
			cmem_reg_cs           : in  std_logic;
			cmem_reg_rw           : in  std_logic;
			cmem_reg_adr          : in  std_logic_vector(5 downto 0);
			cmem_reg_data_in      : in  std_logic_vector(7 downto 0);
			cmem_reg_data_out     : out std_logic_vector(7 downto 0);
			kernel_reg_cs         : in  std_logic;
			kernel_reg_rw         : in  std_logic;
			kernel_reg_adr        : in  std_logic_vector(3 downto 0);
			kernel_reg_data_in    : in  std_logic_vector(31 downto 0);
			kernel_reg_data_out   : out std_logic_vector(31 downto 0);
			cmem_param_size_out   : out std_logic_vector(5 downto 0);
			kernel_param_size_out : out std_logic_vector(3 downto 0);
			kernel_block_x_out    : out std_logic_vector(15 downto 0);
			kernel_block_y_out    : out std_logic_vector(15 downto 0);
			kernel_block_z_out    : out std_logic_vector(15 downto 0);
			kernel_grid_x_out     : out std_logic_vector(15 downto 0);
			kernel_grid_y_out     : out std_logic_vector(15 downto 0);
			kernel_gprs_out       : out std_logic_vector(8 downto 0);
			kernel_shmem_size_out : out std_logic_vector(31 downto 0);
			blocks_per_core_out   : out std_logic_vector(3 downto 0)
		);
	end component;

begin
	gAUTOCOR_CONFIGURATION : if APPLICATION = "AUTOCORR" generate
		uAutocorConfiguration : autocor_configuration
			port map(
				clk                   => clk,
				reset                 => reset,
				reset_registers       => reset_registers,
				cmem_reg_cs           => cmem_reg_cs,
				cmem_reg_rw           => cmem_reg_rw,
				cmem_reg_adr          => cmem_reg_adr,
				cmem_reg_data_in      => cmem_reg_data_in,
				cmem_reg_data_out     => cmem_reg_data_out,
				kernel_reg_cs         => kernel_reg_cs,
				kernel_reg_rw         => kernel_reg_rw,
				kernel_reg_adr        => kernel_reg_adr,
				kernel_reg_data_in    => kernel_reg_data_in,
				kernel_reg_data_out   => kernel_reg_data_out,
				cmem_param_size_out   => cmem_param_size_out,
				kernel_param_size_out => kernel_param_size_out,
				kernel_block_x_out    => kernel_block_x_out,
				kernel_block_y_out    => kernel_block_y_out,
				kernel_block_z_out    => kernel_block_z_out,
				kernel_grid_x_out     => kernel_grid_x_out,
				kernel_grid_y_out     => kernel_grid_y_out,
				kernel_gprs_out       => kernel_gprs_out,
				kernel_shmem_size_out => kernel_shmem_size_out,
				blocks_per_core_out   => blocks_per_core_out
			);
	end generate;

    gTP_CONFIGURATION : if APPLICATION = "TP" generate
		uTPConfiguration : tp_configuration
			port map(
				clk                   => clk,
				reset                 => reset,
				reset_registers       => reset_registers,
				cmem_reg_cs           => cmem_reg_cs,
				cmem_reg_rw           => cmem_reg_rw,
				cmem_reg_adr          => cmem_reg_adr,
				cmem_reg_data_in      => cmem_reg_data_in,
				cmem_reg_data_out     => cmem_reg_data_out,
				kernel_reg_cs         => kernel_reg_cs,
				kernel_reg_rw         => kernel_reg_rw,
				kernel_reg_adr        => kernel_reg_adr,
				kernel_reg_data_in    => kernel_reg_data_in,
				kernel_reg_data_out   => kernel_reg_data_out,
				cmem_param_size_out   => cmem_param_size_out,
				kernel_param_size_out => kernel_param_size_out,
				kernel_block_x_out    => kernel_block_x_out,
				kernel_block_y_out    => kernel_block_y_out,
				kernel_block_z_out    => kernel_block_z_out,
				kernel_grid_x_out     => kernel_grid_x_out,
				kernel_grid_y_out     => kernel_grid_y_out,
				kernel_gprs_out       => kernel_gprs_out,
				kernel_shmem_size_out => kernel_shmem_size_out,
				blocks_per_core_out   => blocks_per_core_out
			);
	end generate;

		
	gTP_LONG_CONFIGURATION : if APPLICATION = "TP_LONG" generate
		uTPConfiguration : TP_LONG_configuration
			port map(
				clk                   => clk,
				reset                 => reset,
				reset_registers       => reset_registers,
				cmem_reg_cs           => cmem_reg_cs,
				cmem_reg_rw           => cmem_reg_rw,
				cmem_reg_adr          => cmem_reg_adr,
				cmem_reg_data_in      => cmem_reg_data_in,
				cmem_reg_data_out     => cmem_reg_data_out,
				kernel_reg_cs         => kernel_reg_cs,
				kernel_reg_rw         => kernel_reg_rw,
				kernel_reg_adr        => kernel_reg_adr,
				kernel_reg_data_in    => kernel_reg_data_in,
				kernel_reg_data_out   => kernel_reg_data_out,
				cmem_param_size_out   => cmem_param_size_out,
				kernel_param_size_out => kernel_param_size_out,
				kernel_block_x_out    => kernel_block_x_out,
				kernel_block_y_out    => kernel_block_y_out,
				kernel_block_z_out    => kernel_block_z_out,
				kernel_grid_x_out     => kernel_grid_x_out,
				kernel_grid_y_out     => kernel_grid_y_out,
				kernel_gprs_out       => kernel_gprs_out,
				kernel_shmem_size_out => kernel_shmem_size_out,
				blocks_per_core_out   => blocks_per_core_out
			);
	end generate;

	gTP_SHORT_CONFIGURATION : if APPLICATION = "TP_SHORT" generate
		uTPConfiguration : TP_SHORT_configuration
			port map(
				clk                   => clk,
				reset                 => reset,
				reset_registers       => reset_registers,
				cmem_reg_cs           => cmem_reg_cs,
				cmem_reg_rw           => cmem_reg_rw,
				cmem_reg_adr          => cmem_reg_adr,
				cmem_reg_data_in      => cmem_reg_data_in,
				cmem_reg_data_out     => cmem_reg_data_out,
				kernel_reg_cs         => kernel_reg_cs,
				kernel_reg_rw         => kernel_reg_rw,
				kernel_reg_adr        => kernel_reg_adr,
				kernel_reg_data_in    => kernel_reg_data_in,
				kernel_reg_data_out   => kernel_reg_data_out,
				cmem_param_size_out   => cmem_param_size_out,
				kernel_param_size_out => kernel_param_size_out,
				kernel_block_x_out    => kernel_block_x_out,
				kernel_block_y_out    => kernel_block_y_out,
				kernel_block_z_out    => kernel_block_z_out,
				kernel_grid_x_out     => kernel_grid_x_out,
				kernel_grid_y_out     => kernel_grid_y_out,
				kernel_gprs_out       => kernel_gprs_out,
				kernel_shmem_size_out => kernel_shmem_size_out,
				blocks_per_core_out   => blocks_per_core_out
			);
	end generate;

	
	
	
	
	
	

	gBITONIC_SORT_CONFIGURATION : if APPLICATION = "BITONIC_SORT" generate
		uBitonicSortConfiguration : bitonic_sort_configuration
			port map(
				clk                   => clk,
				reset                 => reset,
				reset_registers       => reset_registers,
				cmem_reg_cs           => cmem_reg_cs,
				cmem_reg_rw           => cmem_reg_rw,
				cmem_reg_adr          => cmem_reg_adr,
				cmem_reg_data_in      => cmem_reg_data_in,
				cmem_reg_data_out     => cmem_reg_data_out,
				kernel_reg_cs         => kernel_reg_cs,
				kernel_reg_rw         => kernel_reg_rw,
				kernel_reg_adr        => kernel_reg_adr,
				kernel_reg_data_in    => kernel_reg_data_in,
				kernel_reg_data_out   => kernel_reg_data_out,
				cmem_param_size_out   => cmem_param_size_out,
				kernel_param_size_out => kernel_param_size_out,
				kernel_block_x_out    => kernel_block_x_out,
				kernel_block_y_out    => kernel_block_y_out,
				kernel_block_z_out    => kernel_block_z_out,
				kernel_grid_x_out     => kernel_grid_x_out,
				kernel_grid_y_out     => kernel_grid_y_out,
				kernel_gprs_out       => kernel_gprs_out,
				kernel_shmem_size_out => kernel_shmem_size_out,
				blocks_per_core_out   => blocks_per_core_out
			);
	end generate;

	gMATRIX_MULT_CONFIGURATION : if APPLICATION = "MATRIX_MULT" generate
		uMatrixMultConfiguration : matrix_mult_configuration
			port map(
				clk                   => clk,
				reset                 => reset,
				reset_registers       => reset_registers,
				cmem_reg_cs           => cmem_reg_cs,
				cmem_reg_rw           => cmem_reg_rw,
				cmem_reg_adr          => cmem_reg_adr,
				cmem_reg_data_in      => cmem_reg_data_in,
				cmem_reg_data_out     => cmem_reg_data_out,
				kernel_reg_cs         => kernel_reg_cs,
				kernel_reg_rw         => kernel_reg_rw,
				kernel_reg_adr        => kernel_reg_adr,
				kernel_reg_data_in    => kernel_reg_data_in,
				kernel_reg_data_out   => kernel_reg_data_out,
				cmem_param_size_out   => cmem_param_size_out,
				kernel_param_size_out => kernel_param_size_out,
				kernel_block_x_out    => kernel_block_x_out,
				kernel_block_y_out    => kernel_block_y_out,
				kernel_block_z_out    => kernel_block_z_out,
				kernel_grid_x_out     => kernel_grid_x_out,
				kernel_grid_y_out     => kernel_grid_y_out,
				kernel_gprs_out       => kernel_gprs_out,
				kernel_shmem_size_out => kernel_shmem_size_out,
				blocks_per_core_out   => blocks_per_core_out
			);
	end generate;

	gREDUCTION_CONFIGURATION : if APPLICATION = "REDUCTION" generate
		uReductionConfiguration : reduction_configuration
			port map(
				clk                   => clk,
				reset                 => reset,
				reset_registers       => reset_registers,
				cmem_reg_cs           => cmem_reg_cs,
				cmem_reg_rw           => cmem_reg_rw,
				cmem_reg_adr          => cmem_reg_adr,
				cmem_reg_data_in      => cmem_reg_data_in,
				cmem_reg_data_out     => cmem_reg_data_out,
				kernel_reg_cs         => kernel_reg_cs,
				kernel_reg_rw         => kernel_reg_rw,
				kernel_reg_adr        => kernel_reg_adr,
				kernel_reg_data_in    => kernel_reg_data_in,
				kernel_reg_data_out   => kernel_reg_data_out,
				cmem_param_size_out   => cmem_param_size_out,
				kernel_param_size_out => kernel_param_size_out,
				kernel_block_x_out    => kernel_block_x_out,
				kernel_block_y_out    => kernel_block_y_out,
				kernel_block_z_out    => kernel_block_z_out,
				kernel_grid_x_out     => kernel_grid_x_out,
				kernel_grid_y_out     => kernel_grid_y_out,
				kernel_gprs_out       => kernel_gprs_out,
				kernel_shmem_size_out => kernel_shmem_size_out,
				blocks_per_core_out   => blocks_per_core_out
			);
	end generate;

	gTRANSPOSE_CONFIGURATION : if APPLICATION = "TRANSPOSE" generate
		uTransposeConfiguration : transpose_configuration
			port map(
				clk                   => clk,
				reset                 => reset,
				reset_registers       => reset_registers,
				cmem_reg_cs           => cmem_reg_cs,
				cmem_reg_rw           => cmem_reg_rw,
				cmem_reg_adr          => cmem_reg_adr,
				cmem_reg_data_in      => cmem_reg_data_in,
				cmem_reg_data_out     => cmem_reg_data_out,
				kernel_reg_cs         => kernel_reg_cs,
				kernel_reg_rw         => kernel_reg_rw,
				kernel_reg_adr        => kernel_reg_adr,
				kernel_reg_data_in    => kernel_reg_data_in,
				kernel_reg_data_out   => kernel_reg_data_out,
				cmem_param_size_out   => cmem_param_size_out,
				kernel_param_size_out => kernel_param_size_out,
				kernel_block_x_out    => kernel_block_x_out,
				kernel_block_y_out    => kernel_block_y_out,
				kernel_block_z_out    => kernel_block_z_out,
				kernel_grid_x_out     => kernel_grid_x_out,
				kernel_grid_y_out     => kernel_grid_y_out,
				kernel_gprs_out       => kernel_gprs_out,
				kernel_shmem_size_out => kernel_shmem_size_out,
				blocks_per_core_out   => blocks_per_core_out
			);
	end generate;

end Behavioral;

