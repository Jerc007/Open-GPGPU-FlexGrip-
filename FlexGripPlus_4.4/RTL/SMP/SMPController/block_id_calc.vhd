-- VHDL : block_id_calc.vhd
--   Generic block_id_calc
--		[WARNING] use ieee library divisor, performance degradation
-- 		[TODO]
--
--
--     block_id_x_out = (block_idx_in + idx_in) mod grid_x_in
--	   block_id_y_out = (block_idx_in + idx_in) / grid_x_in
--------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity block_id_calc is
	port(
		clk            : in  std_logic; -- NOT USED
		en             : in  std_logic;
		block_idx_in   : in  std_logic_vector(15 downto 0);
		grid_x_in      : in  std_logic_vector(15 downto 0);
		idx_in         : in  std_logic_vector(15 downto 0);
		block_id_x_out : out std_logic_vector(15 downto 0);
		block_id_y_out : out std_logic_vector(15 downto 0);
		valid          : out std_logic
	);
end block_id_calc;

architecture block_id_calc_archi of block_id_calc is
	signal dividend : unsigned(15 downto 0);
begin
	dividend <= unsigned(block_idx_in) + unsigned(idx_in);

	PROC_DIV : process(en, grid_x_in, dividend)
	begin
		if(grid_x_in /= (15 downto 0 => '0') and en = '1') then
			block_id_x_out <= std_logic_vector(dividend mod unsigned(grid_x_in));
			block_id_y_out <= std_logic_vector(dividend / unsigned(grid_x_in));
			valid          <= '1';
		else
			block_id_x_out <= (others => '0'); 
			block_id_y_out <= (others => '0');
			valid <= '0';
		end if;
	end process PROC_DIV;
end architecture block_id_calc_archi;
