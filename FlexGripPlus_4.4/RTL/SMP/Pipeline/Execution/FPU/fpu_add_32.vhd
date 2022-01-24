library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
library work;
use work.gpgpu_package.all;

entity fpu_add is

  port(
    clk        : in  std_logic;
    rst        : in  std_logic;
    enable     : in  std_logic;
    opa        : in  std_logic_vector (31 downto 0);
    opb        : in  std_logic_vector (31 downto 0);
    sign       : out std_logic;
    sum_3      : out std_logic_vector (26 downto 0);  -- '0' & '1.' & mantissa & 2 LSB for rounding
    exponent_2 : out std_logic_vector (7 downto 0)
    );
-- Declarations
end fpu_add;

architecture rtl of fpu_add is


  signal exponent_a              : std_logic_vector(7 downto 0);
  signal exponent_b              : std_logic_vector(7 downto 0);
  signal mantissa_a              : std_logic_vector(22 downto 0);
  signal mantissa_b              : std_logic_vector(22 downto 0);
  signal exponent_small          : std_logic_vector(7 downto 0);
  signal exponent_large          : std_logic_vector(7 downto 0);
  signal mantissa_small          : std_logic_vector(22 downto 0);
  signal mantissa_large          : std_logic_vector(22 downto 0);
  signal small_is_denorm         : std_logic;
  signal large_is_denorm         : std_logic;
  signal large_norm_small_denorm : std_logic_vector(7 downto 0);  -- to correct exponent when small is denorm
  signal exponent_diff           : std_logic_vector(7 downto 0);
  signal large_add               : std_logic_vector(26 downto 0);
  signal small_add               : std_logic_vector(26 downto 0);
  signal small_shift             : std_logic_vector(26 downto 0);
  signal small_shift_nonzero     : std_logic;
  signal small_is_nonzero        : std_logic;
  signal small_fraction_enable   : std_logic;
  signal small_shift_2           : std_logic_vector(26 downto 0);
  signal small_shift_3           : std_logic_vector(26 downto 0);
  signal sum                     : std_logic_vector(26 downto 0);
  signal sum_2                   : std_logic_vector(26 downto 0);
  signal sum_overflow            : std_logic;
  signal exponent                : std_logic_vector(7 downto 0);
  signal sum_leading_one         : std_logic;
  signal denorm_to_norm          : std_logic;


begin

  small_shift_nonzero   <= or_reduce(small_shift);
  small_is_nonzero      <= or_reduce(exponent_small) or or_reduce(mantissa_small(22 downto 0));
  small_fraction_enable <= small_is_nonzero and not small_shift_nonzero;
  small_shift_2         <= "000000000000000000000000001";
  sum_overflow          <= sum(26);  -- sum[26] will be 0 if there was no carry from adding the 2 numbers
  sum_leading_one       <= sum_2(25);  -- this is where the leading one resides,  unless denorm

  p_Addition : process(clk, rst, enable)
  begin
    if (rst = '1') then
      sign                    <= '0';
      exponent_a              <= (others => '0');
      exponent_b              <= (others => '0');
      mantissa_a              <= (others => '0');
      mantissa_b              <= (others => '0');
      exponent_small          <= (others => '0');
      exponent_large          <= (others => '0');
      mantissa_small          <= (others => '0');
      mantissa_large          <= (others => '0');
      small_is_denorm         <= '0';
      large_is_denorm         <= '0';
      large_norm_small_denorm <= (others => '0');
      exponent_diff           <= (others => '0');
      large_add               <= (others => '0');
      small_add               <= (others => '0');
      small_shift             <= (others => '0');
      small_shift_3           <= (others => '0');
      sum                     <= (others => '0');
      sum_2                   <= (others => '0');
      sum_3                   <= (others => '0');
      exponent                <= (others => '0');
      denorm_to_norm          <= '0';
      exponent_2              <= (others => '0');
    elsif (clk'event and clk = '1' and enable = '1') then
      ---- unpacking operands ----
      sign       <= opa(31);
      exponent_a <= opa(30 downto 23);
      exponent_b <= opb(30 downto 23);
      mantissa_a <= opa(22 downto 0);
      mantissa_b <= opb(22 downto 0);
      if (unsigned(exponent_a) > unsigned(exponent_b)) then
        exponent_small <= exponent_b;
        exponent_large <= exponent_a;
        mantissa_small <= mantissa_b;
        mantissa_large <= mantissa_a;
      else
        exponent_small <= exponent_a;
        exponent_large <= exponent_b;
        mantissa_small <= mantissa_a;
        mantissa_large <= mantissa_b;
      end if;
      ---- tests for normalization ----
      if (exponent_small = "00000000") then
        small_is_denorm <= '1';
      else
        small_is_denorm <= '0';
      end if;
      if (exponent_large = "00000000") then
        large_is_denorm <= '1';
      else
        large_is_denorm <= '0';
      end if;
      if (small_is_denorm = '1' and large_is_denorm = '0') then
        large_norm_small_denorm <= "00000001";
      else
        large_norm_small_denorm <= "00000000";
      end if;
      ---- compute exponent diff and shift the smaller mantissa ----
      exponent_diff <= std_logic_vector(unsigned(exponent_large) - unsigned(exponent_small) - unsigned(large_norm_small_denorm));
      large_add     <= '0' & not large_is_denorm & mantissa_large & "00";  -- add implicit 1.mantissa & Round + Sticky
      small_add     <= '0' & not small_is_denorm & mantissa_small & "00";
      small_shift   <= std_logic_vector(shift_right(unsigned(small_add), to_integer(unsigned(exponent_diff))));
      ---- detect potential null mantissa after shifting ----
      if (small_fraction_enable = '1') then
        small_shift_3 <= small_shift_2;
      else
        small_shift_3 <= small_shift;
      end if;
      ---- add mantissas and check for overflow (shift mant and exp+1) ----
      sum <= std_logic_vector(unsigned(large_add) + unsigned(small_shift_3));
      if (sum_overflow = '1') then
        sum_2    <= std_logic_vector(shift_right(unsigned(sum), 1));
        exponent <= std_logic_vector(unsigned(exponent_large) + "00000001");
      else
        sum_2    <= sum;
        exponent <= exponent_large;
      end if;
      sum_3          <= sum_2;
      ---- adjust exp for normalization ----
      denorm_to_norm <= sum_leading_one and large_is_denorm;
      if (denorm_to_norm = '1') then
        exponent_2 <= std_logic_vector(unsigned(exponent) + "00000001");
      else
        exponent_2 <= exponent;
      end if;
    end if;
  end process;
end rtl;
