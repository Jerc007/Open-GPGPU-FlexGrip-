-------------------------------------------------------------------------
-- VHDL : dp_ram_syn.vhd
--   Component declarations for post-syn simulation of dp_ram
--
--------------------------------------------------------------------------
library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- predicate_registers
entity dp_ram_RAM_SIZE512_RAM_A_WIDTH9_RAM_D_WIDTH4_1 is
  port( ce, clk_a, rst_a : in std_logic;  
  		addr_a : in std_logic_vector (8 downto 0);  
  		din_a : in std_logic_vector (3 downto 0);  
  		we_a, clk_b, rst_b : in std_logic;  
  		addr_b : in std_logic_vector (8 downto 0);  
        din_b : in std_logic_vector (3 downto 0);  
        we_b : in std_logic;  
        dout_a, dout_b : out std_logic_vector (3 downto 0)
  );
end entity;

architecture dp_ram_syn_archi of dp_ram_RAM_SIZE512_RAM_A_WIDTH9_RAM_D_WIDTH4_1 is
	component dp_ram is
		generic(RAM_SIZE      : integer := 1024;
			    RAM_A_WIDTH   : integer := 10;
			    RAM_D_WIDTH   : integer := 8
	-- synthesis translate_off
	;
			    RAM_INIT_FILE : string  := "./dummy.mif"
		-- synthesis translate_on
		);
		port(
			ce     : in  std_logic;
			clk_a  : in  std_logic;
			rst_a  : in  std_logic;
			addr_a : in  std_logic_vector(RAM_A_WIDTH - 1 downto 0);
			din_a  : in  std_logic_vector(RAM_D_WIDTH - 1 downto 0);
			we_a   : in  std_logic;
			clk_b  : in  std_logic;
			rst_b  : in  std_logic;
			addr_b : in  std_logic_vector(RAM_A_WIDTH - 1 downto 0);
			din_b  : in  std_logic_vector(RAM_D_WIDTH - 1 downto 0);
			we_b   : in  std_logic;
			dout_a : out std_logic_vector(RAM_D_WIDTH - 1 downto 0);
			dout_b : out std_logic_vector(RAM_D_WIDTH - 1 downto 0)
		);
	end component;
begin
	dp_ram_inst : dp_ram generic map (
			RAM_SIZE => 512,
			RAM_A_WIDTH => 9,
			RAM_D_WIDTH => 4
		) port map(
			ce => ce,
			clk_a  => clk_a  , 
			rst_a  => rst_a  , 
			addr_a => addr_a , 
			din_a  => din_a  , 
			we_a   => we_a   , 
			clk_b  => clk_b  , 
			rst_b  => rst_b  , 
			addr_b => addr_b , 
			din_b  => din_b  , 
			we_b   => we_b   , 
			dout_a => dout_a , 
			dout_b => dout_b 
		);
end architecture dp_ram_syn_archi;
library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- address_register
entity dp_ram_RAM_SIZE512_RAM_A_WIDTH9_RAM_D_WIDTH32_1 is
  port( ce, clk_a, rst_a : in std_logic;  
  		addr_a : in std_logic_vector (8 downto 0);  
  		din_a : in std_logic_vector (3 downto 0);  
  		we_a, clk_b, rst_b : in std_logic;  
  		addr_b : in std_logic_vector (8 downto 0);  
        din_b : in std_logic_vector (3 downto 0);  
        we_b : in std_logic;  
        dout_a, dout_b : out std_logic_vector (3 downto 0)
  );
end entity;

architecture dp_ram_syn_archi of dp_ram_RAM_SIZE512_RAM_A_WIDTH9_RAM_D_WIDTH32_1 is
	component dp_ram is
		generic(RAM_SIZE      : integer := 1024;
			    RAM_A_WIDTH   : integer := 10;
			    RAM_D_WIDTH   : integer := 8
	-- synthesis translate_off
	;
			    RAM_INIT_FILE : string  := "./dummy.mif"
		-- synthesis translate_on
		);
		port(
			ce     : in  std_logic;
			clk_a  : in  std_logic;
			rst_a  : in  std_logic;
			addr_a : in  std_logic_vector(RAM_A_WIDTH - 1 downto 0);
			din_a  : in  std_logic_vector(RAM_D_WIDTH - 1 downto 0);
			we_a   : in  std_logic;
			clk_b  : in  std_logic;
			rst_b  : in  std_logic;
			addr_b : in  std_logic_vector(RAM_A_WIDTH - 1 downto 0);
			din_b  : in  std_logic_vector(RAM_D_WIDTH - 1 downto 0);
			we_b   : in  std_logic;
			dout_a : out std_logic_vector(RAM_D_WIDTH - 1 downto 0);
			dout_b : out std_logic_vector(RAM_D_WIDTH - 1 downto 0)
		);
	end component;
