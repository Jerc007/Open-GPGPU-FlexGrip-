library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity add_sub is
    --generic(K: natural:= 64; P: natural:= 53; E: natural:= 11);
    generic(K: natural:= 32; P: natural:= 24; E: natural:= 8);
    Port ( FP_A : in  std_logic_vector (K-1 downto 0);
           FP_B : in  std_logic_vector (K-1 downto 0);
           add_sub: in std_logic;  			--resta con '0', suma con '1'.
           FP_Z : out  std_logic_vector (K-1 downto 0));
end add_sub;

architecture Behavioral of add_sub is
   function log2 (n : natural) return natural is
      variable a, m : natural;
   begin
      a := 0; m := 1;
      while m < n loop
         a := a + 1; m := m * 2;
      end loop;
      return a;
   end log2;
   constant PLOG : natural := log2(P+3) - 1;
   constant ZEROS : std_logic_vector(K-1 downto 0) := (others => '0');
   constant ONES : std_logic_vector(K-1 downto 0) := (others => '1');

   signal A_int : std_logic_vector(K-1 downto 0);
   signal B_int : std_logic_vector(K-1 downto 0);
   signal expA_FF, expB_FF, expA_Z, expB_Z : std_logic;
   signal fracA_Z, fracB_Z : std_logic;
   
   signal isNaN_A, isNaN_B, isInf_A, isInf_B, isZero_A, isZero_B, isNaN, isInf : std_logic;
   signal underflow_sub : std_logic;
   
   signal sign_A, sign_B : std_logic;
   signal exp_A, exp_B  : std_logic_vector(E-1 downto 0);
   
   signal efectExp: std_logic_vector(E downto 0); 
   
   signal efectFracA, efectFracB, efectFracB_align : std_logic_vector(P+3 downto 0);--P-1+1+3
   signal diffExpAB, diffExpBA, diffExp : std_logic_vector(E downto 0);
   signal addAB, addSubAB, subAB : std_logic_vector(P+3 downto 0);
   signal frac_add_Norm1    : std_logic_vector(P+3 downto 0);
   signal isSUB : std_logic;
      
   signal subBAExpEq : std_logic_vector(P+3 downto 0);
   signal frac_sub_Norm1 : std_logic_vector(P+3 downto 0);
   signal sign : std_logic;
   
   -- Component Declarations
   component right_shifter is
   generic (P: natural; E: natural; PLOG: natural);
   Port ( frac : in  std_logic_vector (P downto 0);
        diff_exp : in  std_logic_vector (E downto 0);
        frac_align : out  std_logic_vector (P downto 0));
   end component;
   
   component fp_leading_zeros_and_shift is
   generic (P: natural:= 27; E: natural := 8; PLOG: natural := 4);
   Port ( frac : in  std_logic_vector (P downto 0);
        exp	: in  std_logic_vector (E-1 downto 0);
        frac_Norm : out  std_logic_vector (P downto 0);
        exp_Norm : out  std_logic_vector (E-1 downto 0);
        underFlow : out std_logic);
   end component;
      
   signal isZero_AorB : std_logic;

   --signals for stage 2
   signal frac, frac_Norm1 : std_logic_vector (P+3 downto 0);
   signal frac_Norm2 : std_logic_vector (P-2 downto 0);
   signal frac_stg2 : std_logic_vector (P+3 downto 0);
   signal exp_Norm1, efectExp_stg2: std_logic_vector(E-1 downto 0);
   signal sign_stg2, isSUB_stg2, isNaN_stg2, isInf_stg2, overflow, underflow: std_logic;
   signal isZero_AorB_stg2: std_logic;
   signal isTwo : std_logic;
   signal exp_add_Norm1, exp_sub_Norm1 : std_logic_vector(E-1 downto 0);
   signal isRoundUp, didNorm1 : std_logic;
   signal FP_Z_int : std_logic_vector(K-1 downto 0);

