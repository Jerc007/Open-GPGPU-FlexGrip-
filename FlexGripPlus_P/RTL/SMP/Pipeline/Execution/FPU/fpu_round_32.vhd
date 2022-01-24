library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
library work;
use work.gpgpu_package.all;

entity fpu_round is

  port(
    clk, rst, enable : in  std_logic;
    round_mode       : in  std_logic_vector (1 downto 0);
    sign_term        : in  std_logic;
    mantissa_term    : in  std_logic_vector (26 downto 0);
    exponent_term    : in  std_logic_vector (8 downto 0);
    round_out        : out std_logic_vector (31 downto 0);
    exponent_final   : out std_logic_vector (8 downto 0)
    );

end fpu_round;

architecture rtl of fpu_round is

  signal rounding_amount                                      : std_logic_vector(26 downto 0);
  signal round_nearest                                        : std_logic;
  signal round_to_zero                                        : std_logic;
  signal round_nearest_trigger_up, round_nearest_trigger_up_2 : std_logic;
  signal round_nearest_trigger_tie                            : std_logic;
  signal round_nearest_trigger_down                           : std_logic;
  signal sum_round                                            : std_logic_vector(26 downto 0);
  signal sum_round_overflow                                   : std_logic;
  -- will be 0 if no carry, 1 if overflow from the rounding unit
  -- overflow from rounding is extremely rare, but possible
  signal sum_round_2                                          : std_logic_vector(26 downto 0);
  signal exponent_round                                       : std_logic_vector(8 downto 0);
  signal exponent_final_2                                     : std_logic_vector(8 downto 0);
  signal sum_final                                            : std_logic_vector(26 downto 0);

begin

  rounding_amount <= "000000000000000000000000100";

  p_Rounding : process(clk, rst, enable)
  begin
    if (rst = '1') then
      round_nearest              <= '0';
      round_to_zero              <= '0';
      round_nearest_trigger_up   <= '0';
      round_nearest_trigger_up_2 <= '0';
      round_nearest_trigger_tie  <= '0';
      round_nearest_trigger_down <= '0';
      sum_round                  <= (others => '0');
      sum_round_2                <= (others => '0');
      exponent_round             <= (others => '0');
      sum_final                  <= (others => '0');
      exponent_final             <= (others => '0');
      exponent_final_2           <= (others => '0');
      round_out                  <= (others => '0');
    elsif(clk'event and clk = '1' and enable = '1') then
      -- determine rounding mode and correct operation to be done
      if round_mode = "00" then
        round_nearest <= '1';
        round_to_zero <= '0';
      elsif(round_mode = "10") then
        round_nearest <= '0';
        round_to_zero <= '1';
      end if;
      if(round_nearest = '1' and mantissa_term(1) = '1' and mantissa_term(0) = '1') then
        round_nearest_trigger_up <= '1';
      else
        round_nearest_trigger_up <= '0';
      end if;
      if(round_nearest = '1' and mantissa_term(1) = '1' and mantissa_term(0) = '0') then
        round_nearest_trigger_tie <= '1';
      else
        round_nearest_trigger_tie <= '0';
      end if;
      if(round_nearest_trigger_tie = '1') then
        if(mantissa_term(2) = '0') then
          round_nearest_trigger_up_2 <= '0';  -- in round to nearest tie to even, floats are tied to the closest even number
          round_nearest_trigger_down <= '1';
        else
          round_nearest_trigger_up_2 <= '1';
          round_nearest_trigger_down <= '0';
        end if;
      else
        round_nearest_trigger_down <= '0';
        round_nearest_trigger_up_2 <= '0';
      end if;
      -- in case of round up compute
      if(round_nearest_trigger_up = '1' or round_nearest_trigger_up_2 = '1') then  -- in case of rounding up, do some calculation
        sum_round          <= std_logic_vector(unsigned(rounding_amount) + unsigned(mantissa_term));
        sum_round_overflow <= sum_round(26);
        if sum_round_overflow = '1' then
          sum_round_2    <= std_logic_vector(shift_right(unsigned(sum_round), 1));
          exponent_round <= std_logic_vector(unsigned(exponent_term) + "000000001");
        else
          sum_round_2    <= sum_round;
          exponent_round <= exponent_term;
        end if;
        exponent_final <= exponent_round;
        round_out      <= sign_term & exponent_round(7 downto 0) & sum_round_2(24 downto 2);
      else  -- in case of rounding down or zero, just truncate
        exponent_final <= exponent_term;
        round_out      <= sign_term & exponent_term(7 downto 0) & mantissa_term(24 downto 2);
      end if;
    end if;
  end process;
end rtl;
