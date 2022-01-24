library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.gpgpu_package.all;

entity vector_register_file is
	generic(NCORES : integer := 8);
	port(
		clk          : in  std_logic;
		base_addr_a    : in  std_logic_vector(8 downto 0);
		base_addr_b    : in  std_logic_vector(8 downto 0);
		din_a          : in  std_logic_vector(31 downto 0);
		din_b          : in  std_logic_vector(31 downto 0);
		reg_num_a      : in  std_logic_vector(8 downto 0);
		reg_num_b      : in  std_logic_vector(8 downto 0);
		warp_lane_id_a : in  std_logic_vector(1 downto 0);
		warp_lane_id_b : in  std_logic_vector(1 downto 0);
		we_a           : in  std_logic;
		we_b           : in  std_logic;
		dout_a         : out std_logic_vector(31 downto 0);
		dout_b         : out std_logic_vector(31 downto 0)
	);
end vector_register_file;

architecture vector_register_file_archi of vector_register_file is
	signal dp_ram_addr_a : std_logic_vector(10 downto 0);
	signal dp_ram_addr_b : std_logic_vector(10 downto 0);
begin
	-- 8 cores 512x4, 16 cores 512x2, 32 cores 512x1
	dp_regfile_inst: dp_regfile generic map(RAM_SIZE=> 512*32/NCORES, RAM_A_WIDTH=>11, RAM_D_WIDTH=>32)
	port map(
		clk  => clk,
        rst    => '0',
		addr_a => dp_ram_addr_a,
		din_a  => din_a,
		dout_a => dout_a,
		we_a   => we_a,
		addr_b => dp_ram_addr_b,
		din_b  => din_b,
		we_b   => we_b,
		dout_b => dout_b
	);
	
	NCORES_8_GEN: if NCORES=8 generate
		dp_ram_addr_a <= warp_lane_id_a & std_logic_vector(unsigned(base_addr_a) + unsigned(reg_num_a));
		dp_ram_addr_b <= warp_lane_id_b & std_logic_vector(unsigned(base_addr_b) + unsigned(reg_num_b));
	end generate NCORES_8_GEN;

	NCORES_16_GEN: if NCORES=16 generate
		dp_ram_addr_a <= "0" & warp_lane_id_a(0) & std_logic_vector(unsigned(base_addr_a) + unsigned(reg_num_a));
		dp_ram_addr_b <= "0" & warp_lane_id_b(0) & std_logic_vector(unsigned(base_addr_b) + unsigned(reg_num_b));
	end generate NCORES_16_GEN;

	NCORES_32_GEN: if NCORES=32 generate
		dp_ram_addr_a <= "00" & std_logic_vector(unsigned(base_addr_a) + unsigned(reg_num_a));
		dp_ram_addr_b <= "00" & std_logic_vector(unsigned(base_addr_b) + unsigned(reg_num_b));
	end generate NCORES_32_GEN;

end architecture vector_register_file_archi;
