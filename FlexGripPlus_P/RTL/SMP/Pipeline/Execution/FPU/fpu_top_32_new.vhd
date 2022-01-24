library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
library work;
use work.gpgpu_package.all;

entity fpu_single is

  port(
    clk, rst, enable                                 : in  std_logic;
    rmode                                            : in  std_logic_vector (1 downto 0);
    S32                                              : in  std_logic;
    abs_en                                           : in  std_logic;
    set_cond_in                                      : in std_logic_vector(2 downto 0);
    fpu_opcode_in                                    : in  fpu_opcode_type;
    fpu_subopcode_in                                 : in  std_logic_vector(2 downto 0);
    src1_in, src2_in, src3_in                        : in  std_logic_vector (31 downto 0);
    src1_neg_in, src2_neg_in, src3_neg_in            : in  std_logic;
    out_fp                                           : out std_logic_vector (31 downto 0);
    stall_in                                         : in  std_logic;  -- tell if the next stage accepts outputs
    finished                                         : out std_logic;
    underflow, overflow, inexact, exception, invalid : out std_logic
    );

end fpu_single;

architecture arch of fpu_single is
  type fpu_state_type is (IDLE, GRAB, SET, WORK, DONE);
  signal fpu_state_machine                  : fpu_state_type;
  type fpu_work_type is (ADD, SUB, MUL, FMA, CONV, COMP, RCP);
  signal workload                           : fpu_work_type;
  -- sources and parameters
  signal fpu_op_reg                         : fpu_opcode_type;
  signal fpu_subop_reg                      : std_logic_vector(2 downto 0);
  signal opa_reg                            : std_logic_vector(31 downto 0);
  signal opb_reg                            : std_logic_vector(31 downto 0);
  signal opc_reg                            : std_logic_vector(31 downto 0);
  signal opa_neg_reg                        : std_logic_vector(31 downto 0);
  signal opb_neg_reg                        : std_logic_vector(31 downto 0);
  signal opc_neg_reg                        : std_logic_vector(31 downto 0);
  signal opa_true_reg                       : std_logic_vector(31 downto 0);
  signal opb_true_reg                       : std_logic_vector(31 downto 0);
  signal opc_true_reg                       : std_logic_vector(31 downto 0);
  signal rmode_reg                          : std_logic_vector(1 downto 0);
  signal src1_neg_i                         : std_logic;
  signal src2_neg_i                         : std_logic;
  signal src3_neg_i                         : std_logic;
  signal set_cond_i                         : std_logic_vector(2 downto 0);
  -- internal control
  signal add_enable                         : std_logic;
  signal sub_enable                         : std_logic;
  signal mul_enable                         : std_logic;
  signal fma_enable                         : std_logic;
  signal conv_enable                        : std_logic;
  signal set_enable                         : std_logic;
  signal rcp_enable                         : std_logic;
  signal convmode                           : fpu_conv_type;
  signal S32_i                              : std_logic;
  signal except_enabled                     : std_logic;
  signal op_enable                          : std_logic;
  signal count_cycles                       : std_logic_vector(6 downto 0);
  signal count_ready                        : std_logic_vector(6 downto 0);
  signal done_0, done_1                     : std_logic;
  signal set_0                              : std_logic;
  signal rst_add, rst_sub, rst_mul, rst_fma : std_logic;
  signal rst_conv, rst_round, rst_except    : std_logic;
  signal rst_rcp                            : std_logic;
  signal first_reset                        : std_logic;
  --data paths internal
  signal sum_out                            : std_logic_vector(26 downto 0);
  signal diff_out                           : std_logic_vector(26 downto 0);
  signal mul_out                            : std_logic_vector(26 downto 0);
  signal fma_out                            : std_logic_vector(26 downto 0);
  signal rcp_out                            : std_logic_vector(26 downto 0);
  signal mantissa_round                     : std_logic_vector(26 downto 0);
  signal exp_add_out                        : std_logic_vector(7 downto 0);
  signal exp_sub_out                        : std_logic_vector(7 downto 0);
  signal exp_mul_out                        : std_logic_vector(8 downto 0);
  signal exp_fma_out                        : std_logic_vector(8 downto 0);
  signal exp_rcp_out                        : std_logic_vector(8 downto 0);
  signal exponent_round                     : std_logic_vector(8 downto 0);
  signal exponent_post_round                : std_logic_vector(8 downto 0);
  signal add_sign                           : std_logic;
  signal sub_sign                           : std_logic;
  signal mul_sign                           : std_logic;
  signal fma_sign                           : std_logic;
  signal rcp_sign                           : std_logic;
  signal round_sign                         : std_logic;
  signal underflow_0                        : std_logic;
  signal overflow_0                         : std_logic;
  signal inexact_0                          : std_logic;
  signal exception_0                        : std_logic;
  signal invalid_0                          : std_logic;
  signal out_round                          : std_logic_vector(31 downto 0);
  signal out_except                         : std_logic_vector(31 downto 0);
  signal out_conv_int                       : std_logic_vector(31 downto 0);
  signal out_conv_float                     : std_logic_vector(31 downto 0);
  signal out_set                            : std_logic_vector(31 downto 0);
  signal out_fp_i                           : std_logic_vector(31 downto 0);
