--------------------------------------------------------------------------
-- VHDL : logic_shift.vhd
--   Generic logic_shift
--		[WARNING] ce_1 and ck_1 are ignored
-- 		[TODO]
--------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shift_logical is
	port(
		a_in         : in  std_logic_vector(31 downto 0);				-- Input
		b_in         : in  std_logic_vector(31 downto 0);				-- Control line
		is_signed_in : in  std_logic;									-- control input
		w32_in       : in  std_logic;									-- control input
		sll_out      : out std_logic_vector(31 downto 0);				-- Output left
		srl_out      : out std_logic_vector(31 downto 0)				-- Output rigth
	);
end shift_logical;

architecture shift_logic_archi of shift_logical is
begin
	COMP_PROC : process(a_in, b_in, is_signed_in, w32_in)
	begin
		if(w32_in = '1') then											-- working with 32 bits format??
			if(unsigned(b_in) > 32) then    							-- Control comparison, am I in the limit???
				sll_out <= (others => '0');
				if(is_signed_in = '1') then
					srl_out <= (others => a_in(31));					-- Copy of the sign bit
				else
					srl_out <= (others => '0');
				end if;
			else
				sll_out <= std_logic_vector(shift_left(unsigned(a_in), to_integer(unsigned(b_in))));

				if(is_signed_in = '1') then
					srl_out <= std_logic_vector(shift_right(signed(a_in), to_integer(unsigned(b_in))));
				else
					srl_out <= std_logic_vector(shift_right(unsigned(a_in), to_integer(unsigned(b_in))));
				end if;
			end if;
		else															-- I should be working with 16 bits data format (Bus included??)
			if(unsigned(b_in) > 16) then
				sll_out <= (others => '0');
				if(is_signed_in = '1') then
					srl_out <= (others => a_in(15));
				else
					srl_out <= (others => '0');
				end if;
			else														-- not in the limit
				sll_out <= std_logic_vector(shift_left(unsigned(a_in), to_integer(unsigned(b_in)))) and X"0000FFFF"; -- to keep the limit.

				if(is_signed_in = '1') then
					srl_out <= std_logic_vector(shift_right(shift_left(signed(a_in), 16), 16 + to_integer(unsigned(b_in))));
				else
					srl_out <= std_logic_vector(shift_right(unsigned(a_in and X"0000FFFF"), to_integer(unsigned(b_in))));
				end if;
			end if;
		end if;
	end process COMP_PROC;
end architecture shift_logic_archi;