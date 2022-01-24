----------------------------------------------------------------------------------
-- Company:          Univerity of Massachusetts 
-- Engineer:         Kevin Andryc
-- 
-- Create Date:      17:50:27 09/19/2010  
-- Module Name:      system_memory_cntlr - arch 
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
-- MODIFIED GIANLUCA ROASCIO - SET MEMORY WIDTH TO 32 BITS
----------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.gpgpu_package.all;

entity system_memory_cntlr is
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
end system_memory_cntlr;

architecture arch of system_memory_cntlr is
begin
	--uSystemMemory : dp_ram generic map(RAM_SIZE => 262144, RAM_A_WIDTH => SYSMEM_ADDR_SIZE, RAM_D_WIDTH => 8
	uSystemMemory : dp_ram generic map(RAM_SIZE => 65536, RAM_A_WIDTH => SYSMEM_ADDR_SIZE, RAM_D_WIDTH => SYSMEM_DATA_SIZE
			-- synthesis translate_off
			,
			RAM_INIT_FILE => "./system_mem.mif"
			-- synthesis translate_on
		)
		port map(
			rst  => '0',
			clk  => clk_in,
			din_a  => mem_data_in_a,
			addr_a => mem_addr_in_a,
			we_a   => mem_wr_en_a,
			dout_a => mem_data_out_a,
			din_b  => mem_data_in_b,
			addr_b => mem_addr_in_b,
			we_b   => mem_wr_en_b,
			dout_b => mem_data_out_b
		);
end arch;

