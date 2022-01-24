
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
	constant TP_INSTRUCTIONS : integer := 72;

begin
	num_instructions_out <= TP_INSTRUCTIONS;

	process(instruction_pointer_in)
	begin
		case instruction_pointer_in is
			when 0 => instruction_out <= x"307ccbfd";   -- 0000  ISET.S32.C0 o[0x7f], g [0x5], R124, LE; 
when 1 => instruction_out <= x"6c20c7c8";
when 2 => instruction_out <= x"30000003";   -- 0008  RET C0.NE; 
when 3 => instruction_out <= x"00000280";
when 4 => instruction_out <= x"a0004c09";   -- 0010  I2I.U32.U16 R2, g [0x6].U16; 
when 5 => instruction_out <= x"04200780";
when 6 => instruction_out <= x"a0004205";   -- 0018  I2I.U32.U16 R1, g [0x1].U16; 
when 7 => instruction_out <= x"04200780";
when 8 => instruction_out <= x"2001840d";   -- 0020  IADD32I R3, R2, 0x1; 
when 9 => instruction_out <= x"00000003";
when 10 => instruction_out <= x"40070411";   -- 0028  IMUL.U16.U16 R4, R1L, R3H; 
when 11 => instruction_out <= x"00000780";
when 12 => instruction_out <= x"30100811";   -- 0030  SHL R4, R4, 0x10; 
when 13 => instruction_out <= x"c4100780";
when 14 => instruction_out <= x"a0000001";   -- 0038  I2I.U32.U16 R0, R0L; 
when 15 => instruction_out <= x"04000780";
when 16 => instruction_out <= x"40020809";   -- 0040  IMUL.U16.U16 R2, R2L, R1L; 
when 17 => instruction_out <= x"00000780";
when 18 => instruction_out <= x"60060405";   -- 0048  IMAD.U16 R1, R1L, R3L, R4; 
when 19 => instruction_out <= x"00010780";
when 20 => instruction_out <= x"20000409";   -- 0050  IADD R2, R2, R0; 
when 21 => instruction_out <= x"04000780";
when 22 => instruction_out <= x"3001020d";   -- 0058  SHL R3, R1, 0x1; 
when 23 => instruction_out <= x"c4100780";
when 24 => instruction_out <= x"1000f801";   -- 0060  MOV R0, R124; 
when 25 => instruction_out <= x"0403c780";
when 26 => instruction_out <= x"1000f805";   -- 0068  MOV R1, R124; 
when 27 => instruction_out <= x"0403c780";
when 28 => instruction_out <= x"30010409";   -- 0070  SHL R2, R2, 0x1; 
when 29 => instruction_out <= x"c4100780";
when 30 => instruction_out <= x"203f860d";   -- 0078  IADD32I R3, R3, 0xffffffff; 
when 31 => instruction_out <= x"0fffffff";
when 32 => instruction_out <= x"20000411";   -- 0080  IADD R4, R2, R1; 
when 33 => instruction_out <= x"04004780";
when 34 => instruction_out <= x"300309fd";   -- 0088  ISET.S32.C0 o[0x7f], R4, R3, GE; 
when 35 => instruction_out <= x"6c0187c8";
when 36 => instruction_out <= x"a001d003";   -- 0090  SSY 0xe8; 
when 37 => instruction_out <= x"00000000";
when 38 => instruction_out <= x"1001d003";   -- 0098  BRA C0.NE, 0xe8; 
when 39 => instruction_out <= x"00000280";
when 40 => instruction_out <= x"30020811";   -- 00a0  SHL R4, R4, 0x2; 
when 41 => instruction_out <= x"c4100780";
when 42 => instruction_out <= x"2000c811";   -- 00a8  IADD R4, g [0x4], R4; 
when 43 => instruction_out <= x"04210780";
when 44 => instruction_out <= x"20048819";   -- 00b0  IADD32I R6, R4, 0x4; 
when 45 => instruction_out <= x"00000003";
when 46 => instruction_out <= x"d00e0815";   -- 00b8  GLD.U32 R5, global14[R4]; 
when 47 => instruction_out <= x"80c00780";
when 48 => instruction_out <= x"d00e0c19";   -- 00c0  GLD.U32 R6, global14[R6]; 
when 49 => instruction_out <= x"80c00780";
when 50 => instruction_out <= x"30060bfd";   -- 00c8  ISET.S32.C0 o[0x7f], R5, R6, LE; 
when 51 => instruction_out <= x"6c00c7c8";
when 52 => instruction_out <= x"d00e0819";   -- 00d0  GST.U32 global14[R4] (C0.EQU), R6; 
when 53 => instruction_out <= x"a0c00500";
when 54 => instruction_out <= x"21000811";   -- 00d8  IADD R4 (C0.EQU), R4, c[0x1][0x0]; 
when 55 => instruction_out <= x"04400500";
when 56 => instruction_out <= x"d00e0815";   -- 00e0  GST.U32 global14[R4] (C0.EQU), R5; 
when 57 => instruction_out <= x"a0c00500";
when 58 => instruction_out <= x"307c0205";   -- 00e8  ISET.S.S32 R1, R1, R124, EQ; 
when 59 => instruction_out <= x"6c008782";
when 60 => instruction_out <= x"20018001";   -- 00f0  IADD32I R0, R0, 0x1; 
when 61 => instruction_out <= x"00000003";
when 62 => instruction_out <= x"3000cbfd";   -- 00f8  ISET.S32.C0 o[0x7f], g [0x5], R0, LE; 
when 63 => instruction_out <= x"6c2147c8";
when 64 => instruction_out <= x"a0000205";   -- 0100  I2I.S32.S32 R1, -R1; 
when 65 => instruction_out <= x"2c014780";
when 66 => instruction_out <= x"10010003";   -- 0108  BRA C0.NE, 0x80; 
when 67 => instruction_out <= x"00000280";
when 68 => instruction_out <= x"f0000001";   -- 0110  NOP; 
when 69 => instruction_out <= x"e0000001";
when 70 => instruction_out <= x"30000003";   -- RET
when 71 => instruction_out <= x"00000780";

			when others => null;
		end case;
	end process;

end arch;
