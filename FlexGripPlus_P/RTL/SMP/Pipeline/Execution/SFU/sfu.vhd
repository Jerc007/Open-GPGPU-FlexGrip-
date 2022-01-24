-- Proyecto				: SFU IEEE754
-- Nombre de archivo	: SFU.vhd
-- Titulo				: Special Function Unit  
-----------------------------------------------------------------------------	
-- Descripcion			: This unit performs the floating point operations
--						  sin(x), cos(x), rsqrt(x), log2(x), exp2(x), 1/x, and sqrt(x), using
--						IEE754 standard and operational compliant with GPU G80
--						architecture
--
-----------------------------------------------------------------------------	
-- Universidad Pedagogica y Tecnologica de Colombia.
-- Facultad de ingenieria.
-- Escuela de ingenieria Electronica - extension Tunja.
-- 
-- Autor: Juan David Guerrero Balaguera; Edward Javier Patiño
-- October 2020
-----------------------------------------------------------------------------	

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.gpgpu_package.all;


entity sfu is
port(--clk_i	  :in std_logic;	--input clock, in this model, it doesn't have efect
	 --rst_n	  :in std_logic;	--reset active low, in this model, it doesn't have efect
	 --start_i  :in std_logic;	--start operation, in this model, it doesn't have efect
	 src1_i	  :in std_logic_vector(31 downto 0); --IEE754 input data
	 -- when sin/cos operation is performed the input data is in fixed point representation after Range reduction
	 -- and the input data is organized in the following way: S Q1Q0 00000M.FFFFFFFFFFFFFFFFFFFFFFF
	 -- when 2^x operation is performed the input data is in fixed point representation after Range reduction
	 -- and the input data is organized in the following way S MMMMMMMM.FFFFFFFFFFFFFFFFFFFFFFF
	 selop_i  :in std_logic_vector(2 downto 0); --operation selection
	 --  "000" => sin(x)
	 --  "001" => cos(x)
	 --  "010" => rsqrt(x)
	 --  "011" => log2(x)
	 --  "100" => 2^x
	 --  "101" => 1/x 
	 --  "110" => sqrt(x)
	 --  "111" => bypass x
	 Result_o :out std_logic_vector(31 downto 0) --IEE754 result data output
	 --stall_o  :out std_logic --stall signal, in this model, it doesn't have efect. it is always 0. 
);
end entity sfu;


architecture sfu_arch of sfu is 
signal 	  	s_in_mantiza		:std_logic_vector(22 downto 0) :=(others=>'0');
signal 	  	s_in_exponent		:std_logic_vector(7 downto 0) :=(others=>'0');
signal 	  	s_in_sign			:std_logic;

signal    	s_in_sin_cos_adj	:std_logic_vector(31 downto 0) :=(others=>'0');
signal    	s_half_pi_minus_x	:std_logic_vector(23 downto 0) :=(others=>'0');
constant 	C_HALF_PI			:unsigned(23 downto 0) := X"c90fdb";  --this is the fixed point representation of pi/2
signal    	s_in_sin_cos_quad 	:std_logic_vector(1 downto 0) :=(others=>'0');
signal    	s_in_data_inter		:std_logic_vector(31 downto 0) :=(others=>'0');
	
signal    	s_in_oper_select  	:std_logic_vector(2 downto 0) :=(others=>'0');
	
signal 	  	s_Res_Quad_int_o 	:std_logic_vector(42 downto 0) :=(others=>'0');

--log2 signals declaration before normalization
signal 		s_log2_Exp_eq_zero	:std_logic :='0';
signal 	    s_log2_sign			:std_logic :='0';
signal 	    s_log2_sign_neg		:std_logic :='0';
signal 		s_log2_exp_sign_ext	:std_logic_vector(6 downto 0) :=(others=>'0');
signal 		s_log2_fix_sign_ext	:std_logic_vector(48 downto 0) :=(others=>'0');
signal 		s_log2_int_part_xor	:std_logic_vector(6 downto 0) := (others=>'0');
signal 		s_log2_int_part		:std_logic_vector(7 downto 0) := (others=>'0');
signal      s_log2_Fix_point_xor:std_logic_vector(48 downto 0) :=(others=>'0');
signal		s_log2_res_exp_nzer :std_logic_vector(48 downto 0) :=(others=>'0');
signal 		s_log2_Fix_point_t	:std_logic_vector(48 downto 0) :=(others=>'0');
signal 		s_log2_Fix_point	:std_logic_vector(48 downto 0) :=(others=>'0');
signal 		s_log2_tmp_fxp		:std_logic_vector(48 downto 0) :=(others=>'0');
signal 		s_log2_mult_Mx		:std_logic_vector(83 downto 0) :=(others=>'0');
signal      s_log2_res_unorm	:std_logic_vector(48 downto 0) :=(others=>'0');
signal      s_log2_tmp_prod		:std_logic_vector(41 downto 0) :=(others=>'0');

