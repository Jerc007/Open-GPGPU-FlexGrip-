----------------------------------------------------------------------------------
-- Company:          Univerity of Massachusetts 
-- Engineer:         Kevin Andryc
-- 
-- Create Date:      17:50:27 09/19/2010  
-- Module Name:      gpgpu_configuration - arch 
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

entity gpgpu_configuration is
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
end gpgpu_configuration;

architecture arch of gpgpu_configuration is
	
	type registers_type is array (63 downto 0) of std_logic_vector(31 downto 0);

	signal config_regs           : registers_type;
	
	constant config_regs_default : registers_type := ( --  63(3F)
		x"00000000", x"00000000", x"00000000", x"00000000", -- 60
		x"00000000", x"00000000", x"00000000", x"00000000", -- 56
		x"00000000", x"00000000", x"00000000", x"00000000", -- 52
		x"00000000", x"00000000", x"00000000", x"00000000", -- 48
		x"00000000", x"00000000", x"00000000", x"00000000", -- 44
		x"00000000", x"00000000", x"00000000", x"00000000", -- 40
		x"00000000", x"00000000", x"00000000", x"00000000", -- 36
		x"00000000", x"00000000", x"00000000", x"00000000", -- 32 
		x"00000000", x"00000000", x"00000000", x"00000000", -- 28
		x"00000000", x"00000000", x"00000000", x"00000000", -- 24
		x"00000000", x"00000000", x"00000000", x"00000000", -- 20
		x"00000000", x"00000000", x"00000000", x"00000000", -- 16
		x"00000000", x"00000000", x"00000000", x"00000000", -- 12
		x"00000000", x"00000000", x"00000001", x"00000003", -- 8
		x"00000001", x"00000010", x"00000010", x"00000000", -- 4
	--	x"00000000", x"00000020", x"0000000B", x"00000001"); -- 0

		x"00000000", x"00000010", x"0000000B", x"00000001"); -- 0  original

begin

	kernel_blocks_per_core <= config_regs(0)(3 downto 0);  --addr 0      -- calculated: MIN(MIN(config_max_vgpr/(kernel_num_gprs * kernel_warps_per_block), kernel_shmem_size / kernel_shmem_total_size), MIN(config_max_ctas, config_max_warps / kernel_warps_per_block)) 
	kernel_num_gprs        <= config_regs(1)(8 downto 0);  --addr 1      -- kernel param from bin cubin (reg)
	kernel_shmem_size      <= config_regs(2)(31 downto 0); --addr 2      -- kernel param from bin cubin (smem)
	kernel_parameter_size  <= config_regs(3)(15 downto 0); --addr 3      -- dynamic kernel param -- from pickbench (??)
	kernel_dyn_shmem_size  <= config_regs(4)(31 downto 0); --addr 4      -- dynamic kernel param -- from pickbench (??)
	kernel_block_x         <= config_regs(5)(15 downto 0); --addr 5      -- dynamic kernel param -- from pickbench (??)
	kernel_block_y         <= config_regs(6)(15 downto 0); --addr 6      -- dynamic kernel param -- from driver (??)
	kernel_block_z         <= config_regs(7)(15 downto 0); --addr 7      -- dynamic kernel param -- from driver (??)
	kernel_grid_x          <= config_regs(8)(15 downto 0); --addr 8      -- dynamic kernel param -- from driver (??)
	kernel_grid_y          <= config_regs(9)(15 downto 0); --addr 9      -- dynamic kernel param -- from driver (??)

	--kernel_warps_per_block      <= config_regs(22) (31 downto 0);    --addr 22      -- calculated: (kernel_warps_per_block + config_warp_size - 1) / config_warp_size;
	--kernel_blocks_per_core      <= config_regs(23) (31 downto 0);    --addr 23      -- calculated: MIN(MIN(config_max_vgpr/(kernel_num_gprs * kernel_warps_per_block), kernel_shmem_size / kernel_shmem_total_size), MIN(config_max_ctas, config_max_warps / kernel_warps_per_block)) 
	--kernel_shmem_total_size     <= config_regs(28) (31 downto 0);    --addr 28      -- calculated: (16 + kernel_parameter_size + kernel_shmem_size + kernel_dyn_shmem_size + 255) & (~255)

	-- This generate Loop creates the 64 debug registers, and controls the write accesses to them. 
	
	gLoopRegistersWrite : for i in 0 to 63 generate							-- check implementation in rtl of this modules. 

		pConfigRegistersWrite : process(clk_in, host_reset, reset_registers)
		begin
			if (host_reset = '1' or reset_registers = '1') then
				config_regs(i) <= config_regs_default(i);
			elsif (rising_edge(clk_in)) then
				if (config_reg_cs = '1' and config_reg_rw = '0') then
					if (config_reg_adr = std_logic_vector(to_unsigned(i, 32))) then
						config_regs(i)(31 downto 0) <= config_reg_data_in;
					end if;
				end if;
			end if;
		end process;
	end generate;

	gLoopRegistersRead : for i in 0 to 63 generate
		pConfigRegistersRead : process(clk_in, host_reset, reset_registers)
		begin
			if (host_reset = '1' or reset_registers = '1') then
				config_reg_data_out <= (others => '0');
			elsif (rising_edge(clk_in)) then
				if (config_reg_cs = '1' and config_reg_rw = '1') then
					for i in 0 to 63 loop													--
						if (config_reg_adr = std_logic_vector(to_unsigned(i, 32))) then
							config_reg_data_out <= config_regs(i);
						end if;
					end loop;
				end if;
			end if;
		end process;
	end generate;

end arch;

