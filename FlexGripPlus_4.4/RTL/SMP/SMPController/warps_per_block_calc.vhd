--------------------------------------------------------------------------
-- VHDL : warps_per_block_calc.vhd
--   Generic warps_per_block_calc
-- 		[TODO]
--------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity warps_per_block_calc is
	port(
		clk                  : in  std_logic; -- NOT USED
		en                   : in  std_logic; --
		threads_per_block_in : in  std_logic_vector(11 downto 0);
		warp_size_in         : in  std_logic_vector(5 downto 0);
		data_valid_out       : out std_logic;
		warps_per_block_out  : out std_logic_vector(5 downto 0)
	);
end warps_per_block_calc;

architecture warps_per_block_calc_archi of warps_per_block_calc is
begin
	CALC_PROC : process(warp_size_in, threads_per_block_in)
		variable threads_per_warp_unsigned    : unsigned(11 downto 0);
		variable threads_per_warp_p1_unsigned : unsigned(11 downto 0);
	begin
		threads_per_warp_unsigned    := unsigned(threads_per_block_in) / unsigned(warp_size_in);
		threads_per_warp_p1_unsigned := threads_per_warp_unsigned + 1;
		if unsigned(threads_per_block_in) rem unsigned(warp_size_in) = 0 then
			warps_per_block_out <= std_logic_vector(threads_per_warp_unsigned(5 downto 0));
		else
			warps_per_block_out <= std_logic_vector(threads_per_warp_p1_unsigned(5 downto 0));
		end if;
		data_valid_out <= '1';
	end process CALC_PROC;

end architecture warps_per_block_calc_archi;