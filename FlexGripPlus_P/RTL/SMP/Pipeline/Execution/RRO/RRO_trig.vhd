library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.gpgpu_package.all;

entity RRO_trig is
port( input_data :in std_logic_vector(31 downto 0);
	  output_data :out std_logic_vector(31 downto 0);
	  quadrant	  :out std_logic_vector(1 downto 0));
end entity RRO_trig;

architecture Reduce_model of RRO_trig is
signal Mult1,Mult2,Mult3,Sub1,Input_pos,output_sign :std_logic_vector(31 downto 0);
signal Mult1_floor :std_logic_vector(253 downto 0);
signal floor_tmp :std_logic_vector(253 downto 0);
signal floor_tmp2 :std_logic_vector(253 downto 0);
signal floor_tmp3 :std_logic_vector(253 downto 0);
signal shift_select :unsigned(7 downto 0);
signal floor_fp :std_logic_vector(31 downto 0);

begin 

Input_pos <= '0'&input_data(30 downto 0);

M0: multFP
	port map(
	entrada_x => Input_pos, 
	entrada_y => X"3f22f983",
	salida => Mult1);
	
	--Floor input data
	Mult1_floor(253 downto 230) <= '1'&Mult1(22 downto 0);
	Mult1_floor(229 downto 0) <= (others=>'0');
	
	
	shift_select <= (to_unsigned(254,8)-unsigned(Mult1(30 downto 23)));
	
	floor_tmp <= std_logic_vector(unsigned(Mult1_floor) srl to_integer(shift_select));
	
	floor_tmp2(125 downto 0) <= (others=>'0');
	floor_tmp2(253 downto 126) <= floor_tmp(253 downto 126);
	floor_tmp3 <= std_logic_vector(unsigned(floor_tmp2) sll to_integer(shift_select));
	
	floor_fp(31) <= '0';
	floor_fp(30 downto 23) <= Mult1(30 downto 23) when unsigned(floor_tmp3)/=0 else (others=>'0');
	floor_fp(22 downto 0)  <= floor_tmp3(252 downto 230);

M1: multFP
	port map(
	entrada_x => floor_fp, 
	entrada_y => X"3fc90000", 
	salida => Mult2);
	
M2: multFP
	port map(
	entrada_x => floor_fp, 
	entrada_y => X"39fdaa22",
	salida => Mult3);


S1: add_sub
    Port map(FP_A => Input_pos,
             FP_B => Mult2,
             add_sub => '0',
             FP_Z => Sub1);

S2: add_sub
    Port map(FP_A => Sub1,
             FP_B => Mult3,
             add_sub => '0',
             FP_Z => output_sign);
	output_data<=input_data(31)&output_sign(30 downto 0);
	quadrant <= floor_tmp2(127 downto 126);
end Reduce_model;