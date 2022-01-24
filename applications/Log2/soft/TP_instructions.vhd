
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
	constant TP_INSTRUCTIONS : integer := 44;

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
when 8 => instruction_out <= x"2000ca01";   -- 0020  IADD R0, g [0x5], R1; 
when 9 => instruction_out <= x"04204780";
when 10 => instruction_out <= x"d00e0001";   -- 0028  GLD.U32 R0, global14[R0]; 
when 11 => instruction_out <= x"80c00780";
when 12 => instruction_out <= x"a0000001";   -- 0030  F2F.F32.F32 R0, R0; 
when 13 => instruction_out <= x"c4004780";
when 14 => instruction_out <= x"b0000009";   -- 0038  FADD32I R2, R0, -0x40800000; 
when 15 => instruction_out <= x"0bf80003";
when 16 => instruction_out <= x"a0000401";   -- 0040  F2F.F32.F32 R0, R2; 
when 17 => instruction_out <= x"c4004780";
when 18 => instruction_out <= x"c0020001";   -- 0048  FMUL R0, R0, R2; 
when 19 => instruction_out <= x"00000780";
when 20 => instruction_out <= x"c0000001";   -- 0050  FMUL32I R0, R0, 0x3f000000; 
when 21 => instruction_out <= x"03f00003";
when 22 => instruction_out <= x"a000000d";   -- 0058  F2F.F32.F32 R3, R0; 
when 23 => instruction_out <= x"c4004780";
when 24 => instruction_out <= x"c002060d";   -- 0060  FMUL R3, R3, R2; 
when 25 => instruction_out <= x"00000780";
when 26 => instruction_out <= x"c02b060d";   -- 0068  FMUL32I R3, R3, 0x3eaaaaab; 
when 27 => instruction_out <= x"03eaaaab";
when 28 => instruction_out <= x"b0000001";   -- 0070  FADD R0, -R0, R2; 
when 29 => instruction_out <= x"04008780";
when 30 => instruction_out <= x"a0000611";   -- 0078  F2F.F32.F32 R4, R3; 
when 31 => instruction_out <= x"c4004780";
when 32 => instruction_out <= x"b0000600";   -- 0080  FADD32 R0, R3, R0;
when 33 => instruction_out <= x"c0020808";   -- 0084  FMUL32 R2, R4, R2;
when 34 => instruction_out <= x"e0008401";   -- 0088  FMAD32I R0, -R2, 0x3e800000, R0; 
when 35 => instruction_out <= x"03e80003";
when 36 => instruction_out <= x"2000c805";   -- 0090  IADD R1, g [0x4], R1; 
when 37 => instruction_out <= x"04204780";
when 38 => instruction_out <= x"c03b0001";   -- 0098  FMUL32I R0, R0, 0x3fb8aa3b; 
when 39 => instruction_out <= x"03fb8aa3";
when 40 => instruction_out <= x"d00e0201";   -- 00a0  GST.U32 global14[R1], R0; 
when 41 => instruction_out <= x"a0c00781";
when 42 => instruction_out <= x"30000003";   -- RET
when 43 => instruction_out <= x"00000780";

			when others => null;
		end case;
	end process;

end arch;