--signal delcaration of the normalization process
signal    	s_in_norm         	:std_logic_vector(63 downto 0) :=(others=>'0');
signal    	s_num_of_Zeros		:std_logic_vector(5 downto 0) :=(others=>'0');
signal    	s_MSB_zeros			:std_logic :='0';
signal 	  	s_exp_norm			:std_logic_vector(8 downto 0):=(others=>'0');
signal    	s_res_norm			:std_logic_vector(48 downto 0) :=(others=>'0');
signal		s_res_mantiza		:std_logic_vector(22 downto 0) :=(others=>'0');

signal 		s_rounding_even 	:std_logic :='0';
signal 		s_rounding_exp      :std_logic_vector(8 downto 0) :=(others=>'0');
signal 		s_mantiza_rounding	:std_logic_vector(24 downto 0) :=(others=>'0');
signal 		s_rounding_mantiza	:std_logic_vector(24 downto 0) :=(others=>'0');

--signal declaration of Exponent correction 
signal		s_sin_final_exp		:std_logic_vector(8 downto 0) :=(others=>'0');
signal		s_cos_final_exp		:std_logic_vector(8 downto 0) :=(others=>'0');
signal		s_rsqrt_final_exp	:std_logic_vector(8 downto 0) :=(others=>'0');
signal		s_log2_final_exp	:std_logic_vector(8 downto 0) :=(others=>'0');
signal		s_exp2_final_exp	:std_logic_vector(8 downto 0) :=(others=>'0');
signal		s_rcp_final_exp		:std_logic_vector(8 downto 0) :=(others=>'0');
signal		s_sqrt_final_exp	:std_logic_vector(8 downto 0) :=(others=>'0');

signal      s_denorm_exp_Ex		:std_logic_vector(8 downto 0) :=(others=>'0');
signal      s_Ex_1				:std_logic_vector(8 downto 0) :=(others=>'0');
signal      s_Ex_1_srl			:std_logic_vector(8 downto 0) :=(others=>'0');
signal      s_Ex_srl			:std_logic_vector(8 downto 0) :=(others=>'0');
signal		s_rsqrt_Ex_1_srl_t	:std_logic_vector(8 downto 0) :=(others=>'0');
signal		s_rcp_Exp_t		:std_logic_vector(8 downto 0) :=(others=>'0');
signal		s_rsqrt_Ex_srl_t	:std_logic_vector(8 downto 0) :=(others=>'0');
signal		s_rsqrt_Ex_t		:std_logic_vector(8 downto 0) :=(others=>'0');
signal      s_final_exp_mux		:std_logic_vector(8 downto 0) :=(others=>'0');
signal      s_final_exp_t		:std_logic_vector(8 downto 0) :=(others=>'0');

--signal declaration of output operations
signal 		s_result_exponent	:std_logic_vector(7 downto 0) :=(others=>'0');
signal 		s_result_sign		:std_logic;

signal    	s_result_sign_sin	:std_logic :='0';
signal    	s_result_sign_cos	:std_logic :='0';
signal    	s_result_sign_rsqrt	:std_logic :='0';
signal    	s_result_sign_log2	:std_logic :='0';
signal    	s_result_sign_exp2	:std_logic :='0';
signal    	s_result_sign_rcp	:std_logic :='0';
signal    	s_result_sign_sqrt	:std_logic :='0';

signal 		s_result_mantiza	:std_logic_vector(22 downto 0) :=(others=>'0');

signal		s_result_complete	:std_logic_vector(31 downto 0) := (others=>'0');

begin 
--stall_o <= '0';
--=================================================================================================================
--							      Input data split 
--=================================================================================================================
s_in_sign <= src1_i(31);
s_in_exponent <= src1_i(30 downto 23);
s_in_mantiza <= src1_i(22 downto 0);

s_in_sin_cos_quad <=s_in_exponent(7 downto 6); 


--when input angle for sin or cos operation be greater than 1 a correction must be implemented in order to waranty 
-- that the input angle to the interpolater is always betwen input [0,1)

