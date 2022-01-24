----------------------------------------------------------------------------------
-- Company:          Univerity of Massachusetts 
-- Engineer:         Kevin Andryc
-- 
-- Create Date:      17:50:27 09/19/2010  
-- Module Name:      fence_registers - arch 
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

entity fence_registers is
	port(
		clk_in       : in  std_logic;
		host_reset   : in  std_logic;
		cta_id_in    : in  std_logic_vector(3 downto 0);
		cta_id_ld    : in  std_logic;
		fence_en_in  : in  std_logic;
		fence_en_ld  : in  std_logic;
		cta_id_out   : out std_logic_vector(3 downto 0);
		fence_en_out : out std_logic
	);
end fence_registers;

architecture arch of fence_registers is

begin
	
	process(clk_in, host_reset)
	begin
		if host_reset = '1' then
			cta_id_out <= (others => '0');
			fence_en_out <= '0';
		elsif rising_edge(clk_in) then
			if fence_en_ld = '1' then
				fence_en_out <= fence_en_in;
			end if;
			
			if cta_id_ld = '1' then
				cta_id_out <= cta_id_in;
			end if;
		end if;
	end process;
end arch;

