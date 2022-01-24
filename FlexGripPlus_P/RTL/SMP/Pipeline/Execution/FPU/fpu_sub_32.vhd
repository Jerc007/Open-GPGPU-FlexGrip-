library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
library work;
use work.gpgpu_package.all;


entity fpu_sub is

  port(
    clk        : in  std_logic;
    rst        : in  std_logic;
    enable     : in  std_logic;
    opa        : in  std_logic_vector (31 downto 0);
    opb        : in  std_logic_vector (31 downto 0);
    sign       : out std_logic;
    diff_2     : out std_logic_vector (26 downto 0);
    exponent_2 : out std_logic_vector (7 downto 0)
    );

end fpu_sub;


architecture rtl of fpu_sub is

  signal diff_shift              : std_logic_vector(5 downto 0);
  signal diff_shift_2            : std_logic_vector(5 downto 0);
  signal exponent_a              : std_logic_vector(7 downto 0);
  signal exponent_b              : std_logic_vector(7 downto 0);
  signal mantissa_a              : std_logic_vector(22 downto 0);
  signal mantissa_b              : std_logic_vector(22 downto 0);
  signal expa_gt_expb            : std_logic;
  signal expa_et_expb            : std_logic;
  signal mana_gtet_manb          : std_logic;
  signal a_gtet_b                : std_logic;
  signal exponent_small          : std_logic_vector(7 downto 0);
  signal exponent_large          : std_logic_vector(7 downto 0);
  signal mantissa_small          : std_logic_vector(22 downto 0);
  signal mantissa_large          : std_logic_vector(22 downto 0);
  signal small_is_denorm         : std_logic;
  signal large_is_denorm         : std_logic;
  signal large_norm_small_denorm : std_logic_vector(7 downto 0);
  signal small_is_nonzero        : std_logic;
  signal exponent_diff           : std_logic_vector(7 downto 0);
  signal minuend                 : std_logic_vector(25 downto 0);
  signal subtrahend              : std_logic_vector(25 downto 0);
  signal subtra_shift            : std_logic_vector(25 downto 0);
  signal subtra_shift_nonzero    : std_logic;
  signal subtra_fraction_enable  : std_logic;
  signal subtra_shift_2          : std_logic_vector(25 downto 0);
  signal subtra_shift_3          : std_logic_vector(25 downto 0);
  signal diff                    : std_logic_vector(25 downto 0);
  signal diffshift_gt_exponent   : std_logic;
  signal diffshift_et_26         : std_logic;  -- when the difference = 0
  signal diff_1                  : std_logic_vector(25 downto 0);
  signal exponent                : std_logic_vector(7 downto 0);
  signal in_norm_out_denorm      : std_logic;

