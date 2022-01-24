--*************************************************************************--
-- Count Leading Zero/Ones
--*************************************************************************--
-- Universidad Pedagogica y Tecnologica de Colombia.
-- Facultad de ingenieria.
-- Escuela de ingenieria Electronica - extension Tunja.
-- 
-- Autor: Cristhian Fernando Moreno Manrique
-- Marzo 2020
--*************************************************************************--
--
--	MODE		0: Count Leading Zeros
--				1: Count Leading Ones
--
--	DATA_BITS	only 2^x data bits: 2, 4, 8, ..., 128... 
--
--
--	o_MSB_zeros is activated when i_data is only 0's or only 1's for Count
--	Leading Zeros and Count Leading One's modes respectively.
-----------------------------------------------------------------------------	
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
	

entity CLZ is
	generic (MODE			: 		std_logic:= '0');									
	port	  (i_data		: in	std_logic_vector(63 downto 0);
				o_zeros		: out std_logic_vector(5 downto 0);
				o_MSB_zeros	: out std_logic);
end CLZ;
-----------------------------------------------------------------------------	

architecture Behavioral of CLZ is
	
	signal s_data: std_logic_vector(i_data'left downto 0);
	signal s_zeros: std_logic_vector(o_zeros'left downto 0);

	type array_or is array (o_zeros'left downto 0) of std_logic_vector(i_data'left downto 0);
	signal w_or: array_or;
	
	-- w_and se utiliza para calcular o_MSB_zeros
	signal w_and			: std_logic_vector(o_zeros'left downto 0);
	signal w_LSB_data		: std_logic;
	signal w_MSB_zeros	: std_logic;
	
begin

	-- MODE CONFIG ------------------------------------------------------------	
	MD0: if MODE = '0' generate
		s_data <= i_data;
	end generate MD0;
	MD1: if MODE = '1' generate
		s_data <= not(i_data);
	end generate MD1;
	
	
	-- calculate o_zeros ------------------------------------------------------	
	w_or(o_zeros'left) <= '0' & s_data(s_data'left downto 1);
	
	U: for i in o_zeros'left downto 1 generate
		signal aux: std_logic_vector(2**(i+1)-1 downto 0);

	begin
		aux(0) <= not(w_or(i)(0));
		
		UU: for ii in 1 to (2**(i+1)-2) generate 						
			 UU_impar:if ((ii+1) mod 2) = 0 generate
				w_or(i-1)((ii+1)/2-1) <= w_or(i)(ii+1) or w_or(i)(ii);
				aux(ii)<= w_or(i)(ii) or aux(ii-1);				
			 end generate;
			 UU_par:if (ii mod 2) = 0 generate
				aux(ii)<= not(w_or(i)(ii)) and aux(ii-1);				
			 end generate;		 
		end generate UU;
	
		s_zeros((s_zeros'left)-i) <= aux(aux'left-1);
	end generate U;
	
	s_zeros(s_zeros'left) <= not(w_or(0)(0));
	
	
	--- calculate o_MSB_zeros -------------------------------------------------
	w_and(0) <= s_zeros(0);
	
	M: for i in 1 to s_zeros'left generate
		w_and(i) <= w_and(i-1) and s_zeros(i);
		o_zeros(i)	<= s_zeros(i) and not(w_MSB_zeros);
	end generate M;
	
	w_LSB_data 	<= s_data(0);
	w_MSB_zeros	<= not(w_LSB_data) and w_and(w_and'left);

	-- result ------------------------------------------------------------------
	o_zeros(0) <= s_zeros(0) and not(w_MSB_zeros);
	o_MSB_zeros <=  w_MSB_zeros;
	
end Behavioral;