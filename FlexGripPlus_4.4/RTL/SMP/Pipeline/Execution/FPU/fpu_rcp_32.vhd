----------------------------------------------------------------------------------
-- Floating Point Divider for binary IEEE 754 (fp_div.vhd)  MODIFIED FOR RECIPROCAL ONLY + SUBNORMAL SUPPORT
-- Combinational version
--
--
-- Section 12.5.3. Example 12.10. Floating Point Division
-- Combinational circuits but registering input and output.
-- For pipelined version contact the authors at arithmetic-circuits.org
--
-- K size of FP (s, exp, significand). Also Extorege width
-- E size of Exponent
-- P size of significant or fractional (includind the 1.). Also precision.
-- K = E+P
-- D is the pipeline depth of divider;
-- That means that result will be sup((P+3)/D) cycles later.
--
-- binary32; K=32, E= 8, P=24
-- binary64; K=64, E=11, P=53
--
-- In code is used the name frac (from fractional) instead of sig (from significant)
-- in order to not be confused with the sign.
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
library work;
use work.gpgpu_package.all;


entity fpu_rcp is
  generic(K : natural := 32; P : natural := 24; E : natural := 8);
  port (
    clk      : in  std_logic;
    rst      : in  std_logic;
    enable   : in  std_logic;
    FP_IN    : in  std_logic_vector (K-1 downto 0);
    sign     : out std_logic;
    exponent : out std_logic_vector(E downto 0);
    mantissa : out std_logic_vector(P+2 downto 0)
    );
end fpu_rcp;

architecture Behavioral of fpu_rcp is

  -- Internal constant declarations
  constant ZEROS  : std_logic_vector(K-1 downto 0) := (others => '0');
  constant ONES   : std_logic_vector(K-1 downto 0) := (others => '1');
  constant BIAS   : std_logic_vector(E-1 downto 0) := '0' & ONES(E-2 downto 0);  --7F in 32 bits, 3FF 64bits
  constant PBITS  : natural                        := P+3;  --P plus the 3 bits neenablessary in rounding 27

  component div_nr_wsticky is
    generic(NBITS : integer; PBITS : integer);
    port (
      A      : in  std_logic_vector (NBITS-1 downto 0);
      B      : in  std_logic_vector (NBITS-1 downto 0);
      Q      : out std_logic_vector (PBITS-1 downto 0);
      sticky : out std_logic);
  end component;

  signal FP_int                           : std_logic_vector(31 downto 0);
  signal exp_int, exp_temp                : std_logic_vector (E downto 0);  -- 9 bits
  signal frac_int, frac_int_2, frac_const : std_logic_vector (P-1 downto 0);  -- 24 bits

  signal exp_FF, exp_Z : std_logic;
  signal frac_Z        : std_logic;

  signal isNaN, isInf, isZero, isDenorm : std_logic;

  signal frac_div             : std_logic_vector (PBITS-1 downto 0);  -- 27 bits
  signal frac_div_shifted     : std_logic_vector (PBITS-1 downto 0);
  signal frac_final           : std_logic_vector (P+2 downto 0);  -- 27 bits
  signal exp_final            : std_logic_vector(E downto 0);
  signal lzc                  : unsigned(5 downto 0);
  signal sticky_bit, sticky_2 : std_logic;

