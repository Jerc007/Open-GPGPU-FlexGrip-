--------------------------------------------------------------------------
-- VHDL : convert_int_int.vhd
--   Generic convert_int_int
--		[WARNING] ce_1 and ck_1 are ignored
-- 		[TODO]
--------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity convert_int_int is
	port(
		a_in            : in  std_logic_vector(31 downto 0);
		abs_saturate_in : in  std_logic_vector(1 downto 0);
		cvt_neg_in      : in  std_logic;
		cvt_type_in     : in  std_logic_vector(2 downto 0);
		w32_in          : in  std_logic;
		result_out      : out std_logic_vector(31 downto 0)
	);
end convert_int_int;

architecture convert_i_i_archi of convert_int_int is
begin
	CONVERT_PROC : process(a_in, abs_saturate_in, cvt_neg_in, cvt_type_in, w32_in)
		
		-- REMOVED GIANLUCA ROASCIO - NOT USEFUL ANYMORE
		--variable n_op   : std_logic;
		variable a_tmp  : std_logic_vector(31 downto 0);
		variable a_tmp1 : std_logic_vector(31 downto 0);
		
	begin
		
		-- REMOVED GIANLUCA ROASCIO - NOT USEFUL ANYMORE
--		if (((cvt_type_in = "001" or cvt_type_in = "101") and w32_in = '1') or cvt_type_in = "111") and (cvt_neg_in = '0') then
--			n_op := '1';
--		else
--			n_op := '0';
--		end if;

		-- MODIFIED GIANLUCA ROASCIO (ACCORDING TO LINES 791 - 799 OF pipeline_decode.vhd WHICH DECIDES DATA TYPES FROM CVT TYPES)
		case cvt_type_in is
			when "000"  => a_tmp := a_in and X"0000FFFF";
			--when "001"  => a_tmp := (others => '0');
			when "001"  => a_tmp := a_in;
			--when "010"  => a_tmp := (others => '0');
			when "010"  => a_tmp := a_in and X"000000FF";
			--when "011"  => a_tmp := a_in and X"000000FF";
			when "011"  => a_tmp := a_in;
			when "100"  => a_tmp := (31 downto 16 => a_in(15)) & a_in(15 downto 0);
			when "101"  => a_tmp := a_in;
			when "110"  => a_tmp := (31 downto 8 => a_in(7)) & a_in(7 downto 0);
			--when "111"  => a_tmp := (others => '0');
			when "111"  => a_tmp := a_in;
			--when others => a_tmp := (others => '0');
			when others => a_tmp := a_in;
		end case;
                                                                 
		-- NOTE GIANLUCA ROASCIO: THE CURRENT DESIGN BOUNDS cvt_neg_in TO '0', SO THIS IF IS NEVER ENTERED !!!
		if(cvt_neg_in = '1') then
			a_tmp1 := std_logic_vector(not (unsigned(a_tmp)) + 1);
		else
			a_tmp1 := a_tmp;
		end if;

		-- MODIFIED GIANLUCA ROASCIO
--		if(n_op = '1') then
--			result_out <= a_in;
--		else
--			if(abs_saturate_in = "10") then
--				result_out <= a_tmp1 and X"7FFFFFFF";
--			else
--				result_out <= a_tmp1;
--			end if;
--		end if;
		if(abs_saturate_in = "10" and (cvt_type_in = "100" or cvt_type_in = "101" or cvt_type_in = "110") and a_tmp1(31) = '1') then
			result_out <= std_logic_vector(not (unsigned(a_tmp1)) + 1);
		else
			result_out <= a_tmp1;
		end if;
		
		
	end process CONVERT_PROC;
	
end architecture convert_i_i_archi;