--------------------------------------------------------------------------
-- VHDL : compute_set_pred_i.vhd
--   Generic compute_set_pred_i
--		[WARNING] ce_1 and ck_1 are ignored
-- 		[TODO]
--------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity compute_set_pred_i is
	port(
		is_signed_in : in  std_logic;
		set_cond_in  : in  std_logic_vector(2 downto 0);
		src_1_in     : in  std_logic_vector(31 downto 0);
		src_2_in     : in  std_logic_vector(31 downto 0);
		w32_in       : in  std_logic;
		result_out   : out std_logic_vector(31 downto 0);
		sign_out     : out std_logic;
		zero_out     : out std_logic
	);
end compute_set_pred_i;

architecture comp_set_pred_i_archi of compute_set_pred_i is
begin
	COMP_SET_PROC : process(is_signed_in, set_cond_in, src_1_in, src_2_in, w32_in)
		variable which : integer;
	begin
		if(is_signed_in = '1') then
			if(w32_in = '1') then
				if(signed(src_1_in) < signed(src_2_in)) then
					which := 0;
				elsif(signed(src_1_in) = signed(src_2_in)) then
					which := 1;
				else
					which := 2;
				end if;
			else
				if(signed(src_1_in(15 downto 0)) < signed(src_2_in(15 downto 0))) then
					which := 0;
				elsif(signed(src_1_in(15 downto 0)) = signed(src_2_in(15 downto 0))) then
					which := 1;
				else
					which := 2;
				end if;
			end if;
		else
			if(w32_in = '1') then
				if(unsigned(src_1_in) < unsigned(src_2_in)) then
					which := 0;
				elsif(unsigned(src_1_in) = unsigned(src_2_in)) then
					which := 1;
				else
					which := 2;
				end if;
			else
				if(unsigned(src_1_in(15 downto 0)) < unsigned(src_2_in(15 downto 0))) then
					which := 0;
				elsif(unsigned(src_1_in(15 downto 0)) = unsigned(src_2_in(15 downto 0))) then
					which := 1;
				else
					which := 2;
				end if;
			end if;
		end if;

		if(set_cond_in(which) = '1') then
			result_out <= (others => '1');
			sign_out   <= '1';
			zero_out   <= '0';
		else
			result_out <= (others => '0');
			sign_out   <= '0';
			zero_out   <= '1';
		end if;
	end process COMP_SET_PROC;
end architecture comp_set_pred_i_archi;