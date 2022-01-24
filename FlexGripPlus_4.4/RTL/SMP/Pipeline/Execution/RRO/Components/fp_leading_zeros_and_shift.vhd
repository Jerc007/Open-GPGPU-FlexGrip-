----------------------------------------------------------------------------------
-- FP leading zeros and normalization (fp_leading_zeros_and_shift.vhd)
--
-- The fractional P includes the guard digits and the sticky bit.
-- Returns the normalized number and the adjusted exponent
-- Used in FP add of section 12.5.1
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity fp_leading_zeros_and_shift is
    generic (P: natural:= 27; E: natural := 8; PLOG: natural := 4);
    Port ( frac : in  std_logic_vector (P downto 0);
           exp	: in  std_logic_vector (E-1 downto 0);
           frac_Norm : out  std_logic_vector (P downto 0);
           exp_Norm : out  std_logic_vector (E-1 downto 0);
           underFlow : out std_logic);
end fp_leading_zeros_and_shift;

architecture Behavioral of fp_leading_zeros_and_shift is
   constant ZEROS : std_logic_vector(P downto 0):= (others => '0');	
   signal leadZerosBin : std_logic_vector(PLOG downto 0);
   signal exp_Norm_int : std_logic_vector(E-1 downto 0);
   signal isZ : std_logic;
    
begin

    --count zeros: elegant version.
    detectZeros: process(frac, exp)
       variable leadZerosBinVar : std_logic_vector(PLOG downto 0);
    begin 
      leadZerosBinVar := ZEROS(PLOG downto 0);
      for i in P downto 1 loop
       if (frac(P-1 downto P-i)= ZEROS(P-1 downto P-i) ) then 
          leadZerosBinVar := conv_std_logic_vector(i,PLOG+1);
          exit;
       end if;
      end loop;
      leadZerosBin <= leadZerosBinVar;
    end process;


   adjustExponent: process(leadZerosBin, exp, isZ)
   begin
      if isZ = '1' then
         exp_Norm_int <= (others => '0');
      else
         exp_Norm_int <= exp - ("000" & leadZerosBin);
      end if;
   end process;
    
   isZ <= '1' when frac(P-1 downto 0) = ZEROS (P-1 downto 0) else '0';
   underFlow <= '0' when isZ='0' and exp > leadZerosBin else '1';
   exp_Norm <= exp_Norm_int;
   
   shift: process(leadZerosBin, frac)
      variable temp : std_logic_vector(P downto 0);
      variable dtemp : std_logic_vector(P downto 0);
      variable fracAgnVar : std_logic_vector(P downto 0);
   begin
      temp := frac;
      for i in PLOG downto 0 loop
         if (leadZerosBin(i) = '1') then
            dtemp := (others => '0');
            dtemp(P downto 2**i) := temp(P - 2**i downto 0);
         else
            dtemp := temp;
         end if;
         temp := dtemp;
      end loop;
      frac_Norm <= dtemp;
   end process;

end Behavioral;