begin

   A_int <= FP_A;
   B_int <= FP_B;

   --unpacking and detections
   expA_FF <= '1' when A_int(K-2 downto K-E-1)= ONES(K-2 downto K-E-1) else '0'; --In single (30..23)
   expB_FF <= '1' when B_int(K-2 downto K-E-1)= ONES(K-2 downto K-E-1) else '0';
   expA_Z <= '1' when A_int(K-2 downto K-E-1)= ZEROS(K-2 downto K-E-1) else '0';
   expB_Z <= '1' when B_int(K-2 downto K-E-1)= ZEROS(K-2 downto K-E-1) else '0';
   fracA_Z <= '1' when A_int(P-2 downto 0) = ZEROS(P-2 downto 0) else '0'; --In single (22..00)
   fracB_Z <= '1' when B_int(P-2 downto 0) = ZEROS(P-2 downto 0) else '0';

   isNaN_A <= expA_FF and (not fracA_Z);
   isNaN_B <= expB_FF and (not fracB_Z);
   isInf_A <= expA_FF; -- not compared the fractional part since NaN has priority.
   isInf_B <= expB_FF; -- 
   isZero_A <= expA_Z and fracA_Z;
   isZero_B <= expB_Z and fracB_Z;
   isZero_AorB <= isZero_A or isZero_B;
   
   --NaN Generacion del valor infinito.
   isNaN <= (isNaN_A or isNaN_B) or (isInf_A and isInf_B and isSUB); --NaN generation
   isInf <= (isInf_A xor isInf_B) or (isInf_A and isInf_B and (not isSUB)); --Infinite generation
   
   sign_A <= A_int(K-1); -- asignacion del valor de 32 bits.
   exp_A <= A_int(K-2 downto K-E-1); --in simple(30 .. 23);
   
   sign_B <= B_int(K-1) when add_sub='1' else not B_int(K-1); --establecimiento de bit de signo de operando B.
   exp_B <= B_int(K-2 downto K-E-1); --in simple(30 .. 23);
   
   isSUB <= sign_A XOR sign_B;
   
   diffExpAB <= ('0' & exp_A) - ('0' & exp_B); --one extra bit for sign
   diffExpBA <= ('0' & exp_B) - ('0' & exp_A);
   
   diffExp <= diffExpAB when diffExpAB(E)='0' else diffExpBA; --in binary32 E = 8;

   --swap
   efectFracA <= "01" & A_int(P-2 downto 0) & "000" when diffExpAB(E)='0' else "01" & B_int(P-2 downto 0) & "000";
   efectFracB <= "01" & B_int(P-2 downto 0) & "000" when diffExpAB(E)='0' else "01" & A_int(P-2 downto 0) & "000";
   efectExp <= '0' & exp_A when diffExpAB(E)='0' else '0' & exp_B;
   --in efectFracA, the number with bigger exponent, In efectFracB, nro with lower exp --> alignment needed
   --end swap
   
   --Effective alignment
   unioa: right_shifter generic map (P => P+3, E => E, PLOG => PLOG)
							port map( frac => efectFracB, diff_exp => diffExp, frac_align => efectFracB_align);
   
    
   --Addition / subtraction 
   addAB <= efectFracA + efectFracB_align;
   subAB <= efectFracA - efectFracB_align;
   addSubAB <= addAB when isSUB = '0' else subAB ;
    
   --subtraction without alignment (equal exponents); no swap was done
   subBAExpEq <= (("01" & B_int(P-2 downto 0)) - ("01" & A_int(P-2 downto 0))) & "000";
      
   --selection of correct fractional (significand) result
   frac <= "01" & B_int(P-2 downto 0) & "000" when isZero_A='1' else
           "01" & A_int(P-2 downto 0) & "000" when isZero_B='1' else
         subBAExpEq when subBAExpEq(P+3) = '0' and exp_A = exp_B and isSUB = '1' else
         addSubAB;
         
   --sign computation
   sign <= sign_A when sign_A = sign_B else
         sign_B when diffExpAB(E)='1' else
         sign_A when addSubAB(P+3)='0' else sign_B;
   
   -- isSpecialCase <= isZero_A or isZero_B or isNan or isInf;
   
   -- second stage: Norm1, Round And Norm2
   frac_stg2 <= frac;
   efectExp_stg2 <= efectExp(E-1 downto 0);
   isZero_AorB_stg2 <= isZero_AorB;
   isNaN_stg2 <= isNaN;
   isInf_stg2 <= isInf;
   sign_stg2 <= sign;
   isSUB_stg2 <= isSUB;

   
   -- Establecimiento de criterios de normalizacion.
   
   --para sumas:
   addition_norm: process(frac_stg2)
   begin
      if (frac_stg2(P+3)='1') then
         frac_add_Norm1 <= '0' & frac_stg2(P+3 downto 2)&(frac_stg2(1) or frac_stg2(0));
         didNorm1 <= '1';
      else
         frac_add_Norm1 <= frac_stg2;
         didNorm1 <= '0';
      end if;
   end process;
      
   isTwo <= '1' when (frac_stg2(P+2 downto 2)= ONES(P+2 downto 2)) else '0'; --only could happen in addition
   exp_add_Norm1 <= efectExp_stg2 + (didNorm1 or isTwo);
   
   --para resta:
   subtraction_norm: fp_leading_zeros_and_shift
   generic map(P => P+3, E => E, PLOG => PLOG)
   port map(
      frac       => frac_stg2,
      exp        => efectExp_stg2,
      frac_Norm  => frac_sub_Norm1,
      exp_Norm   => exp_sub_Norm1,
      underFlow  => underflow_sub
   );
      
   --seleccion entre suma resta:
   frac_Norm1 <= frac_add_Norm1 when isSUB_stg2 = '0' else frac_sub_Norm1;
   exp_Norm1 <= exp_add_Norm1(E-1 downto 0)  when isSUB_stg2 = '0' else exp_sub_Norm1(E-1 downto 0);
   
      
   --aplicacion de criterios de redondeo, criterio de aprox al par. 
   isRoundUp <= '1' when ( (frac_Norm1(2) = '1' and (frac_Norm1(1) = '1' or frac_Norm1(0) = '1')) or frac_Norm1(3 downto 0)="1100") else '0';
   frac_Norm2 <= frac_Norm1(P+1 downto 3) + isRoundUp;
   
   --seguda normalizacion.
   --It´s only necessary for the case 01.111...1111 (almost 2). This is catched with isTwo and round up.

   --overflow, underflow detection
   overflow <= '1' when (exp_Norm1 = ONES(E-1 downto 0) and (isSUB_stg2 = '0')) else '0';
   underflow <= underflow_sub when isSUB_stg2 = '1' else '0';
                        
   --pack
   FP_Z_int <= sign_stg2 & ONES(E-1 downto 0) & ZEROS(P-2 downto 1) & '1' when isNaN_stg2='1' else
               sign_stg2 & ONES(E-1 downto 0) & ZEROS(P-2 downto 0) when (isInf_stg2='1' or overflow = '1') else
               sign_stg2 & efectExp_stg2(E-1 downto 0) & frac_stg2(P+1 downto 3) when isZero_AorB_stg2 = '1' else
               sign_stg2 & ZEROS(K-2 downto 0) when underflow='1' else --if underflow => to zero.
               sign_stg2 & exp_Norm1 & frac_Norm2;
                     
   -- asignacion de salida.
            FP_Z <= FP_Z_int;
   
end Behavioral;