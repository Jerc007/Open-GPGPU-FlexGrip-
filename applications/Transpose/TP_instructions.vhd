
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
	constant TP_INSTRUCTIONS : integer := 102;

begin
	num_instructions_out <= TP_INSTRUCTIONS;

	process(instruction_pointer_in)
	begin
		case instruction_pointer_in is
			when 0 => instruction_out <= x"307ccffd";   -- 0000  ISET.S32.C0 o[0x7f], g [0x7], R124, LE; 
when 1 => instruction_out <= x"6c20c7c8";
when 2 => instruction_out <= x"1000000d";   -- 0008  MOV R3, R0; 
when 3 => instruction_out <= x"0403c780";
when 4 => instruction_out <= x"30000003";   -- 0010  RET C0.NE; 
when 5 => instruction_out <= x"00000280";
when 6 => instruction_out <= x"d0800e01";   -- 0018  LOP.AND.U16 R0L, R3H, c[0x1][0x0]; 
when 7 => instruction_out <= x"00400780";
when 8 => instruction_out <= x"a0000009";   -- 0020  I2I.U32.U16 R2, R0L; 
when 9 => instruction_out <= x"04000780";
when 10 => instruction_out <= x"1000cc01";   -- 0028  MOV R0, g [0x6]; 
when 11 => instruction_out <= x"0423c780";
when 12 => instruction_out <= x"60824e05";   -- 0030  IMAD.U16 R1, g [0x7].U16, c[0x1][0x2], R2; 
when 13 => instruction_out <= x"00608780";
when 14 => instruction_out <= x"a0000c0d";   -- 0038  I2I.U32.U16 R3, R3L; 
when 15 => instruction_out <= x"04000780";
when 16 => instruction_out <= x"40030015";   -- 0040  IMUL.U16.U16 R5, R0L, R1H; 
when 17 => instruction_out <= x"00000780";
when 18 => instruction_out <= x"60824c11";   -- 0048  IMAD.U16 R4, g [0x6].U16, c[0x1][0x2], R3; 
when 19 => instruction_out <= x"0060c780";
when 20 => instruction_out <= x"6002021d";   -- 0050  IMAD.U16 R7, R0H, R1L, R5; 
when 21 => instruction_out <= x"00014780";
when 22 => instruction_out <= x"3004cd19";   -- 0058  ISET.S32.C0 R6, g [0x6], R4, LE; 
when 23 => instruction_out <= x"6c210780";
when 24 => instruction_out <= x"3004d215";   -- 0060  ISET.S32 R5, g [0x9], R4, GT; 
when 25 => instruction_out <= x"6c210780";
when 26 => instruction_out <= x"3001d225";   -- 0068  ISET.S32 R9, g [0x9], R1, GT; 
when 27 => instruction_out <= x"6c210780";
when 28 => instruction_out <= x"3001cd21";   -- 0070  ISET.S32.C0 R8, g [0x6], R1, LE; 
when 29 => instruction_out <= x"6c210780";
when 30 => instruction_out <= x"d0820c19";   -- 0078  LOP.AND R6, R6, c[0x1][0x2]; 
when 31 => instruction_out <= x"04400780";
when 32 => instruction_out <= x"30100e1d";   -- 0080  SHL R7, R7, 0x10; 
when 33 => instruction_out <= x"c4100780";
when 34 => instruction_out <= x"d0820a15";   -- 0088  LOP.AND R5, R5, c[0x1][0x2]; 
when 35 => instruction_out <= x"04400780";
when 36 => instruction_out <= x"d0821225";   -- 0090  LOP.AND R9, R9, c[0x1][0x2]; 
when 37 => instruction_out <= x"04400780";
when 38 => instruction_out <= x"d0821021";   -- 0098  LOP.AND R8, R8, c[0x1][0x2]; 
when 39 => instruction_out <= x"04400780";
when 40 => instruction_out <= x"60020001";   -- 00a0  IMAD.U16 R0, R0L, R1L, R7; 
when 41 => instruction_out <= x"0001c780";
when 42 => instruction_out <= x"d0061205";   -- 00a8  LOP.AND R1, R9, R6; 
when 43 => instruction_out <= x"04000780";
when 44 => instruction_out <= x"d0051015";   -- 00b0  LOP.AND R5, R8, R5; 
when 45 => instruction_out <= x"04000780";
when 46 => instruction_out <= x"20000011";   -- 00b8  IADD R4, R0, R4; 
when 47 => instruction_out <= x"04010780";
when 48 => instruction_out <= x"1000f819";   -- 00c0  MOV R6, R124; 
when 49 => instruction_out <= x"0403c780";
when 50 => instruction_out <= x"307c03fd";   -- 00c8  ISET.S32.C0 o[0x7f], R1, R124, EQ; 
when 51 => instruction_out <= x"6c0087c8";
when 52 => instruction_out <= x"a0022003";   -- 00d0  SSY 0x110; 
when 53 => instruction_out <= x"00000000";
when 54 => instruction_out <= x"10022003";   -- 00d8  BRA C0.NE, 0x110; 
when 55 => instruction_out <= x"00000280";
when 56 => instruction_out <= x"30040401";   -- 00e0  SHL R0, R2, 0x4; 
when 57 => instruction_out <= x"c4100780";
when 58 => instruction_out <= x"3002081d";   -- 00e8  SHL R7, R4, 0x2; 
when 59 => instruction_out <= x"c4100780";
when 60 => instruction_out <= x"20008600";   -- 00f0  IADD32 R0, R3, R0;
when 61 => instruction_out <= x"2107ea1c";   -- 00f4  IADD32 R7, g [0x5], R7;
when 62 => instruction_out <= x"00020005";   -- 00f8  R2A A1, R0, 0x2; 
when 63 => instruction_out <= x"c0000780";
when 64 => instruction_out <= x"d00e0e01";   -- 0100  GLD.U32 R0, global14[R7]; 
when 65 => instruction_out <= x"80c00780";
when 66 => instruction_out <= x"04001601";   -- 0108  R2G.U32.U32 g[A1+0xb], R0; 
when 67 => instruction_out <= x"e4200780";
when 68 => instruction_out <= x"f0000001";   -- 0110  NOP.S; 
when 69 => instruction_out <= x"e0000002";
when 70 => instruction_out <= x"861ffe03";   -- 0118  BAR.ARV.WAIT b0, 0xfff; 
when 71 => instruction_out <= x"00000000";
when 72 => instruction_out <= x"307c0bfd";   -- 0120  ISET.S32.C0 o[0x7f], R5, R124, EQ; 
when 73 => instruction_out <= x"6c0087c8";
when 74 => instruction_out <= x"a002d003";   -- 0128  SSY 0x168; 
when 75 => instruction_out <= x"00000000";
when 76 => instruction_out <= x"1002d003";   -- 0130  BRA C0.NE, 0x168; 
when 77 => instruction_out <= x"00000280";
when 78 => instruction_out <= x"30040401";   -- 0138  SHL R0, R2, 0x4; 
when 79 => instruction_out <= x"c4100780";
when 80 => instruction_out <= x"2000061d";   -- 0140  IADD R7, R3, R0; 
when 81 => instruction_out <= x"04000780";
when 82 => instruction_out <= x"30020801";   -- 0148  SHL R0, R4, 0x2; 
when 83 => instruction_out <= x"c4100780";
when 84 => instruction_out <= x"00020e05";   -- 0150  R2A A1, R7, 0x2; 
when 85 => instruction_out <= x"c0000780";
when 86 => instruction_out <= x"2100e81c";   -- 0158  IADD32 R7, g [0x4], R0;
when 87 => instruction_out <= x"1500f600";   -- 015c  MOV32 R0, g [A1+0xb];
when 88 => instruction_out <= x"d00e0e01";   -- 0160  GST.U32 global14[R7], R0; 
when 89 => instruction_out <= x"a0c00780";
when 90 => instruction_out <= x"f0000001";   -- 0168  NOP.S; 
when 91 => instruction_out <= x"e0000002";
when 92 => instruction_out <= x"20018c19";   -- 0170  IADD32I R6, R6, 0x1; 
when 93 => instruction_out <= x"00000003";
when 94 => instruction_out <= x"3006cffd";   -- 0178  ISET.S32.C0 o[0x7f], g [0x7], R6, LE; 
when 95 => instruction_out <= x"6c2147c8";
when 96 => instruction_out <= x"10019003";   -- 0180  BRA C0.NE, 0xc8; 
when 97 => instruction_out <= x"00000280";
when 98 => instruction_out <= x"f0000001";   -- 0188  NOP; 
when 99 => instruction_out <= x"e0000001";
when 100 => instruction_out <= x"30000003";   -- RET
when 101 => instruction_out <= x"00000780";

			when others => null;
		end case;
	end process;

end arch;
