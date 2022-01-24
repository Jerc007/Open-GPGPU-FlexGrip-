library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity Booth_PP is
generic(Data_widht :natural :=8);
port(x_i0	:in 	std_logic;
	 x_i1	:in 	std_logic;
	 x_i2	:in 	std_logic;
	 Data_i :in 	std_logic_vector(Data_widht-1 downto 0);
	 Data_o :out 	std_logic_vector(Data_widht-1 downto 0);
	 adj_o  :out 	std_logic);
end entity Booth_PP;


architecture Booth_PP_arch of Booth_PP is
signal signo_booth, signo_oper, zero, two_m :std_logic;
signal shift :std_logic_vector(Data_widht-1 downto 0);
signal sign_extend :std_logic_vector(Data_widht-1 downto 0);
signal data_comp :std_logic_vector(Data_widht-1 downto 0);
signal zero_extend :std_logic_vector(Data_widht-1 downto 0);
signal data_o_tmp :std_logic_vector(Data_widht-1 downto 0);
begin

signo_booth <= (x_i2 and (not x_i1)) or (x_i2 and (not(x_i0)));

two_m <= (x_i2 and (not(x_i1)) and (not(x_i0))) or ((not(x_i2)) and x_i1 and x_i0);

zero <= (x_i2 or x_i1 or x_i0) and ((not(x_i2)) or (not(x_i1)) or (not(x_i0)));

signo_oper <= signo_booth xor Data_i(Data_widht-1);


shift <= Data_i(Data_widht-2 downto 0)&'0' when two_m='1'  else '0'&Data_i(Data_widht-2 downto 0);

sign_extend <= (others=>signo_oper);

data_comp <= sign_extend xor shift;

zero_extend <= (others=>zero);

data_o_tmp <= zero_extend and data_comp;

Data_o(Data_widht-1) <= not data_o_tmp(Data_widht-1);
Data_o(Data_widht-2 downto 0) <= data_o_tmp(Data_widht-2 downto 0);
adj_o <= signo_oper and zero;

end Booth_PP_arch;