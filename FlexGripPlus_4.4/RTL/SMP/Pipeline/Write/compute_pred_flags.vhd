----------------------------------------------------------------------------------
-- Company:          Univerity of Massachusetts
-- Engineer:         Kevin Andryc
--
-- Create Date:      17:50:27 09/19/2010
-- Module Name:      increment_address - arch
-- Project Name:     GPGPU
-- Target Devices:
-- Tool versions:    ISE 10.1
-- Description:
--
----------------------------------------------------------------------------
-- Revisions:
--  REV:        Date:           Description:
--  0.1.a       9/13/2010       Created Top level file
----------------------------------------------------------------------------
-- [Boyang Du]
-- This component should be combinational !!!!!!!!!!!!!!!!!!!!!!!!!!!!! OK with that
----------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.gpgpu_package.all;

entity compute_pred_flags is
	port(
		data_in      : in  vector_register;
		flags_in     : in  vector_flag_register;
		data_type_in : in  data_type;
		flags_out    : out vector_flag_register
	);
end compute_pred_flags;

architecture arch of compute_pred_flags is

	-- REMOVED GIANLUCA ROASCIO - UNNECESSARY REDEFINITION, ONLY CAUSING PROBLEMS WHEN DEALING WITH HIGH VALUE IMMEDIATE OPERANDS
	--subtype int_32_t is integer range -2147483647 to +2147483647;
	--subtype int_16_t is integer range -32767 to +32767;
	--type signed_32_vector_register is array (CORES - 1 downto 0) of int_32_t;
	--type signed_16_vector_register is array (CORES - 1 downto 0) of int_16_t;

	--signal signed_32_i : signed_32_vector_register;
	--signal signed_16_i : signed_16_vector_register;
	signal flags_u32_i : vector_flag_register;
	signal flags_u16_i : vector_flag_register;

begin

	-- REMOVED GIANLUCA ROASCIO - UNNECESSARY REDEFINITION, ONLY CAUSING PROBLEMS WHEN DEALING WITH HIGH VALUE IMMEDIATE OPERANDS
	--gSignedInt32 : for i in 0 to CORES - 1 generate
	--	signed_32_i(i) <= to_integer(signed(data_in(i)));
	--end generate;

	--gSignedInt16 : for i in 0 to CORES - 1 generate
	--	signed_16_i(i) <= to_integer(signed(data_in(i)));
	--end generate;

	-- MODIFIED GIANLUCA ROASCIO - MODIFICATION ACCORDING TO PREVIOUS ONES, FURTHERMORE SIGNED TYPES WERE FORGOTTEN
	-- REMODIFIED GIANLUCA ROASCIO - SIMPLY TAKE THE FLAGS FROM THE EXECUTE STAGE, WITHOUT RECOMPUTING IT, TO AVOID TIME MISMATCHING PROBLEM IN READING THE INPUTS
	gComputePredFlags32 : for i in 0 to CORES - 1 generate
		--flags_u32_i(i)(encode_flag_type(FLAG_ZERO))     <= '1' when (data_in(i) = x"00000000") else '0'; ---Can also take in flags_in(0) directly?
		----flags_u32_i(i)(encode_flag_type(FLAG_SIGN))     <= '1' when (signed_32_i(i) < 0) else '0'; ---Can also take in flags_in(1) directly?
		--flags_u32_i(i)(encode_flag_type(FLAG_SIGN))     <= '1' when (data_in(i)(31) = '1' and data_type_in = DT_S32) else '0';
		flags_u32_i(i)(encode_flag_type(FLAG_ZERO))     <= flags_in(i)(encode_flag_type(FLAG_ZERO));
		flags_u32_i(i)(encode_flag_type(FLAG_SIGN))     <= flags_in(i)(encode_flag_type(FLAG_SIGN));
		flags_u32_i(i)(encode_flag_type(FLAG_CARRY))    <= flags_in(i)(encode_flag_type(FLAG_CARRY));
		flags_u32_i(i)(encode_flag_type(FLAG_OVERFLOW)) <= flags_in(i)(encode_flag_type(FLAG_OVERFLOW));
	end generate;

	gComputePredFlags16 : for i in 0 to CORES - 1 generate
		--flags_u16_i(i)(encode_flag_type(FLAG_ZERO))     <= '1' when ((data_in(i) and x"0000FFFF") = x"00000000") else '0';
		----flags_u16_i(i)(encode_flag_type(FLAG_SIGN))     <= '1' when (signed_16_i(i) < 0) else '0';
		--flags_u16_i(i)(encode_flag_type(FLAG_SIGN))     <= '1' when (data_in(i)(15) = '1' and data_type_in = DT_S16) else '0';
		flags_u16_i(i)(encode_flag_type(FLAG_ZERO))     <= flags_in(i)(encode_flag_type(FLAG_ZERO));
		flags_u16_i(i)(encode_flag_type(FLAG_SIGN)) 	<= flags_in(i)(encode_flag_type(FLAG_SIGN));
		flags_u16_i(i)(encode_flag_type(FLAG_CARRY))    <= flags_in(i)(encode_flag_type(FLAG_CARRY));
		flags_u16_i(i)(encode_flag_type(FLAG_OVERFLOW)) <= flags_in(i)(encode_flag_type(FLAG_OVERFLOW));
	end generate;

	--flags_out <= flags_u32_i when (data_type_in = DT_U32) else flags_u16_i when (data_type_in = DT_U16) else flags_in;
	flags_out <= flags_u32_i when (data_type_in = DT_U32 or data_type_in = DT_S32)  -- AND FOR DT_F32 ??????
			else flags_u16_i when (data_type_in = DT_U16 or data_type_in = DT_S16)
			else flags_in;

end arch;
