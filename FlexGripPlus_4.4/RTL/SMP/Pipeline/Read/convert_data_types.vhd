----------------------------------------------------------------------------------
-- Company:          Univerity of Massachusetts 
-- Engineer:         Kevin Andryc
-- 
-- Create Date:      17:50:27 09/19/2010  
-- Module Name:      convert_data_types - arch 
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

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.gpgpu_package.all;

entity convert_data_types is
	port(
		mov_size_in                : in  std_logic_vector(2 downto 0);
		conv_type_in               : in  conv_type;
		reg_type_in                : in  reg_type;
		data_type_in               : in  data_type;
		sm_type_in                 : in  std_logic_vector(1 downto 0);
		mem_type_in                : in  std_logic_vector(2 downto 0);
		mv_size_to_sm_type_out     : out sm_type;
		data_type_to_sm_type_out   : out sm_type;
		sm_type_to_sm_type_out     : out sm_type;
		mem_type_to_sm_type_out    : out sm_type;
		conv_type_to_reg_type_out  : out reg_type;
		reg_type_to_data_type_out  : out data_type;
		mv_size_to_data_type_out   : out data_type;
		conv_type_to_data_type_out : out data_type;
		sm_type_to_data_type_out   : out data_type;
		mem_type_to_data_type_out  : out data_type;
		sm_type_to_cvt_type_out    : out conv_type;
		mem_type_to_cvt_type_out   : out conv_type
	);
end convert_data_types;

