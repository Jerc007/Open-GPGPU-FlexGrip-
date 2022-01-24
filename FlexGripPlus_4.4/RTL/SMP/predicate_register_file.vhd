library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.gpgpu_package.all;

entity predicate_register_file is
	generic(NCORES : integer := 8);
	port(
        clk                       : in std_logic;
        warp_id_a                   : in std_logic_vector(4 downto 0);
        warp_lane_id_a              : in std_logic_vector(1 downto 0);
        reg_addr_a                  : in std_logic_vector(1 downto 0);
        wr_en_a                     : in std_logic; 
        din_a                       : in std_logic_vector(3 downto 0);
        dout_a                      : out std_logic_vector(3 downto 0); 
        warp_id_b                   : in std_logic_vector(4 downto 0);
        warp_lane_id_b              : in std_logic_vector(1 downto 0);
        reg_addr_b                  : in std_logic_vector(1 downto 0);
        wr_en_b                     : in std_logic; 
        din_b                       : in std_logic_vector(3 downto 0);
        dout_b                      : out std_logic_vector(3 downto 0)
	);
end predicate_register_file;

architecture predicate_register_file_archi of predicate_register_file is
	signal dp_ram_addr_a : std_logic_vector(8 downto 0);
	signal dp_ram_addr_b : std_logic_vector(8 downto 0);
begin
	dp_regfile_inst: dp_regfile generic map(RAM_SIZE=>128*32/NCORES, RAM_A_WIDTH=>9, RAM_D_WIDTH=>4) -- [FIXME] 384 is doutable
	port map(
		clk  => clk,
		rst  => '0',
		addr_a => dp_ram_addr_a,
		din_a  => din_a,
		dout_a => dout_a,
		we_a   => wr_en_a,
		addr_b => dp_ram_addr_b,
		din_b  => din_b,
		we_b   => wr_en_b,
		dout_b => dout_b
	);
	
	NCORES_8_GEN: if NCORES=8 generate
		dp_ram_addr_a <= warp_lane_id_a & warp_id_a  & reg_addr_a;
		dp_ram_addr_b <= warp_lane_id_b & warp_id_b  & reg_addr_b;
	end generate NCORES_8_GEN;

	NCORES_16_GEN: if NCORES=16 generate
		dp_ram_addr_a <= "0" & warp_lane_id_a(0) & warp_id_a  & reg_addr_a;
		dp_ram_addr_b <= "0" & warp_lane_id_b(0) & warp_id_b  & reg_addr_b;
	end generate NCORES_16_GEN;

	NCORES_32_GEN: if NCORES=32 generate
		dp_ram_addr_a <= "00" & warp_id_a  & reg_addr_a;
		dp_ram_addr_b <= "00" & warp_id_b  & reg_addr_b;
	end generate NCORES_32_GEN;

end architecture predicate_register_file_archi;
