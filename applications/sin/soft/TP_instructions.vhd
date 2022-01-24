
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
	constant TP_INSTRUCTIONS : integer := 52;

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
when 6 => instruction_out <= x"30020005";   -- 0018  SHL R1, R0, 0x2; 
when 7 => instruction_out <= x"c4100780";
when 8 => instruction_out <= x"10008001";   -- 0020  MVI R0, 0x42f00000; 
when 9 => instruction_out <= x"042f0003";
when 10 => instruction_out <= x"2000ca09";   -- 0028  IADD R2, g [0x5], R1; 
when 11 => instruction_out <= x"04204780";
when 12 => instruction_out <= x"b08001fd";   -- 0030  FSET.C0 o[0x7f], R0, c[0x1][0x0], GT; 
when 13 => instruction_out <= x"604107c8";
when 14 => instruction_out <= x"d00e0409";   -- 0038  GLD.U32 R2, global14[R2]; 
when 15 => instruction_out <= x"80c00780";
when 16 => instruction_out <= x"c0020400";   -- 0040  FMUL32 R0, R2, R2;
when 17 => instruction_out <= x"c0000400";   -- 0044  FMUL32 R0, R2, R0;
when 18 => instruction_out <= x"c000040d";   -- 0048  FMUL R3, R2, R0; 
when 19 => instruction_out <= x"00000780";
when 20 => instruction_out <= x"10008011";   -- 0050  MVI R4, 0x42f00000; 
when 21 => instruction_out <= x"042f0003";
when 22 => instruction_out <= x"c003040d";   -- 0058  FMUL R3, R2, R3; 
when 23 => instruction_out <= x"00000780";
when 24 => instruction_out <= x"c081060d";   -- 0060  FMUL R3 (C0.NEU), R3, c[0x1][0x1]; 
when 25 => instruction_out <= x"00400680";
when 26 => instruction_out <= x"10000411";   -- 0068  MVC R4 (C0.NEU), c[0x1] [0x2]; 
when 27 => instruction_out <= x"2440c680";
when 28 => instruction_out <= x"10008015";   -- 0070  MVI R5, 0x40c00000; 
when 29 => instruction_out <= x"040c0003";
when 30 => instruction_out <= x"90000811";   -- 0078  RCP R4, R4; 
when 31 => instruction_out <= x"00000780";
when 32 => instruction_out <= x"b0800bfd";   -- 0080  FSET.C0 o[0x7f], R5, c[0x1][0x0], GT; 
when 33 => instruction_out <= x"604107c8";
when 34 => instruction_out <= x"c004060d";   -- 0088  FMUL R3, R3, R4; 
when 35 => instruction_out <= x"00000780";
when 36 => instruction_out <= x"10008011";   -- 0090  MVI R4, 0x40c00000; 
when 37 => instruction_out <= x"040c0003";
when 38 => instruction_out <= x"c0810001";   -- 0098  FMUL R0 (C0.NEU), R0, c[0x1][0x1]; 
when 39 => instruction_out <= x"00400680";
when 40 => instruction_out <= x"10000611";   -- 00a0  MVC R4 (C0.NEU), c[0x1] [0x3]; 
when 41 => instruction_out <= x"2440c680";
when 42 => instruction_out <= x"90000811";   -- 00a8  RCP R4, R4; 
when 43 => instruction_out <= x"00000780";
when 44 => instruction_out <= x"e0040001";   -- 00b0  FMAD R0, -R0, R4, R2; 
when 45 => instruction_out <= x"04008780";
when 46 => instruction_out <= x"b0000608";   -- 00b8  FADD32 R2, R3, R0;
when 47 => instruction_out <= x"2101e800";   -- 00bc  IADD32 R0, g [0x4], R1;
when 48 => instruction_out <= x"d00e0009";   -- 00c0  GST.U32 global14[R0], R2; 
when 49 => instruction_out <= x"a0c00781";
when 50 => instruction_out <= x"30000003";   -- RET
when 51 => instruction_out <= x"00000780";

			when others => null;
		end case;
	end process;

end arch;
