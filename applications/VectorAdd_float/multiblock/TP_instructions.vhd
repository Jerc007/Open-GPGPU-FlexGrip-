
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
	constant TP_INSTRUCTIONS : integer := 20;

begin
	num_instructions_out <= TP_INSTRUCTIONS;

	process(instruction_pointer_in)
	begin
		case instruction_pointer_in is
			when 0 => instruction_out <= x"10004205";   -- MOV.U16 R0H, g [0x1].U16;
when 1 => instruction_out <= x"0023c780";
when 2 => instruction_out <= x"a0000005";   -- I2I.U32.U16 R1, R0L;
when 3 => instruction_out <= x"04000780";
when 4 => instruction_out <= x"60014c01";   -- IMAD.U16 R0, g [0x6].U16, R0H, R1;
when 5 => instruction_out <= x"00204780";
when 6 => instruction_out <= x"30020009";   -- SHL R2, R0, 0x2;
when 7 => instruction_out <= x"c4100780";
when 8 => instruction_out <= x"2102e800";   -- IADD32 R0, g [0x4], R2;
when 9 => instruction_out <= x"2102ea0c";   -- IADD32 R3, g [0x5], R2;
when 10 => instruction_out <= x"d00e0005";   -- GLD.U32 R1, global14[R0];
when 11 => instruction_out <= x"80c00780";
when 12 => instruction_out <= x"d00e0601";   -- GLD.U32 R0, global14[R3];
when 13 => instruction_out <= x"80c00780";
when 14 => instruction_out <= x"b0000204";   -- FADD32 R1, R1, R0;
when 15 => instruction_out <= x"2102ec00";   -- IADD32 R0, g [0x6], R2;
when 16 => instruction_out <= x"d00e0005";   -- GST.U32 global14[R0], R1;
when 17 => instruction_out <= x"a0c00781";
when 18 => instruction_out <= x"30000003";   -- RET
when 19 => instruction_out <= x"00000780";

			when others => null;
		end case;
	end process;

end arch;
