library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity CSA_4_2 is
port( ci			:in std_logic;
	  X1 			:in std_logic;
	  X2 			:in std_logic;
	  X3 			:in std_logic;
	  X4 			:in std_logic;
	  co 			:out std_logic;
	  C 			:out std_logic;
	  S				:out std_logic);
end entity CSA_4_2;


architecture CSA_4_2_arch of CSA_4_2 is
signal sxor1, sxor2, sxor3 :std_logic;

begin

sxor1 <= X1 xor X2;

sxor2 <= X3 xor X4;

sxor3 <= sxor1 xor sxor2;

S <= sxor3 xor ci;

co <= (X3 and X4) or (X2 and X4) or (X2 and X3);

C <= ci when sxor3='1' else X1;

end CSA_4_2_arch;