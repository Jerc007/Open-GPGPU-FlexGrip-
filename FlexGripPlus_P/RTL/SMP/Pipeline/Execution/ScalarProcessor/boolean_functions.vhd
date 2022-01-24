--------------------------------------------------------------------------
-- VHDL : boolean_functions.vhd
--   Generic boolean_functions
--		[WARNING]
-- 		[TODO]
--------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity boolean_functions is
	port(
		a_in    : in  std_logic_vector(31 downto 0);
		b_in    : in  std_logic_vector(31 downto 0);
		and_out : out std_logic_vector(31 downto 0);
		neg_out : out std_logic_vector(31 downto 0);
		or_out  : out std_logic_vector(31 downto 0);
		xor_out : out std_logic_vector(31 downto 0)
	);
end boolean_functions;

architecture bool_func_archi of boolean_functions is
begin
	--BITWISE_GEN: for i in 0 to 31 generate
	--	and_out(i) <= a_in(i) and b_in(i);
	--	neg_out(i) <= not a_in(i);
	--	or_out(i) <= a_in(i) or b_in(i);
	--	xor_out(i) <= a_in(i) xor b_in(i);
	--end generate BITWISE_GEN;
	and_out <= a_in and b_in;
	neg_out <= not a_in;
	or_out  <= a_in or b_in;
	xor_out <= a_in xor b_in;
end architecture bool_func_archi;