s_half_pi_minus_x <= std_logic_vector(C_HALF_PI-unsigned(src1_i(23 downto 0))); --calculates pi/2-x

s_in_sin_cos_adj <= '0'&"0000000"&s_half_pi_minus_x when src1_i(23)='1' else src1_i; --if input>=1 then angle to evaluate is pi/2-input; else input 

s_in_data_inter <= s_in_sin_cos_adj when selop_i(2 downto 1)="00" else src1_i;

s_in_oper_select <= "00"&(s_in_sin_cos_quad(0) xor selop_i(0) xor src1_i(23)) when selop_i(2 downto 1)="00" else selop_i;

--=================================================================================================================


--=================================================================================================================
--                          Quadratic Interpolator component 
-- This componet performs Quadratic interpolation for sin(x), cos(x), rsqrt(x), log2(x), exp2(x), 1/x, and sqrt(x)
-- operations the input is a 32 bit IEEE754 number representation and de output is a 43 bit Sign magnitud in 
-- fixed point representation using the format SM.FFFFFFFFFFF 1 bit sign, 1 bit integer part, and 41 bits fractional
-- this componet computes the funtions only using the mantiza or significand in the following ranges: sin(x)/cos(x) 
-- only in range [0,1), rsqrt(x), log2(x), 1/x, and sqrt(x) in range (1,2) nd exp2(x) in range (0,1).  
--=================================================================================================================
uQuadraticInterpol: Quadratic_Interpolator
	port map(src1_i	  		 	=> s_in_data_inter,		
	         selop_i  		 	=> s_in_oper_select,		
	         Res_Quad_int_o 	=> s_Res_Quad_int_o); 
--=================================================================================================================

--=================================================================================================================
--	Log2(x) adjust add the exponent as integer part and table selection acording to the exponent value
--=================================================================================================================
s_log2_Exp_eq_zero <= '1' when s_in_exponent="01111111" else '0';

s_log2_tmp_prod <= '0'&s_in_mantiza&"000000000000000000";
s_log2_mult_Mx <= std_logic_vector(unsigned(s_Res_Quad_int_o(41 downto 0))*unsigned(s_log2_tmp_prod));

s_log2_sign<= '1' when unsigned(s_in_exponent)<127 else '0';
s_log2_sign_neg <= not s_log2_sign;

s_log2_exp_sign_ext <= (others=>s_log2_sign); 
s_log2_fix_sign_ext <= (others=>s_log2_sign);
s_log2_int_part_xor <= (s_in_exponent(6 downto 0)) xor s_log2_exp_sign_ext;
s_log2_Fix_point_xor <= ("0000000"&s_Res_Quad_int_o(41 downto 0)) xor s_log2_fix_sign_ext;
s_log2_int_part <= std_logic_vector(unsigned('0'&s_log2_int_part_xor)+1) when s_log2_sign_neg='1' else '0'&s_log2_int_part_xor;

s_log2_tmp_fxp <='0'&s_log2_int_part(6 downto 0)&"00000000000000000000000000000000000000000";
s_log2_Fix_point_t <= std_logic_vector(unsigned(s_log2_tmp_fxp)+unsigned(s_log2_Fix_point_xor));
s_log2_Fix_point <= std_logic_vector(unsigned(s_log2_Fix_point_t)+1)  when s_log2_sign='1' else s_log2_Fix_point_t;

s_log2_res_unorm <= "0000000"&s_log2_mult_Mx(82 downto 41) when s_log2_Exp_eq_zero='1' else '0'&s_log2_Fix_point(47 downto 0);


--=================================================================================================================

--=================================================================================================================
--							   Normalization of interpolation result 
--=================================================================================================================
-- 
s_in_norm <= s_log2_res_unorm&"000000000000000" when selop_i="011" else "0000000"&s_Res_Quad_int_o(41 downto 0)&"000000000000000";


uCountLeadingZeros: CLZ   --this cmponent counts the leading zeros of result gotten from interpolation
	generic map(MODE => '0')
	port map(i_data		  => s_in_norm, 
	         o_zeros	  => s_num_of_Zeros,	
	         o_MSB_zeros  => s_MSB_zeros);

s_res_norm <= std_logic_vector(unsigned(s_in_norm(63 downto 15)) sll to_integer(unsigned(s_num_of_Zeros)));
--  Rounding to nearest even
s_rounding_even <= (s_res_norm(24) and s_res_norm(23)) or (s_res_norm(25) and s_res_norm(24));


