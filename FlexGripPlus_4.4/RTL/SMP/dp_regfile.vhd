-------------------------------------------------------------------------
-- VHDL : dp_ram.vhd
--   Generic Dual Port RAM
--   Fix Configuration:
--		1. Seperated Clocks
--		2. No confliction checks
--		3. Out of boundary read generates Xs
--		[WARNING] Read after write logic is not verified
-- 		[TODO]
--
--------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dp_regfile is
	generic(RAM_SIZE      : integer := 1024;
		    RAM_A_WIDTH   : integer := 10;			-- 10 for warp syn sim
		    RAM_D_WIDTH   : integer := 8			-- 8
	);
	port(
		clk  : in  std_logic;
		rst  : in  std_logic;
		addr_a : in  std_logic_vector(RAM_A_WIDTH - 1 downto 0);
		din_a  : in  std_logic_vector(RAM_D_WIDTH - 1 downto 0);
		we_a   : in  std_logic;
		addr_b : in  std_logic_vector(RAM_A_WIDTH - 1 downto 0);
		din_b  : in  std_logic_vector(RAM_D_WIDTH - 1 downto 0);
		we_b   : in  std_logic;
		dout_a : out std_logic_vector(RAM_D_WIDTH - 1 downto 0);
		dout_b : out std_logic_vector(RAM_D_WIDTH - 1 downto 0)
	);
end entity dp_regfile;

architecture dp_regfile_archi of dp_regfile is
	type mem_type is array (0 to RAM_SIZE - 1) of std_logic_vector(RAM_D_WIDTH - 1 downto 0);

    signal mem : mem_type := ( others=>(others=>'0') );
begin
	-- MEM WRITE PROCESS
	write_proc : process(rst, clk)
	begin
		if(rst = '1') then
			null;
		elsif rising_edge(clk) then
			if(we_a = '1') then
				if(to_integer(unsigned(addr_a)) >= RAM_SIZE) then
					null;
				else
					mem(to_integer(unsigned(addr_a))) <= din_a;
				end if;
			end if;

            if(we_b = '1') then
                if(to_integer(unsigned(addr_b)) >= RAM_SIZE) then
					null;
				else
					mem(to_integer(unsigned(addr_b))) <= din_b;
				end if;
            end if;
		end if;
	end process write_proc;

	dout_a <= (others => 'X') when to_integer(unsigned(addr_a)) >= RAM_SIZE  -- X
		else din_b when we_b = '1' and addr_a = addr_b
		else mem(to_integer(unsigned(addr_a))) when we_a /= '1'
		else din_a;

	dout_b <= (others => 'X') when to_integer(unsigned(addr_b)) >= RAM_SIZE			-- X en vez de 0
		else din_a when we_a = '1' and addr_a = addr_b
		else mem(to_integer(unsigned(addr_b))) when we_b /= '1'
		else din_b;

end architecture dp_regfile_archi;