architecture arch of convert_data_types is
begin
	pMvSizeToSMType : process(mov_size_in)
	begin
		case mov_size_in is
			when "000" =>
				mv_size_to_sm_type_out <= SM_U16;
			when "001" =>
				mv_size_to_sm_type_out <= SM_U32;
			when "010" =>
				mv_size_to_sm_type_out <= SM_U8;
			when others =>
				mv_size_to_sm_type_out <= SM_NONE;
		end case;
	end process;

	pDataTypeToSMType : process(data_type_in)
	begin
		case data_type_in is
			when DT_U8 =>
				data_type_to_sm_type_out <= SM_U8;
			when DT_S8 =>
				data_type_to_sm_type_out <= SM_U8;
			when DT_U16 =>
				data_type_to_sm_type_out <= SM_U16;
			when DT_S16 =>
				data_type_to_sm_type_out <= SM_S16;
			when DT_U32 =>
				data_type_to_sm_type_out <= SM_U32;
			when DT_S32 =>
				data_type_to_sm_type_out <= SM_U32;
			when DT_F32 =>
				data_type_to_sm_type_out <= SM_U32;
			when others =>
				data_type_to_sm_type_out <= SM_NONE;
		end case;
	end process;

	pSMTypeToSMType : process(sm_type_in)
	begin
		case sm_type_in is
			when "00" =>
				sm_type_to_sm_type_out <= SM_U8;
			when "01" =>
				sm_type_to_sm_type_out <= SM_U16;
			when "10" =>
				sm_type_to_sm_type_out <= SM_S16;
			when "11" =>
				sm_type_to_sm_type_out <= SM_U32;
			when others =>
				sm_type_to_sm_type_out <= SM_NONE;
		end case;
	end process;

	pMemTypeToSMType : process(mem_type_in)
	begin
		case mem_type_in is
			when "000" =>
				mem_type_to_sm_type_out <= SM_U8;
			when "001" =>
				mem_type_to_sm_type_out <= SM_U16;
			when "010" =>
				mem_type_to_sm_type_out <= SM_S16;
			when "011" =>
				mem_type_to_sm_type_out <= SM_U32;
			when others =>
				mem_type_to_sm_type_out <= SM_NONE;
		end case;
	end process;

	pCvtTypeToRegType : process(conv_type_in)
	begin
		case conv_type_in is
			when CT_U16 =>
				conv_type_to_reg_type_out <= RT_U16;
			when CT_S16 =>
				conv_type_to_reg_type_out <= RT_U16;
			when CT_U8 =>
				conv_type_to_reg_type_out <= RT_U16;
			when CT_S8 =>
				conv_type_to_reg_type_out <= RT_U16;
			when CT_U32 =>
				conv_type_to_reg_type_out <= RT_U32;
			when CT_S32 =>
				conv_type_to_reg_type_out <= RT_U32;
			when CT_U32U8 =>
				conv_type_to_reg_type_out <= RT_U32;
			when CT_NONE =>
				conv_type_to_reg_type_out <= RT_U32;
			when others =>
				conv_type_to_reg_type_out <= RT_NONE;
		end case;
	end process;

	pRegTypeToDataType : process(reg_type_in)
	begin
		case reg_type_in is
			when RT_U16 =>
				reg_type_to_data_type_out <= DT_U16;
			when RT_U32 =>
				reg_type_to_data_type_out <= DT_U32;
			when others =>
				reg_type_to_data_type_out <= DT_NONE;
		end case;
	end process;

	-- MODIFIED GIANLUCA ROASCIO - CORRECTED ACCORDING TO ENCODING OF INSTRUCTIONS
	--pMvSizeToDataType : process(mov_size_in)
	--begin
	--	case mov_size_in is
	--		when "000" =>
	--			mv_size_to_data_type_out <= DT_U16;
	--		when "001" =>
	--			mv_size_to_data_type_out <= DT_U32;
	--		when "010" =>
	--			mv_size_to_data_type_out <= DT_U8;
	--		when "110" =>               --MM: Included additional condition for DT_U32
	--			mv_size_to_data_type_out <= DT_U32;
	--		when others =>
	--			mv_size_to_data_type_out <= DT_NONE;
	--	end case;
	--end process;
	pMvSizeToDataType : process(mov_size_in)
	begin
		case mov_size_in is
			when "000" =>
				mv_size_to_data_type_out <= DT_U8;
			when "001" =>
				mv_size_to_data_type_out <= DT_S8;
			when "010" =>
				mv_size_to_data_type_out <= DT_U16;
			when "011" =>
				mv_size_to_data_type_out <= DT_S16;
			when "110" =>               
				mv_size_to_data_type_out <= DT_U32;
			when others => -- NO OTHER DATA TYPES ARE SUPPORTED
				mv_size_to_data_type_out <= DT_NONE;
		end case;
	end process;

	pCvtTypeToDataType : process(conv_type_in)
	begin
		case conv_type_in is
			when CT_U16 =>
				conv_type_to_data_type_out <= DT_U16;
			when CT_S16 =>
				conv_type_to_data_type_out <= DT_S16;
			when CT_U8 =>
				conv_type_to_data_type_out <= DT_U8;
			when CT_U32U8 =>
				conv_type_to_data_type_out <= DT_U32;
			when CT_S8 =>
				conv_type_to_data_type_out <= DT_S8;
			when CT_U32 =>
				conv_type_to_data_type_out <= DT_U32;
			when CT_NONE =>
				conv_type_to_data_type_out <= DT_U32;
			when CT_S32 =>
				conv_type_to_data_type_out <= DT_S32;
			when others =>
				conv_type_to_data_type_out <= DT_NONE;
		end case;
	end process;

	pSMTypeToDataType : process(sm_type_in)
	begin
		case sm_type_in is
			when "00" =>
				sm_type_to_data_type_out <= DT_U8;
			when "01" =>
				sm_type_to_data_type_out <= DT_U16;
			when "10" =>
				sm_type_to_data_type_out <= DT_S16;
			when "11" =>
				sm_type_to_data_type_out <= DT_U32;
			when others =>
				sm_type_to_data_type_out <= DT_NONE;
		end case;
	end process;

	pMemTypeToDataType : process(mem_type_in)
	begin
		case mem_type_in is
			when "000" =>
				mem_type_to_data_type_out <= DT_U8;
			when "001" =>
				mem_type_to_data_type_out <= DT_U16;
			when "010" =>
				mem_type_to_data_type_out <= DT_S16;
			when "011" =>
				mem_type_to_data_type_out <= DT_U32;
			when others =>
				mem_type_to_data_type_out <= DT_NONE;
		end case;
	end process;

	pSMTypeToCvtType : process(sm_type_in)
	begin
		case sm_type_in is
			when "00" =>
				sm_type_to_cvt_type_out <= CT_U8;
			when "01" =>
				sm_type_to_cvt_type_out <= CT_U16;
			when "10" =>
				sm_type_to_cvt_type_out <= CT_S16;
			when "11" =>
				sm_type_to_cvt_type_out <= CT_U32;
			when others =>
				sm_type_to_cvt_type_out <= CT_NONE;
		end case;
	end process;

	pMemTypeToCvtType : process(mem_type_in)
	begin
		case mem_type_in is
			when "000" =>
				mem_type_to_cvt_type_out <= CT_U8;
			when "001" =>
				mem_type_to_cvt_type_out <= CT_U16;
			when "010" =>
				mem_type_to_cvt_type_out <= CT_S16;
			when "011" =>
				mem_type_to_cvt_type_out <= CT_U32;
			when others =>
				mem_type_to_cvt_type_out <= CT_NONE;
		end case;
	end process;

end arch;

