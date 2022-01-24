--------------------------------------------------------------------------
-- VHDL : min_max.vhd
--   Generic min_max
--		[WARNING] ce_1 and ck_1 are ignored  !!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- 		[TODO]
--------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity min_max is
	port(
		a_in         : in  std_logic_vector(31 downto 0);
		b_in         : in  std_logic_vector(31 downto 0);
		is_signed_in : in  std_logic;
		w32_in       : in  std_logic;
		max_out      : out std_logic_vector(31 downto 0);
		min_out      : out std_logic_vector(31 downto 0)
	);
end min_max;

architecture min_max_archi of min_max is
begin
	COMP_PROC : process(a_in, b_in, is_signed_in, w32_in)
		variable a_signed_16   : signed(31 downto 0);
		variable b_signed_16   : signed(31 downto 0);
		variable a_unsigned_16 : unsigned(31 downto 0);
		variable b_unsigned_16 : unsigned(31 downto 0);
	begin
		if(w32_in = '1') then
			if(is_signed_in = '1') then
				-- signed 32 bit comparison
				if(signed(a_in) < signed(b_in)) then
					min_out <= a_in;
					max_out <= b_in;
				else
					min_out <= b_in;
					max_out <= a_in;
				end if;
			else
				if(unsigned(a_in) < unsigned(b_in)) then
					min_out <= a_in;
					max_out <= b_in;
				else
					min_out <= b_in;
					max_out <= a_in;
				end if;
			end if;
		else
			if(is_signed_in = '1') then
				a_signed_16 := shift_right(shift_left(signed(a_in), 16), 16); -- it is an awful way to extend the sign
				b_signed_16 := shift_right(shift_left(signed(b_in), 16), 16);

				if(a_signed_16 < b_signed_16) then
					min_out <= std_logic_vector(a_signed_16);
					max_out <= std_logic_vector(b_signed_16);
				else
					min_out <= std_logic_vector(b_signed_16);
					max_out <= std_logic_vector(a_signed_16);
				end if;
			else
				a_unsigned_16 := unsigned(a_in) and X"0000FFFF";
				b_unsigned_16 := unsigned(b_in) and X"0000FFFF";

				if(a_unsigned_16 < b_unsigned_16) then
					min_out <= std_logic_vector(a_unsigned_16);
					max_out <= std_logic_vector(b_unsigned_16);
				else
					min_out <= std_logic_vector(b_unsigned_16);
					max_out <= std_logic_vector(a_unsigned_16);
				end if;
			end if;
		end if;
	end process COMP_PROC;

end architecture min_max_archi;