-- Proyecto				: SFU IEEE754
-- Nombre de archivo	: Quadratic_Interpolator.vhd
-- Titulo				: Quadratic_Interpolator  
-----------------------------------------------------------------------------	
-- Descripcion			: 	This unit performs the Quadratic aproximation follow the methox exposed by oberman 
--						  	the function performs the operation F=C2*X2^2 + C1X2 + C0 where C0, C1 and C2 are 
--                        	constants obtainded from mimimax aproximation algorithm, X2 is the 17 or 16 LSB of mantiza
--						  	Result is a 43 bit data using the representation SM.FFFFFFFFFFFF
-- 							This componet performs Quadratic interpolation for sin(x), cos(x), rsqrt(x), log2(x), exp2(x), 1/x, and sqrt(x)
-- 							operations the input is a 32 bit IEEE754 number representation and de output is a 43 bit Sign magnitud in 
-- 							fixed point representation using the format SM.FFFFFFFFFFF 1 bit signm 1 bit integer partm and 41 bits fractional
-- 							this componet computes the funtions only using the mantiza or significand: sin(x)/cos(x) only in range [0,1)
-- 							rsqrt(x), log2(x), 1/x, and sqrt(x) in range (1,2) nd exp2(x) in range (0,1).  
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


entity Quadratic_Interpolator is
port(src1_i	  		 :in std_logic_vector(31 downto 0); --IEE754 input data
	 selop_i  		 :in std_logic_vector(2 downto 0); --operation selection
	 Res_Quad_int_o  :out std_logic_vector(42 downto 0)); --IEE754 result data output
end entity Quadratic_Interpolator;


architecture Quadratic_Interpolator_arch of Quadratic_Interpolator is 
signal	  s_C0				:std_logic_vector(28 downto 0) :=(others=>'0');
signal	  s_C1				:std_logic_vector(19 downto 0) :=(others=>'0');
signal	  s_C2				:std_logic_vector(13 downto 0) :=(others=>'0');
signal	  s_X2X2     		:std_logic_vector(33 downto 0) :=(others=>'0');
signal    s_X2X2_approx		:std_logic_vector(15 downto 0) :=(others=>'0'); 
signal	  s_X2				:std_logic_vector(16 downto 0) :=(others=>'0');
signal    s_X1				:std_logic_vector(6 downto 0) :=(others=>'0');

signal    s_m6				:std_logic :='0';
signal    s_Exp_Zero		:std_logic :='0';
signal    s_Exp_even        :std_logic :='0'; 

signal 	  s_in_mantiza		:std_logic_vector(22 downto 0);
signal 	  s_in_exponent		:std_logic_vector(7 downto 0);
signal 	  s_in_sign			:std_logic :='0';
signal	  s_coeff_select	:std_logic_vector(3 downto 0) :=(others=>'0');			
signal 	  s_Operation		:std_logic_vector(4 downto 0) :=(others=>'0');

begin 
s_in_sign <= src1_i(31);
s_in_exponent <= src1_i(30 downto 23);
s_in_mantiza <= src1_i(22 downto 0);

s_m6 <= (((not selop_i(1)) and (not selop_i(0))) or (selop_i(2)  xnor selop_i(1)) or (s_Exp_Zero and (not selop_i(2)) and selop_i(0)));  --It determines wich operations use m=6 bits 

s_X2(16) <= s_m6 and s_in_mantiza(16);
s_X2(15 downto 0) <= s_in_mantiza(15 downto 0);

s_X1 <= s_in_mantiza(22 downto 16);  --when m=6 you must take form X1(22 downto 17) when m=7 you can take X1 complete

s_Exp_Zero <= '1' when unsigned(s_in_exponent)=127 else '0';  --this bit inform when the input exponent is zero
s_Exp_even <= s_in_exponent(0); -- this bit informs when Exponent is odd=0 even=1

s_Operation <= selop_i&s_Exp_Zero&s_Exp_even;

with s_Operation select
	s_coeff_select 	<= 	"1000" when "00000"|"00001"|"00010"|"00011", --sin
						"1001" when "00100"|"00101"|"00110"|"00111", --cos
						"0011" when "01001"|"01011", 				 -- rsqrt when exp is even
						"0100" when "01000"|"01010", 				 -- rsqrt when exp is odd
						"0110" when "01100"|"01101", 				 -- log2 when exp != 0      
						"0111" when "01110"|"01111", 				 -- log2 when exp = 0 (correct this when the correct table be available with 7)
						"0101" when "10000"|"10001"|"10010"|"10011", -- exp 2
						"0000" when "10100"|"10101"|"10110"|"10111", -- 1/x operation 
						"0001" when "11001"|"11011", 				 -- sqrt when exp is even
						"0010" when "11000"|"11010", 				 -- sqrt when exp is odd
						"1111" when others;
						

--=========================================== Coefficients Tables ==============================================================================
-- Here the Coeffients Tables must be instantiated
-- the followign lines must be conected to the component when it be intantiated
--=============================================================================================================================================

uLookUpTable: ROM
	generic map(
		bus_C0	=>29,
		bus_C1  =>20,
		bus_C2	=> 14,
		fn_bits	=> 4,
		add_bits => 7)
	port map(
		addr  => s_X1,
		fn	  => s_coeff_select,
		C0	  => s_C0,
		C1	  => s_C1,
		C2	  => s_C2);

--============================================================================================================================================= 


-- ==========================================Special Aquare Unit ==============================================================================
-- Here must be the special square unit Edward Patiño
-- the component must be instatiated here and replace the following line
-- ============================================================================================================================================
--s_X2X2 <= std_logic_vector(unsigned(s_X2)*unsigned(s_X2));
--s_X2X2_approx <='0'&s_X2X2(33 downto 19);

u_SpecialSquaringUnit: squaring
	generic map(word_bits => 17)
	port map(
		d_in => s_X2,
		d_out => s_X2X2);

s_X2X2_approx <='0'&s_X2X2(33 downto 19);
--============================================================================================================================================= 


--=========================================== Fused Accumulation Tree =========================================================================
-- This componetn performs the operation F=C2*X2^2 + C1X2 + C0 using booth coding to get partial producto and fussed accumulation tree
-- to get the final result using 43 bits. 
--=============================================================================================================================================
uFusedAccTree: fused_accum_tree
	port map(C0		 	=> s_C0,		
	         C1		 	=> s_C1,		
	         C2		 	=> s_C2,		 
	         X2X2       => s_X2X2_approx,	 
	         X2		 	=> s_X2,		 
	         Result	 	=> Res_Quad_int_o); 

end Quadratic_Interpolator_arch;