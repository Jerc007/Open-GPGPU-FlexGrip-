library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
library work;
use work.gpgpu_package.all;

entity fpu_fma is

  port(
    clk      : in  std_logic;
    rst      : in  std_logic;
    enable   : in  std_logic;
    opa      : in  std_logic_vector (31 downto 0);
    opb      : in  std_logic_vector (31 downto 0);
    opc      : in  std_logic_vector (31 downto 0);
    sign     : out std_logic;
    mantissa : out std_logic_vector (26 downto 0);
    exponent : out std_logic_vector (8 downto 0)
    );

end fpu_fma;

architecture arch of fpu_fma is
  signal mantissa_a                       : std_logic_vector(22 downto 0);
  signal mantissa_b                       : std_logic_vector(22 downto 0);
  signal mantissa_c                       : std_logic_vector(22 downto 0);
  signal lmantissa_a                      : std_logic_vector(23 downto 0);
  signal lmantissa_b                      : std_logic_vector(23 downto 0);
  signal lmantissa_c                      : std_logic_vector(23 downto 0);
  signal exponent_a                       : std_logic_vector(8 downto 0);
  signal exponent_b                       : std_logic_vector(8 downto 0);
  signal exponent_c                       : std_logic_vector(8 downto 0);
  signal exponent_ab                      : std_logic_vector(8 downto 0);
  signal sign_a, sign_b, sign_c, sign_i   : std_logic;
  signal a_isnorm, b_isnorm, c_isnorm     : std_logic;
  signal a_is_denorm, b_is_denorm         : std_logic;
  signal exp_diff                         : signed(9 downto 0);
  signal shift_1, shift_2                 : unsigned(9 downto 0);
  signal ab_shifted                       : std_logic_vector(76 downto 0);
  signal expo                             : std_logic_vector(8 downto 0);
  signal c_shifted_temp, c_shifted_temp_2 : std_logic_vector(99 downto 0);
  signal c_compressed, c_compressed_2     : std_logic_vector(76 downto 0);
  signal sum, diff                        : std_logic_vector(77 downto 0);
  signal sum_2, diff_comp                 : std_logic_vector(76 downto 0);
  signal sum_shifted                      : std_logic_vector(76 downto 0);
  signal leadzeros                        : std_logic_vector(8 downto 0);
  signal sticky_c, sticky_f               : std_logic;
  signal product_ab                       : unsigned(47 downto 0);
  signal test_denorm                      : std_logic_vector(9 downto 0);
