--------------------------------------------------------------------------
-- VHDL : thread_id_calc.vhd
--   Generic thread_id_calc
-- 		[TODO]
--------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity thread_id_calc is
	port(
		clk                : in  std_logic; -- NOT USED
		en                 : in  std_logic;
		block_indx_in      : in  std_logic_vector(15 downto 0);
		block_x_in         : in  std_logic_vector(15 downto 0);
		block_y_in         : in  std_logic_vector(15 downto 0);
		block_z_in         : in  std_logic_vector(15 downto 0);
		num_cores_in       : in  std_logic_vector(7 downto 0);
		warp_size_in       : in  std_logic_vector(5 downto 0);
		warps_per_block_in : in  std_logic_vector(5 downto 0);
		x_indx_in          : in  std_logic_vector(15 downto 0);
		y_indx_in          : in  std_logic_vector(15 downto 0);
		z_indx_in          : in  std_logic_vector(15 downto 0);
		data_valid         : out std_logic;
		thread_id_out      : out std_logic_vector(31 downto 0);
		thread_lane_id_out : out std_logic_vector(7 downto 0);
		warp_id_out        : out std_logic_vector(31 downto 0);
		warp_lane_id_out   : out std_logic_vector(5 downto 0)
	);
end thread_id_calc;

architecture thread_id_calc_archi of thread_id_calc is
	
begin
	
	calc_process : process(block_x_in, block_indx_in, block_y_in, num_cores_in, warp_size_in, warps_per_block_in, x_indx_in, y_indx_in, z_indx_in)
		variable q_res                       : unsigned(47 downto 0);
		variable warp_id_out_unsigned        : unsigned(47 downto 0);
		variable warp_lane_id_out_unsigned   : unsigned(5 downto 0);
		variable thread_lane_id_out_unsigned : unsigned(7 downto 0);
	begin
		q_res := unsigned(x_indx_in) + (unsigned(y_indx_in) + unsigned(z_indx_in) * unsigned(block_y_in)) * unsigned(block_x_in);

		thread_id_out               <= ((31 downto 16 => '0') & x_indx_in) or (y_indx_in & (15 downto 0 => '0')) or (z_indx_in(5 downto 0) & (25 downto 0 => '0'));
		thread_lane_id_out_unsigned := q_res rem unsigned(num_cores_in);
		thread_lane_id_out          <= std_logic_vector(thread_lane_id_out_unsigned(7 downto 0));

		warp_id_out_unsigned := (q_res / unsigned(warp_size_in) + (unsigned(block_indx_in) * unsigned(warps_per_block_in)));
		warp_id_out          <= std_logic_vector(warp_id_out_unsigned(31 downto 0));

		warp_lane_id_out_unsigned := (q_res rem unsigned(warp_size_in)) / unsigned(num_cores_in);
		warp_lane_id_out          <= std_logic_vector(warp_lane_id_out_unsigned(5 downto 0));
		data_valid                <= '1';
	end process calc_process;

end architecture thread_id_calc_archi;