begin
	dp_ram_inst : dp_ram generic map (
			RAM_SIZE => 512,
			RAM_A_WIDTH => 9,
			RAM_D_WIDTH => 32
		) port map(
			ce => ce,
			clk_a  => clk_a  , 
			rst_a  => rst_a  , 
			addr_a => addr_a , 
			din_a  => din_a  , 
			we_a   => we_a   , 
			clk_b  => clk_b  , 
			rst_b  => rst_b  , 
			addr_b => addr_b , 
			din_b  => din_b  , 
			we_b   => we_b   , 
			dout_a => dout_a , 
			dout_b => dout_b 
		);
end architecture dp_ram_syn_archi;

library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- vector_registers
entity dp_ram_RAM_SIZE2048_RAM_A_WIDTH11_RAM_D_WIDTH32_1 is
  port( ce, clk_a, rst_a : in std_logic;  
  		addr_a : in std_logic_vector (8 downto 0);  
  		din_a : in std_logic_vector (3 downto 0);  
  		we_a, clk_b, rst_b : in std_logic;  
  		addr_b : in std_logic_vector (8 downto 0);  
        din_b : in std_logic_vector (3 downto 0);  
        we_b : in std_logic;  
        dout_a, dout_b : out std_logic_vector (3 downto 0)
  );
end entity;

architecture dp_ram_syn_archi of dp_ram_RAM_SIZE2048_RAM_A_WIDTH11_RAM_D_WIDTH32_1 is
	component dp_ram is
		generic(RAM_SIZE      : integer := 1024;
			    RAM_A_WIDTH   : integer := 10;
			    RAM_D_WIDTH   : integer := 8
	-- synthesis translate_off
	;
			    RAM_INIT_FILE : string  := "./dummy.mif"
		-- synthesis translate_on
		);
		port(
			ce     : in  std_logic;
			clk_a  : in  std_logic;
			rst_a  : in  std_logic;
			addr_a : in  std_logic_vector(RAM_A_WIDTH - 1 downto 0);
			din_a  : in  std_logic_vector(RAM_D_WIDTH - 1 downto 0);
			we_a   : in  std_logic;
			clk_b  : in  std_logic;
			rst_b  : in  std_logic;
			addr_b : in  std_logic_vector(RAM_A_WIDTH - 1 downto 0);
			din_b  : in  std_logic_vector(RAM_D_WIDTH - 1 downto 0);
			we_b   : in  std_logic;
			dout_a : out std_logic_vector(RAM_D_WIDTH - 1 downto 0);
			dout_b : out std_logic_vector(RAM_D_WIDTH - 1 downto 0)
		);
	end component;
begin
	dp_ram_inst : dp_ram generic map (
			RAM_SIZE => 2048,
			RAM_A_WIDTH => 11,
			RAM_D_WIDTH => 32
		) port map(
			ce => ce,
			clk_a  => clk_a  , 
			rst_a  => rst_a  , 
			addr_a => addr_a , 
			din_a  => din_a  , 
			we_a   => we_a   , 
			clk_b  => clk_b  , 
			rst_b  => rst_b  , 
			addr_b => addr_b , 
			din_b  => din_b  , 
			we_b   => we_b   , 
			dout_a => dout_a , 
			dout_b => dout_b 
		);
end architecture dp_ram_syn_archi;
library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity dp_ram_RAM_SIZE32_RAM_A_WIDTH5_RAM_D_WIDTH2_1 is
  port( ce, clk_a, rst_a : in std_logic;  
  		addr_a : in std_logic_vector (8 downto 0);  
  		din_a : in std_logic_vector (3 downto 0);  
  		we_a, clk_b, rst_b : in std_logic;  
  		addr_b : in std_logic_vector (8 downto 0);  
        din_b : in std_logic_vector (3 downto 0);  
        we_b : in std_logic;  
        dout_a, dout_b : out std_logic_vector (3 downto 0)
  );
