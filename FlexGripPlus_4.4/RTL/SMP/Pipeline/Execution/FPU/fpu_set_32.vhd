library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
library work;
use work.gpgpu_package.all;

entity fpu_set is
  port (
    clk         : in  std_logic;
    rst         : in std_logic;
    enable      : in  std_logic;
    opa         : in  std_logic_vector (31 downto 0);
    opb         : in  std_logic_vector (31 downto 0);
    set_cond_in : in  std_logic_vector(2 downto 0);
    abs_en      : in  std_logic;
    result_out  : out std_logic_vector(31 downto 0)
    );
end fpu_set;

architecture rtl of fpu_set is
  signal exp_a_LT_exp_b, exp_a_EQ_exp_b     : std_logic;
  signal mant_a_LT_mant_b, mant_a_EQ_mant_b : std_logic;

begin

  p_Set : process(clk, rst, enable)
    variable condition_filled : boolean;
  begin
    if (rst = '1') then
      exp_a_EQ_exp_b <= '0';
      exp_a_LT_exp_b <= '0';
      mant_a_LT_mant_b <= '0';
      mant_a_EQ_mant_b <= '0';
      result_out <= (others => '0');
    elsif(clk'event and clk = '1' and enable = '1') then
      condition_filled := false;
      -- def of internals
      if(unsigned(opa(30 downto 23)) < unsigned(opb(30 downto 23))) then
        exp_a_LT_exp_b <= '1';
      else
        exp_a_LT_exp_b <= '0';
      end if;
      if(unsigned(opa(30 downto 23)) = unsigned(opb(30 downto 23))) then
        exp_a_EQ_exp_b <= '1';
      else
        exp_a_EQ_exp_b <= '0';
      end if;
      if(unsigned(opa(22 downto 0)) < unsigned(opb(22 downto 0))) then
        mant_a_LT_mant_b <= '1';
      else
        mant_a_LT_mant_b <= '0';
      end if;
      if(unsigned(opa(22 downto 0)) = unsigned(opb(22 downto 0))) then
        mant_a_EQ_mant_b <= '1';
      else
        mant_a_EQ_mant_b <= '0';
      end if;

      -- tests
      if(set_cond_in = "001") then      -- LT
        if(
               ((exp_a_LT_exp_b = '1' or (exp_a_EQ_exp_b = '1' and mant_a_LT_mant_b = '1')) and ((opa(31) = '0' and opb(31) = '0') or (opa(31) = '1' and opb(31) = '0') or abs_en = '1'))
            or ((exp_a_LT_exp_b = '0' or (exp_a_EQ_exp_b = '1' and mant_a_LT_mant_b = '0')) and ((opa(31) = '1' and opb(31) = '0') or (opa(31) = '1' and opb(31) = '1')))
          ) then  -- 0<A<B A<0<B |A|<|B| or  A<0<B A<B<0
             condition_filled := true;
        end if;
      elsif(set_cond_in = "011") then   -- LE
        if(
             ((exp_a_LT_exp_b = '1' or (exp_a_EQ_exp_b = '1' and mant_a_LT_mant_b = '1')) and ((opa(31) = '0' and opb(31) = '0') or (opa(31) = '1' and opb(31) = '0') or abs_en = '1'))
          or ((exp_a_LT_exp_b = '0' or (exp_a_EQ_exp_b = '1' and mant_a_LT_mant_b = '0')) and ((opa(31) = '1' and opb(31) = '0') or (opa(31) = '1' and opb(31) = '1')))
          or (exp_a_EQ_exp_b = '1' and mant_a_EQ_mant_b = '1' and (opa(31) = opb(31) or abs_en = '1'))
          ) then -- 0<A<B A<0<B |A|<|B| or A<0<B A<B<0 or A=B |A|=|B|
            condition_filled := true;
        end if;

      elsif(set_cond_in = "010") then   -- EQ
        if((exp_a_EQ_exp_b = '1' and mant_a_EQ_mant_b = '1') and (opa(31) = opb(31) or abs_en = '1')) then -- A=B |A|=|B|
          condition_filled := true;
        end if;
      elsif(set_cond_in = "101") then   -- NEQ
        if((exp_a_EQ_exp_b = '0' or mant_a_EQ_mant_b = '0') or (opa(31) /= opb(31) and abs_en = '0')) then --A/=B or |A|=|B| and sign /=
          condition_filled := true ;
        end if;
      elsif(set_cond_in = "100") then   -- GT
        if (
              ((exp_a_LT_exp_b = '0' or (exp_a_EQ_exp_b = '1' and mant_a_LT_mant_b = '0')) and ((opa(31) = '0' and opb(31) = '0') or (opa(31) = '0' and opb(31) = '1') or abs_en = '1'))
            or ((exp_a_LT_exp_b = '1' or (exp_a_EQ_exp_b = '1' and mant_a_LT_mant_b = '1')) and ((opa(31) = '0' and opb(31) = '1') or (opa(31) = '1' and opb(31) = '1') or abs_en = '1'))
           ) then -- 0<B<A B<0<A |B|<|A| or  B<A<0 B<0<A
           condition_filled := true;
         end if;
      elsif(set_cond_in = "110") then   --GE
        if(
            ((exp_a_LT_exp_b = '0' or (exp_a_EQ_exp_b = '1' and mant_a_LT_mant_b = '0')) and ((opa(31) = '0' and opb(31) = '0') or (opa(31) = '0' and opb(31) = '1') or abs_en = '1'))
         or ((exp_a_LT_exp_b = '1' or (exp_a_EQ_exp_b = '1' and mant_a_LT_mant_b = '1')) and ((opa(31) = '0' and opb(31) = '1') or (opa(31) = '1' and opb(31) = '1') or abs_en = '1'))
         or (exp_a_EQ_exp_b = '1' and mant_a_EQ_mant_b = '1' and (opa(31) = opb(31) or abs_en = '1'))
        ) then -- 0<B<A B<0<A |B|<|A| or B<A<0 B<0<A or  A=B |A|=|B|
          condition_filled := true;
        end if;
      end if;

      if(condition_filled = true) then
      --  result_out <= x"3F800000";      -- '1.0' written in float
        result_out <= x"FFFFFFFF";        -- MODIFIED to match ISET functionning
      else
        result_out <= x"00000000";
      end if;
    end if;
  end process;
end rtl;
