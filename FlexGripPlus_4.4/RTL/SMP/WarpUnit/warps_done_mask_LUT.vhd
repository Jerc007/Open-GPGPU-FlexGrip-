----------------------------------------------------------------------------------
-- Company:          Univerity of Massachusetts 
-- Engineer:         Murtaza Merchant
-- 
-- Create Date:      08/28/2012  
-- Module Name:      warps_donw_mask_LUT - arch 
-- Project Name:     GPGPU
-- Target Devices: 
-- Tool versions:    ISE 14.1
-- Description: 
--
----------------------------------------------------------------------------
-- Revisions:       
--  REV:        Date:           Description:
--  0.1.a       08/28/2012       Created Top level file 
----------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.gpgpu_package.all;

entity warps_done_lut is
	port(
		clk_in          : in  std_logic;
		host_reset      : in  std_logic;
		num_warps_in    : in  std_logic_vector(4 downto 0);
		warps_done_mask : out std_logic_vector(MAX_WARPS - 1 downto 0)
	);
end warps_done_lut;

architecture arch of warps_done_lut is
	
	type registers_type is array (MAX_WARPS downto 0) of std_logic_vector(MAX_WARPS - 1 downto 0);
	constant warps_done_lut_default : registers_type := (
		 x"FFFFFFFF",  --32
		x"7FFFFFFF", x"3FFFFFFF", x"1FFFFFFF", x"0FFFFFFF",  -- 28
		x"07FFFFFF", x"03FFFFFF", x"01FFFFFF", x"00FFFFFF",  -- 24
		x"007FFFFF", x"003FFFFF", x"001FFFFF", x"000FFFFF", -- 20
		x"0007FFFF", x"0003FFFF", x"0001FFFF", x"0000FFFF", -- 16
		x"00007FFF", x"00003FFF", x"00001FFF", x"00000FFF", -- 12
		x"000007FF", x"000003FF", x"000001FF", x"000000FF", -- 8
		x"0000007F", x"0000003F", x"0000001F", x"0000000F", -- 4   
		x"00000007", x"00000003", x"00000001", x"00000000"); -- 0

begin
	
	pRegisterRead : process(clk_in, host_reset)
	begin	
			if (host_reset = '1') then
				warps_done_mask <= (others => '0');
			elsif (rising_edge(clk_in)) then
				for i in 0 to MAX_WARPS loop
					if (num_warps_in = std_logic_vector(to_unsigned(i, 5))) then
						warps_done_mask <= warps_done_lut_default(i);
					end if;
				end loop;
			end if;
	end process;

end arch;

