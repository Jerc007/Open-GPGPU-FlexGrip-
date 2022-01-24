--------------------------------------------------------------------------
-- VHDL : integer_add_subtract.vhd    behavioral or structural????
--   Generic integer_add_subtract
--		[WARNING] ce_1 and ck_1 are ignored
-- 		[TODO]
--------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity integer_add_subtract is
	port(
		a_in         : in  std_logic_vector(31 downto 0);
		a_neg_in     : in  std_logic;
		b_in         : in  std_logic_vector(31 downto 0);
		b_neg_in     : in  std_logic;
		carry_in     : in  std_logic;
		saturate_in  : in  std_logic;
		sub_en       : in  std_logic;
		w32_in       : in  std_logic;
		carry_out    : out std_logic;
		overflow_out : out std_logic;
		result_out   : out std_logic_vector(31 downto 0)
	);
end integer_add_subtract;

architecture int_addsub_archi of integer_add_subtract is
begin
	PROC_ADD_SUB : process(w32_in, a_in, a_neg_in, b_in, b_neg_in, carry_in, saturate_in, sub_en)
		variable a_src : signed(31 downto 0);
		variable b_src : signed(31 downto 0);
		variable res_o : signed(32 downto 0);
	begin
		if(w32_in = '1') then
			if(a_neg_in = '1') then
				a_src := -signed(a_in);
			else
				a_src := signed(a_in);
			end if;

			if(b_neg_in = '1') then
				b_src := -signed(b_in);
			else
				b_src := signed(b_in);
			end if;
		else
			if(a_neg_in = '1') then
				a_src := -signed((31 downto 16 => a_in(15)) & a_in(15 downto 0));
			else
				a_src := signed((31 downto 16 => a_in(15)) & a_in(15 downto 0));
			end if;

			if(b_neg_in = '1') then
				b_src := -signed((31 downto 16 => b_in(15)) & b_in(15 downto 0));
			else
				b_src := signed((31 downto 16 => b_in(15)) & b_in(15 downto 0));
			end if;
		end if;

		-- MODIFIED GIANLUCA ROASCIO - BEFORE THIS, OVERFLOW AND CARRY WERE NOT CORRECTLY SETTABLE
		if(sub_en = '0') then
			if(carry_in = '1') then
				--res_o := (a_src(31) & a_src) + b_src + 1;
				res_o := ('0' & a_src) + ('0' & b_src) + 1;
			else
				--res_o := (a_src(31) & a_src) + b_src;
				res_o := ('0' & a_src) + ('0' & b_src);
			end if;
		else
			if(carry_in = '1') then
				--res_o := (a_src(31) & a_src) - b_src - 1;
				res_o := ('0' & a_src) - ('0' & b_src) - 1;
			else
				--res_o := (a_src(31) & a_src) - b_src;
				res_o := ('0' & a_src) - ('0' & b_src);
			end if;
		end if;

		if(saturate_in = '1') then
			overflow_out <= '0';
			if(w32_in = '1') then
				if(res_o(32) /= res_o(31)) then -- sum does not fit the bits -> saturate to 0xFFFFFFFF
					result_out <= (others => '1'); 
					carry_out  <= '0';
				else
					result_out <= std_logic_vector(res_o(31 downto 0));
					carry_out  <= res_o(32);
				end if;
			else
				if(res_o(16) /= res_o(15)) then
					result_out <= x"0000FFFF"; 
					carry_out  <= '0';
				else
					result_out <= x"0000" & std_logic_vector(res_o(15 downto 0));
					carry_out  <= res_o(16);
				end if;
			end if;
		else
			if(w32_in = '1') then
				-- MODIFIED GIANLUCA ROASCIO
				--if(res_o(32) /= res_o(31)) then
				if(a_src(31) = b_src(31) and a_src(31) /= res_o(31)) then -- if the result have different sign from the operands there is overflow
					overflow_out <= '1';
				else
					overflow_out <= '0';
				end if;
				result_out <= std_logic_vector(res_o(31 downto 0));
				carry_out  <= res_o(32);
			else
				--if(res_o(16) /= res_o(15)) then
				if(a_src(15) = b_src(15) and a_src(15) /= res_o(15)) then
					overflow_out <= '1';
				else
					overflow_out <= '0';
				end if;
				result_out <= x"0000" & std_logic_vector(res_o(15 downto 0));
				carry_out  <= res_o(16);
			end if;
		end if;
	end process PROC_ADD_SUB;
end architecture int_addsub_archi;