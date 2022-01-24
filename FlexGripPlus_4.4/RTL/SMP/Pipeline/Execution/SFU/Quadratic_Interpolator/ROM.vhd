library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.gpgpu_package.all;

entity ROM is
	generic(
		bus_C0		:natural:=29;
		bus_C1		:natural:=20;
		bus_C2		:natural:=14;
		fn_bits		:natural:=4;
		add_bits		:natural:=7
	);
	port(
		addr		:in std_logic_vector(add_bits-1 downto 0);
		fn			:in std_logic_vector(fn_bits-1 downto 0);
		C0			:out std_logic_vector(bus_C0-1 downto 0);
		C1			:out std_logic_vector(bus_C1-1 downto 0);
		C2			:out std_logic_vector(bus_C2-1 downto 0)
	);
end entity;

architecture behav of ROM is
	type storageC0 is array (0 to 16) of std_logic_vector(bus_C0-1 downto 0);
	signal romC0:storageC0;

	type storageC1 is array (0 to 16) of std_logic_vector(bus_C1-1 downto 0);
	signal romC1:storageC1;

	type storageC2 is array (0 to 16) of std_logic_vector(bus_C2-1 downto 0);
	signal romC2:storageC2;
begin
	C0_reci: LUT_C0_reci
		generic map(
			word_bits	=> 26,
		    bus_bits	=> 29,
		    add_bits	=> 7)		
		port map(
			addr	=> addr,
			data	=> romC0(0)
		);

	C0_sqrt_1_2: LUT_C0_sqrt_1_2
		generic map(
			word_bits	=> 26,
		    bus_bits	=> 29,
		    add_bits	=> 6)	
		port map(
			addr	=> addr(add_bits-1 downto 1),
			data	=> romC0(1)
		);

	C0_sqrt_2_4: LUT_C0_sqrt_2_4
		generic map(
			word_bits	=> 27,
		    bus_bits	=> 29,
		    add_bits	=> 6)	
		port map(
			addr	=> addr(add_bits-1 downto 1),
			data	=> romC0(2)
		);

	C0_reci_sqrt_1_2: LUT_C0_reci_sqrt_1_2
		generic map(
			word_bits	=> 26,
		    bus_bits	=> 29,
		    add_bits	=> 7)	
		port map(
			addr	=> addr,
			data	=> romC0(3)
		);

	C0_reci_sqrt_2_4: LUT_C0_reci_sqrt_2_4
		generic map(
			word_bits	=> 25,
		    bus_bits	=> 29,
		    add_bits	=> 7 )	
		port map(
			addr	=> addr,
			data	=> romC0(4)
		);

	C0_exp: LUT_C0_exp
		generic map(
			word_bits	=> 27,
		    bus_bits	=> 29,
		    add_bits	=> 6)	
		port map(
			addr	=> addr(add_bits-1 downto 1),
			data	=> romC0(5)
		);

	C0_ln2: LUT_C0_ln2
		generic map(
			word_bits	=> 27,
		    bus_bits	=> 29,
		    add_bits	=> 7)
		port map(
			addr	=> addr,
			data	=> romC0(6)
		);

	C0_ln2e0: LUT_C0_ln2e0
		generic map(
			word_bits	=> 26,
		    bus_bits	=> 29,
		    add_bits	=> 6)
		port map(
			addr	=> addr(add_bits-1 downto 1),
			data	=> romC0(7)
		);

	C0_sin: LUT_C0_sin
		generic map(
			word_bits	=> 27,
		    bus_bits	=> 29,
		    add_bits	=> 6)
		port map(
			addr	=> addr(add_bits-1 downto 1),
			data	=> romC0(8)
		);

	C0_cos: LUT_C0_cos
		generic map(
			word_bits	=> 28,
		    bus_bits	=> 29,
		    add_bits	=> 6)
		port map(
			addr	=> addr(add_bits-1 downto 1),
			data	=> romC0(9)
		);

	C0 <= romC0(to_integer(unsigned(fn)));

	C1_reci: LUT_C1_reci
		generic map(
			word_bits	=> 18,
		    bus_bits	=> 20,
		    add_bits	=> 7)
		port map(
			addr	=> addr,
			data	=> romC1(0)
		);

	C1_sqrt_1_2: LUT_C1_sqrt_1_2
		generic map(
			word_bits	=> 16,
		    bus_bits	=> 20,
		    add_bits	=> 6)
		port map(
			addr	=> addr(add_bits-1 downto 1),
			data	=> romC1(1)
		);

	C1_sqrt_2_4: LUT_C1_sqrt_2_4
		generic map(
			word_bits	=> 16,
		    bus_bits	=> 20,
		    add_bits	=> 6)
		port map(
			addr	=> addr(add_bits-1 downto 1),
			data	=> romC1(2)
		);

	C1_reci_sqrt_1_2: LUT_C1_reci_sqrt_1_2
		generic map(
			word_bits	=> 17,
		    bus_bits	=> 20,
		    add_bits	=> 7)
		port map(
			addr	=> addr,
			data	=> romC1(3)
		);

	C1_reci_sqrt_2_4: LUT_C1_reci_sqrt_2_4
		generic map(
			word_bits	=> 17,
		    bus_bits	=> 20,
		    add_bits	=> 7)
		port map(
			addr	=> addr,
			data	=> romC1(4)
		);

	C1_exp: LUT_C1_exp
		generic map(
			word_bits	=> 19,
		    bus_bits	=> 20,
		    add_bits	=> 6)
		port map(
			addr	=> addr(add_bits-1 downto 1),
			data	=> romC1(5)
		);

	C1_ln2: LUT_C1_ln2
		generic map(
			word_bits	=> 19,
		    bus_bits	=> 20,
		    add_bits	=> 7)
		port map(
			addr	=> addr,
			data	=> romC1(6)
		);

	C1_ln2e0: LUT_C1_ln2e0
		generic map(
			word_bits	=> 18,
		    bus_bits	=> 20,
		    add_bits	=> 6)
		port map(
			addr	=> addr(add_bits-1 downto 1),
			data	=> romC1(7)
		);

	C1_sin: LUT_C1_sin
		generic map(
			word_bits	=> 19,
		    bus_bits	=> 20,
		    add_bits	=> 6)
		port map(
			addr	=> addr(add_bits-1 downto 1),
			data	=> romC1(8)
		);

	C1_cos: LUT_C1_cos
		generic map(
			word_bits	=> 18,
		    bus_bits	=> 20,
		    add_bits	=> 6)
		port map(
			addr	=> addr(add_bits-1 downto 1),
			data	=> romC1(9)
		);

	C1 <= romC1(to_integer(unsigned(fn)));

	C2_reci: LUT_C2_reci
		generic map(
			word_bits	=> 13,
		    bus_bits	=> 14,
		    add_bits	=> 7)
		port map(
			addr	=> addr,
			data	=> romC2(0)
		);

	C2_sqrt_1_2: LUT_C2_sqrt_1_2
		generic map(
			word_bits	=> 10,
		    bus_bits	=> 14,
		    add_bits	=> 6)
		port map(
			addr	=> addr(add_bits-1 downto 1),
			data	=> romC2(1)
		);

	C2_sqrt_2_4: LUT_C2_sqrt_2_4
		generic map(
			word_bits	=> 11,
		    bus_bits	=> 14,
		    add_bits	=> 6)
		port map(
			addr	=> addr(add_bits-1 downto 1),
			data	=> romC2(2)
		);

	C2_reci_sqrt_1_2: LUT_C2_reci_sqrt_1_2
		generic map(
			word_bits	=> 12,
		    bus_bits	=> 14,
		    add_bits	=> 7)
		port map(
			addr	=> addr,
			data	=> romC2(3)
		);

	C2_reci_sqrt_2_4: LUT_C2_reci_sqrt_2_4
		generic map(
			word_bits	=> 12,
		    bus_bits	=> 14,
		    add_bits	=> 7)
		port map(
			addr	=> addr,
			data	=> romC2(4)
		);

	C2_exp: LUT_C2_exp
		generic map(
			word_bits	=> 12,
		    bus_bits	=> 14,
		    add_bits	=> 6)
		port map(
			addr	=> addr(add_bits-1 downto 1),
			data	=> romC2(5)
		);

	C2_ln2: LUT_C2_ln2
		generic map(
			word_bits	=> 13,
		    bus_bits	=> 14,
		    add_bits	=> 7)
		port map(
			addr	=> addr,
			data	=> romC2(6)
		);

	C2_ln2e0: LUT_C2_ln2e0
		generic map(
			word_bits	=> 12,
		    bus_bits	=> 14,
		    add_bits	=> 6)
		port map(
			addr	=> addr(add_bits-1 downto 1),
			data	=> romC2(7)
		);

	C2_sin: LUT_C2_sin
		generic map(
			word_bits	=> 12,
		    bus_bits	=> 14,
		    add_bits	=> 6)
		port map(
			addr	=> addr(add_bits-1 downto 1),
			data	=> romC2(8)
		);

	C2_cos: LUT_C2_cos
		generic map(
			word_bits	=> 12,
		    bus_bits	=> 14,
		    add_bits	=> 6)
		port map(
			addr	=> addr(add_bits-1 downto 1),
			data	=> romC2(9)
		);

	C2 <= romC2(to_integer(unsigned(fn)));

end architecture;