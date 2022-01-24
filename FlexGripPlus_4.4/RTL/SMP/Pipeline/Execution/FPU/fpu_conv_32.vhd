library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
library work;
use work.gpgpu_package.all;
entity fpu_conv is
  port(
    clk       : in  std_logic;
    rst       : in  std_logic;
    enable    : in  std_logic;
    convmode  : in  fpu_conv_type;
    int_in    : in  std_logic_vector(31 downto 0);
    float_in  : in  std_logic_vector(31 downto 0);
    int_out   : out std_logic_vector(31 downto 0);
    float_out : out std_logic_vector(31 downto 0)
    );
end fpu_conv;

architecture rtl of fpu_conv is

begin

  p_Conversion : process(clk, rst, enable)
    variable shift_value  : unsigned(5 downto 0);
    variable mantissa     : std_logic_vector(22 downto 0);
    variable mantissa_tmp : std_logic_vector(31 downto 0);
    variable exponent     : std_logic_vector(7 downto 0);
    variable twoscomp     : std_logic_vector(31 downto 0);
    variable nb_zeros     : integer;
    variable tmp_int      : std_logic_vector(76 downto 0);
    variable tmp2_int     : std_logic_vector(31 downto 0);
    variable tmp_int_2    : std_logic_vector(32 downto 0);
    variable tie          : std_logic_vector(1 downto 0);
  begin
    if rst = '1' then
      int_out   <= (others => '0');
      float_out <= (others => '0');
    elsif (clk'event and clk = '1') then
      if(enable = '1') then
        shift_value  := (others => 'X');
        mantissa     := (others => 'X');
        mantissa_tmp := (others => 'X');
        exponent     := (others => 'X');
        twoscomp     := (others => 'X');
        nb_zeros     := 0;
        tmp_int      := (others => 'X');
        tmp2_int      := (others => 'X');
        tmp_int_2    := (others => 'X');
        tie :=    (others =>'X');
        case convmode is
          when U2F =>
            int_out <= (others        => '0');
            if int_in = (int_in'range => '0') then        -- check for null input
              float_out <= (others => '0');
            else
              shift_value  := unsigned(count_l_zeros(int_in(31 downto 0)));
              mantissa_tmp := std_logic_vector(shift_left(unsigned(int_in), to_integer(shift_value) +1));  -- first 1 is the one of the 1.mantissa
              mantissa     := mantissa_tmp(31 downto 9);
              -- rounding of the possible rest of the integer // CAN IT OVERFLOW?
              tie := mantissa_tmp(8) & or_reduce(mantissa_tmp(7 downto 0));
              if (tie = "11" or (tie = "10" and mantissa(0) = '1')) then
                mantissa := std_logic_vector(unsigned(mantissa) + "00000000000000000000001");
              end if;
              exponent     := std_logic_vector("10011110" - shift_value);  -- 158 - shift value
              float_out    <= ('0' & exponent & mantissa);
            end if;
          when S2F =>  -- meme chose qu'avant mais on prend le complement à 2 de l'entrée avant de travailler
            int_out <= (others        => '0');
            if int_in = (int_in'range => '0') then        -- check for null input
              float_out <= (others => '0');
            else
              twoscomp     := complement(int_in);
              shift_value  := unsigned(count_l_zeros(twoscomp(31 downto 0)));
              mantissa_tmp := std_logic_vector(shift_left(unsigned(twoscomp), to_integer(shift_value) +1));  -- first 1 is the one of the 1.mantissa
              mantissa     := mantissa_tmp(31 downto 9);
              -- rounding of the possible rest of the integer // CAN IT OVERFLOW?
              tie := mantissa_tmp(8) & or_reduce(mantissa_tmp(7 downto 0));
              if (tie = "11" or (tie = "10" and mantissa(0) = '1')) then
                mantissa := std_logic_vector(unsigned(mantissa) + "00000000000000000000001");
              end if;
              exponent     := std_logic_vector("10011110" - shift_value);  -- 158 - shift_value
              float_out    <= (int_in(31) & exponent & mantissa);
            end if;
          when F2U =>
            float_out <= (others => '0');
            if(float_in(30 downto 23) = "00000000") then  -- case float is denorm flush to 0
              int_out <= (others => '0');
            elsif(float_in(30 downto 23) = "11111111") then  -- case float is +/-infinite flush to max int
              int_out <= (others => '1');
            elsif(float_in(31) = '1' and (unsigned(float_in(30 downto 23)) > "01111111" or  -- UNSPECIFIED BEHAVIOR BY IEEE : negative floats <-1  flush MAX INT
                                         (float_in(30 downto 23) = "01111111" and or_reduce(float_in(22 downto 0)) = '1') or
                                         (float_in(30 downto 23) = "01111110" and or_reduce(float_in(22 downto 0)) = '1')  )) then  -- those are [-0.5 : -1[
              int_out <= (others => '1');
            elsif(float_in(31) = '1' and unsigned(float_in(30 downto 23)) <= "01111111" ) then  -- UNSPECIFIED BEHAVIOR BY IEEE : negative float >-1  flush 0
              int_out <= (others => '0');
            else
              --calculate shifting
              nb_zeros    := 158 - to_integer(unsigned(float_in(30 downto 23)));
              -- temporarily fill on the left the mantissa
              tmp_int(76) := '1';         -- 1. mantissa
              tmp_int(75 downto 53)     := float_in(22 downto 0);
              tmp_int(52 downto 0)      := (others =>'0');
              -- shift for the right amount, iif too much shifting is needed instead put all at zero
              if (0 <= nb_zeros and nb_zeros < 77) then
                tmp_int     := std_logic_vector(shift_right(unsigned(tmp_int), nb_zeros));  -- shift right to get the '0' at left side
                tie := tmp_int(44) & or_reduce(tmp_int(43 downto 0));
                -- extract the integer
                tmp2_int := tmp_int(76 downto 45);
                -- check for rounding
                if tie = "11" or (tie = "10" and tmp2_int(0) = '1') then
                  tmp2_int := std_logic_vector(unsigned(tmp2_int) + x"00000001");
                end if;
                int_out     <= tmp2_int;
              elsif (nb_zeros < 0 )  then -- number bigger than max int
                int_out <= x"FFFFFFFF";
              else
                int_out <= (others =>'0');
              end if;
            end if;
          when F2S =>
             float_out <= (others => '0');
             if(float_in(30 downto 23) = "00000000") then  -- case float is denorm flush to 0
               int_out <= (others => '0');
             elsif(float_in(30 downto 23) = "11111111" and or_reduce(float_in(22 downto 0)) = '1') then -- case NaN flush to max -int
               int_out <= x"80000000";
             elsif(float_in(30 downto 23) = "11111111" and float_in(31) = '0') then  -- case float is +infinite flush to max +int
               int_out <= x"7FFFFFFF";
             elsif(float_in(30 downto 23) = "11111111" and float_in(31) = '1') then  -- case float is -infinite flush to max -int
               int_out <= x"80000000";
             else
               --calculate shifting
               nb_zeros    := 158 - to_integer(unsigned(float_in(30 downto 23)));
               -- temporarily fill on the left the mantissa
               tmp_int(76) := '1';         -- 1. mantissa
               tmp_int(75 downto 53)     := float_in(22 downto 0);
               tmp_int(52 downto 0)      := (others =>'0');
               -- shift for the right amount, iif too much shifting is needed instead put all at zero
               if (0 < nb_zeros and nb_zeros < 77) then
                 tmp_int     := std_logic_vector(shift_right(unsigned(tmp_int),nb_zeros));  -- shift right to get the '0' at left side
                 tie := tmp_int(44) & or_reduce(tmp_int(43 downto 0));
                 -- extract the integer
                 tmp2_int := tmp_int(76 downto 45);
                 -- check for rounding
                 if tie = "11" or (tie = "10" and tmp2_int(0) = '1') then
                   tmp2_int := std_logic_vector(unsigned(tmp2_int) + x"00000001");
                 end if;
                 -- correct sign of result
                 if(float_in(31) = '1') then
                   tmp_int_2 := '1' & tmp2_int;
                   int_out <= complement(tmp_int_2)(31 downto 0);
                 else
                   int_out     <= tmp2_int;
                 end if;
               elsif (nb_zeros < 0 or (nb_zeros = 0 and or_reduce(float_in(22 downto 0)) = '1'))  then -- number bigger than max int
                 int_out <= x"80000000";
               else
                 int_out <= (others =>'0');
               end if;
             end if;
          when NEG =>
            float_out <= not float_in(31) & float_in(30 downto 0);
          when ABSO =>
            float_out <= '0' & float_in(30 downto 0);
          when TRSFR =>
            float_out <= float_in;
        end case;
      end if;
    end if;
  end process;
end rtl;
