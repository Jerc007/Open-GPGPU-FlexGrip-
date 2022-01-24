--------------------------------------------------------------------------
-- VHDL : thread_id_calc.vhd
--   Generic thread_id_calc
--      [TODO]
--------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.gpgpu_package.all;

entity warp_id_calc is
	port(
		clk 				: in std_logic;							-- [FIXME] The following signals are not used
		reset				: in std_logic;							-- since we use only sim multi and div
		en  				: in std_logic;							
		block_num_in       : in  std_logic_vector(3 downto 0);
		gprs_size_in       : in  std_logic_vector(8 downto 0);
		warp_num_in        : in  std_logic_vector(4 downto 0);
		warps_per_block_in : in  std_logic_vector(5 downto 0);
		data_valid_out     : out std_logic;
		gprs_base_addr_out : out std_logic_vector(8 downto 0);
		warp_id_out        : out std_logic_vector(4 downto 0)
	);
end warp_id_calc;

architecture warp_id_calc_archi of warp_id_calc is
begin
	calc_process : process(warps_per_block_in, block_num_in, gprs_size_in, warp_num_in)
		variable q_res                       : unsigned(9 downto 0);
		variable gprs_base_addr_out_unsigned : unsigned(18 downto 0);
		variable q_res_rem 					 : unsigned(9 downto 0);
	begin
		q_res       := (unsigned(block_num_in) * unsigned(warps_per_block_in) + unsigned(warp_num_in));
		q_res_rem 	:= q_res rem MAX_WARPS;
		warp_id_out <= std_logic_vector(q_res_rem(4 downto 0));

		gprs_base_addr_out_unsigned := q_res * unsigned(gprs_size_in);
		gprs_base_addr_out          <= std_logic_vector(gprs_base_addr_out_unsigned(8 downto 0));

		data_valid_out <= '1';
	end process calc_process;

end architecture warp_id_calc_archi;