end entity;

architecture dp_ram_syn_archi of dp_ram_RAM_SIZE32_RAM_A_WIDTH5_RAM_D_WIDTH2_1 is
	component dp_ram is
		generic(RAM_SIZE      : integer := 1024;
			    RAM_A_WIDTH   : integer := 10;
			    RAM_D_WIDTH   : integer := 8
	-- synthesis translate_off
	;
			    RAM_INIT_FILE : string  := "./dummy.mif"
		-- synthesis translate_on
		);
		port(
			ce     : in  std_logic;
			clk_a  : in  std_logic;
			rst_a  : in  std_logic;
			addr_a : in  std_logic_vector(RAM_A_WIDTH - 1 downto 0);
			din_a  : in  std_logic_vector(RAM_D_WIDTH - 1 downto 0);
			we_a   : in  std_logic;
			clk_b  : in  std_logic;
			rst_b  : in  std_logic;
			addr_b : in  std_logic_vector(RAM_A_WIDTH - 1 downto 0);
			din_b  : in  std_logic_vector(RAM_D_WIDTH - 1 downto 0);
			we_b   : in  std_logic;
			dout_a : out std_logic_vector(RAM_D_WIDTH - 1 downto 0);
			dout_b : out std_logic_vector(RAM_D_WIDTH - 1 downto 0)
		);
	end component;
begin
	dp_ram_inst : dp_ram generic map (
			RAM_SIZE => 32,
			RAM_A_WIDTH => 5,
			RAM_D_WIDTH => 2
		) port map(
			ce => ce,
			clk_a  => clk_a  , 
			rst_a  => rst_a  , 
			addr_a => addr_a , 
			din_a  => din_a  , 
			we_a   => we_a   , 
			clk_b  => clk_b  , 
			rst_b  => rst_b  , 
			addr_b => addr_b , 
			din_b  => din_b  , 
			we_b   => we_b   , 
			dout_a => dout_a , 
			dout_b => dout_b 
		);
end architecture dp_ram_syn_archi;
library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- system_memory_controller
entity dp_ram_RAM_SIZE512_RAM_A_WIDTH9_RAM_D_WIDTH8 is
  port( ce, clk_a, rst_a : in std_logic;  
  		addr_a : in std_logic_vector (8 downto 0);  
  		din_a : in std_logic_vector (3 downto 0);  
  		we_a, clk_b, rst_b : in std_logic;  
  		addr_b : in std_logic_vector (8 downto 0);  
        din_b : in std_logic_vector (3 downto 0);  
        we_b : in std_logic;  
        dout_a, dout_b : out std_logic_vector (3 downto 0)
  );
end entity;

architecture dp_ram_syn_archi of dp_ram_RAM_SIZE512_RAM_A_WIDTH9_RAM_D_WIDTH8 is
	component dp_ram is
		generic(RAM_SIZE      : integer := 1024;
			    RAM_A_WIDTH   : integer := 10;
			    RAM_D_WIDTH   : integer := 8
	-- synthesis translate_off
	;
			    RAM_INIT_FILE : string  := "./dummy.mif"
		-- synthesis translate_on
		);
		port(
			ce     : in  std_logic;
			clk_a  : in  std_logic;
			rst_a  : in  std_logic;
			addr_a : in  std_logic_vector(RAM_A_WIDTH - 1 downto 0);
			din_a  : in  std_logic_vector(RAM_D_WIDTH - 1 downto 0);
			we_a   : in  std_logic;
			clk_b  : in  std_logic;
			rst_b  : in  std_logic;
			addr_b : in  std_logic_vector(RAM_A_WIDTH - 1 downto 0);
			din_b  : in  std_logic_vector(RAM_D_WIDTH - 1 downto 0);
			we_b   : in  std_logic;
			dout_a : out std_logic_vector(RAM_D_WIDTH - 1 downto 0);
			dout_b : out std_logic_vector(RAM_D_WIDTH - 1 downto 0)
		);
	end component;
