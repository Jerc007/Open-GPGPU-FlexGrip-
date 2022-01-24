
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
	constant TP_INSTRUCTIONS : integer := 70;

begin
	num_instructions_out <= TP_INSTRUCTIONS;

	process(instruction_pointer_in)
	begin
		case instruction_pointer_in is
			when 0 => instruction_out <= x"10000005";   -- MOV R1, R0;
when 1 => instruction_out <= x"0403c780";
when 2 => instruction_out <= x"d080060d";   -- LOP.AND.U16 R1H, R1H, c[0x1][0x0];
when 3 => instruction_out <= x"00400780";
when 4 => instruction_out <= x"10004411";   -- MOV.U16 R2L, g [0x2].U16;
when 5 => instruction_out <= x"0023c780";
when 6 => instruction_out <= x"a0000611";   -- I2I.U32.U16 R4, R1H;
when 7 => instruction_out <= x"04000780";
when 8 => instruction_out <= x"1000420d";   -- MOV.U16 R1H, g [0x1].U16;
when 9 => instruction_out <= x"0023c780";
when 10 => instruction_out <= x"a000040d";   -- I2I.U32.U16 R3, R1L;
when 11 => instruction_out <= x"04000780";
when 12 => instruction_out <= x"60044e09";   -- IMAD.U16 R2, g [0x7].U16, R2L, R4;
when 13 => instruction_out <= x"00210780";
when 14 => instruction_out <= x"60034c0d";   -- IMAD.U16 R3, g [0x6].U16, R1H, R3;
when 15 => instruction_out <= x"0020c780";
when 16 => instruction_out <= x"3002cffd";   -- ISET.S32.C0 o[0x7f], g [0x7], R2, LE;
when 17 => instruction_out <= x"6c2107c8";
when 18 => instruction_out <= x"30000003";   -- RET C0.EQ;
when 19 => instruction_out <= x"00000100";
when 20 => instruction_out <= x"307ccffd";   -- ISET.S32.C0 o[0x7f], g [0x7], R124, LE;
when 21 => instruction_out <= x"6c20c7c8";
when 22 => instruction_out <= x"30000003";   -- RET C0.NE;
when 23 => instruction_out <= x"00000280";
when 24 => instruction_out <= x"1000ce05";   -- MOV R1, g [0x7];
when 25 => instruction_out <= x"0423c780";
when 26 => instruction_out <= x"40050411";   -- IMUL.U16.U16 R4, R1L, R2H;
when 27 => instruction_out <= x"00000780";
when 28 => instruction_out <= x"60040611";   -- IMAD.U16 R4, R1H, R2L, R4;
when 29 => instruction_out <= x"00010780";
when 30 => instruction_out <= x"30100811";   -- SHL R4, R4, 0x10;
when 31 => instruction_out <= x"c4100780";
when 32 => instruction_out <= x"60040405";   -- IMAD.U16 R1, R1L, R2L, R4;
when 33 => instruction_out <= x"00010780";
when 34 => instruction_out <= x"20000211";   -- IADD R4, R1, R3;
when 35 => instruction_out <= x"0400c780";
when 36 => instruction_out <= x"3002060d";   -- SHL R3, R3, 0x2;
when 37 => instruction_out <= x"c4100780";
when 38 => instruction_out <= x"3002ce09";   -- SHL R2, g [0x7], 0x2;;
when 39 => instruction_out <= x"c4300780";
when 40 => instruction_out <= x"30020215";   -- SHL R5, R1, 0x2;
when 41 => instruction_out <= x"c4100780";
when 42 => instruction_out <= x"30020819";   -- SHL R6, R4, 0x2;
when 43 => instruction_out <= x"c4100780";
when 44 => instruction_out <= x"2103ea0c";   -- IADD32 R3, g [0x5], R3;
when 45 => instruction_out <= x"2101ee10";   -- IADD32 R4, g [0x7], R1;
when 46 => instruction_out <= x"2105e814";   -- IADD32 R5, g [0x4], R5;
when 47 => instruction_out <= x"2106ec18";   -- IADD32 R6, g [0x6], R6;
when 48 => instruction_out <= x"d00e0a21";   -- GLD.U32 R8, global14[R5];
when 49 => instruction_out <= x"80c00780";
when 50 => instruction_out <= x"d00e061d";   -- GLD.U32 R7, global14[R3];
when 51 => instruction_out <= x"80c00780";
when 52 => instruction_out <= x"20018205";   -- IADD32I R1, R1, 0x1;
when 53 => instruction_out <= x"00000003";
when 54 => instruction_out <= x"e0071001";   -- FMAD R0, R8, R7, R0;
when 55 => instruction_out <= x"00000780";
when 56 => instruction_out <= x"300403fd";   -- ISET.S32.C0 o[0x7f], R1, R4, NE;
when 57 => instruction_out <= x"6c0147c8";
when 58 => instruction_out <= x"20048a15";   -- IADD32I R5, R5, 0x4;
when 59 => instruction_out <= x"00000003";
when 60 => instruction_out <= x"2000040d";   -- IADD R3, R2, R3;
when 61 => instruction_out <= x"0400c780";
when 62 => instruction_out <= x"d00e0c01";   -- GST.U32 global14[R6], R0;
when 63 => instruction_out <= x"a0c00780";
when 64 => instruction_out <= x"10018003";   -- BRA C0.NE, 0xc8;			8 instead of 9
when 65 => instruction_out <= x"00000280";
when 66 => instruction_out <= x"f0000001";   -- NOP;
when 67 => instruction_out <= x"e0000001";
when 68 => instruction_out <= x"30000003";   -- RET
when 69 => instruction_out <= x"00000780";

			when others => null;
		end case;
	end process;

end arch;

