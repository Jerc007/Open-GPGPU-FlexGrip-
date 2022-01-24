library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.gpgpu_package.all;

entity fused_accum_tree is
port( C0			:in std_logic_vector(28 downto 0); --29 bits from LUTS in format SM.FFFFFFFFFFFFFFFF; S-M representation
	  C1			:in std_logic_vector(19 downto 0); --20 bits from LUTS in format SM.FFFFFFFFFFFFF ; S-M representation
	  C2			:in std_logic_vector(13 downto 0); --14 bits from LUTS in format S.FFFFFFFFFF ; S-M representation
	  X2X2	     	:in std_logic_vector(15 downto 0);  --take 15 bits from square unit from 19 to 33 form result and add extra 0 to left
	  X2			:in std_logic_vector(16 downto 0); -- 17 or 16 LSB from mantiza when m=7 MSB must be 0
	  Result		:out std_logic_vector(42 downto 0)); --43 bits output in format SM.FFFFFFFFFFFFF CA2 representation
end entity fused_accum_tree;


architecture fused_accum_tree_arch of fused_accum_tree is
type PP1 is array (0 to 7) of std_logic_vector(30 downto 0);
type PP2 is array (0 to 8) of std_logic_vector(42 downto 0);

type S1 is array (0 to 2) of std_logic_vector(31 downto 0);
type CC1 is array (0 to 2) of std_logic_vector(31 downto 0);

type S2 is array (0 to 5) of std_logic_vector(43 downto 0);
type CC2 is array (0 to 5) of std_logic_vector(43 downto 0);

signal PP_C2X2 :PP1 :=(others=>(others=>'0'));
signal PP_C1X2 :PP2 :=(others=>(others=>'0'));

signal CSA_Summ_C2X2 :S1 :=(others=>(others=>'0'));
signal CSA_Carr_C2X2 :CC1 :=(others=>(others=>'0'));
signal CSA_Summ_C1X2 :S2 :=(others=>(others=>'0'));
signal CSA_Carr_C1X2 :CC2 :=(others=>(others=>'0'));

signal X2_adj :std_logic_vector(18 downto 0) :=(others=>'0');
signal X2S_adj :std_logic_vector(16 downto 0) :=(others=>'0');
signal C1_adjust :std_logic_vector(20 downto 0) :=(others=>'0');
signal C2_adjust :std_logic_vector(15 downto 0) :=(others=>'0');
signal C0_adjust :std_logic_vector(43 downto 0) :=(others=>'0');
signal C0_adjust1 :std_logic_vector(43 downto 0) :=(others=>'0');
signal C0_adjustn :std_logic_vector(43 downto 0) :=(others=>'0');
signal L,K	  :std_logic_vector(42 downto 0) :=(others=>'0');

signal carry_int1 :std_logic_vector(23 downto 0) :=(others=>'0');
signal carry_int2 :std_logic_vector(23 downto 0) :=(others=>'0');
signal carry_int3 :std_logic_vector(31 downto 0) :=(others=>'0');

signal carry_int_1 :std_logic_vector(32 downto 0) :=(others=>'0');
signal carry_int_2 :std_logic_vector(28 downto 0) :=(others=>'0');
signal carry_int_3 :std_logic_vector(37 downto 0) :=(others=>'0');
signal carry_int_4 :std_logic_vector(43 downto 0) :=(others=>'0');
signal carry_int_5 :std_logic_vector(43 downto 0) :=(others=>'0');
signal carry_int_6 :std_logic_vector(43 downto 0) :=(others=>'0');

signal Carry_adjust :std_logic_vector(43 downto 0) :=(others=>'0');
signal add_one		:std_logic_vector(43 downto 0) :=(others=>'0');
signal Carry_C2X2_Final :std_logic_vector(43 downto 0) :=(others=>'0');
signal summ_C2X2_Final  :std_logic_vector(43 downto 0) :=(others=>'0');

signal summ_Final  :std_logic_vector(43 downto 0) :=(others=>'0');

begin


--parcial Product generate for C1X2
X2_adj <= '0'&X2&'0';
C1_adjust <= C1(19)&'0'&C1(18 downto 0);

