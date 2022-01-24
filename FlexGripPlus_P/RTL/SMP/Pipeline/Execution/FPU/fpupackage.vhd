library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
use STD.textio.all;
use ieee.std_logic_textio.all;

package fpupackage is

  function or_reduce (s_vector     : std_logic_vector) return std_logic;
  function count_l_zeros (s_vector : std_logic_vector) return std_logic_vector;
  function complement (s_vector    : std_logic_vector) return std_logic_vector;
  function to_string (a            : std_logic_vector) return string;
  type fpu_opcode_type is (FADD, FMUL, FMAD, CONV, UNKNOWN);
  type fpu_conv_type is (U2F, S2F, F2U, F2S, NEG, TRSFR, ABSO);
  --- Component Declarations ---

  component fpu_add is
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
  end component;

  component fpu_sub is

    port(
      clk        : in  std_logic;
      rst        : in  std_logic;
      enable     : in  std_logic;
      opa        : in  std_logic_vector (31 downto 0);
      opb        : in  std_logic_vector (31 downto 0);
      -- fpu_op     : in  std_logic_vector (2 downto 0);
      sign       : out std_logic;
      diff_2     : out std_logic_vector (26 downto 0);
      exponent_2 : out std_logic_vector (7 downto 0)
      );
    -- Declarations

  end component;

  component fpu_mul is
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
  end component;



  component fpu_round is
    port(
      clk, rst, enable : in  std_logic;
      round_mode       : in  std_logic_vector (1 downto 0);
      sign_term        : in  std_logic;
      mantissa_term    : in  std_logic_vector (26 downto 0);
      exponent_term    : in  std_logic_vector (8 downto 0);
      round_out        : out std_logic_vector (31 downto 0);
      exponent_final   : out std_logic_vector (8 downto 0)
      );
  end component;

  component fpu_exceptions is
    port(
      clk, rst, enable                        : in  std_logic;
      rmode                                   : in  std_logic_vector (1 downto 0);
      opa, opb, opc, in_except                : in  std_logic_vector (31 downto 0);
      exponent_in                             : in  std_logic_vector (8 downto 0);
      mantissa_in                             : in  std_logic_vector (1 downto 0);
      fpu_op                                  : in  fpu_opcode_type;
      out_fp                                  : out std_logic_vector (31 downto 0);
      ex_enable, underflow, overflow, inexact : out std_logic;
      exception, invalid                      : out std_logic
      );

  end component;

  component fpu_conv is
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
  end component;

  component fpu_fma is

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

  end component;

end fpupackage;


package body fpupackage is

  function or_reduce (s_vector : std_logic_vector) return std_logic is
    variable bool : std_logic;
  begin
    bool := s_vector(s_vector'right);
    for i in (s_vector'right + 1) to (s_vector'left) loop
      bool := bool or s_vector(i);
    end loop;
    return bool;
  end or_reduce;

  function count_l_zeros (s_vector : std_logic_vector) return std_logic_vector is
    variable v_count   : unsigned(5 downto 0);
    variable first_one : std_logic;
  begin
    v_count   := "000000";
    first_one := '0';
    for i in s_vector'range loop
      case s_vector(i) is
        when '0' =>
          if (first_one = '0') then
            v_count := v_count + "000001";
          end if;
        when others => first_one := '1';
      end case;
    end loop;
    return std_logic_vector(v_count);
  end count_l_zeros;

  function complement (s_vector : std_logic_vector) return std_logic_vector is
    variable temp : std_logic_vector(s_vector'left downto s_vector'right);
    variable un   : unsigned(s_vector'range);
  begin
    un    := (others => '0');
    un(0) := '1';
    if(s_vector(s_vector'left) = '1') then
      for i in s_vector'range loop
        temp(i) := s_vector(s_vector'left) xor s_vector(i);
      end loop;
      temp := std_logic_vector(unsigned(temp) + un);
    else
      temp := s_vector;
    end if;
    return temp;
  end complement;

  function to_string (a : std_logic_vector) return string is
    variable b    : string (1 to a'length) := (others => NUL);
    variable stri : integer                := 1;
  begin
    for i in a'range loop
      b(stri) := std_logic'image(a((i)))(2);
      stri    := stri+1;
    end loop;
    return b;
  end function;

end fpupackage;
