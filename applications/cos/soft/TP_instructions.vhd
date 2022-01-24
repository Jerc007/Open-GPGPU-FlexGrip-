
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
	constant TP_INSTRUCTIONS : integer := 64;

begin
	num_instructions_out <= TP_INSTRUCTIONS;

	process(instruction_pointer_in)
	begin
		case instruction_pointer_in is
			when 0 => instruction_out <= x"10004205";   -- 0000  MOV.U16 R0H, g [0x1].U16; 
when 1 => instruction_out <= x"0023c780";
when 2 => instruction_out <= x"a0000005";   -- 0008  I2I.U32.U16 R1, R0L; 
when 3 => instruction_out <= x"04000780";
when 4 => instruction_out <= x"60014c01";   -- 0010  IMAD.U16 R0, g [0x6].U16, R0H, R1; 
when 5 => instruction_out <= x"00204780";
when 6 => instruction_out <= x"30020009";   -- 0018  SHL R2, R0, 0x2; 
when 7 => instruction_out <= x"c4100780";
when 8 => instruction_out <= x"10008001";   -- 0020  MVI R0, 0x41c00000; 
when 9 => instruction_out <= x"041c0003";
when 10 => instruction_out <= x"2000ca05";   -- 0028  IADD R1, g [0x5], R2; 
when 11 => instruction_out <= x"04208780";
when 12 => instruction_out <= x"b08001fd";   -- 0030  FSET.C0 o[0x7f], R0, c[0x1][0x0], GT; 
when 13 => instruction_out <= x"604107c8";
when 14 => instruction_out <= x"d00e020d";   -- 0038  GLD.U32 R3, global14[R1]; 
when 15 => instruction_out <= x"80c00780";
when 16 => instruction_out <= x"c0030610";   -- 0040  FMUL32 R4, R3, R3;
when 17 => instruction_out <= x"c0040600";   -- 0044  FMUL32 R0, R3, R4;
when 18 => instruction_out <= x"c0000605";   -- 0048  FMUL R1, R3, R0; 
when 19 => instruction_out <= x"00000780";
when 20 => instruction_out <= x"10008015";   -- 0050  MVI R5, 0x41c00000; 
when 21 => instruction_out <= x"041c0003";
when 22 => instruction_out <= x"10000201";   -- 0058  MOV R0, R1; 
when 23 => instruction_out <= x"0403c780";
when 24 => instruction_out <= x"c0810205";   -- 0060  FMUL R1 (C0.NEU), R1, c[0x1][0x1]; 
when 25 => instruction_out <= x"00400680";
when 26 => instruction_out <= x"10000415";   -- 0068  MVC R5 (C0.NEU), c[0x1] [0x2]; 
when 27 => instruction_out <= x"2440c680";
when 28 => instruction_out <= x"c0000819";   -- 0070  FMUL32I R6, R4, 0x3f000000; 
when 29 => instruction_out <= x"03f00003";
when 30 => instruction_out <= x"90000a11";   -- 0078  RCP R4, R5; 
when 31 => instruction_out <= x"00000780";
when 32 => instruction_out <= x"a0000c15";   -- 0080  F2F.F32.F32 R5, R6; 
when 33 => instruction_out <= x"c4004780";
when 34 => instruction_out <= x"c0040211";   -- 0088  FMUL R4, R1, R4; 
when 35 => instruction_out <= x"00000780";
when 36 => instruction_out <= x"10008005";   -- 0090  MVI R1, 0x44340000; 
when 37 => instruction_out <= x"04434003";
when 38 => instruction_out <= x"b0008a15";   -- 0098  FADD32I R5, -R5, 0x3f800000; 
when 39 => instruction_out <= x"03f80003";
when 40 => instruction_out <= x"a0000811";   -- 00a0  F2F.F32.F32 R4, R4; 
when 41 => instruction_out <= x"c4004780";
when 42 => instruction_out <= x"c0000619";   -- 00a8  FMUL R6, R3, R0; 
when 43 => instruction_out <= x"00000780";
when 44 => instruction_out <= x"b08003fd";   -- 00b0  FSET.C0 o[0x7f], R1, c[0x1][0x0], GT; 
when 45 => instruction_out <= x"604107c8";
when 46 => instruction_out <= x"b0050800";   -- 00b8  FADD32 R0, R4, R5;
when 47 => instruction_out <= x"c0060604";   -- 00bc  FMUL32 R1, R3, R6;
when 48 => instruction_out <= x"1000800d";   -- 00c0  MVI R3, 0x44340000; 
when 49 => instruction_out <= x"04434003";
when 50 => instruction_out <= x"c0810205";   -- 00c8  FMUL R1 (C0.NEU), R1, c[0x1][0x1]; 
when 51 => instruction_out <= x"00400680";
when 52 => instruction_out <= x"1000060d";   -- 00d0  MVC R3 (C0.NEU), c[0x1] [0x3]; 
when 53 => instruction_out <= x"2440c680";
when 54 => instruction_out <= x"9000060c";   -- 00d8  RCP32 R3, R3;
when 55 => instruction_out <= x"c0030204";   -- 00dc  FMUL32 R1, R1, R3;
when 56 => instruction_out <= x"a0000205";   -- 00e0  F2F.F32.F32 R1, R1; 
when 57 => instruction_out <= x"c4004780";
when 58 => instruction_out <= x"b0410004";   -- 00e8  FADD32 R1, R0, -R1;
when 59 => instruction_out <= x"2102e800";   -- 00ec  IADD32 R0, g [0x4], R2;
when 60 => instruction_out <= x"d00e0005";   -- 00f0  GST.U32 global14[R0], R1; 
when 61 => instruction_out <= x"a0c00781";
when 62 => instruction_out <= x"30000003";   -- RET
when 63 => instruction_out <= x"00000780";

			when others => null;
		end case;
	end process;

end arch;
