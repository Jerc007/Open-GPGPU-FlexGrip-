
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.gpgpu_package.all;
use work.pick_bench.all;

entity TP_configuration is
	port(	
		clk                   : in  std_logic;
		reset                 : in  std_logic;
		reset_registers       : in  std_logic;
		cmem_reg_cs           : in  std_logic;
		cmem_reg_rw           : in  std_logic;
		cmem_reg_adr          : in  std_logic_vector(5 downto 0);
		cmem_reg_data_in      : in  std_logic_vector(7 downto 0);
		cmem_reg_data_out     : out std_logic_vector(7 downto 0);
		kernel_reg_cs         : in  std_logic;
		kernel_reg_rw         : in  std_logic;
		kernel_reg_adr        : in  std_logic_vector(3 downto 0);
		kernel_reg_data_in    : in  std_logic_vector(31 downto 0);
		kernel_reg_data_out   : out std_logic_vector(31 downto 0);
		cmem_param_size_out   : out std_logic_vector(5 downto 0);
		kernel_param_size_out : out std_logic_vector(3 downto 0);
		kernel_block_x_out    : out std_logic_vector(15 downto 0);
		kernel_block_y_out    : out std_logic_vector(15 downto 0);
		kernel_block_z_out    : out std_logic_vector(15 downto 0);
		kernel_grid_x_out     : out std_logic_vector(15 downto 0);
		kernel_grid_y_out     : out std_logic_vector(15 downto 0);
		kernel_gprs_out       : out std_logic_vector(8 downto 0);
		kernel_shmem_size_out : out std_logic_vector(31 downto 0);
		blocks_per_core_out   : out std_logic_vector(3 downto 0)
	);
end TP_configuration;

architecture Behavioral of TP_configuration is
	type cmem_regs_type is array (63 downto 0) of std_logic_vector(7 downto 0);
	type kernel_regs_type is array (15 downto 0) of std_logic_vector(31 downto 0);

	signal cmem_regs           : cmem_regs_type;
	constant cmem_regs_default : cmem_regs_type := ( --  63(3F)
		x"00", x"03", x"ff", x"ff",     -- 60
		x"00", x"03", x"ff", x"ff",     -- 56
		x"00", x"03", x"ff", x"ff",     -- 52
		x"00", x"03", x"ff", x"ff",     -- 48
		x"00", x"03", x"ff", x"ff",     -- 44
		x"00", x"03", x"ff", x"ff",     -- 40
		x"00", x"03", x"ff", x"ff",     -- 36
		x"00", x"03", x"ff", x"ff",     -- 32
		x"00", x"03", x"ff", x"ff",     -- 28
		x"00", x"03", x"ff", x"ff",     -- 24
		x"00", x"03", x"ff", x"ff",     -- 20
		x"00", x"03", x"ff", x"ff",     -- 16
		x"00", x"03", x"ff", x"ff",     -- 12
		x"00", x"03", x"ff", x"ff",     -- 8
		x"00", x"03", x"ff", x"ff",     -- 4
		BENCH_CMEMREG3, BENCH_CMEMREG2, BENCH_CMEMREG1, BENCH_CMEMREG0); -- 0     it replaces the procedure in the original development process
																		 -- 	  from flexgrip

	signal kernel_regs           : kernel_regs_type;
	constant kernel_regs_default : kernel_regs_type := ( --  15(0F)
		x"00000000", x"00000000", x"00000000", x"00000000", -- 12
		BENCH_KREG11, BENCH_KREG10, BENCH_KREG9, BENCH_KREG8, -- 8
		BENCH_KREG7,  BENCH_KREG6,  BENCH_KREG5, BENCH_KREG4, -- 4
		BENCH_KREG3,  BENCH_KREG2,  BENCH_KREG1, BENCH_KREG0); -- 0 					it replaces the procedure in the original development process
															 -- 			  		from flexgrip

	-- addr 0: start address of data
	-- addr 1: start address of results
	-- addr 2: size of array

	constant cmem_param_size   : std_logic_vector(5 downto 0)  := BENCH_CMEM_PARAM_SIZE; -- "00" & x"4"; -- 4 bytes
	constant kernel_param_size : std_logic_vector(3 downto 0)  := BENCH_KERNEL_PARAM_SIZE; -- x"4"; -- 4
	constant kernel_block_x    : std_logic_vector(15 downto 0) := BENCH_K_BLKX; -- 16
	constant kernel_block_y    : std_logic_vector(15 downto 0) := BENCH_K_BLKY; -- 1
	constant kernel_block_z    : std_logic_vector(15 downto 0) := BENCH_K_BLKZ; -- 1
	constant kernel_grid_x     : std_logic_vector(15 downto 0) := BENCH_K_GRDX; -- 1
	constant kernel_grid_y     : std_logic_vector(15 downto 0) := BENCH_K_GRDY; -- 1
	constant kernel_gprs       : std_logic_vector(8 downto 0)  := BENCH_KERNEL_GPRS; -- "0" & x"0B"; -- 11;
	constant kernel_shmem_size : std_logic_vector(31 downto 0) := BENCH_KERNEL_SHMEM_SIZE; -- x"0000002C"; -- 44      x"00000010";     -- 16
	constant blocks_per_core   : std_logic_vector(3 downto 0)  := BENCH_BLOCKS_PER_CORE; -- x"3"; -- 3
