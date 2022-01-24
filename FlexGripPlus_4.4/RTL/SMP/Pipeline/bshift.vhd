-- bshift.vhdl  A barrel shifter for 32 bit words

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity bshift is
	port(
		datain    : in  std_logic_vector(31 downto 0);
		direction : in  std_logic;
		count     : in  std_logic_vector(4 downto 0);
		dataout   : out std_logic_vector(31 downto 0)
	);
end bshift;

architecture arch of bshift is
	
	function barrel_shift(din : in std_logic_vector(31 downto 0);
			              dir : in std_logic;
			              cnt : in std_logic_vector(4 downto 0)) return std_logic_vector is
	begin
		if (dir = '1') then
			return std_logic_vector(shift_right(unsigned(din), to_integer(unsigned(cnt))));
		else
			return std_logic_vector(shift_left(unsigned(din), to_integer(unsigned(cnt))));
		end if;
	end barrel_shift;

begin
	
	P1 : process(datain, direction, count)
	begin
		dataout <= barrel_shift(datain, direction, count);
	end process;

end arch;