begin

  --
  p_Reciprocal : process(clk, rst, enable)
    begin
      if (rst = '1') then
        exp_int          <= (others => '0');
        frac_int         <= (others => '0');
        frac_int_2       <= (others => '0');
        lzc              <= (others => '0');
        frac_div_shifted <= (others => '0');
        frac_final       <= (others => '0');
        exp_final        <= (others => '0');
        exp_FF           <= '0';
        exp_Z            <= '0';
        frac_Z           <= '0';
        isNaN            <= '0';
        isInf            <= '0';
        isZero           <= '0';
        isDenorm         <= '0';
        exponent         <= (others =>'0');
        mantissa         <= (others =>'0');
        sign             <= '0';
      elsif (clk'event and clk = '1') then
        if(enable = '1') then
          --inputs & special cases detection
          FP_int     <= FP_IN;
          if(FP_int(K-2 downto K-E-1) = ONES(K-2 downto K-E-1)) then
            exp_FF     <= '1';
          else
             exp_FF     <='0';
          end if;
          if(FP_int(K-2 downto K-E-1) = ZEROS(K-2 downto K-E-1)) then
            exp_Z      <= '1';
          else
            exp_Z      <='0';
          end if;
          if(FP_int(P-2 downto 0) = ZEROS(P-2 downto 0)) then
            frac_Z     <= '1';
          else
            frac_Z     <='0';
          end if;
          isNaN      <= exp_FF and (not frac_Z);
          isInf      <= exp_FF;  -- not compared the fractional part since NaN has priority.
          isZero     <= exp_Z and frac_Z;
          isDenorm   <= (exp_Z and (not frac_Z));
          frac_const <= x"800000";
          sticky_2   <= frac_div(0) or sticky_bit;
          -- separate denorm inputs and normal
          if(isDenorm = '0') then
            -- FP unpacking
            exp_int          <= '0' & FP_int(K-2 downto K-E-1);  --30 downto 23
            frac_int_2       <= ('1' & FP_int(P-2 downto 0));  -- Restore hidden 1.sssss when not zero or denormal
            exp_temp         <= std_logic_vector("011111110" - unsigned(exp_int));  -- 2* bias - exp
            --Normalization: shitf if significand < 1 and sub for exp
            if(frac_div(PBITS-1) = '0') then
              frac_div_shifted <= frac_div(PBITS-2 downto 0) & '0';
            else
              frac_div_shifted <= frac_div;
            end if;
            if(isNaN = '1') then
              exp_final  <= exp_int;
            elsif(isZero = '1') then
               exp_final <= (others => '1');
            elsif(frac_div(PBITS-1) = '0' and (exp_int /= "011111110")) then
               exp_final <= std_logic_vector(unsigned(exp_temp) - "000000001"); --shift for normalization
            else
               exp_final <= exp_temp;
            end if;
            if(isNaN = '1') then
              frac_final <= "00" & frac_int(23 downto 0) & '0';
            elsif(isZero = '1') then
              frac_final <= (others => '0');
            elsif(exp_int = "011111110") then
              frac_final <= "01" & frac_div(26 downto 3) & (frac_div(1) or frac_div(2) or sticky_2);  --padding for the round stage
            elsif(exp_int = "011111101") then
              frac_final <= '0' & frac_div(26 downto 2) & (frac_div(1) or sticky_2); --padding for the round stage
            else
              frac_final <= frac_div(26 downto 1) & sticky_2;
            end if;
          elsif(isDenorm = '1') then
            exp_int    <= (others => '0');  --30 downto 23
            frac_int   <= ('0' & FP_int(P-2 downto 0));  -- 0.mantissa the number is denormal
            lzc        <= unsigned(count_l_zeros(frac_int(P-2 downto 0)));
            frac_int_2 <= std_logic_vector(shift_left(unsigned(frac_int), to_integer(lzc)+1));  -- Normalize mantissa by shifting left until the first one
            exp_temp   <= std_logic_vector("011111101" + lzc);  -- "real" exp of the number is 1-LZC so the result exp is 2*bias -( 1-LZC) = 253 + LZC
            if(exp_temp(8) = '0') then -- check for overflow
              exp_final  <= exp_temp;
            else
              exp_final  <= (others => '1');
            end if;
            frac_final <= frac_div(26 downto 1) & sticky_2;
          end if;
          -- outputs
          exponent <= exp_final;
          mantissa <= frac_final;
          sign     <= FP_IN(31);
        end if;
      end if;
    end process;

a_div : div_nr_wsticky generic map(NBITS => 24, PBITS => 27)
  port map(A => frac_const, B => frac_int_2, Q => frac_div, sticky => sticky_bit);  -- reciprocal computation only: 1/X
end Behavioral;
