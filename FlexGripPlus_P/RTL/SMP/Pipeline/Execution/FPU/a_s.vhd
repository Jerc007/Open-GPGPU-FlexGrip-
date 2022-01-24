library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
library work;
use work.gpgpu_package.all;

-- atomic block definition (adder_subtractor)
entity a_s is
  generic(NBITS : integer := 24);
  port (
    op_a : in  std_logic_vector (NBITS downto 0);
    op_m : in  std_logic_vector (NBITS downto 0);
    as   : in  std_logic;
    outp : out std_logic_vector (NBITS downto 0));
end a_s;

architecture a_s_cel_arch of a_s is

begin

  adder_subt : process (as, op_a, op_m)
  begin
    if as = '1' then
      outp <= std_logic_vector(unsigned(op_a) + unsigned(op_m));
    else
      outp <= std_logic_vector(unsigned(op_a) - unsigned(op_m));
    end if;
  end process;

end a_s_cel_arch;
