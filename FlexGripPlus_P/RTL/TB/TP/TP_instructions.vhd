
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
	constant TP_INSTRUCTIONS : integer := 130;

begin
	num_instructions_out <= TP_INSTRUCTIONS;

	process(instruction_pointer_in)
	begin
		case instruction_pointer_in is
			when 0 => instruction_out <= x"10004205";   -- 0000  MOV.U16 R0H, g [0x1].U16; 
when 1 => instruction_out <= x"0023c780";
when 2 => instruction_out <= x"a0000005";   -- 0008  I2I.U32.U16 R1, R0L; 
when 3 => instruction_out <= x"04000780";
when 4 => instruction_out <= x"3001c809";   -- 0010  SHL R2, g [0x4], 0x1; 
when 5 => instruction_out <= x"c4300780";
when 6 => instruction_out <= x"60014c15";   -- 0018  IMAD.U16 R5, g [0x6].U16, R0H, R1; 
when 7 => instruction_out <= x"00204780";
when 8 => instruction_out <= x"2000c805";   -- 0020  IADD R1, g [0x4], R2; 
when 9 => instruction_out <= x"04208780";
when 10 => instruction_out <= x"2105e80c";   -- 0028  IADD32 R3, g [0x4], R5;
when 11 => instruction_out <= x"20028a00";   -- 002c  IADD32 R0, R5, R2;
when 12 => instruction_out <= x"20000a05";   -- 0030  IADD R1, R5, R1;           -- only calc of thread id
when 13 => instruction_out <= x"04004780";
when 14 => instruction_out <= x"30020a11";   -- 0038  SHL R4, R5, 0x2; 
when 15 => instruction_out <= x"c4100780";
when 16 => instruction_out <= x"30020619";   -- 0040  SHL R6, R3, 0x2; 
when 17 => instruction_out <= x"c4100780";
when 18 => instruction_out <= x"3002000d";   -- 0048  SHL R3, R0, 0x2; 
when 19 => instruction_out <= x"c4100780";
when 20 => instruction_out <= x"30020201";   -- 0050  SHL R0, R1, 0x2; 
when 21 => instruction_out <= x"c4100780";
when 22 => instruction_out <= x"2000ca05";   -- 0058  IADD R1, g [0x5], R4; --5
when 23 => instruction_out <= x"04210780";
when 24 => instruction_out <= x"d00e0209";   -- 0060  GLD.U32 R2, global14[R1];  -- float density
when 25 => instruction_out <= x"80c00780";
when 26 => instruction_out <= x"2000ca05";   -- 0068  IADD R1, g [0x5], R6; --5
when 27 => instruction_out <= x"04218780";
when 28 => instruction_out <= x"d00e0219";   -- 0070  GLD.U32 R6, global14[R1];  -- mom.x
when 29 => instruction_out <= x"80c00780";
when 30 => instruction_out <= x"2000ca05";   -- 0078  IADD R1, g [0x5], R3; --5
when 31 => instruction_out <= x"0420c780";
when 32 => instruction_out <= x"d00e020d";   -- 0080  GLD.U32 R3, global14[R1];  -- mom.y
when 33 => instruction_out <= x"80c00780";
when 34 => instruction_out <= x"2000ca01";   -- 0088  IADD R0, g [0x5], R0; --5
when 35 => instruction_out <= x"04200780";
when 36 => instruction_out <= x"d00e0005";   -- 0090  GLD.U32 R1, global14[R0];  -- mom.z
when 37 => instruction_out <= x"80c00780";										-- velocity.x
when 38 => instruction_out <= x"b08005fd";   -- 0098  FSET.C0 o[0x7f], |R2|, c[0x1][0x0], GT; -- 0x04 floating point  0x40800000 / 7e800000
when 39 => instruction_out <= x"605107c8";
when 40 => instruction_out <= x"10000401";   -- 00a0  MOV R0, R2; 
when 41 => instruction_out <= x"0403c780";
when 42 => instruction_out <= x"c0810c19";   -- 00a8  FMUL R6 (C0.NEU), R6, c[0x1][0x1];      -- 0x02 floating point  0x40000000  / 3
when 43 => instruction_out <= x"00400680";
when 44 => instruction_out <= x"c0810409";   -- 00b0  FMUL R2 (C0.NEU), R2, c[0x1][0x1]; 
when 45 => instruction_out <= x"00400680";
when 46 => instruction_out <= x"90000408";   -- 00b8  RCP32 R2, R2;
when 47 => instruction_out <= x"c0020c18";   -- 00bc  FMUL32 R6, R6, R2;    -- velocity.y
when 48 => instruction_out <= x"b08001fd";   -- 00c0  FSET.C0 o[0x7f], |R0|, c[0x1][0x0], GT; 
when 49 => instruction_out <= x"605107c8";
when 50 => instruction_out <= x"10000009";   -- 00c8  MOV R2, R0; 
when 51 => instruction_out <= x"0403c780";
when 52 => instruction_out <= x"c081060d";   -- 00d0  FMUL R3 (C0.NEU), R3, c[0x1][0x1]; 
when 53 => instruction_out <= x"00400680";
when 54 => instruction_out <= x"c0810409";   -- 00d8  FMUL R2 (C0.NEU), R2, c[0x1][0x1]; 
when 55 => instruction_out <= x"00400680";
when 56 => instruction_out <= x"90000408";   -- 00e0  RCP32 R2, R2;
when 57 => instruction_out <= x"c002060c";   -- 00e4  FMUL32 R3, R3, R2;   -- velocity.z
when 58 => instruction_out <= x"b08001fd";   -- 00e8  FSET.C0 o[0x7f], |R0|, c[0x1][0x0], GT; 
when 59 => instruction_out <= x"605107c8";
when 60 => instruction_out <= x"10000009";   -- 00f0  MOV R2, R0; 
when 61 => instruction_out <= x"0403c780";
when 62 => instruction_out <= x"c0810205";   -- 00f8  FMUL R1 (C0.NEU), R1, c[0x1][0x1]; 
when 63 => instruction_out <= x"00400680";
when 64 => instruction_out <= x"c0810409";   -- 0100  FMUL R2 (C0.NEU), R2, c[0x1][0x1]; 
when 65 => instruction_out <= x"00400680";
when 66 => instruction_out <= x"3002c81d";   -- 0108  SHL R7, g [0x4], 0x2; 
when 67 => instruction_out <= x"c4300780";
when 68 => instruction_out <= x"20078a14";   -- 0110  IADD32 R5, R5, R7;
when 69 => instruction_out <= x"c0060c1c";   -- 0114  FMUL32 R7, R6, R6;
when 70 => instruction_out <= x"90000419";   -- 0118  RCP R6, R2; 
when 71 => instruction_out <= x"00000780";
when 72 => instruction_out <= x"30020a09";   -- 0120  SHL R2, R5, 0x2; 
when 73 => instruction_out <= x"c4100780";
when 74 => instruction_out <= x"e0030615";   -- 0128  FMAD R5, R3, R3, R7; 
when 75 => instruction_out <= x"0001c780";
when 76 => instruction_out <= x"c006020c";   -- 0130  FMUL32 R3, R1, R6;
when 77 => instruction_out <= x"2102ea04";   -- 0134  IADD32 R1, g [0x5], R2; --5
when 78 => instruction_out <= x"d00e0205";   -- 0138  GLD.U32 R1, global14[R1]; 
when 79 => instruction_out <= x"80c00780";
when 80 => instruction_out <= x"e0030609";   -- 0140  FMAD R2, R3, R3, R5; 
when 81 => instruction_out <= x"00014780";
when 82 => instruction_out <= x"c000000d";   -- 0148  FMUL32I R3, R0, 0x3f000000; 
when 83 => instruction_out <= x"03f00003";
when 84 => instruction_out <= x"e003040d";   -- 0150  FMAD R3, -R2, R3, R1; 
when 85 => instruction_out <= x"04004780";
when 86 => instruction_out <= x"90000405";   -- 0158  RSQ R1, R2; 
when 87 => instruction_out <= x"40000780";
when 88 => instruction_out <= x"c00c0609";   -- 0160  FMUL32I R2, R3, 0x3ecccccc; 
when 89 => instruction_out <= x"03eccccf";
when 90 => instruction_out <= x"b08001fd";   -- 0168  FSET.C0 o[0x7f], |R0|, c[0x1][0x0], GT; 
when 91 => instruction_out <= x"605107c8";
when 92 => instruction_out <= x"90000205";   -- 0170  RCP R1, R1; 
when 93 => instruction_out <= x"00000780";
when 94 => instruction_out <= x"c0330409";   -- 0178  FMUL32I R2, R2, 0x3fb33333; 
when 95 => instruction_out <= x"03fb3333";
when 96 => instruction_out <= x"c0810409";   -- 0180  FMUL R2 (C0.NEU), R2, c[0x1][0x1]; 
when 97 => instruction_out <= x"00400680";
when 98 => instruction_out <= x"c0810001";   -- 0188  FMUL R0 (C0.NEU), R0, c[0x1][0x1]; 
when 99 => instruction_out <= x"00400680";
when 100 => instruction_out <= x"90000000";   -- 0190  RCP32 R0, R0;
when 101 => instruction_out <= x"c0000400";   -- 0194  FMUL32 R0, R2, R0;
when 102 => instruction_out <= x"90000001";   -- 0198  RSQ R0, R0; 
when 103 => instruction_out <= x"40000780";
when 104 => instruction_out <= x"90000008";   -- 01a0  RCP32 R2, R0;
when 105 => instruction_out <= x"2104ec00";   -- 01a4  IADD32 R0, g [0x6], R4; --6
when 106 => instruction_out <= x"d00e0001";   -- 01a8  GLD.U32 R0, global14[R0]; 
when 107 => instruction_out <= x"80c00780";
when 108 => instruction_out <= x"b0000205";   -- 01b0  FADD R1, R1, R2; 
when 109 => instruction_out <= x"00008780";
when 110 => instruction_out <= x"90000001";   -- 01b8  RSQ R0, R0; 
when 111 => instruction_out <= x"40000780";
when 112 => instruction_out <= x"90000000";   -- 01c0  RCP32 R0, R0;
when 113 => instruction_out <= x"c0000204";   -- 01c4  FMUL32 R1, R1, R0;
when 114 => instruction_out <= x"b08003fd";   -- 01c8  FSET.C0 o[0x7f], |R1|, c[0x1][0x0], GT; 
when 115 => instruction_out <= x"605107c8";
when 116 => instruction_out <= x"10008001";   -- 01d0  MVI R0, 0x3f000000; 
when 117 => instruction_out <= x"03f00003";
when 118 => instruction_out <= x"c0810205";   -- 01d8  FMUL R1 (C0.NEU), R1, c[0x1][0x1]; /3                      0x40400000
when 119 => instruction_out <= x"00400680";
when 120 => instruction_out <= x"10000401";   -- 01e0  MVC R0 (C0.NEU), c[0x1] [0x2]; -- 2 floating point         0x40000000
when 121 => instruction_out <= x"2440c680";
when 122 => instruction_out <= x"90000204";   -- 01e8  RCP32 R1, R1;
when 123 => instruction_out <= x"c0010004";   -- 01ec  FMUL32 R1, R0, R1;
when 124 => instruction_out <= x"2000ce01";   -- 01f0  IADD R0, g [0x7], R4; -- 7
when 125 => instruction_out <= x"04210780";
when 126 => instruction_out <= x"d00e0005";   -- 01f8  GST.U32 global14[R0], R1; 
when 127 => instruction_out <= x"a0c00781";
when 128 => instruction_out <= x"30000003";   -- RET
when 129 => instruction_out <= x"00000780";

			when others => null;
		end case;
	end process;

end arch;