begin
	dp_ram_inst : dp_ram generic map (
			RAM_SIZE => 512,
			RAM_A_WIDTH => 9,
			RAM_D_WIDTH => 8
		) port map(
			ce => ce,
			clk_a  => clk_a  , 
			rst_a  => rst_a  , 
			addr_a => addr_a , 
			din_a  => din_a  , 
			we_a   => we_a   , 
			clk_b  => clk_b  , 
			rst_b  => rst_b  , 
			addr_b => addr_b , 
			din_b  => din_b  , 
			we_b   => we_b   , 
			dout_a => dout_a , 
			dout_b => dout_b 
		);
end architecture dp_ram_syn_archi;
library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- ?????
entity dp_ram_RAM_SIZE16384_RAM_A_WIDTH14_RAM_D_WIDTH8_1 is
  port( ce, clk_a, rst_a : in std_logic;  
  		addr_a : in std_logic_vector (8 downto 0);  
  		din_a : in std_logic_vector (3 downto 0);  
  		we_a, clk_b, rst_b : in std_logic;  
  		addr_b : in std_logic_vector (8 downto 0);  
        din_b : in std_logic_vector (3 downto 0);  
        we_b : in std_logic;  
        dout_a, dout_b : out std_logic_vector (3 downto 0)
  );
end entity;

architecture dp_ram_syn_archi of dp_ram_RAM_SIZE16384_RAM_A_WIDTH14_RAM_D_WIDTH8_1 is
	component dp_ram is
		generic(RAM_SIZE      : integer := 1024;
			    RAM_A_WIDTH   : integer := 10;
			    RAM_D_WIDTH   : integer := 8
	-- synthesis translate_off
	;
			    RAM_INIT_FILE : string  := "./dummy.mif"
		-- synthesis translate_on
		);
		port(
			ce     : in  std_logic;
			clk_a  : in  std_logic;
			rst_a  : in  std_logic;
			addr_a : in  std_logic_vector(RAM_A_WIDTH - 1 downto 0);
			din_a  : in  std_logic_vector(RAM_D_WIDTH - 1 downto 0);
			we_a   : in  std_logic;
			clk_b  : in  std_logic;
			rst_b  : in  std_logic;
			addr_b : in  std_logic_vector(RAM_A_WIDTH - 1 downto 0);
			din_b  : in  std_logic_vector(RAM_D_WIDTH - 1 downto 0);
			we_b   : in  std_logic;
			dout_a : out std_logic_vector(RAM_D_WIDTH - 1 downto 0);
			dout_b : out std_logic_vector(RAM_D_WIDTH - 1 downto 0)
		);
	end component;
begin
	dp_ram_inst : dp_ram generic map (
			RAM_SIZE => 16384,
			RAM_A_WIDTH => 14,
			RAM_D_WIDTH => 8
		) port map(
			ce => ce,
			clk_a  => clk_a  , 
			rst_a  => rst_a  , 
			addr_a => addr_a , 
			din_a  => din_a  , 
			we_a   => we_a   , 
			clk_b  => clk_b  , 
			rst_b  => rst_b  , 
			addr_b => addr_b , 
			din_b  => din_b  , 
			we_b   => we_b   , 
			dout_a => dout_a , 
			dout_b => dout_b 
		);
end architecture dp_ram_syn_archi;
library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- ?????
entity dp_ram_RAM_SIZE8192_RAM_A_WIDTH13_RAM_D_WIDTH8_1 is
  port( ce, clk_a, rst_a : in std_logic;  
  		addr_a : in std_logic_vector (8 downto 0);  
  		din_a : in std_logic_vector (3 downto 0);  
  		we_a, clk_b, rst_b : in std_logic;  
  		addr_b : in std_logic_vector (8 downto 0);  
        din_b : in std_logic_vector (3 downto 0);  
        we_b : in std_logic;  
        dout_a, dout_b : out std_logic_vector (3 downto 0)
  );
end entity;