gPP_C1X2: for i in 0 to 8 generate
	uPP_C1X2: Booth_PP
		generic map(Data_widht => 21)
		port map(x_i0	=> X2_adj(2*i),
		         x_i1	=> X2_adj(2*i+1),
		         x_i2	=> X2_adj(2*i+2),
		         Data_i => C1_adjust,
		         Data_o => PP_C1X2(i)(2*i+20 downto 2*i),
				 adj_o  => L(2*i));
end generate;


--Extra bits added to sign extension using booth codign arithmetic
PP_C1X2(0)(22)<='1';
PP_C1X2(1)(24)<='1';
PP_C1X2(4)(30)<='1';
PP_C1X2(6)(33)<='1';
PP_C1X2(7)(35)<='1';
PP_C1X2(8)(42 downto 37)<=(others=>'1');


--parcial Product generate for C2X2
X2S_adj <= X2X2&'0';
C2_adjust <= C2(13)&'0'&'0'&C2(12 downto 0);
gPP_C2X2: for i in 0 to 7 generate
	uPP_C2X2: Booth_PP
		generic map(Data_widht => 16)
		port map(x_i0	=> X2S_adj(2*i),
		         x_i1	=> X2S_adj(2*i+1),
		         x_i2	=> X2S_adj(2*i+2),
		         Data_i => C2_adjust,
		         Data_o => PP_C2X2(i)(2*i+15 downto 2*i),
				 adj_o  => K(2*i));
end generate;

--Extra bits added to sign extension using booth codign arithmetic
PP_C2X2(0)(16)<='1';
PP_C2X2(1)(18)<='1';
PP_C2X2(1)(19)<='1';
PP_C2X2(4)(25)<='1';
PP_C2X2(5)(27)<='1';

-- Fused_accum_tree
carry_int1(0) <='0';
CSA_Carr_C2X2(0)(0)<='0';
gCSA_4_2_C2X2_L1: for i in 0 to 21 generate
	uCSA_4_2_C2X2: CSA_4_2
		port map(ci => carry_int1(i),
		         X1 => PP_C2X2(0)(i),
		         X2 => PP_C2X2(1)(i),
		         X3 => PP_C2X2(2)(i),
		         X4 => PP_C2X2(3)(i),
		         co => carry_int1(i+1),
		         C  => CSA_Carr_C2X2(0)(i+1),
		         S	=> CSA_Summ_C2X2(0)(i));
end generate;

carry_int2(0) <='0';
CSA_Carr_C2X2(1)(8)<='0';
gCSA_4_2_C2X2_L2: for i in 0 to 21 generate
	uCSA_4_2_C2X2: CSA_4_2
		port map(ci => carry_int2(i),
		         X1 => PP_C2X2(4)(i+8),
		         X2 => PP_C2X2(5)(i+8),
		         X3 => PP_C2X2(6)(i+8),
		         X4 => PP_C2X2(7)(i+8),
		         co => carry_int2(i+1),
		         C  => CSA_Carr_C2X2(1)(i+9),
		         S	=> CSA_Summ_C2X2(1)(i+8));
end generate;

carry_int3(0) <='0';
CSA_Carr_C2X2(2)(0)<='0';
gCSA_4_2_C2X2_Lx2: for i in 0 to 29 generate
	uCSA_4_2_C2X2: CSA_4_2
		port map(ci => carry_int3(i),
		         X1 => CSA_Summ_C2X2(0)(i),
		         X2 => CSA_Carr_C2X2(0)(i),
		         X3 => CSA_Summ_C2X2(1)(i),
		         X4 => CSA_Carr_C2X2(1)(i),
		         co => carry_int3(i+1),
		         C  => CSA_Carr_C2X2(2)(i+1),
		         S	=> CSA_Summ_C2X2(2)(i));
end generate;

--

carry_int_1(0) <='0';
CSA_Carr_C1X2(0)(0)<='0';
gCSA_4_2_C1X2_L2: for i in 0 to 26 generate
	uCSA_4_2_C1X2: CSA_4_2
		port map(ci => carry_int_1(i),
		         X1 => PP_C1X2(0)(i),
		         X2 => PP_C1X2(1)(i),
		         X3 => PP_C1X2(2)(i),
		         X4 => PP_C1X2(3)(i),
		         co => carry_int_1(i+1),
		         C  => CSA_Carr_C1X2(0)(i+1),
		         S	=> CSA_Summ_C1X2(0)(i));
