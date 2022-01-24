library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
library work;
use work.gpgpu_package.all;

entity fpu_exceptions is

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

end fpu_exceptions;

architecture rtl of fpu_exceptions is

  signal opa_et_zero       : std_logic;
  signal opb_et_zero       : std_logic;
  signal opc_et_zero       : std_logic;
  signal add               : std_logic;
  signal sub               : std_logic;
  signal multiply          : std_logic;
  signal fusedmadd         : std_logic;
  signal reciprocal        : std_logic;
  signal opa_QNaN          : std_logic;
  signal opb_QNaN          : std_logic;
  signal opc_QNaN          : std_logic;
  signal opa_SNaN          : std_logic;
  signal opb_SNaN          : std_logic;
  signal opc_SNaN          : std_logic;
  signal opa_pos_inf       : std_logic;
  signal opb_pos_inf       : std_logic;
  signal opc_pos_inf       : std_logic;
  signal opa_neg_inf       : std_logic;
  signal opb_neg_inf       : std_logic;
  signal opc_neg_inf       : std_logic;
  signal underflow_trigger : std_logic;
  signal invalid_trigger   : std_logic;
  signal overflow_trigger  : std_logic;
  signal inexact_trigger   : std_logic;
  signal except_trigger    : std_logic;
  signal enable_trigger    : std_logic;
  signal out_overflow      : std_logic_vector(31 downto 0);
  signal out_invalid       : std_logic_vector(31 downto 0);
  signal exp_255           : std_logic_vector(7 downto 0);
  signal exp_254           : std_logic_vector(7 downto 0);