architecture dp_ram_syn_archi of dp_ram_RAM_SIZE8192_RAM_A_WIDTH13_RAM_D_WIDTH8_1 is
	component dp_ram is
		generic(RAM_SIZE      : integer := 1024;
			    RAM_A_WIDTH   : integer := 10;
			    RAM_D_WIDTH   : integer := 8
	-- synthesis translate_off
	;
			    RAM_INIT_FILE : string  := "./dummy.mif"
		-- synthesis translate_on
		);
		port(
			ce     : in  std_logic;
			clk_a  : in  std_logic;
			rst_a  : in  std_logic;
			addr_a : in  std_logic_vector(RAM_A_WIDTH - 1 downto 0);
			din_a  : in  std_logic_vector(RAM_D_WIDTH - 1 downto 0);
			we_a   : in  std_logic;
			clk_b  : in  std_logic;
			rst_b  : in  std_logic;
			addr_b : in  std_logic_vector(RAM_A_WIDTH - 1 downto 0);
			din_b  : in  std_logic_vector(RAM_D_WIDTH - 1 downto 0);
			we_b   : in  std_logic;
			dout_a : out std_logic_vector(RAM_D_WIDTH - 1 downto 0);
			dout_b : out std_logic_vector(RAM_D_WIDTH - 1 downto 0)
		);
	end component;
begin
	dp_ram_inst : dp_ram generic map (
			RAM_SIZE => 8192,
			RAM_A_WIDTH => 13,
			RAM_D_WIDTH => 8,
		    RAM_INIT_FILE => "./constant_mem.mif" 
		) port map(
			ce => ce,
			clk_a  => clk_a  , 
			rst_a  => rst_a  , 
			addr_a => addr_a , 
			din_a  => din_a  , 
			we_a   => we_a   , 
			clk_b  => clk_b  , 
			rst_b  => rst_b  , 
			addr_b => addr_b , 
			din_b  => din_b  , 
			we_b   => we_b   , 
			dout_a => dout_a , 
			dout_b => dout_b 
		);
end architecture dp_ram_syn_archi;
library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- ?????
entity dp_ram_RAM_SIZE262144_RAM_A_WIDTH18_RAM_D_WIDTH8_1 is
  port( ce, clk_a, rst_a : in std_logic;  
  		addr_a : in std_logic_vector (8 downto 0);  
  		din_a : in std_logic_vector (3 downto 0);  
  		we_a, clk_b, rst_b : in std_logic;  
  		addr_b : in std_logic_vector (8 downto 0);  
        din_b : in std_logic_vector (3 downto 0);  
        we_b : in std_logic;  
        dout_a, dout_b : out std_logic_vector (3 downto 0)
  );
end entity;

architecture dp_ram_syn_archi of dp_ram_RAM_SIZE262144_RAM_A_WIDTH18_RAM_D_WIDTH8_1 is
	component dp_ram is
		generic(RAM_SIZE      : integer := 1024;
			    RAM_A_WIDTH   : integer := 10;
			    RAM_D_WIDTH   : integer := 8
	-- synthesis translate_off
	;
			    RAM_INIT_FILE : string  := "./dummy.mif"
		-- synthesis translate_on
		);
		port(
			ce     : in  std_logic;
			clk_a  : in  std_logic;
			rst_a  : in  std_logic;
			addr_a : in  std_logic_vector(RAM_A_WIDTH - 1 downto 0);
			din_a  : in  std_logic_vector(RAM_D_WIDTH - 1 downto 0);
			we_a   : in  std_logic;
			clk_b  : in  std_logic;
			rst_b  : in  std_logic;
			addr_b : in  std_logic_vector(RAM_A_WIDTH - 1 downto 0);
			din_b  : in  std_logic_vector(RAM_D_WIDTH - 1 downto 0);
			we_b   : in  std_logic;
			dout_a : out std_logic_vector(RAM_D_WIDTH - 1 downto 0);
			dout_b : out std_logic_vector(RAM_D_WIDTH - 1 downto 0)
		);
	end component;
begin
	dp_ram_inst : dp_ram generic map (
			RAM_SIZE => 262144,
			RAM_A_WIDTH => 18,
			RAM_D_WIDTH => 8,
			RAM_INIT_FILE => "./global_mem.mif" 

		) port map(
			ce => ce,
			clk_a  => clk_a  , 
			rst_a  => rst_a  , 
			addr_a => addr_a , 
			din_a  => din_a  , 
			we_a   => we_a   , 
			clk_b  => clk_b  , 
			rst_b  => rst_b  , 
			addr_b => addr_b , 
			din_b  => din_b  , 
			we_b   => we_b   , 
			dout_a => dout_a , 
			dout_b => dout_b 
		);
end architecture dp_ram_syn_archi;