
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

package pick_bench is

    type cmem_regs_type   is array (63 downto 0) of std_logic_vector(7 downto 0);
    type kernel_regs_type is array (15 downto 0) of std_logic_vector(31 downto 0);

    constant BENCH_CORES      : integer := 8;
    constant BENCH_WARP_LANES : integer := 4; -- WARP_SIZE/BENCH_CORES. WARP_SIZE is fixed by hardware constraints

    constant BENCH_APP      : string := "TP";
    constant BENCH_APP_INST : string := "TP";

    -- block dimensions (not changeable at runtime)
    constant BENCH_K_BLKX : std_logic_vector(15 downto 0) := x"0020";
    constant BENCH_K_BLKY : std_logic_vector(15 downto 0) := x"0001";
    constant BENCH_K_BLKZ : std_logic_vector(15 downto 0) := x"0001";

    -- number of total blocks in the grid
    constant BENCH_K_GRDX : std_logic_vector(15 downto 0) := x"0001";
    constant BENCH_K_GRDY : std_logic_vector(15 downto 0) := x"0001";

    constant BENCH_CMEM_PARAM_SIZE   : std_logic_vector(5 downto 0)  :=  "100000";    -- 32  
    constant BENCH_KERNEL_PARAM_SIZE : std_logic_vector(3 downto 0)  :=  x"4";      
    constant BENCH_KERNEL_GPRS       : std_logic_vector(8 downto 0)  :=  "000000101"; -- 5 
    constant BENCH_KERNEL_SHMEM_SIZE : std_logic_vector(31 downto 0) :=  x"0000002c"; -- 44
    constant BENCH_BLOCKS_PER_CORE   : std_logic_vector(3 downto 0)  :=  x"8"; 

    constant BENCH_DYN_SHMEM_SIZE : std_logic_vector(31 downto 0) :=  x"0000002c"; -- 44

--  constant BENCH_CMEM_PARAM_SIZE          : std_logic_vector(5 downto 0)  :=  "000100";
--  constant BENCH_KERNEL_GPRS              : std_logic_vector(8 downto 0)  :=  "000001011";
		
    -- used by old benchmarks
    constant BENCH_KREG0: std_logic_vector(31 downto 0) := x"00000000";			-- Fixed for the 1024 case
    constant BENCH_KREG1: std_logic_vector(31 downto 0) := x"00002000";
    constant BENCH_KREG2: std_logic_vector(31 downto 0) := x"00004000";
    constant BENCH_KREG3: std_logic_vector(31 downto 0) := x"00000040";
    constant BENCH_KREG4: std_logic_vector(31 downto 0) := x"00000000";			-- Fixed for the 1024 case
    constant BENCH_KREG5: std_logic_vector(31 downto 0) := x"00001000";
    constant BENCH_KREG6: std_logic_vector(31 downto 0) := x"00002000";
    constant BENCH_KREG7: std_logic_vector(31 downto 0) := x"00000040";
    constant BENCH_KREG8: std_logic_vector(31 downto 0) := x"00000000";			-- Fixed for the 1024 case
    constant BENCH_KREG9: std_logic_vector(31 downto 0) := x"00001000";
    constant BENCH_KREG10: std_logic_vector(31 downto 0) := x"00002000";
    constant BENCH_KREG11: std_logic_vector(31 downto 0) := x"00000040";
	constant BENCH_KREG12: std_logic_vector(31 downto 0) := x"00000040";
	constant BENCH_KREG13: std_logic_vector(31 downto 0) := x"00000040";
	constant BENCH_KREG14: std_logic_vector(31 downto 0) := x"00000040";
	constant BENCH_KREG15: std_logic_vector(31 downto 0) := x"00000040";
	

 --   constant READ_DATA_SIZE : std_logic_vector(17 downto 0) := "000000100000100000";	
	
    -- used by old benchmarks
    constant BENCH_CMEMREG0 : std_logic_vector(7 downto 0) := x"ff";
    constant BENCH_CMEMREG1 : std_logic_vector(7 downto 0) := x"03";
    constant BENCH_CMEMREG2 : std_logic_vector(7 downto 0) := x"ff";
    constant BENCH_CMEMREG3 : std_logic_vector(7 downto 0) := x"03";

    constant cmem_regs_default : cmem_regs_type := ( -- 63(3F)
        x"00", x"00", x"00", x"00",                  -- 60
        x"00", x"00", x"00", x"00",                  -- 56
        x"00", x"00", x"00", x"00",                  -- 52
        x"00", x"00", x"00", x"00",                  -- 48
        x"00", x"00", x"00", x"00",                  -- 44
        x"00", x"00", x"00", x"00",                  -- 40
        x"00", x"00", x"00", x"00",                  -- 36
        x"00", x"00", x"00", x"00",                  -- 32
        x"00", x"00", x"00", x"00",                  -- 28
        x"00", x"00", x"00", x"00",                  -- 24
        x"00", x"00", x"00", x"00",                  -- 20
        x"00", x"00", x"00", x"00",                  -- 16
        x"00", x"00", x"00", x"00",                  -- 12       
        x"00", x"00", x"04", x"00",                  -- 8     
        x"00", x"00", x"00", x"ff",                  -- 4     
        x"00", x"00", x"03", x"ff");                 -- 0                                         

    -- ORIGINAL FOR TP:
    -- x"03", x"ff", x"03", x"ff"

    constant kernel_regs_default : kernel_regs_type := (     -- 15 (0F)
        x"00000000", x"00000000", x"00000000", x"00000000",  -- 12 
        x"00000000", x"00000000", x"00000000", x"00000000",  -- 8
        x"00000000", x"00000000", x"00000000", x"00000000",  -- 4
        x"00000010", x"00000010", x"00000300", x"00000000"); -- 0                   
    
    -- ORIGINAL FOR OLD BENCHMARKS:
    -- addr 0: start address of data_a (x"00000000") 
    -- addr 1: start address of data_b (x"00000100")
    -- addr 2: start address of data_c (x"00000200")
    -- addr 3: dimension               (x"00000008") 

    -- ORIGINAL FOR OLD BENCHMARKS: 2080
    constant READ_DATA_SIZE : std_logic_vector(17 downto 0) := std_logic_vector(to_unsigned(3073, 18));

end pick_bench;


