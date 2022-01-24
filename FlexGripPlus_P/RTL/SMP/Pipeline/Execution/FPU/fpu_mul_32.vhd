library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
library work;
use work.gpgpu_package.all;

entity fpu_mul is

  port(
    clk        : in  std_logic;
    rst        : in  std_logic;
    enable     : in  std_logic;
    opa        : in  std_logic_vector (31 downto 0);
    opb        : in  std_logic_vector (31 downto 0);
    sign       : out std_logic;
    product_7  : out std_logic_vector (26 downto 0);
    exponent_5 : out std_logic_vector (8 downto 0)
    );

end fpu_mul;


architecture rtl of fpu_mul is

  signal product_shift         : std_logic_vector(5 downto 0);
  signal product_shift_2       : std_logic_vector(5 downto 0);
  signal mantissa_a            : std_logic_vector(22 downto 0);
  signal mantissa_b            : std_logic_vector(22 downto 0);
  signal exponent_a            : std_logic_vector(8 downto 0);
  signal exponent_b            : std_logic_vector(8 downto 0);
  signal a_is_norm             : std_logic;
  signal b_is_norm             : std_logic;
  signal a_is_zero             : std_logic;
  signal b_is_zero             : std_logic;
  signal in_zero               : std_logic;
  signal exponent_terms        : std_logic_vector(8 downto 0);
  signal exponent_gt_expoffset : std_logic;
  signal exponent_under        : std_logic_vector(8 downto 0);
  signal exponent_1            : std_logic_vector(8 downto 0);
  signal exponent              : std_logic_vector(8 downto 0);
  signal exponent_2            : std_logic_vector(8 downto 0);
  signal exponent_gt_prodshift : std_logic;
  signal exponent_3            : std_logic_vector(8 downto 0);
  signal exponent_4            : std_logic_vector(8 downto 0);
  signal exponent_et_zero      : std_logic;
  signal mul_a                 : std_logic_vector(23 downto 0);
  signal mul_b                 : std_logic_vector(23 downto 0);
  signal product               : std_logic_vector(47 downto 0);
  signal product_1             : std_logic_vector(47 downto 0);
  signal product_2             : std_logic_vector(47 downto 0);
  signal product_3             : std_logic_vector(47 downto 0);
  signal product_4             : std_logic_vector(47 downto 0);
  signal product_5             : std_logic_vector(47 downto 0);
  signal product_6             : std_logic_vector(47 downto 0);
  signal product_lsb           : std_logic;