begin
	cmem_param_size_out   <= cmem_param_size;
	kernel_param_size_out <= kernel_param_size;
	kernel_block_x_out    <= kernel_block_x;
	kernel_block_y_out    <= kernel_block_y;
	kernel_block_z_out    <= kernel_block_z;
	kernel_grid_x_out     <= kernel_grid_x;
	kernel_grid_y_out     <= kernel_grid_y;
	kernel_gprs_out       <= kernel_gprs;
	kernel_shmem_size_out <= kernel_shmem_size;
	blocks_per_core_out   <= blocks_per_core;

	-- This generate Loop creates the 64 const mem registers, and controls the write accesses to them.
	gLoopConstMemRegistersWrite : for i in 0 to 63 generate
		pConstMemRegistersWrite : process(clk, reset, reset_registers)
		begin
			if (reset = '1' or reset_registers = '1') then
				cmem_regs(i) <= cmem_regs_default(i);
			elsif (rising_edge(clk)) then
				if (cmem_reg_cs = '1' and cmem_reg_rw = '0') then
					if (cmem_reg_adr = std_logic_vector(to_unsigned(i, 6))) then
						cmem_regs(i)(7 downto 0) <= cmem_reg_data_in;
					end if;
				end if;
			end if;
		end process;
	end generate;

	gLoopConstMemRegistersRead : for i in 0 to 63 generate
		pConstMemRegistersRead : process(clk, reset, reset_registers)
		begin
			if (reset = '1' or reset_registers = '1') then
				cmem_reg_data_out <= (others => '0');
			elsif (rising_edge(clk)) then
				if (cmem_reg_cs = '1' and cmem_reg_rw = '1') then
					for i in 0 to 63 loop
						if (cmem_reg_adr = std_logic_vector(to_unsigned(i, 6))) then
							cmem_reg_data_out <= cmem_regs(i);
						end if;
					end loop;
				end if;
			end if;
		end process;
	end generate;

	-- This generate Loop creates the 16 shared mem registers, and controls the write accesses to them.
	gLoopKernelRegistersWrite : for i in 0 to 15 generate
		pKernelRegistersWrite : process(reset, reset_registers, clk)
		begin
			if (reset = '1' or reset_registers = '1') then
				kernel_regs(i) <= kernel_regs_default(i);
			elsif (rising_edge(clk)) then
				if (kernel_reg_cs = '1' and kernel_reg_rw = '0') then
					if (kernel_reg_adr = std_logic_vector(to_unsigned(i, 4))) then
						kernel_regs(i)(31 downto 0) <= kernel_reg_data_in;
					end if;
				end if;
			end if;
		end process;
	end generate;

	gLoopKernelRegistersRead : for i in 0 to 15 generate
		pKernelRegistersRead : process(reset, reset_registers, clk)
		begin
			if (reset = '1' or reset_registers = '1') then
				kernel_reg_data_out <= (others => '0');
			elsif (rising_edge(clk)) then
				if (kernel_reg_cs = '1' and kernel_reg_rw = '1') then
					for i in 0 to 15 loop
						if (kernel_reg_adr = std_logic_vector(to_unsigned(i, 4))) then
							kernel_reg_data_out <= kernel_regs(i);
						end if;
					end loop;
				end if;
			end if;
		end process;
	end generate;
end Behavioral;

