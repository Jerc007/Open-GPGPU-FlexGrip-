library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
library work;
use work.gpgpu_package.all;

-- mantissa divisor block definition
entity div_nr_wsticky is
  generic(NBITS : integer := 24; PBITS : integer := 27);
  port (
    A      : in  std_logic_vector(NBITS-1 downto 0);
    B      : in  std_logic_vector(NBITS-1 downto 0);
    Q      : out std_logic_vector(PBITS-1 downto 0);
    sticky : out std_logic
    );
end div_nr_wsticky;

architecture div_arch of div_nr_wsticky is

  component a_s is
    generic(NBITS : integer);
    port (
      op_a : in  std_logic_vector (NBITS downto 0);
      op_m : in  std_logic_vector (NBITS downto 0);
      as   : in  std_logic;
      outp : out std_logic_vector (NBITS downto 0)
      );
  end component;

  constant ZEROS : std_logic_vector (NBITS-1 downto 0) := (others => '0');
  type matrizconexion is array (0 to PBITS) of std_logic_vector (NBITS downto 0);
  type matrizconexion_P is array (0 to PBITS) of std_logic_vector (PBITS-1 downto 0);

  signal YY_in                   : matrizconexion;
  signal QQ_in                   : matrizconexion_P;
  signal m_cablesIn, m_cablesOut : matrizconexion;

  signal a_or_s : std_logic_vector (PBITS downto 0);
  signal QQ     : std_logic_vector (PBITS-1 downto 0);
  signal YY, XX : std_logic_vector (NBITS-1 downto 0);

begin

  XX <= A;
  YY <= B;
  Q  <= QQ;

  a_or_s(0)     <= '0';
  m_cablesIn(0) <= '0' & XX;
  YY_IN(0)      <= '0' & YY;

  divisor : for I in 0 to PBITS-1 generate
    int_mod : a_s generic map(NBITS => NBITS)
      port map (op_a => m_cablesIn(i), op_m => YY_IN(i),
                as   => a_or_s(i), outp => m_cablesOut(i));
  end generate;

  -- cable connections
  conex : for I in 0 to PBITS-1 generate
    a_or_s(i+1)                                       <= m_cablesOut(i)(NBITS);
    m_cablesIn(i+1)                                   <= m_cablesOut(i)(NBITS-1 downto 0) & '0';
    YY_IN(i+1)                                        <= YY_IN(i);
    QQ_in(i+1)(i)                                     <= a_or_s(i+1);
    rest : if I > 0 generate QQ_in(i+1)(I-1 downto 0) <= QQ_in(i)(I-1 downto 0); end generate;
  end generate;

  quotient : for I in 0 to PBITS-1 generate
    QQ(I) <= not QQ_in(PBITS)(PBITS-1-I);
  end generate;

  sticky <= '0' when m_cablesOut(PBITS-1) = ZEROS else '1'; -- potential issue, done by original designer

end div_arch;