begin
  -- instanciation
  i_fpu_add : fpu_add
    port map (
      clk  => clk, rst => rst_add, enable => add_enable, opa => opa_true_reg, opb => opb_true_reg,
      sign => add_sign, sum_3 => sum_out, exponent_2 => exp_add_out);

  i_fpu_sub : fpu_sub
    port map (
      clk        => clk, rst => rst_sub, enable => sub_enable, opa => opa_true_reg, opb => opb_true_reg,
      sign       => sub_sign, diff_2 => diff_out,
      exponent_2 => exp_sub_out);

  i_fpu_mul : fpu_mul
    port map (
      clk  => clk, rst => rst_mul, enable => mul_enable, opa => opa_true_reg, opb => opb_true_reg,
      sign => mul_sign, product_7 => mul_out, exponent_5 => exp_mul_out);

  i_fpu_fma : fpu_fma
    port map(clk  => clk, rst => rst_fma, enable => fma_enable, opa => opa_true_reg, opb => opb_true_reg, opc => opc_true_reg,
             sign => fma_sign, mantissa => fma_out, exponent => exp_fma_out);

  i_fpu_round : fpu_round
    port map (
      clk       => clk, rst => rst_round, enable => op_enable, round_mode => rmode_reg,
      sign_term => round_sign, mantissa_term => mantissa_round, exponent_term => exponent_round,
      round_out => out_round, exponent_final => exponent_post_round);

  i_fpu_exceptions : fpu_exceptions
    port map (
      clk         => clk, rst => rst_except, enable => op_enable, rmode => rmode_reg,
      opa         => opa_true_reg, opb => opb_true_reg, opc => opc_true_reg,
      in_except   => out_round, exponent_in => exponent_post_round,
      mantissa_in => mantissa_round(1 downto 0), fpu_op => fpu_op_reg, out_fp => out_except,
      ex_enable   => except_enabled, underflow => underflow_0, overflow => overflow_0,
      inexact     => inexact_0, exception => exception_0, invalid => invalid_0);

  i_fpu_conv : fpu_conv
    port map(
      clk    => clk, rst => rst_conv, enable => conv_enable, convmode => convmode,
      int_in => opa_true_reg, float_in => opa_true_reg, int_out => out_conv_int, float_out => out_conv_float
      );
  i_fpu_set : fpu_set
    port map(
    clk => clk, rst => rst,
    enable => set_enable, opa => opa_true_reg, opb => opb_true_reg, set_cond_in => set_cond_i, abs_en => abs_en,
    result_out => out_set
    );
  i_fpu_rcp : fpu_rcp
    port map(
      clk   => clk, rst  => rst_rcp, enable => rcp_enable,
      FP_IN => opa_true_reg,
      sign => rcp_sign, exponent => exp_rcp_out, mantissa => rcp_out
    );


    p_FPU_FSM : process(clk, rst, enable)
    begin
      if(rst = '1') then
        fpu_state_machine <= IDLE;
        fpu_op_reg        <= UNKNOWN;
        opa_reg           <= (others => '0');
        opb_reg           <= (others => '0');
        opc_reg           <= (others => '0');
        opa_neg_reg       <= (others => '0');
        opb_neg_reg       <= (others => '0');
        opc_neg_reg       <= (others => '0');
        opa_true_reg      <= (others => '0');
        opb_true_reg      <= (others => '0');
        opc_true_reg      <= (others => '0');
        rmode_reg         <= (others => '0');
        src1_neg_i        <= '0';
        src2_neg_i        <= '0';
        src3_neg_i        <= '0';
        add_enable        <= '0';
        sub_enable        <= '0';
        mul_enable        <= '0';
        fma_enable        <= '0';
        rcp_enable        <= '0';
        conv_enable       <= '0';
        op_enable         <= '0';
        count_cycles      <= (others => '0');
        count_ready       <= (others => '0');
        done_0            <= '0';
        done_1            <= '0';
        finished          <= '0';
        out_fp_i          <= (others => '0');
        underflow         <= '0';
        overflow          <= '0';
        inexact           <= '0';
        exception         <= '0';
        invalid           <= '0';
        set_0             <= '0';
        rst_add           <= '1';
        rst_sub           <= '1';
        rst_mul           <= '1';
        rst_fma           <= '1';
        rst_rcp           <= '1';
        rst_conv          <= '1';
        rst_except        <= '1';
        rst_round         <= '1';
      elsif(clk'event and clk = '1') then
        if(enable = '1') then
          rst_add     <= '0';
          rst_sub     <= '0';
          rst_mul     <= '0';
          rst_fma     <= '0';
          rst_rcp     <= '0';
          rst_conv    <= '0';
          rst_except  <= '0';
          rst_round   <= '0';
          first_reset <= '0';
          case fpu_state_machine is
            when IDLE =>
              fpu_op_reg   <= UNKNOWN;
              opa_reg      <= (others => '0');
              opb_reg      <= (others => '0');
              opc_reg      <= (others => '0');
              opa_neg_reg  <= (others => '0');
              opb_neg_reg  <= (others => '0');
              opc_neg_reg  <= (others => '0');
              opa_true_reg <= (others => '0');
              opb_true_reg <= (others => '0');
              opc_true_reg <= (others => '0');
              rmode_reg    <= (others => '0');
              S32_i        <= '0';
              src1_neg_i   <= '0';
              src2_neg_i   <= '0';
              src3_neg_i   <= '0';
              add_enable   <= '0';
              sub_enable   <= '0';
              mul_enable   <= '0';
              fma_enable   <= '0';
              rcp_enable   <= '0';
              conv_enable  <= '0';
              set_enable   <= '0';
              op_enable    <= '0';
              count_cycles <= (others => '0');
              count_ready  <= (others => '0');
              done_0       <= '0';
              done_1       <= '0';
              finished     <= '0';
              out_fp_i     <= (others => '0');
              set_0        <= '0';
              if (first_reset = '0') then   --saving energy
                rst_add    <= '1';
                rst_sub    <= '1';
                rst_mul    <= '1';
                rst_fma    <= '1';
                rst_rcp    <= '1';
                rst_conv   <= '1';
                rst_except <= '1';
                rst_round  <= '1';
              end if;
              first_reset <= '1';
              if (enable = '1') then        -- start the FPU
                fpu_state_machine <= GRAB;
              end if;
            when GRAB =>
              -- get operands
              fpu_op_reg    <= fpu_opcode_in;
              fpu_subop_reg <= fpu_subopcode_in;
              opa_reg       <= src1_in;
              opb_reg       <= src2_in;
              opa_neg_reg   <= ((not src1_in(31)) & src1_in(30 downto 0));
              opb_neg_reg   <= ((not src2_in(31)) & src2_in(30 downto 0));
              src1_neg_i    <= src1_neg_in;
              src2_neg_i    <= src2_neg_in;
              if(fpu_opcode_in = FMAD) then
                opc_reg     <= src3_in;
                opc_neg_reg <= ((not src3_in(31)) & src3_in(30 downto 0));
                src3_neg_i  <= src3_neg_in;
              end if;
              rmode_reg         <= rmode;
              S32_i             <= S32;
              set_cond_i        <= set_cond_in;
              fpu_state_machine <= SET;
            when SET =>
              -- set the good operand according to options given
              if(src1_neg_i = '1') then
                opa_true_reg <= opa_neg_reg;
              else
                opa_true_reg <= opa_reg;
              end if;
              if(src2_neg_i = '1') then
                opb_true_reg <= opb_neg_reg;
              else
                opb_true_reg <= opb_reg;
              end if;
              if(src3_neg_i = '1') then
                opc_true_reg <= opc_neg_reg;
              else
                opc_true_reg <= opc_reg;
              end if;

              op_enable <= '1';  -- enable round and except(disabled later for conv as not needed)
              -- choose block to enable, set counter and input for round
              if((fpu_op_reg = FADD) and (opa_true_reg(31) = '0' and opb_true_reg(31) = '0')) then  -- add
                workload     <= ADD;
                add_enable   <= '1';
                count_cycles <= "0001111";  -- 15
              elsif (fpu_op_reg = FADD and (opa_true_reg(31) = '1' or opb_true_reg(31) = '1')) then  -- sub because the compiler doesnt have a instruction for sub,
                workload     <= SUB;  --  it gives add and changes the options to put negative values
                sub_enable   <= '1';
                count_cycles <= "0010000";  -- 16
              elsif(fpu_op_reg = FMUL) then                   -- mul
                workload     <= MUL;
                mul_enable   <= '1';
                count_cycles <= "0010000";  -- 16
              elsif(fpu_op_reg = FMAD) then                   -- fma
                workload     <= FMA;
                fma_enable   <= '1';
                count_cycles <= "0010100";  -- 20
              elsif(fpu_op_reg = CONV) then                   -- conv
                op_enable    <= '0';   --disable rounding
                conv_enable  <= '1';
                workload     <= CONV;
                count_cycles <= "0000011";  -- 3
                if(fpu_subop_reg = "100") then                -- F2I
                  if(S32_i = '1') then
                    convmode <= F2S;
                  else
                    convmode <= F2U;
                  end if;
                elsif(fpu_subop_reg = "010") then             -- I2F
                  if(S32_i = '1') then
                    convmode <= S2F;
                  else
                    convmode <= U2F;
                  end if;
                elsif(fpu_subop_reg = "111") then             -- negate
                  convmode <= NEG;
                elsif (fpu_subop_reg = "110") then            -- transfer/ ABSO
                  if(abs_en = '1') then
                    convmode <= ABSO;
                  else
                    convmode <= TRSFR;
                  end if;
                end if;
              elsif(fpu_op_reg = FSET) then
                op_enable    <= '0';  --disable rounding
                workload     <= COMP;
                set_enable   <= '1';
                count_cycles <= "0000101";  -- 5
              elsif(fpu_op_reg = RCP) then
                workload     <= RCP;
                rcp_enable   <= '1';
                count_cycles <= "0001111";  -- 15
              end if;
              set_0 <= '1';                 -- 1 cycle delay
              if(set_0 = '1') then
                fpu_state_machine <= WORK;
              end if;
            when WORK =>
              -- waiting for the calculation to finish
              if(unsigned(count_ready) < unsigned(count_cycles)) then
                count_ready <= std_logic_vector(unsigned(count_ready) + "000001");
                case workload is
                  when ADD =>
                    exponent_round <= '0' & exp_add_out;
                    mantissa_round <= sum_out;
                    round_sign     <= add_sign;
                  when SUB =>
                    exponent_round <= '0' & exp_sub_out;
                    mantissa_round <= diff_out;
                    round_sign     <= sub_sign;
                  when MUL =>
                    exponent_round <= exp_mul_out;
                    mantissa_round <= mul_out;
                    round_sign     <= mul_sign;
                  when FMA =>
                    exponent_round <= exp_fma_out;
                    mantissa_round <= fma_out;
                    round_sign     <= fma_sign;
                  when RCP =>
                    exponent_round <= exp_rcp_out;
                    mantissa_round <= rcp_out;
                    round_sign    <= rcp_sign;
                  when CONV =>
                  when COMP =>
                -- nothing special to do with rounding
                end case;
              else
                fpu_state_machine <= DONE;
              end if;
            when DONE =>
              -- keep the output high for at least 1 cycle and until next stage isn't stalling
              done_0    <= '1';
              done_1    <= done_0 and (not stall_in);
              finished  <= done_0;
              underflow <= underflow_0;
              overflow  <= overflow_0;
              inexact   <= inexact_0;
              exception <= exception_0;
              invalid   <= invalid_0;
              if((fpu_op_reg = FADD or fpu_op_reg = FMUL or fpu_op_reg = FMAD or fpu_op_reg = RCP) and except_enabled = '1') then
                out_fp_i <= out_except;
              elsif((fpu_op_reg = FADD or fpu_op_reg = FMUL or fpu_op_reg = FMAD or fpu_op_reg = RCP) and except_enabled = '0') then
                out_fp_i <= out_round;
              elsif(fpu_op_reg = FSET) then
                out_fp_i <= out_set;
              elsif(convmode = F2S or convmode = F2U) then
                out_fp_i <= out_conv_int;
              elsif (convmode = U2F or convmode = S2F or convmode = TRSFR or convmode = NEG or convmode = ABSO) then
                out_fp_i <= out_conv_float;
              end if;
              first_reset <= '0';
              if(done_1 = '1') then
                fpu_state_machine <= IDLE;
              end if;
          end case;
        elsif(enable = '0') then  -- protect the FPU from cycling when the GPGPU is doing somthing else
          fpu_op_reg   <= UNKNOWN;
          opa_reg      <= (others => '0');
          opb_reg      <= (others => '0');
          opc_reg      <= (others => '0');
          opa_neg_reg  <= (others => '0');
          opb_neg_reg  <= (others => '0');
          opc_neg_reg  <= (others => '0');
          opa_true_reg <= (others => '0');
          opb_true_reg <= (others => '0');
          opc_true_reg <= (others => '0');
          rmode_reg    <= (others => '0');
          S32_i        <= '0';
          src1_neg_i   <= '0';
          src2_neg_i   <= '0';
          src3_neg_i   <= '0';
          add_enable   <= '0';
          sub_enable   <= '0';
          mul_enable   <= '0';
          fma_enable   <= '0';
          rcp_enable   <= '0';
          conv_enable  <= '0';
          op_enable    <= '0';
          count_cycles <= (others => '0');
          count_ready  <= (others => '0');
          done_0       <= '0';
          done_1       <= '0';
          finished     <= '0';
          out_fp_i     <= (others => '0');
          set_0        <= '0';
          if first_reset = '0' then         --saving energy
            rst_add    <= '1';
            rst_sub    <= '1';
            rst_mul    <= '1';
            rst_fma    <= '1';
            rst_rcp    <= '1';
            rst_conv   <= '1';
            rst_except <= '1';
            rst_round  <= '1';
          end if;
          first_reset       <= '1';
          fpu_state_machine <= IDLE;
        end if;
      end if;
    end process;
  out_fp <= out_fp_i;
end architecture;
