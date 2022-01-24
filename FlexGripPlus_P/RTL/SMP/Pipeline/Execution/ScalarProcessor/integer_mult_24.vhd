--------------------------------------------------------------------------
-- VHDL : integer_mult_24.vhd     behavioral or structural????
--   Generic integer_mult_24
--		[WARNING] ce_1 and ck_1 are ignored, the width is not
-- 		[TODO]
--------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity integer_mult_24 is
	port(
		a_in         : in  std_logic_vector(31 downto 0);
		a_neg_in     : in  std_logic;
		b_in         : in  std_logic_vector(31 downto 0);
		b_neg_in     : in  std_logic;
		is_signed_in : in  std_logic;
		w32_in       : in  std_logic;
		result_out   : out std_logic_vector(31 downto 0)
	);
end integer_mult_24;

architecture int_mult24_archi of integer_mult_24 is
begin


	PROC_MULT24 : process(a_in, a_neg_in, b_in, b_neg_in, w32_in, is_signed_in)		-- why a_neg_in and b_neg_in if are not used???
		variable mult_a_signed   : signed(31 downto 0);
		variable mult_b_signed   : signed(31 downto 0);
		variable mult_a_unsigned : unsigned(31 downto 0);
		variable mult_b_unsigned : unsigned(31 downto 0);

		variable result_tmp : std_logic_vector(63 downto 0);
	begin
		if(is_signed_in = '0') then
			if(a_neg_in = '1') then
				mult_a_unsigned := not (unsigned(a_in)) + 1;			-- 2 complement
			else
				mult_a_unsigned := unsigned(a_in);						-- normal
			end if;

			if(b_neg_in = '1') then
				mult_b_unsigned := not (unsigned(b_in)) + 1;			-- 2 complement
			else
				mult_b_unsigned := unsigned(b_in);						-- normal
			end if;

			if(w32_in = '1') then										-- evitar overflow
				mult_a_unsigned := mult_a_unsigned and X"00FFFFFF";
				mult_b_unsigned := mult_b_unsigned and X"00FFFFFF";
			else
				mult_a_unsigned := mult_a_unsigned and X"0000FFFF";
				mult_b_unsigned := mult_b_unsigned and X"0000FFFF";
			end if;

			result_tmp := std_logic_vector(mult_a_unsigned * mult_b_unsigned);			-- uso de libreria interna.
			result_out <= result_tmp(31 downto 0);
		else			-- not signed opps.
			if(w32_in = '1') then
				mult_a_signed := signed((7 downto 0 => a_in(23)) & a_in(23 downto 0));
				mult_b_signed := signed((7 downto 0 => b_in(23)) & b_in(23 downto 0));
			else
				mult_a_signed := signed((15 downto 0 => a_in(15)) & a_in(15 downto 0));
				mult_b_signed := signed((15 downto 0 => b_in(15)) & b_in(15 downto 0));
			end if;

			if(a_neg_in = '1') then
				mult_a_signed := (not mult_a_signed) + 1;
			end if;

			if(b_neg_in = '1') then
				mult_b_signed := (not mult_b_signed) + 1;
			end if;

			result_tmp := std_logic_vector(mult_a_signed * mult_b_signed);				-- why is not defined a 32 bits output in the entity??
			result_out <= result_tmp(31 downto 0);
		end if;
	end process PROC_MULT24;
end architecture int_mult24_archi;