s_mantiza_rounding <="000000000000000000000000"&s_rounding_even;
s_rounding_mantiza <= std_logic_vector(unsigned('0'&s_res_norm(48 downto 25))+unsigned(s_mantiza_rounding));

s_rounding_exp <= "00000000"&(s_rounding_mantiza(24));
s_exp_norm <= std_logic_vector((to_unsigned(7,9) - resize(unsigned(s_num_of_Zeros),9))+unsigned(s_rounding_exp));
s_res_mantiza <= std_logic_vector(unsigned(s_rounding_mantiza(22 downto 0)));
--=================================================================================================================
--=================================================================================================================
--						Exponent correction acording to input equation.	
--=================================================================================================================
s_denorm_exp_Ex <= std_logic_vector(signed('0'&s_in_exponent)-127);

s_Ex_1 <= std_logic_vector(signed(s_denorm_exp_Ex)-1);
s_Ex_1_srl <= s_Ex_1(8)&s_Ex_1(8 downto 1);--std_logic_vector(signed(s_Ex_1) sra 1);  --(Ex-1)/2
s_Ex_srl <= s_denorm_exp_Ex(8)&s_denorm_exp_Ex(8 downto 1);--std_logic_vector(signed(s_denorm_exp_Ex) sra 1); --Ex/2

s_rsqrt_Ex_1_srl_t <= std_logic_vector(signed(s_exp_norm)-signed(s_Ex_1_srl));
s_rsqrt_Ex_srl_t <= std_logic_vector(signed(s_exp_norm)-signed(s_Ex_srl));
s_rcp_Exp_t <=std_logic_vector(signed(s_exp_norm)-signed(s_denorm_exp_Ex));

s_log2_final_exp <= s_exp_norm;
s_sin_final_exp	 <= s_exp_norm;
s_cos_final_exp  <= s_exp_norm;
s_exp2_final_exp <= std_logic_vector(resize(signed(s_in_exponent),9));
s_rcp_final_exp <= s_rcp_Exp_t;
s_sqrt_final_exp <= s_Ex_1_srl when s_denorm_exp_Ex(0)='1' else s_Ex_srl;
s_rsqrt_final_exp <= s_rsqrt_Ex_1_srl_t when s_denorm_exp_Ex(0)='1' else s_rsqrt_Ex_srl_t;

with selop_i select
	s_final_exp_mux <= 	s_sin_final_exp		when "000",
						s_cos_final_exp		when "001",
						s_rsqrt_final_exp	when "010",
						s_log2_final_exp	when "011",
						s_exp2_final_exp	when "100",
						s_rcp_final_exp		when "101",
						s_sqrt_final_exp	when "110",
						s_denorm_exp_Ex		when others;


s_final_exp_t <= (others=>'0')  when (signed(s_final_exp_mux)<-126 or s_MSB_zeros='1') else std_logic_vector(signed(s_final_exp_mux) + 127); 
--=================================================================================================================
--						Output selection results	
--=================================================================================================================
s_result_sign_sin <= s_in_sign xor s_in_sin_cos_quad(1);
s_result_sign_cos <= s_in_sin_cos_quad(1) xor s_in_sin_cos_quad(0);
s_result_sign_log2 <= s_log2_sign;
s_result_sign_rcp <= s_in_sign;
s_result_sign_exp2 <= '0';
s_result_sign_rsqrt <= '0';
s_result_sign_sqrt <= '0';

s_result_exponent <= s_final_exp_t(7 downto 0);

with selop_i select
	s_result_sign <=s_result_sign_sin	when "000",
					s_result_sign_cos	when "001",
					s_result_sign_rsqrt	when "010",
					s_result_sign_log2	when "011",
					s_result_sign_exp2	when "100",
					s_result_sign_rcp	when "101",
					s_result_sign_sqrt	when "110",
					src1_i(31)		when others;
					

s_result_mantiza <= (others=>'0') when (signed(s_final_exp_mux)<-126 or s_MSB_zeros='1') else s_res_mantiza;

s_result_complete <= s_result_sign&s_result_exponent&s_result_mantiza;

uExceptions: SFU_Exceptions
	port map(
			i_data_input	=> s_in_data_inter,
			i_data_sin_cos	=> src1_i,
			i_oper_result	=> s_result_complete,
			i_selop			=> s_in_oper_select,
			o_result_solved => Result_o); 

--=================================================================================================================

end sfu_arch;