begin

  subtra_shift_nonzero   <= or_reduce(subtra_shift);
  subtra_fraction_enable <= small_is_nonzero and not subtra_shift_nonzero;
  subtra_shift_2         <= "00000000000000000000000001";
  in_norm_out_denorm     <= or_reduce(exponent_large) and not or_reduce(exponent);

  p_Substraction : process(clk, rst, enable)
  begin
    if (rst = '1') then
      exponent_a              <= (others => '0');
      exponent_b              <= (others => '0');
      mantissa_a              <= (others => '0');
      mantissa_b              <= (others => '0');
      expa_gt_expb            <= '0';
      expa_et_expb            <= '0';
      mana_gtet_manb          <= '0';
      a_gtet_b                <= '0';
      exponent_small          <= (others => '0');
      exponent_large          <= (others => '0');
      mantissa_small          <= (others => '0');
      mantissa_large          <= (others => '0');
      sign                    <= '0';
      small_is_denorm         <= '0';
      large_is_denorm         <= '0';
      large_norm_small_denorm <= (others => '0');
      small_is_nonzero        <= '0';
      exponent_diff           <= (others => '0');
      minuend                 <= (others => '0');
      subtrahend              <= (others => '0');
      subtra_shift            <= (others => '0');
      subtra_shift_3          <= (others => '0');
      diff_shift              <= (others => '0');
      diff_shift_2            <= (others => '0');
      diff                    <= (others => '0');
      diffshift_gt_exponent   <= '0';
      diffshift_et_26         <= '0';
      diff_1                  <= (others => '0');
      exponent                <= (others => '0');
      exponent_2              <= (others => '0');
      diff_2                  <= (others => '0');
    elsif (clk'event and clk = '1' and enable = '1') then
      ---- unpacking ----
      exponent_a <= opa(30 downto 23);
      exponent_b <= opb(30 downto 23);
      mantissa_a <= opa(22 downto 0);
      mantissa_b <= opb(22 downto 0);
      ---- Determine bigger precisely ----
      if (unsigned(exponent_a) > unsigned(exponent_b)) then
        expa_gt_expb <= '1';
      else
        expa_gt_expb <= '0';
      end if;
      if (exponent_a = exponent_b) then
        expa_et_expb <= '1';
      else
        expa_et_expb <= '0';
      end if;
      if (unsigned(mantissa_a) >= unsigned(mantissa_b)) then
        mana_gtet_manb <= '1';
      else
        mana_gtet_manb <= '0';
      end if;
      a_gtet_b <= expa_gt_expb or (expa_et_expb and mana_gtet_manb);
      if (a_gtet_b = '1') then
        exponent_small <= exponent_b;
        exponent_large <= exponent_a;
        mantissa_small <= mantissa_b;
        mantissa_large <= mantissa_a;
        sign           <= opa(31);
      else
        exponent_small <= exponent_a;
        exponent_large <= exponent_b;
        mantissa_small <= mantissa_a;
        mantissa_large <= mantissa_b;
        sign           <= opb(31);  -- Signs of operands are corrected before this stage to match the operation, so A - B is written A + (-B)
      -- if we want A - B but B is bigger, we do instead -(B - A) because its easier when the biggest is first
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
      small_is_nonzero <= (not small_is_denorm) or or_reduce(mantissa_small);
      ---- compute exponent diff and shift the smallest mantissa ----
      exponent_diff    <= std_logic_vector(unsigned(exponent_large) - unsigned(exponent_small) - unsigned(large_norm_small_denorm));
      minuend          <= not large_is_denorm & mantissa_large & "00";  -- extended large mantissa: 1.mantissa & Round + Sticky
      subtrahend       <= not small_is_denorm & mantissa_small & "00";  -- extended small mantissa
      subtra_shift     <= std_logic_vector(shift_right(unsigned(subtrahend), to_integer(unsigned(exponent_diff))));  -- shift-corrected small mantissa
      ---- detect potential null mantissa after shifting ----
      if (subtra_fraction_enable = '1') then
        subtra_shift_3 <= subtra_shift_2;    -- 1
      else
        subtra_shift_3 <= subtra_shift;
      end if;
      ---- subtract mantissas and check for cancelation----
      diff         <= std_logic_vector(unsigned(minuend) - unsigned(subtra_shift_3));
      diff_shift   <= count_l_zeros(diff(25 downto 0));
      diff_shift_2 <= diff_shift;
      if (unsigned(diff_shift_2) > unsigned(exponent_large)) then  -- shifting after cancellation will lead to a denorm number
        diffshift_gt_exponent <= '1';
      else
        diffshift_gt_exponent <= '0';
      end if;
      if (diff_shift_2 = "011010") then      -- 26
        diffshift_et_26 <= '1';
      else
        diffshift_et_26 <= '0';
      end if;
      if (diffshift_gt_exponent = '1') then  -- number is denorm, mantissa doesnt start with a 1
        diff_1   <= std_logic_vector(shift_left(unsigned(diff), to_integer(unsigned(exponent_large))));
        exponent <= "00000000";
      else
        diff_1   <= std_logic_vector(shift_left(unsigned(diff), to_integer(unsigned(diff_shift_2))));  -- number is normalized, shift left if there are front zeros
        exponent <= std_logic_vector(unsigned(exponent_large) - unsigned(diff_shift_2));  -- decrease exp by one for each shift
      end if;
      if (diffshift_et_26 = '1') then
        exponent_2 <= "00000000";
      else
        exponent_2 <= exponent;
      end if;
      if (in_norm_out_denorm = '1') then
        diff_2 <= '0' & std_logic_vector(shift_right(unsigned(diff_1), 1));
      else
        diff_2 <= '0' & diff_1;
      end if;
    end if;
  end process;

end rtl;