end generate;

carry_int_2(0) <='0';
CSA_Carr_C1X2(1)(8)<='0';
gCSA_4_2_C1X2_Ly2: for i in 0 to 27 generate
	uCSA_4_2_C1X2: CSA_4_2
		port map(ci => carry_int_2(i),
		         X1 => PP_C1X2(4)(i+8),
		         X2 => PP_C1X2(5)(i+8),
		         X3 => PP_C1X2(6)(i+8),
		         X4 => PP_C1X2(7)(i+8),
		         co => carry_int_2(i+1),
		         C  => CSA_Carr_C1X2(1)(i+9),
		         S	=> CSA_Summ_C1X2(1)(i+8));
end generate;

KL: for i in 0 to 8 generate
	Carry_adjust(2*i) <= L(2*i);
	Carry_adjust(2*i+1) <= K(2*i);
end generate;

add_one(16) <= '1';

carry_int_3(0) <='0';
CSA_Carr_C1X2(2)(0)<='0';
gCSA_4_2_C1X2_L3: for i in 0 to 36 generate
	uCSA_4_2_C1X2: CSA_4_2
		port map(ci => carry_int_3(i),
		         X1 => CSA_Summ_C1X2(0)(i),
		         X2 => CSA_Carr_C1X2(0)(i),
		         X3 => CSA_Summ_C1X2(1)(i),
		         X4 => CSA_Carr_C1X2(1)(i),
		         co => carry_int_3(i+1),
		         C  => CSA_Carr_C1X2(2)(i+1),
		         S	=> CSA_Summ_C1X2(2)(i));
end generate;
			 
			 
C0_adjust1 <="00"&C0(27 downto 0)&"00000000000000";	
C0_adjustn <= (others=>C0(28));
C0_adjust <= C0_adjustn xor C0_adjust1;
PP_C1X2(8)(0)<=C0(28);


carry_int_4(0) <='0';		 
CSA_Carr_C1X2(3)(0)<='0';
gCSA_3_2_C1X2_L3: for i in 0 to 42 generate
	uCSA_3_2_C1X2: CSA_4_2		 
		port map(ci => carry_int_4(i),
		         X1 => PP_C1X2(8)(i),
		         X2 => C0_adjust(i),
		         X3 => Carry_adjust(i),
		         X4 => add_one(i),
		         co => carry_int_4(i+1),
		         C  => CSA_Carr_C1X2(3)(i+1),
		         S	=> CSA_Summ_C1X2(3)(i));		 
			 
end generate;


carry_int_6(0) <='0';
CSA_Carr_C1X2(4)(0)<='0';
gCSA_4_2_C1X2_L4: for i in 0 to 42 generate
	uCSA_4_2_C1X2: CSA_4_2
		port map(ci => carry_int_6(i),
		         X1 => CSA_Summ_C1X2(2)(i),
		         X2 => CSA_Carr_C1X2(2)(i),
		         X3 => CSA_Summ_C1X2(3)(i),
		         X4 => CSA_Carr_C1X2(3)(i),
		         co => carry_int_6(i+1),
		         C  => CSA_Carr_C1X2(4)(i+1),
		         S	=> CSA_Summ_C1X2(4)(i));
end generate;


Carry_C2X2_Final <= "00000000000"&CSA_Carr_C2X2(2)&'0';
summ_C2X2_Final <= "00000000000"&CSA_Summ_C2X2(2)&'0';

carry_int_5(0) <='0';
CSA_Carr_C1X2(5)(0)<='0';
gCSA_4_2_Final: for i in 0 to 42 generate
	uCSA_4_2_Final: CSA_4_2
		port map(ci => carry_int_5(i),
		         X1 => CSA_Summ_C1X2(4)(i),
		         X2 => CSA_Carr_C1X2(4)(i),
		         X3 => summ_C2X2_Final(i),
		         X4 => Carry_C2X2_Final(i),
		         co => carry_int_5(i+1),
		         C  => CSA_Carr_C1X2(5)(i+1),
		         S	=> CSA_Summ_C1X2(5)(i));
end generate;


summ_Final <= std_logic_vector(unsigned(CSA_Carr_C1X2(5))+unsigned(CSA_Summ_C1X2(5)));

Result <= summ_Final(42 downto 0);
end fused_accum_tree_arch;