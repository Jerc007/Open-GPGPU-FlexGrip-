
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
	constant TP_INSTRUCTIONS : integer := 106;

begin
	num_instructions_out <= TP_INSTRUCTIONS;

	process(instruction_pointer_in)
	begin
		case instruction_pointer_in is
			when 0 => instruction_out <= x"d0820205";   -- 0000  LOP.AND.U16 R0H, R0H, c[0x1][0x2]; 
when 1 => instruction_out <= x"00400780";
when 2 => instruction_out <= x"a0000205";   -- 0008  I2I.U32.U16 R1, R0H; 
when 3 => instruction_out <= x"04000780";
when 4 => instruction_out <= x"41202809";   -- 0010  IMUL32I.U16.U16 R2, g [0x4].U16, 0x20; 
when 5 => instruction_out <= x"00000003";
when 6 => instruction_out <= x"a0000001";   -- 0018  I2I.U32.U16 R0, R0L; 
when 7 => instruction_out <= x"04000780";
when 8 => instruction_out <= x"61202e05";   -- 0020  IMAD32I.U16 R1, g [0x7].U16, 0x20, R1; 
when 9 => instruction_out <= x"00000003";
when 10 => instruction_out <= x"61202c01";   -- 0028  IMAD32I.U16 R0, g [0x6].U16, 0x20, R0; 
when 11 => instruction_out <= x"00000003";
when 12 => instruction_out <= x"40030810";   -- 0030  IMUL32.U16.U16 R4, R2L, R1H;
when 13 => instruction_out <= x"4001080c";   -- 0034  IMUL32.U16.U16 R3, R2L, R0H;
when 14 => instruction_out <= x"60020a11";   -- 0038  IMAD.U16 R4, R2H, R1L, R4; 
when 15 => instruction_out <= x"00010780";
when 16 => instruction_out <= x"60000a0d";   -- 0040  IMAD.U16 R3, R2H, R0L, R3; 
when 17 => instruction_out <= x"0000c780";
when 18 => instruction_out <= x"30100811";   -- 0048  SHL R4, R4, 0x10; 
when 19 => instruction_out <= x"c4100780";
when 20 => instruction_out <= x"3010060d";   -- 0050  SHL R3, R3, 0x10; 
when 21 => instruction_out <= x"c4100780";
when 22 => instruction_out <= x"60020811";   -- 0058  IMAD.U16 R4, R2L, R1L, R4; 
when 23 => instruction_out <= x"00010780";
when 24 => instruction_out <= x"6000080d";   -- 0060  IMAD.U16 R3, R2L, R0L, R3; 
when 25 => instruction_out <= x"0000c780";
when 26 => instruction_out <= x"20048014";   -- 0068  IADD32 R5, R0, R4;
when 27 => instruction_out <= x"20018610";   -- 006c  IADD32 R4, R3, R1;
when 28 => instruction_out <= x"30020a15";   -- 0070  SHL R5, R5, 0x2; 
when 29 => instruction_out <= x"c4100780";
when 30 => instruction_out <= x"2008820d";   -- 0078  IADD32I R3, R1, 0x8; 
when 31 => instruction_out <= x"00000003";
when 32 => instruction_out <= x"30020811";   -- 0080  SHL R4, R4, 0x2; 
when 33 => instruction_out <= x"c4100780";
when 34 => instruction_out <= x"2000ca15";   -- 0088  IADD R5, g [0x5], R5; 
when 35 => instruction_out <= x"04214780";
when 36 => instruction_out <= x"d00e0a15";   -- 0090  GLD.U32 R5, global14[R5]; 
when 37 => instruction_out <= x"80c00780";
when 38 => instruction_out <= x"40070818";   -- 0098  IMUL32.U16.U16 R6, R2L, R3H;
when 39 => instruction_out <= x"2104e810";   -- 009c  IADD32 R4, g [0x4], R4;
when 40 => instruction_out <= x"60060a19";   -- 00a0  IMAD.U16 R6, R2H, R3L, R6; 
when 41 => instruction_out <= x"00018780";
when 42 => instruction_out <= x"30100c19";   -- 00a8  SHL R6, R6, 0x10; 
when 43 => instruction_out <= x"c4100780";
when 44 => instruction_out <= x"6006080d";   -- 00b0  IMAD.U16 R3, R2L, R3L, R6; 
when 45 => instruction_out <= x"00018780";
when 46 => instruction_out <= x"2000000d";   -- 00b8  IADD R3, R0, R3; 
when 47 => instruction_out <= x"0400c780";
when 48 => instruction_out <= x"30020619";   -- 00c0  SHL R6, R3, 0x2; 
when 49 => instruction_out <= x"c4100780";
when 50 => instruction_out <= x"2010820d";   -- 00c8  IADD32I R3, R1, 0x10; 
when 51 => instruction_out <= x"00000003";
when 52 => instruction_out <= x"d00e0815";   -- 00d0  GST.U32 global14[R4], R5; 
when 53 => instruction_out <= x"a0c00780";
when 54 => instruction_out <= x"2000ca15";   -- 00d8  IADD R5, g [0x5], R6; 
when 55 => instruction_out <= x"04218780";
when 56 => instruction_out <= x"d00e0a15";   -- 00e0  GLD.U32 R5, global14[R5]; 
when 57 => instruction_out <= x"80c00780";
when 58 => instruction_out <= x"4007081d";   -- 00e8  IMUL.U16.U16 R7, R2L, R3H; 
when 59 => instruction_out <= x"00000780";
when 60 => instruction_out <= x"20208819";   -- 00f0  IADD32I R6, R4, 0x20; 
when 61 => instruction_out <= x"00000003";
when 62 => instruction_out <= x"60060a1d";   -- 00f8  IMAD.U16 R7, R2H, R3L, R7; 
when 63 => instruction_out <= x"0001c780";
when 64 => instruction_out <= x"30100e1d";   -- 0100  SHL R7, R7, 0x10; 
when 65 => instruction_out <= x"c4100780";
when 66 => instruction_out <= x"6006080d";   -- 0108  IMAD.U16 R3, R2L, R3L, R7; 
when 67 => instruction_out <= x"0001c780";
when 68 => instruction_out <= x"2000000d";   -- 0110  IADD R3, R0, R3; 
when 69 => instruction_out <= x"0400c780";
when 70 => instruction_out <= x"3002060d";   -- 0118  SHL R3, R3, 0x2; 
when 71 => instruction_out <= x"c4100780";
when 72 => instruction_out <= x"20188205";   -- 0120  IADD32I R1, R1, 0x18; 
when 73 => instruction_out <= x"00000003";
when 74 => instruction_out <= x"d00e0c15";   -- 0128  GST.U32 global14[R6], R5; 
when 75 => instruction_out <= x"a0c00780";
when 76 => instruction_out <= x"2000ca0d";   -- 0130  IADD R3, g [0x5], R3; 
when 77 => instruction_out <= x"0420c780";
when 78 => instruction_out <= x"d00e060d";   -- 0138  GLD.U32 R3, global14[R3]; 
when 79 => instruction_out <= x"80c00780";
when 80 => instruction_out <= x"40030819";   -- 0140  IMUL.U16.U16 R6, R2L, R1H; 
when 81 => instruction_out <= x"00000780";
when 82 => instruction_out <= x"20008815";   -- 0148  IADD32I R5, R4, 0x40; 
when 83 => instruction_out <= x"00000007";
when 84 => instruction_out <= x"60020a19";   -- 0150  IMAD.U16 R6, R2H, R1L, R6; 
when 85 => instruction_out <= x"00018780";
when 86 => instruction_out <= x"30100c19";   -- 0158  SHL R6, R6, 0x10; 
when 87 => instruction_out <= x"c4100780";
when 88 => instruction_out <= x"60020805";   -- 0160  IMAD.U16 R1, R2L, R1L, R6; 
when 89 => instruction_out <= x"00018780";
when 90 => instruction_out <= x"20000001";   -- 0168  IADD R0, R0, R1; 
when 91 => instruction_out <= x"04004780";
when 92 => instruction_out <= x"30020001";   -- 0170  SHL R0, R0, 0x2; 
when 93 => instruction_out <= x"c4100780";
when 94 => instruction_out <= x"d00e0a0d";   -- 0178  GST.U32 global14[R5], R3; 
when 95 => instruction_out <= x"a0c00780";
when 96 => instruction_out <= x"2000ca01";   -- 0180  IADD R0, g [0x5], R0; 
when 97 => instruction_out <= x"04200780";
when 98 => instruction_out <= x"d00e0001";   -- 0188  GLD.U32 R0, global14[R0]; 
when 99 => instruction_out <= x"80c00780";
when 100 => instruction_out <= x"20208805";   -- 0190  IADD32I R1, R4, 0x60; 
when 101 => instruction_out <= x"00000007";
when 102 => instruction_out <= x"d00e0201";   -- 0198  GST.U32 global14[R1], R0; 
when 103 => instruction_out <= x"a0c00781";
when 104 => instruction_out <= x"30000003";   -- RET
when 105 => instruction_out <= x"00000780";

			when others => null;
		end case;
	end process;

end arch;
