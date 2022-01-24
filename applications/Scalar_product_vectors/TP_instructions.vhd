
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
when 0 => instruction_out <= x"10004205";   -- MOV.U16 R0H, g [0x1].U16;
when 1 => instruction_out <= x"0023c780";
when 2 => instruction_out <= x"a0000005";   -- I2I.U32.U16 R1, R0L;
when 3 => instruction_out <= x"04000780";
when 4 => instruction_out <= x"60014c05";   -- IMAD.U16 R1, g [0x6].U16, R0H, R1;
when 5 => instruction_out <= x"00204780";
when 6 => instruction_out <= x"3002020d";   -- SHL R3, R1, 0x2;
when 7 => instruction_out <= x"c4100780";
when 8 => instruction_out <= x"2103ea00";   -- IADD32 R0, g [0x5], R3;
when 9 => instruction_out <= x"2103ec08";   -- IADD32 R2, g [0x6], R3;
when 10 => instruction_out <= x"d00e0001";   -- GLD.U32 R0, global14[R0];
when 11 => instruction_out <= x"80c00780";
when 12 => instruction_out <= x"d00e0409";   -- GLD.U32 R2, global14[R2];
when 13 => instruction_out <= x"80c00780";
when 14 => instruction_out <= x"40050011";   -- IMUL.U16.U16 R4, R0L, R2H;
when 15 => instruction_out <= x"00000780";
when 16 => instruction_out <= x"60040211";   -- IMAD.U16 R4, R0H, R2L, R4;
when 17 => instruction_out <= x"00010780";
when 18 => instruction_out <= x"30100811";   -- SHL R4, R4, 0x10;
when 19 => instruction_out <= x"c4100780";
when 20 => instruction_out <= x"60040019";   -- IMAD.U16 R6, R0L, R2L, R4;
when 21 => instruction_out <= x"00010780";
when 22 => instruction_out <= x"2000c815";   -- IADD R5, g [0x4], R3;
when 23 => instruction_out <= x"0420c780";
when 24 => instruction_out <= x"3080cffd";   -- ISET.S32.C0 o[0x7f], g [0x7], c[0x1][0x0], LE;
when 25 => instruction_out <= x"6c6047c8";
when 26 => instruction_out <= x"d00e0a19";   -- GST.U32 global14[R5], R6;
when 27 => instruction_out <= x"a0c00780";
when 28 => instruction_out <= x"30000003";   -- RET C0.NE;
when 29 => instruction_out <= x"00000280";
when 30 => instruction_out <= x"10018009";   -- MVI R2, 0x1;
when 31 => instruction_out <= x"00000003";
when 32 => instruction_out <= x"3001040d";   -- SHL R3, R2, 0x1;
when 33 => instruction_out <= x"c4100780";
when 34 => instruction_out <= x"10008200";   -- MOV32 R0, R1;
when 35 => instruction_out <= x"10008610";   -- MOV32 R4, R3;
when 36 => instruction_out <= x"2001e003";   -- CAL.NOINC 0xf0;
when 37 => instruction_out <= x"00000000";
when 38 => instruction_out <= x"307c01fd";   -- ISET.S32.C0 o[0x7f], R0, R124, NE;
when 39 => instruction_out <= x"6c0147c8";
when 40 => instruction_out <= x"20000401";   -- IADD R0 (C0.EQU), R2, R1;
when 41 => instruction_out <= x"04004500";
when 42 => instruction_out <= x"30020001";   -- SHL R0 (C0.EQU), R0, 0x2;
when 43 => instruction_out <= x"c4100500";
when 44 => instruction_out <= x"2000c801";   -- IADD R0 (C0.EQU), g [0x4], R0;
when 45 => instruction_out <= x"04200500";
when 46 => instruction_out <= x"d00e0001";   -- GLD.U32 R0 (C0.EQU), global14[R0];
when 47 => instruction_out <= x"80c00500";
when 48 => instruction_out <= x"20000019";   -- IADD R6 (C0.EQU), R0, R6;
when 49 => instruction_out <= x"04018500";
when 50 => instruction_out <= x"d00e0a19";   -- GST.U32 global14[R5] (C0.EQU), R6;
when 51 => instruction_out <= x"a0c00500";
when 52 => instruction_out <= x"3003cffd";   -- ISET.S32.C0 o[0x7f], g [0x7], R3, LE;
when 53 => instruction_out <= x"6c2187c8";
when 54 => instruction_out <= x"10000609";   -- MOV R2, R3;
when 55 => instruction_out <= x"0403c780";
when 56 => instruction_out <= x"10010003";   -- BRA C0.NE, 0x80;
when 57 => instruction_out <= x"00000280";
when 58 => instruction_out <= x"30000003";   -- RET ;
when 59 => instruction_out <= x"00000780";
when 60 => instruction_out <= x"a000081d";   -- I2I.U32.S32 R7, |R4|;
when 61 => instruction_out <= x"04114780";
when 62 => instruction_out <= x"a0000e21";   -- I2F.F32.U32 R8, R7;
when 63 => instruction_out <= x"44004780";
when 64 => instruction_out <= x"a0000025";   -- I2I.U32.S32 R9, |R0|;
when 65 => instruction_out <= x"04114780";
when 66 => instruction_out <= x"90001029";   -- RCP R10, R8;
when 67 => instruction_out <= x"00000780";
when 68 => instruction_out <= x"a0001221";   -- I2F.F32.U32.TRUNC R8, R9;
when 69 => instruction_out <= x"44064780";
when 70 => instruction_out <= x"203e9429";   -- IADD32I R10, R10, 0xfffffffe;
when 71 => instruction_out <= x"0fffffff";
when 72 => instruction_out <= x"c00a1021";   -- FMUL.TRUNC.C0 R8, R8, R10;
when 73 => instruction_out <= x"0000c7c0";
when 74 => instruction_out <= x"a0001021";   -- F2I.U32.F32.TRUNC R8, R8;
when 75 => instruction_out <= x"84064780";
when 76 => instruction_out <= x"40111c2d";   -- IMUL.U16.U16 R11, R7L, R8H;
when 77 => instruction_out <= x"00000780";
when 78 => instruction_out <= x"60101e2d";   -- IMAD.U16 R11, R7H, R8L, R11;
when 79 => instruction_out <= x"0002c780";
when 80 => instruction_out <= x"3010162d";   -- SHL R11, R11, 0x10;
when 81 => instruction_out <= x"c4100780";
when 82 => instruction_out <= x"60101c2d";   -- IMAD.U16 R11, R7L, R8L, R11;
when 83 => instruction_out <= x"0002c780";
when 84 => instruction_out <= x"2040122d";   -- IADD R11, R9, -R11;
when 85 => instruction_out <= x"0402c780";
when 86 => instruction_out <= x"a000162d";   -- I2F.F32.U32.TRUNC R11, R11;
when 87 => instruction_out <= x"44064780";
when 88 => instruction_out <= x"c00a1629";   -- FMUL.TRUNC.C0 R10, R11, R10;
when 89 => instruction_out <= x"0000c7c0";
when 90 => instruction_out <= x"a0001429";   -- F2I.U32.F32.TRUNC R10, R10;
when 91 => instruction_out <= x"84064780";
when 92 => instruction_out <= x"20001021";   -- IADD R8, R8, R10;
when 93 => instruction_out <= x"04028780";
when 94 => instruction_out <= x"400e2229";   -- IMUL.U16.U16 R10, R8H, R7L;
when 95 => instruction_out <= x"00000780";
when 96 => instruction_out <= x"600f2029";   -- IMAD.U16 R10, R8L, R7H, R10;
when 97 => instruction_out <= x"00028780";
when 98 => instruction_out <= x"30101429";   -- SHL R10, R10, 0x10;
when 99 => instruction_out <= x"c4100780";
when 100 => instruction_out <= x"600e2029";   -- IMAD.U16 R10, R8L, R7L, R10;
when 101 => instruction_out <= x"00028780";
when 102 => instruction_out <= x"30001429";   -- IADD R10, -R10, R9;
when 103 => instruction_out <= x"04024780";
when 104 => instruction_out <= x"300a0e29";   -- ISET R10, R7, R10, LE;
when 105 => instruction_out <= x"6400c780";
when 106 => instruction_out <= x"30001421";   -- IADD R8, -R10, R8;
when 107 => instruction_out <= x"04020780";
when 108 => instruction_out <= x"400e2229";   -- IMUL.U16.U16 R10, R8H, R7L;
when 109 => instruction_out <= x"00000780";
when 110 => instruction_out <= x"600f2029";   -- IMAD.U16 R10, R8L, R7H, R10;
when 111 => instruction_out <= x"00028780";
when 112 => instruction_out <= x"30101429";   -- SHL R10, R10, 0x10;
when 113 => instruction_out <= x"c4100780";
when 114 => instruction_out <= x"600e201d";   -- IMAD.U16 R7, R8L, R7L, R10;
when 115 => instruction_out <= x"00028780";
when 116 => instruction_out <= x"301f0001";   -- SHR R0, R0, 0x1f;
when 117 => instruction_out <= x"e4100780";
when 118 => instruction_out <= x"30000e21";   -- IADD R8, -R7, R9;
when 119 => instruction_out <= x"04024780";
when 120 => instruction_out <= x"a000001d";   -- I2I.S32.S32 R7, -R0;
when 121 => instruction_out <= x"2c014780";
when 122 => instruction_out <= x"d0080e1d";   -- LOP.XOR R7, R7, R8;
when 123 => instruction_out <= x"04008780";
when 124 => instruction_out <= x"307c09fd";   -- ISET.S32.C0 o[0x7f], R4, R124, NE;
when 125 => instruction_out <= x"6c0147c8";
when 126 => instruction_out <= x"20000001";   -- IADD R0, R0, R7;
when 127 => instruction_out <= x"0401c780";
when 128 => instruction_out <= x"d0040001";   -- LOP.PASS_B R0 (C0.EQU), R0, ~R4;
when 129 => instruction_out <= x"0402c500";
when 130 => instruction_out <= x"30000003";   -- RET ;
when 131 => instruction_out <= x"00000780";
when 132 => instruction_out <= x"f0000001";   -- NOP;
when 133 => instruction_out <= x"e0000001";
when 134 => instruction_out <= x"30000003";   -- RET
when 135 => instruction_out <= x"00000780";

			when others => null;
		end case;
	end process;

end arch;