begin

  exp_255 <= "11111111";
  exp_254 <= "11111110";

  p_InputHandler : process(clk, rst, enable)
  begin
    if(rst = '1') then
      opa_et_zero    <= '0';
      opb_et_zero    <= '0';
      opc_et_zero    <= '0';
      add            <= '0';
      sub            <= '0';
      multiply       <= '0';
      fusedmadd      <= '0';
      reciprocal     <= '0';
      opa_QNaN       <= '0';
      opb_QNaN       <= '0';
      opc_QNaN       <= '0';
      opa_SNaN       <= '0';
      opb_SNaN       <= '0';
      opc_SNaN       <= '0';
      opa_pos_inf    <= '0';
      opb_pos_inf    <= '0';
      opc_pos_inf    <= '0';
      opa_neg_inf    <= '0';
      opb_neg_inf    <= '0';
      opc_neg_inf    <= '0';
      except_trigger <= '0';
      enable_trigger <= '0';
    elsif(clk'event and clk = '1' and enable = '1') then
      -- tests for 0
      if(or_reduce(opa(31 downto 0)) = '0') then
        opa_et_zero <= '1';
      else
        opa_et_zero <= '0';
      end if;
      if(or_reduce(opb(31 downto 0)) = '0') then
        opb_et_zero <= '1';
      else
        opb_et_zero <= '0';
      end if;
      if(or_reduce(opc(31 downto 0)) = '0') then
        opc_et_zero <= '1';
      else
        opc_et_zero <= '0';
      end if;
      -- tests for infinity and NaNs
      if(opa(30 downto 23) = exp_255) then
        if(or_reduce(opa(23 downto 0)) = '0') then
          opa_QNaN <= '0';
          opa_SNaN <= '0';
          if(opa(31) = '1') then
            opa_neg_inf <= '1';
          else
            opa_pos_inf <= '1';
          end if;
        elsif(opa(23) = '1') then
          opa_QNaN    <= '1';
          opa_SNaN    <= '0';
          opa_pos_inf <= '0';
          opa_neg_inf <= '0';
        else
          opa_QNaN    <= '0';
          opa_SNaN    <= '1';
          opa_pos_inf <= '0';
          opa_neg_inf <= '0';
        end if;
      else
        opa_QNaN    <= '0';
        opa_SNaN    <= '0';
        opa_pos_inf <= '0';
        opa_neg_inf <= '0';
      end if;

      if(opb(30 downto 23) = exp_255) then
        if(or_reduce(opb(23 downto 0)) = '0') then
          opb_QNaN <= '0';
          opb_SNaN <= '0';
          if(opb(31) = '1') then
            opb_neg_inf <= '1';
          else
            opb_pos_inf <= '1';
          end if;
        elsif(opb(23) = '1') then
          opb_QNaN    <= '1';
          opb_SNaN    <= '0';
          opb_pos_inf <= '0';
          opb_neg_inf <= '0';
        else
          opb_QNaN    <= '0';
          opb_SNaN    <= '1';
          opb_pos_inf <= '0';
          opb_neg_inf <= '0';
        end if;
      else
        opb_QNaN    <= '0';
        opb_SNaN    <= '0';
        opb_pos_inf <= '0';
        opb_neg_inf <= '0';
      end if;

      if(opc(30 downto 23) = exp_255) then
        if(or_reduce(opc(23 downto 0)) = '0') then
          opc_QNaN <= '0';
          opc_SNaN <= '0';
          if(opc(31) = '1') then
            opc_neg_inf <= '1';
          else
            opc_pos_inf <= '1';
          end if;
        elsif(opc(23) = '1') then
          opc_QNaN    <= '1';
          opc_SNaN    <= '0';
          opc_pos_inf <= '0';
          opc_neg_inf <= '0';
        else
          opc_QNaN    <= '0';
          opc_SNaN    <= '1';
          opc_pos_inf <= '0';
          opc_neg_inf <= '0';
        end if;
      else
        opc_QNaN    <= '0';
        opc_SNaN    <= '0';
        opc_pos_inf <= '0';
        opc_neg_inf <= '0';
      end if;

      -- tests for the operation
      if(fpu_op = FADD and opa(31) = '0' and opb(31) = '0') then
        add <= '1';
      else
        add <= '0';
      end if;

      if(fpu_op = FADD and (opa(31) = '1' or opb(31) = '1')) then
        sub <= '1';
      else
        sub <= '0';
      end if;

      if(fpu_op = FMUL) then
        multiply <= '1';
      else
        multiply <= '0';
      end if;

      if(fpu_op = FMAD) then
        fusedmadd <= '1';
      else
        fusedmadd <= '0';
      end if;

      if(fpu_op = RCP) then
        reciprocal <= '1';
      else
        reciprocal <= '0';
      end if;
    end if;
  end process;

  p_InvalidFinder : process(clk, rst)
  begin
    if (rst = '1') then
      invalid_trigger <= '0';
      out_invalid     <= (others => '0');
    elsif (clk'event and clk = '1' and enable = '1') then
      --- list of events leading to invalid output
      if(opa_SNaN = '1' or opa_QNaN = '1') then
        invalid_trigger <= '1';
        out_invalid     <= opa(31) & exp_255 & '1' & opa(21 downto 0);
      elsif(opb_SNaN = '1' or opb_QNaN = '1') then
        invalid_trigger <= '1';
        out_invalid     <= opb(31) & exp_255 & '1' & opb(21 downto 0);
      elsif(fusedmadd = '1' and (opc_SNaN = '1' or opc_QNaN = '1')) then
        invalid_trigger <= '1';
        out_invalid     <= opc(31) & exp_255 & '1' & opc(21 downto 0);
      elsif(add = '1' and ((opa_pos_inf = '1' and opb_neg_inf = '1') or (opa_neg_inf = '1' and opb_pos_inf = '1'))) then
        invalid_trigger <= '1';
      elsif(sub = '1' and ((opa_pos_inf = '1' and opb_pos_inf = '1') or (opa_neg_inf = '1' and opb_neg_inf = '1'))) then
        invalid_trigger <= '1';
      elsif(multiply = '1' and
            (((opa_et_zero = '1' and (opb_pos_inf = '1' or opb_neg_inf = '1'))
              or
              ((opb_et_zero = '1' and (opa_pos_inf = '1' or opa_neg_inf = '1')))))) then
        invalid_trigger <= '1';         -- UNDEFINED OUTPUT FOR 0 X INF
      elsif(unsigned(opa(30 downto 0)) <= "011111110" and unsigned(opb(30 downto 0)) <= "011111110") then
        invalid_trigger <= '0';
        out_invalid     <= (others => '0');
      elsif(reciprocal = '1' and opa_et_zero = '1') then
        invalid_trigger <= '1';
        out_invalid <= x"7f000000";
      end if;
    end if;
  end process;

  p_OverflowFinder : process(clk, rst)
  begin
    if (rst = '1') then
      overflow_trigger <= '0';
      out_overflow     <= (others => '0');
    elsif (clk'event and clk = '1' and enable = '1') then
      --- list of events leading to overflow output
      if(unsigned(exponent_in) > "011111110" and opa_QNaN = '0' and opa_SNaN = '0' and opb_SNaN = '0' and opb_QNaN = '0') then  -- true overflow
        overflow_trigger <= '1';
        if(rmode = "00") then           --round to nearest
          out_overflow <= in_except(31) & exp_255 & "000" & x"00000";
        elsif(rmode = "01") then        -- round to zero
          out_overflow <= in_except(31) & exp_254 & "111" & x"FFFFF";
        end if;
      elsif(unsigned(exponent_in) > "011111110" and (opa_QNaN = '1' or opa_SNaN = '1')) then  -- forced overflow due to Nan inputs
        overflow_trigger <= '1';
        out_overflow     <= opa(31) & exp_255 & '0' & opa(21 downto 0);
      elsif(unsigned(exponent_in) > "011111110" and (opb_QNaN = '1' or opb_SNaN = '1')) then
        overflow_trigger <= '1';
        out_overflow     <= opb(31) & exp_255 & '0' & opb(21 downto 0);  -- CARE UNDEFINED OUTPUT IF BOTH OP ARE NANS
      elsif(unsigned(exponent_in) <= "011111110") then
        overflow_trigger <= '0';
        out_overflow     <= (others => '0');
      end if;
    end if;
  end process;

  p_UnderflowFinder : process(clk, rst)
  begin
    if (rst = '1') then
      underflow_trigger <= '0';
    elsif (clk'event and clk = '1' and enable = '1') then
      underflow_trigger <= '0';
      --- list of events leading to overflow output
      if(unsigned(exponent_in) = "000000000") then
        underflow_trigger <= '1';
      end if;
    end if;
  end process;

  p_InexactFinder : process(clk, rst)
  begin
    if (rst = '1') then
      inexact_trigger <= '0';
    elsif (clk'event and clk = '1' and enable = '1') then
      inexact_trigger <= '0';
      if((or_reduce(mantissa_in(1 downto 0)) = '1' or overflow_trigger = '1' or underflow_trigger = '1') and opa_QNaN = '0' and opa_SNaN = '0' and opb_QNaN = '0' and opb_SNaN = '0') then
        inexact_trigger <= '1';
      end if;
    end if;
  end process;



  p_ExceptionOutputs : process(clk, rst)
  begin
    if (rst = '1') then
      ex_enable <= '0';
      underflow <= '0';
      overflow  <= '0';
      inexact   <= '0';
      exception <= '0';
      invalid   <= '0';
      out_fp    <= (others => '0');
    elsif (clk'event and clk = '1' and enable = '1') then
      underflow <= underflow_trigger;
      overflow  <= overflow_trigger;
      inexact   <= inexact_trigger;
      exception <= except_trigger;
      invalid   <= invalid_trigger;
      if(invalid_trigger = '1') then
        ex_enable <= '1';
        out_fp    <= out_invalid;
      elsif(overflow_trigger = '1') then
        ex_enable <= '1';
        out_fp    <= out_overflow;
      else
        out_fp    <= (others => '0');
        ex_enable <= '0';
      end if;
    end if;
  end process;

end rtl;
