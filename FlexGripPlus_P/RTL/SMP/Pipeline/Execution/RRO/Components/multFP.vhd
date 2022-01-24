-- multiplicador Ripple Carry.

Library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity multFP is 
port(
	entrada_x, entrada_y: in std_logic_vector(31 downto 0);
	salida: out std_logic_vector(31 downto 0);
	underflow, overflow :out std_logic
	);
end multFP;

architecture ar of multFP is
type desplazar is array(0 to 47) of std_logic_vector(47 downto 0);
signal mantisa_finalex :desplazar :=(others=>(others=>'0'));
signal mantisa1_n,mantisa2_n :std_logic_vector(23 downto 0);
signal mantisa_final :std_logic_vector(47 downto 0);
signal mantisa_real :std_logic_vector(22 downto 0);
signal resultado :std_logic_vector(31 downto 0);
signal exponente_final :std_logic_vector(9 downto 0);
signal exponentex,exponentey :std_logic_vector(9 downto 0);
signal sunderflow, soverflow :std_logic;
begin
-- Se suman exponentes:
--exponente_final(7 downto 0) contiene el exponente listo.
mantisa1_n <= '1' & entrada_x(22 downto 0);				-- inclusion de 1 en el bit mas significativo para multiplicacion. 
mantisa2_n <= '1' & entrada_y(22 downto 0);	
exponentex <= "00"& entrada_x(30 downto 23);
exponentey <= "00"& entrada_y(30 downto 23);				
-- operacion sobre la mantisa.		
mantisa_final<=std_logic_vector(unsigned(mantisa1_n)*unsigned(mantisa2_n));


process(entrada_x,entrada_y,resultado,sunderflow,soverflow)
begin
if unsigned(entrada_x) = X"00000000" or unsigned(entrada_y) = X"00000000" or unsigned(entrada_x) = X"80000000" or unsigned(entrada_y) = X"80000000"  then -- no se realiza la operacion, uno de los operandos es cero por lo tanto la respuesta es cero.
	salida <= (others=>'0');
	underflow <='0';
	overflow <= '0';
else 						-- se realiza la operacion.
	underflow<=sunderflow;
	overflow<= soverflow;
	salida <= resultado;
	salida(31)<= (entrada_x(31) xor entrada_y(31));  -- asignacion de signo al resultado.
end if;
end process;	

process(mantisa_final,exponentex,exponentey)
begin
	if(mantisa_final(47)='1') then
		exponente_final <= std_logic_vector((unsigned(exponentex) + unsigned(exponentey)) - 126);	
	else
		exponente_final <= std_logic_vector((unsigned(exponentex) + unsigned(exponentey)) - 127);
	end if;
end process;

process(exponente_final,mantisa_real)
begin
if signed(exponente_final) > 255 then			-- finaliza la operacion si hay overflow.
	soverflow<='1';
	sunderflow<='0';
	resultado <= (others=>'0');
elsif 	signed(exponente_final) < 0 then 		-- finaliza la operacion si hay underflow.
	sunderflow<='1';
	soverflow<='0';
	resultado <= (others=>'0');
else 											-- continue con la operacion.		
	sunderflow<='0';
	soverflow<='0';
	-- asignacion final del resultado.
	resultado(22 downto 0) <= mantisa_real;		-- Mantisa.
	resultado(30 downto 23) <= exponente_final(7 downto 0);	-- Exponente.
end if;
end process;

mantisa_finalex(47) <= mantisa_final;
NX:for i in 46 downto 0 generate
	mantisa_finalex(i) <= mantisa_finalex(i+1)(46 downto 0) & '0';
end generate;


process(mantisa_final,mantisa_finalex)
variable var :integer;
begin
var:=0;
for i in 0 to 47 loop
	if(mantisa_final(i)='1') then
		var:=i;
	end if;
end loop;
mantisa_real <= mantisa_finalex(var)(46 downto 24);
end process;
		
end ar;