begin
  p_Multiplication : process(clk, rst, enable)
    variable a_norm_add       : std_logic_vector(8 downto 0);
    variable b_norm_add       : std_logic_vector(8 downto 0);
    variable tmp_prod_shift_2 : std_logic_vector(8 downto 0);
  begin
    if (rst = '1') then
      sign                  <= '0';
      mantissa_a            <= (others => '0');
      mantissa_b            <= (others => '0');
      exponent_a            <= (others => '0');
      exponent_b            <= (others => '0');
      a_is_norm             <= '0';
      b_is_norm             <= '0';
      a_is_zero             <= '0';
      b_is_zero             <= '0';
      in_zero               <= '0';
      exponent_terms        <= (others => '0');
      exponent_gt_expoffset <= '0';
      exponent_under        <= (others => '0');
      exponent_1            <= (others => '0');
      exponent_2            <= (others => '0');
      exponent_gt_prodshift <= '0';
      exponent_3            <= (others => '0');
      exponent_4            <= (others => '0');
      exponent_et_zero      <= '0';
      mul_a                 <= (others => '0');
      mul_b                 <= (others => '0');
      product               <= (others => '0');
      product_1             <= (others => '0');
      product_2             <= (others => '0');
      product_3             <= (others => '0');
      product_4             <= (others => '0');
      product_5             <= (others => '0');
      product_6             <= (others => '0');
      product_lsb           <= '0';
      exponent_5            <= (others => '0');
      product_shift         <= (others => '0');
      product_shift_2       <= (others => '0');
      a_norm_add            := (others => '0');
      b_norm_add            := (others => '0');
      tmp_prod_shift_2      := (others => '0');

    elsif (clk'event and clk = '1') then
      if(enable = '1') then
        a_norm_add       := (others => 'X');
        b_norm_add       := (others => 'X');
        tmp_prod_shift_2 := (others => 'X');
        exponent  <= "000000000";
        ---- unpacking ----
        sign           <= opa(31) xor opb(31);
        exponent_a     <= '0' & opa(30 downto 23);
        exponent_b     <= '0' & opb(30 downto 23);
        mantissa_a     <= opa(22 downto 0);
        mantissa_b     <= opb(22 downto 0);
        a_is_norm      <= or_reduce(opa(30 downto 23));
        b_is_norm      <= or_reduce(opb(30 downto 23));
        a_is_zero      <= not or_reduce(opa(30 downto 0));
        b_is_zero      <= not or_reduce(opb(30 downto 0));
        a_norm_add     := "00000000" & not a_is_norm;
        b_norm_add     := "00000000" & not b_is_norm;
        in_zero        <= a_is_zero or b_is_zero;
        ---- add exponent| if denorm add 1 ----
        exponent_terms <= std_logic_vector(unsigned(exponent_a) + unsigned(exponent_b) + unsigned(a_norm_add) + unsigned(b_norm_add));
        mul_a          <= a_is_norm & mantissa_a;
        mul_b          <= b_is_norm & mantissa_b;
        ---- adjust the final exponent ----
        if (unsigned(exponent_terms) > "001111101") then  -- positive exponent (sup to 125 bc of the way we calc exp_terms : e = E - bias + 1 - norm)
          exponent_gt_expoffset <= '1';
        else
          exponent_gt_expoffset <= '0';
        end if;
        exponent_under <= std_logic_vector("01111110" - unsigned(exponent_terms));
        exponent_1     <= std_logic_vector(unsigned(exponent_terms) - "01111110");  -- exponent after corrected bias
        ---- multiply mantissas and stock in 48 bits long ----
        product        <= std_logic_vector(unsigned(mul_a) * unsigned(mul_b));
        ---- check for denorm ----
        if (exponent_gt_expoffset = '1') then
          exponent_2 <= exponent_1;
        else
          exponent_2 <= exponent;
        end if;
        ---- adjust the mantissa and exponent for normalization ----
        product_1     <= std_logic_vector(shift_right(unsigned(product), to_integer(unsigned(exponent_under))));  -- if the exponent was too small, shift to compensate
        product_shift <= count_l_zeros(product(47 downto 23));
        if (exponent_gt_expoffset = '1') then
          product_2 <= product;
        else
          product_2 <= product_1;
        end if;
        product_shift_2 <= product_shift;
        if (unsigned(exponent_2) > unsigned(product_shift_2)) then
          exponent_gt_prodshift <= '1';
        else
          exponent_gt_prodshift <= '0';
        end if;
        tmp_prod_shift_2 := "000" & product_shift_2;
        exponent_3       <= std_logic_vector(unsigned(exponent_2) - unsigned(tmp_prod_shift_2));
        if (exponent_gt_prodshift = '1') then
          exponent_4 <= exponent_3;
        else
          exponent_4 <= exponent;
        end if;
        if (exponent_4 = "000000000") then
          exponent_et_zero <= '1';
        else
          exponent_et_zero <= '0';
        end if;
        product_3 <= std_logic_vector(shift_left(unsigned(product_2), to_integer(unsigned(product_shift_2))));
        product_4 <= std_logic_vector(shift_left(unsigned(product_2), to_integer(unsigned(exponent_2))));
        if (in_zero = '1') then
          exponent_5 <= "000000000";
        else
          exponent_5 <= exponent_4;
        end if;
        if (exponent_gt_prodshift = '1') then
          product_5 <= product_3;
        else
          product_5 <= product_4;
        end if;
        if (exponent_et_zero = '1') then
          product_6 <= std_logic_vector(shift_right(unsigned(product_5), 1));
        else
          product_6 <= product_5;
        end if;
        ---- all remaining bits are compacted into the Round bit ----
        product_lsb <= or_reduce(product_6(22 downto 0));
        product_7 <= '0' & product_6(47 downto 23) & product_lsb;  -- output
      end if;
    end if;
  end process;
end rtl;