begin

  p_FusedMultiplyAdd : process(clk, rst)
    variable na, nb, nc                             : std_logic_vector(9 downto 0);
    variable dna, dnb, dnc                          : std_logic_vector(9 downto 0);
    variable temp_c_compressed, temp_c_compressed_2 : std_logic_vector(77 downto 0);
    variable temp_sum, temp_sum_2                   : std_logic_vector(78 downto 0);
    variable adjust                                 : std_logic_vector(8 downto 0);
  begin
    if(rst = '1') then
      mantissa_a       <= (others => '0');
      mantissa_b       <= (others => '0');
      mantissa_c       <= (others => '0');
      lmantissa_a      <= (others => '0');
      lmantissa_b      <= (others => '0');
      lmantissa_c      <= (others => '0');
      exponent_a       <= (others => '0');
      exponent_b       <= (others => '0');
      exponent_c       <= (others => '0');
      exponent_ab      <= (others => '0');
      sign_a           <= '0';
      sign_b           <= '0';
      sign_c           <= '0';
      sign_i           <= '0';
      a_isnorm         <= '0';
      b_isnorm         <= '0';
      c_isnorm         <= '0';
      a_is_denorm      <= '0';
      b_is_denorm      <= '0';
      exp_diff         <= (others => '0');
      shift_1          <= "0000000000";
      shift_2          <= "0000000000";
      ab_shifted       <= (others => '0');
      expo             <= (others => '0');
      c_shifted_temp   <= (others => '0');
      c_shifted_temp_2 <= (others => '0');
      c_compressed     <= (others => '0');
      c_compressed_2   <= (others => '0');
      sum              <= (others => '0');
      sum_2            <= (others => '0');
      sum_shifted      <= (others => '0');
      leadzeros        <= (others => '0');
      sticky_c         <= '0';
      sticky_f         <= '0';
      sign             <= '0';
      mantissa         <= (others => '0');
      exponent         <= (others => '0');
      test_denorm      <= (others =>'0');
    elsif(clk'event and clk = '1') then
      if(enable = '1') then
        ---- unpacking ----
        mantissa_a                                       <= opa(22 downto 0);
        mantissa_b                                       <= opb(22 downto 0);
        mantissa_c                                       <= opc(22 downto 0);
        exponent_a                                       <= '0' & opa(30 downto 23);
        exponent_b                                       <= '0' & opb(30 downto 23);
        exponent_c                                       <= '0' & opc(30 downto 23);
        sign_a                                           <= opa(31);
        sign_b                                           <= opb(31);
        sign_c                                           <= opc(31);
        if(opa(30 downto 23) = "00000000") then a_isnorm <= '0'; else a_isnorm <= '1'; end if;
        if(opb(30 downto 23) = "00000000") then b_isnorm <= '0'; else b_isnorm <= '1'; end if;
        if(opc(30 downto 23) = "00000000") then c_isnorm <= '0'; else c_isnorm <= '1'; end if;
        na                                               := "000000000" & a_isnorm;
        nb                                               := "000000000" & b_isnorm;
        nc                                               := "000000000" & c_isnorm;
        dna                                              := "000000000" & (not a_isnorm);
        dnb                                              := "000000000" & (not b_isnorm);
        dnc                                              := "000000000" & (not c_isnorm);
        lmantissa_a                                      <= a_isnorm & mantissa_a;
        lmantissa_b                                      <= b_isnorm & mantissa_b;
        lmantissa_c                                      <= c_isnorm & mantissa_c;
        exponent_ab                                      <= std_logic_vector(unsigned(exponent_a) + unsigned(exponent_b));  -- care has 2 time the bias
        ---- compute exponent difference C- (A+B) + 127 - normalization bits ----
        exp_diff                                         <= signed(std_logic_vector(unsigned('0' & exponent_c) - unsigned('0' & exponent_ab) + "001111110" - unsigned(nc) + unsigned(na) + unsigned(nb)));
        product_ab                                       <= unsigned(lmantissa_a) * unsigned(lmantissa_b);
        ab_shifted                                       <= "000000000000000000000000000" & std_logic_vector(product_ab) & "00";

        ----determine shifting of C mantissa depending on A*B bigger than C or not ----
        if(exp_diff <= "1111010001") then  -- ]-oo:-47] product-anchored case with saturated shift
          shift_1 <= "0001001100";        -- 76
          expo    <= std_logic_vector(unsigned(exponent_ab) - "001111101");  -- A+B -127 + 2 for norm
          sign_i  <= sign_a xor sign_b;
        elsif(exp_diff > "1111010001" and exp_diff <= "0000000010") then  -- [-46:2] product-anchored case or cancellation
          shift_1 <= unsigned(std_logic_vector("0000011100" - exp_diff));  -- 28 - exp_diff
          expo    <= std_logic_vector(unsigned(exponent_ab) - "001111101");  -- A+B - 127 + 2
          sign_i  <= sign_a xor sign_b;
        elsif(exp_diff > "0000000010" and exp_diff <= "0000011010") then  -- [3:26] addend-anchored case
          shift_1 <= unsigned(std_logic_vector("0000011100" - exp_diff));  -- 28 - exp_diff
          expo    <= exponent_c;
          sign_i  <= sign_c;
        elsif(exp_diff > "0000011010") then  -- [27: +oo[ addend-anchored case with saturated shift
          shift_1 <= "0000000000";
          expo    <= exponent_c;
          sign_i  <= sign_c;
        end if;
        ---- positionning C mantissa for addition ----
        c_shifted_temp(99 downto 76) <= lmantissa_c;
        c_shifted_temp(75 downto 0)  <= (others => '0');
        c_shifted_temp_2             <= std_logic_vector(shift_right(unsigned(c_shifted_temp), to_integer(shift_1)));
        c_compressed                 <= c_shifted_temp_2(99 downto 23);
        sticky_c                     <= or_reduce(c_shifted_temp_2(23 downto 0));
        c_compressed_2               <= c_compressed;
        ---- compute possible outputs A*B+C| A*B-C| -A*B+C
        sum                          <= std_logic_vector(unsigned('0' & ab_shifted) + unsigned('0' & c_compressed_2));
        diff                         <= std_logic_vector(unsigned('0' & ab_shifted) - unsigned('0' & c_compressed_2));
        temp_sum                     := '1' & diff;
        diff_comp                    <= complement(temp_sum)(76 downto 0);
        ---- choose one of the precedent outputs ----
        --- effective add A*B+C : 0 or 2 operands are negative (remember it is always possible to cahnge the sign in the end if -(AB)-C is wanted)
        if ((sign_a = '0' and sign_b = '0' and sign_c = '0') or (sign_a = '1' and sign_b = '1' and sign_c = '0')
            or (sign_a = '1' and sign_b = '0' and sign_c = '1') or (sign_a = '0' and sign_b = '1' and sign_c = '1')) then
          sum_2 <= sum(76 downto 0);
        --- case AB bigger than C and one of the operand is negative, the result already has the sign of AB so we compute AB-C and the result will be -AB+C
        elsif exp_diff < "000000000" then
          sum_2 <= diff(76 downto 0);
        --- case C is bigger and one of the operand is negative, the result take the sign of C and we compute -AB+C, which can be transformed into AB-C in the end if C is negative
        elsif exp_diff > "0000000001" then
          sum_2  <= diff_comp(76 downto 0);
          sign_i <= sign_c;
        --- limit cases when AB and C are not different enough to predict the result with the exponent (still one negative), we compare mantissas to know precisely who is bigger and fall back on one of the precedent case
        elsif((exp_diff = "0000000000" or exp_diff = "0000000001") and (unsigned(c_compressed_2) > unsigned(ab_shifted))) then
          sum_2  <= diff_comp(76 downto 0);
          sign_i <= sign_c;
        elsif ((exp_diff = "0000000000" or exp_diff = "0000000001") and (unsigned(c_compressed_2) < unsigned(ab_shifted))) then
          sum_2 <= diff(76 downto 0);
        end if;

        ---- shifting left to get the 1st one front of the mantissa ----
        if(exp_diff <= "0000000001") then    -- ]-oo:1] product-anchored case,
          leadzeros <= "000" & count_l_zeros(sum_2(50 downto 0));
           test_denorm <= std_logic_vector(unsigned('0' & exponent_ab) - unsigned('0' & leadzeros) - "0001111111" + unsigned(na) + unsigned(nb));
          if( signed(test_denorm) > "0000000000") then  -- test for subnormal
            shift_2 <= "0000011010" + unsigned('0' & leadzeros);
            expo    <= std_logic_vector(unsigned(exponent_ab) - unsigned(leadzeros) - "001111101" + unsigned(dna(8 downto 0)) + unsigned(dnb(8 downto 0)));  -- add 1 if an operand is denorm
          elsif(signed(test_denorm) = "0000000000") then
            shift_2 <= "0000011001" + unsigned('0' & leadzeros);
            expo    <= std_logic_vector(unsigned(exponent_ab) - unsigned(leadzeros) - "001111101" + unsigned(dna(8 downto 0)) + unsigned(dnb(8 downto 0)));  -- add 1 if an operand is denorm
          else
            shift_2 <= "0000011100" + unsigned('0' & exponent_ab) - "0000000001" - "0001111111";
            expo    <= std_logic_vector("000000000" + unsigned(dna(8 downto 0)) + unsigned(dnb(8 downto 0)));
          end if;
        elsif(exp_diff = "0000000010") then  -- = 2 risk of cancellation
          leadzeros <= "000" & count_l_zeros(sum_2(51 downto 0));
          test_denorm <= std_logic_vector(unsigned('0' & exponent_ab) - unsigned('0' & leadzeros) - "0001111110" + unsigned(na) + unsigned(nb));
          if(signed(test_denorm) > "0000000000") then  -- test for subnormal
            shift_2 <= "0000011001" + unsigned('0' & leadzeros);
            expo    <= std_logic_vector(unsigned(exponent_ab) - unsigned(leadzeros) - "001111100" + unsigned(dna(8 downto 0)) + unsigned(dnb(8 downto 0)));  -- Ea+Eb-L+3 as in the paper
          elsif(signed(test_denorm) = "0000000000") then
            shift_2 <= "0000011000" + unsigned('0' & leadzeros);
            expo    <= std_logic_vector(unsigned(exponent_ab) - unsigned(leadzeros) - "001111100" + unsigned(dna(8 downto 0)) + unsigned(dnb(8 downto 0)));  -- add 1 if an operand is denorm
          else
             shift_2 <= "0000011100" + unsigned('0' & exponent_ab) - "0000000001" - "0001111111" + unsigned(dna(8 downto 0)) + unsigned(dnb(8 downto 0));
            expo    <= std_logic_vector("000000000" + unsigned(dna(8 downto 0)) + unsigned(dnb(8 downto 0)));
          end if;
        elsif(exp_diff > "0000000010" and exp_diff <= "0000011010" and shift_1 /= "0000000000" and c_isnorm = '1') then  -- [3:26] addend enchored case
          if(sum_2(to_integer("001001101" - shift_1)) = '1' and ((sign_a = '0' and sign_b = '0' and sign_c = '0') or (sign_a = '1' and sign_b = '1' and sign_c = '0')
                                                                 or (sign_a = '1' and sign_b = '0' and sign_c = '1') or (sign_a = '0' and sign_b = '1' and sign_c = '1'))) then  -- if effective add, a carry may appear
            shift_2 <= shift_1 - "000000001";
            expo    <= std_logic_vector(unsigned(exponent_c) + "000000001");
          elsif(sum_2(to_integer("001001100" - shift_1)) /= '1' and ((sign_a = '1' and sign_b = '1' and sign_c = '1') or (sign_a = '1' and sign_b = '0' and sign_c = '0')
                                                                     or (sign_a = '0' and sign_b = '1' and sign_c = '0') or (sign_a = '0' and sign_b = '0' and sign_c = '1'))) then  -- if effective subtraction, a cancellation may appear
            shift_2 <= shift_1 + "000000001";
            expo    <= std_logic_vector(unsigned(exponent_c) - "000000001");
          else  -- shift equals the first right shift of C's mantissa
            shift_2 <= shift_1;
            expo    <= exponent_c;
          end if;
        elsif(exp_diff > "0000011010" and c_isnorm = '1') then  -- [27:+oo] addend anchored case
          shift_2 <= shift_1;
          expo    <= exponent_c;
        elsif(exp_diff > "0000000010" and c_isnorm = '0') then  -- case C denorm but still bigger than AB
          shift_2 <= shift_1;
           expo <= "000000000"; -- expo C TODO
          -- adjust := dna ;
          -- expo    <= std_logic_vector(unsigned(exponent_c) + unsigned(adjust));
        end if;

        sum_shifted <= std_logic_vector(shift_left(unsigned(sum_2), to_integer(shift_2)));
        sticky_f    <= sticky_c or or_reduce(sum_shifted(51 downto 0));
        exponent    <= expo;
        mantissa    <= '0' & sum_shifted(76 downto 52) & sticky_f;
        sign        <= sign_i;
      end if;
    end if;
  end process;
end architecture;
