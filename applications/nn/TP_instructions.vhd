
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity TP_instructions is
	port(
		instruction_pointer_in : in  integer;
		num_instructions_out   : out integer;
		instruction_out        : out std_logic_vector(31 downto 0)
	);
end TP_instructions;

architecture arch of TP_instructions is
	constant TP_INSTRUCTIONS : integer := 46;

begin
	num_instructions_out <= TP_INSTRUCTIONS;

	process(instruction_pointer_in)
	begin
		case instruction_pointer_in is
			when 0 => instruction_out <= x"a0004c09";   -- 0000  I2I.U32.U16 R2, g [0x6].U16; 
when 1 => instruction_out <= x"04200780";
when 2 => instruction_out <= x"10004e09";   -- 0008  MOV.U16 R1L, g [0x7].U16; 
when 3 => instruction_out <= x"0023c780";
when 4 => instruction_out <= x"60024805";   -- 0010  IMAD.U16 R1, g [0x4].U16, R1L, R2; 
when 5 => instruction_out <= x"00208780";
when 6 => instruction_out <= x"40034209";   -- 0018  IMUL.U16.U16 R2, g [0x1].U16, R1H; 
when 7 => instruction_out <= x"00200780";
when 8 => instruction_out <= x"30100409";   -- 0020  SHL R2, R2, 0x10; 
when 9 => instruction_out <= x"c4100780";
when 10 => instruction_out <= x"60024205";   -- 0028  IMAD.U16 R1, g [0x1].U16, R1L, R2; 
when 11 => instruction_out <= x"00208780";
when 12 => instruction_out <= x"a0000001";   -- 0030  I2I.U32.U16 R0, R0L; 
when 13 => instruction_out <= x"04000780";
when 14 => instruction_out <= x"20000201";   -- 0038  IADD R0, R1, R0; 
when 15 => instruction_out <= x"04000780";
when 16 => instruction_out <= x"3000CFFD";   -- 0040  ISET.S32.C0 o[0x7f], g [0x7], R0, LE;   // 7
when 17 => instruction_out <= x"6c20c7c8";
when 18 => instruction_out <= x"30000003";   -- 0048  RET C0.NE;
when 19 => instruction_out <= x"00000280";
when 20 => instruction_out <= x"30030005";   -- 0050  SHL R1, R0, 0x3; 
when 21 => instruction_out <= x"c4100780";
when 22 => instruction_out <= x"2000c805";   -- 0058  IADD R1, g [0x4], R1; 
when 23 => instruction_out <= x"04204780";
when 24 => instruction_out <= x"20048209";   -- 0060  IADD32I R2, R1, 0x4; 
when 25 => instruction_out <= x"00000003";
when 26 => instruction_out <= x"d00e0409";   -- 0068  GLD.U32 R2, global14[R2]; 
when 27 => instruction_out <= x"80c00780";
when 28 => instruction_out <= x"d00e0205";   -- 0070  GLD.U32 R1, global14[R1]; 
when 29 => instruction_out <= x"80c00780";
when 30 => instruction_out <= x"B1427208";   -- 0078  FADD32 R2, g [0x9], -R2;  // 9
when 31 => instruction_out <= x"B1417004";   -- 007c  FADD32 R1, g [0x8], -R1;  // 8
when 32 => instruction_out <= x"c0020409";   -- 0080  FMUL R2, R2, R2; 
when 33 => instruction_out <= x"00000780";
when 34 => instruction_out <= x"e0010205";   -- 0088  FMAD R1, R1, R1, R2; 
when 35 => instruction_out <= x"00008780";
when 36 => instruction_out <= x"30020001";   -- 0090  SHL R0, R0, 0x2; 
when 37 => instruction_out <= x"c4100780";
when 38 => instruction_out <= x"90000205";   -- 0098  RSQ R1, R1; 
when 39 => instruction_out <= x"40000780";
when 40 => instruction_out <= x"2100ec00";   -- 00a0  IADD32 R0, g [0x6], R0; // 6
when 41 => instruction_out <= x"90000204";   -- 00a4  RCP32 R1, R1;
when 42 => instruction_out <= x"d00e0005";   -- 00a8  GST.U32 global14[R0], R1; 
when 43 => instruction_out <= x"a0c00781";
when 44 => instruction_out <= x"30000003";   -- RET
when 45 => instruction_out <= x"00000780";

			when others => null;
		end case;
	end process;

end arch;
