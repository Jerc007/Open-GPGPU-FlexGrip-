
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
	constant TP_INSTRUCTIONS : integer := 136;

begin
	num_instructions_out <= TP_INSTRUCTIONS;

	process(instruction_pointer_in)
	begin
		case instruction_pointer_in is
			when 0 => instruction_out <= x"10004205";   -- 0000  MOV.U16 R0H, g [0x1].U16; 
when 1 => instruction_out <= x"0023c780";
when 2 => instruction_out <= x"a0000005";   -- 0008  I2I.U32.U16 R1, R0L; 
when 3 => instruction_out <= x"04000780";
when 4 => instruction_out <= x"60014c05";   -- 0010  IMAD.U16 R1, g [0x6].U16, R0H, R1; 
when 5 => instruction_out <= x"00204780";
when 6 => instruction_out <= x"30020201";   -- 0018  SHL R0, R1, 0x2; 
when 7 => instruction_out <= x"c4100780";
when 8 => instruction_out <= x"2000c815";   -- 0020  IADD R5, g [0x4], R0; 
when 9 => instruction_out <= x"04200780";
when 10 => instruction_out <= x"3080cdfd";   -- 0028  ISET.S32.C0 o[0x7f], g [0x6], c[0x1][0x0], LE; 
when 11 => instruction_out <= x"6c6047c8";
when 12 => instruction_out <= x"2000ca19";   -- 0030  IADD R6, g [0x5], R0; 
when 13 => instruction_out <= x"04200780";
when 14 => instruction_out <= x"d00e0a1d";   -- 0038  GLD.U32 R7, global14[R5]; 
when 15 => instruction_out <= x"80c00780";
when 16 => instruction_out <= x"d00e0c1d";   -- 0040  GST.U32 global14[R6], R7; 
when 17 => instruction_out <= x"a0c00780";
when 18 => instruction_out <= x"1001a003";   -- 0048  BRA C0.NE, 0xd0; 
when 19 => instruction_out <= x"00000280";
when 20 => instruction_out <= x"a0019003";   -- 0050  SSY 0xc8; 
when 21 => instruction_out <= x"00000000";
when 22 => instruction_out <= x"10018011";   -- 0058  MVI R4, 0x1; 
when 23 => instruction_out <= x"00000003";
when 24 => instruction_out <= x"30010809";   -- 0060  SHL R2, R4, 0x1; 
when 25 => instruction_out <= x"c4100780";
when 26 => instruction_out <= x"10008200";   -- 0068  MOV32 R0, R1;
when 27 => instruction_out <= x"1000840c";   -- 006c  MOV32 R3, R2;
when 28 => instruction_out <= x"2001e003";   -- 0070  CAL.NOINC 0xf0; 
when 29 => instruction_out <= x"00000000";
when 30 => instruction_out <= x"307c01fd";   -- 0078  ISET.S32.C0 o[0x7f], R0, R124, NE; 
when 31 => instruction_out <= x"6c0147c8";
when 32 => instruction_out <= x"20000801";   -- 0080  IADD R0 (C0.EQU), R4, R1; 
when 33 => instruction_out <= x"04004500";
when 34 => instruction_out <= x"30020001";   -- 0088  SHL R0 (C0.EQU), R0, 0x2; 
when 35 => instruction_out <= x"c4100500";
when 36 => instruction_out <= x"2000ca01";   -- 0090  IADD R0 (C0.EQU), g [0x5], R0; 
when 37 => instruction_out <= x"04200500";
when 38 => instruction_out <= x"d00e0001";   -- 0098  GLD.U32 R0 (C0.EQU), global14[R0]; 
when 39 => instruction_out <= x"80c00500";
when 40 => instruction_out <= x"2000001d";   -- 00a0  IADD R7 (C0.EQU), R0, R7; 
when 41 => instruction_out <= x"0401c500";
when 42 => instruction_out <= x"d00e0c1d";   -- 00a8  GST.U32 global14[R6] (C0.EQU), R7; 
when 43 => instruction_out <= x"a0c00500";
when 44 => instruction_out <= x"3002cdfd";   -- 00b0  ISET.S32.C0 o[0x7f], g [0x6], R2, LE; 
when 45 => instruction_out <= x"6c2187c8";
when 46 => instruction_out <= x"10000411";   -- 00b8  MOV R4, R2; 
when 47 => instruction_out <= x"0403c780";
when 48 => instruction_out <= x"1000c003";   -- 00c0  BRA C0.NE, 0x60; 
when 49 => instruction_out <= x"00000280";
when 50 => instruction_out <= x"f0000001";   -- 00c8  NOP.S; 
when 51 => instruction_out <= x"e0000002";
when 52 => instruction_out <= x"307c03fd";   -- 00d0  ISET.S32.C0 o[0x7f], R1, R124, NE; 
when 53 => instruction_out <= x"6c0147c8";
when 54 => instruction_out <= x"30000003";   -- 00d8  RET C0.NE; 
when 55 => instruction_out <= x"00000280";
when 56 => instruction_out <= x"d00e0a1d";   -- 00e0  GST.U32 global14[R5], R7; 
when 57 => instruction_out <= x"a0c00780";
when 58 => instruction_out <= x"30000003";   -- 00e8  RET ; 
when 59 => instruction_out <= x"00000780";
when 60 => instruction_out <= x"a0000621";   -- 00f0  I2I.U32.S32 R8, |R3|; 
when 61 => instruction_out <= x"04114780";
when 62 => instruction_out <= x"a0001025";   -- 00f8  I2F.F32.U32 R9, R8; 
when 63 => instruction_out <= x"44004780";
when 64 => instruction_out <= x"a0000029";   -- 0100  I2I.U32.S32 R10, |R0|; 
when 65 => instruction_out <= x"04114780";
when 66 => instruction_out <= x"9000122d";   -- 0108  RCP R11, R9; 
when 67 => instruction_out <= x"00000780";
when 68 => instruction_out <= x"a0001425";   -- 0110  I2F.F32.U32.TRUNC R9, R10; 
when 69 => instruction_out <= x"44064780";
when 70 => instruction_out <= x"203e962d";   -- 0118  IADD32I R11, R11, 0xfffffffe; 
when 71 => instruction_out <= x"0fffffff";
when 72 => instruction_out <= x"c00b1225";   -- 0120  FMUL.TRUNC.C0 R9, R9, R11; 
when 73 => instruction_out <= x"0000c7c0";
when 74 => instruction_out <= x"a0001225";   -- 0128  F2I.U32.F32.TRUNC R9, R9; 
when 75 => instruction_out <= x"84064780";
when 76 => instruction_out <= x"40132031";   -- 0130  IMUL.U16.U16 R12, R8L, R9H; 
when 77 => instruction_out <= x"00000780";
when 78 => instruction_out <= x"60122231";   -- 0138  IMAD.U16 R12, R8H, R9L, R12; 
when 79 => instruction_out <= x"00030780";
when 80 => instruction_out <= x"30101831";   -- 0140  SHL R12, R12, 0x10; 
when 81 => instruction_out <= x"c4100780";
when 82 => instruction_out <= x"60122031";   -- 0148  IMAD.U16 R12, R8L, R9L, R12; 
when 83 => instruction_out <= x"00030780";
when 84 => instruction_out <= x"20401431";   -- 0150  IADD R12, R10, -R12; 
when 85 => instruction_out <= x"04030780";
when 86 => instruction_out <= x"a0001831";   -- 0158  I2F.F32.U32.TRUNC R12, R12; 
when 87 => instruction_out <= x"44064780";
when 88 => instruction_out <= x"c00b182d";   -- 0160  FMUL.TRUNC.C0 R11, R12, R11; 
when 89 => instruction_out <= x"0000c7c0";
when 90 => instruction_out <= x"a000162d";   -- 0168  F2I.U32.F32.TRUNC R11, R11; 
when 91 => instruction_out <= x"84064780";
when 92 => instruction_out <= x"20001225";   -- 0170  IADD R9, R9, R11; 
when 93 => instruction_out <= x"0402c780";
when 94 => instruction_out <= x"4010262d";   -- 0178  IMUL.U16.U16 R11, R9H, R8L; 
when 95 => instruction_out <= x"00000780";
when 96 => instruction_out <= x"6011242d";   -- 0180  IMAD.U16 R11, R9L, R8H, R11; 
when 97 => instruction_out <= x"0002c780";
when 98 => instruction_out <= x"3010162d";   -- 0188  SHL R11, R11, 0x10; 
when 99 => instruction_out <= x"c4100780";
when 100 => instruction_out <= x"6010242d";   -- 0190  IMAD.U16 R11, R9L, R8L, R11; 
when 101 => instruction_out <= x"0002c780";
when 102 => instruction_out <= x"3000162d";   -- 0198  IADD R11, -R11, R10; 
when 103 => instruction_out <= x"04028780";
when 104 => instruction_out <= x"300b102d";   -- 01a0  ISET R11, R8, R11, LE; 
when 105 => instruction_out <= x"6400c780";
when 106 => instruction_out <= x"30001625";   -- 01a8  IADD R9, -R11, R9; 
when 107 => instruction_out <= x"04024780";
when 108 => instruction_out <= x"4010262d";   -- 01b0  IMUL.U16.U16 R11, R9H, R8L; 
when 109 => instruction_out <= x"00000780";
when 110 => instruction_out <= x"6011242d";   -- 01b8  IMAD.U16 R11, R9L, R8H, R11; 
when 111 => instruction_out <= x"0002c780";
when 112 => instruction_out <= x"3010162d";   -- 01c0  SHL R11, R11, 0x10; 
when 113 => instruction_out <= x"c4100780";
when 114 => instruction_out <= x"60102421";   -- 01c8  IMAD.U16 R8, R9L, R8L, R11; 
when 115 => instruction_out <= x"0002c780";
when 116 => instruction_out <= x"301f0001";   -- 01d0  SHR R0, R0, 0x1f; 
when 117 => instruction_out <= x"e4100780";
when 118 => instruction_out <= x"30001025";   -- 01d8  IADD R9, -R8, R10; 
when 119 => instruction_out <= x"04028780";
when 120 => instruction_out <= x"a0000021";   -- 01e0  I2I.S32.S32 R8, -R0; 
when 121 => instruction_out <= x"2c014780";
when 122 => instruction_out <= x"d0091021";   -- 01e8  LOP.XOR R8, R8, R9; 
when 123 => instruction_out <= x"04008780";
when 124 => instruction_out <= x"307c07fd";   -- 01f0  ISET.S32.C0 o[0x7f], R3, R124, NE; 
when 125 => instruction_out <= x"6c0147c8";
when 126 => instruction_out <= x"20000001";   -- 01f8  IADD R0, R0, R8; 
when 127 => instruction_out <= x"04020780";
when 128 => instruction_out <= x"d0030001";   -- 0200  LOP.PASS_B R0 (C0.EQU), R0, ~R3; 
when 129 => instruction_out <= x"0402c500";
when 130 => instruction_out <= x"30000003";   -- 0208  RET ; 
when 131 => instruction_out <= x"00000780";
when 132 => instruction_out <= x"f0000001";   -- 0210  NOP; 
when 133 => instruction_out <= x"e0000001";
when 134 => instruction_out <= x"30000003";   -- RET
when 135 => instruction_out <= x"00000780";

			when others => null;
		end case;
	end process;

end arch;
