--------------------------------------------------------------------------
-- VHDL : calculate_address.vhd
--   Generic calculate_address
-- 		[TODO]
--------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity calculate_address is
	port(
		address_in   : in  std_logic_vector(31 downto 0);
		data_type_in : in  std_logic_vector(3 downto 0);
		address_out  : out std_logic_vector(31 downto 0)
	);
end calculate_address;

architecture calc_addr_archi of calculate_address is
begin
	
		address_out <= 						   address_in when data_type_in = X"0" -- DT_U8 
														 	or data_type_in = X"1" -- DT_S8
		else std_logic_vector(unsigned(address_in) sll 1) when data_type_in = X"2" -- DT_U16
														 	or data_type_in = X"3" -- DT_S16
		else std_logic_vector(unsigned(address_in) sll 2) when data_type_in = X"6" -- DT_U32
														  	or data_type_in = X"7" -- DT_S32
														  	or data_type_in = X"8" -- DT_F32
		else std_logic_vector(unsigned(address_in) sll 3) when data_type_in = X"4" -- DT_U64
															or data_type_in = X"9" -- DT_F64
		else std_logic_vector(unsigned(address_in) sll 4) when data_type_in = X"5" -- DT_U128
		else (others => '0');

end architecture calc_addr_archi;