----------------------------------------------------------------------------------
-- Company:          Univerity of Massachusetts 
-- Engineer:         Kevin Andryc
-- 
-- Create Date:      17:50:27 09/19/2010  
-- Module Name:      shared_memory_controller - arch 
-- Project Name:     GPGPU
-- Target Devices: 
-- Tool versions:    ISE 10.1
-- Description: 
--
----------------------------------------------------------------------------
-- Revisions:       
--  REV:        Date:           Description:
--  0.1.a       9/13/2010       Created Top level file 
----------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.gpgpu_package.all;

entity constant_memory_controller is
	generic(
		ADDRESS_SIZE     : integer   := 32;
		ARB_GPRS_EN      : std_logic := '1';
		ARB_ADDR_REGS_EN : std_logic := '0'
	);
	port(
		reset                : in  std_logic;
		clk_in               : in  std_logic;
		en                   : in  std_logic;
		addr_in              : in  vector_register;
		mask_in              : in  std_logic_vector(CORES - 1 downto 0);
		rd_wr_type_in        : in  mem_opcode_type;
		sm_type_in           : in  sm_type;
		addr_lo_in           : in  std_logic_vector(1 downto 0);
		addr_hi_in           : in  std_logic;
		addr_imm_in          : in  std_logic;
		gprs_req_out         : out std_logic;
		gprs_ack_out         : out std_logic;
		gprs_grant_in        : in  std_logic;
		gprs_en_out          : out std_logic;
		gprs_reg_num_out     : out std_logic_vector(8 downto 0);
		gprs_data_type_out   : out data_type;
		gprs_rd_data_in      : in  vector_word_register_array;
		gprs_rdy_in          : in  std_logic;
		addr_regs_req_out    : out std_logic;
		addr_regs_ack_out    : out std_logic;
		addr_regs_grant_in   : in  std_logic;
		addr_regs_en_out     : out std_logic;
		addr_regs_reg_out    : out std_logic_vector(1 downto 0);
		addr_regs_rd_data_in : in  vector_register;
		addr_regs_rdy_in     : in  std_logic;
		cmem_addr_out        : out std_logic_vector(ADDRESS_SIZE - 1 downto 0);
		cmem_wr_en_out       : out std_logic;
		cmem_wr_data_out     : out std_logic_vector(7 downto 0);
		cmem_rd_data_in      : in  std_logic_vector(7 downto 0);
		data_out             : out vector_word_register_array;
		rdy_out              : out std_logic
	);
end constant_memory_controller;

architecture arch of constant_memory_controller is
	type constant_memory_cntrl_state_type is (IDLE, CALCULATE_BASE_ADDR, READ_CONSTANT_MEM, GATHER_CONSTANT_MEM,
		                                      GATHER_CONSTANT_WAIT, CALC_EFFECTIVE_ADDR);
	signal constant_memory_cntrl_state_machine : constant_memory_cntrl_state_type;

	signal addr_reg_i           : std_logic_vector(2 downto 0);
	signal cmem_addr_i          : std_logic_vector(ADDRESS_SIZE - 1 downto 0);
	signal cmem_size_i          : std_logic_vector(2 downto 0);
	signal cmem_en              : std_logic;
	signal addr_i               : vector_register;
	signal reg_i                : std_logic_vector(31 downto 0);
	signal effective_addr_en    : std_logic;
	signal addr_o               : vector_register;
	signal effective_addr_rdy_o : std_logic;
	signal cmem_rd_data         : vector_register;
	signal shift_i              : std_logic_vector(4 downto 0);
	signal cmem_size            : std_logic_vector(2 downto 0);
	signal cmem_rd_data_o       : std_logic_vector(31 downto 0);
	signal cmem_rd_wr_done_o    : std_logic;
	signal constant_mem_rd_cntr : integer range 0 to CORES;

begin
	
	addr_reg_i <= (addr_hi_in & "00") or ("0" & addr_lo_in);

	pConstantMemoryController : process(clk_in, reset)
	begin
		if (reset = '1') then
			cmem_addr_i                         <= (others => '0');
			cmem_size_i                         <= (others => '0');
			cmem_en                             <= '0';
			data_out                            <= (others => (others => (others => '0')));
			rdy_out                             <= '0';
			addr_i                              <= (others => (others => '0'));
			reg_i                               <= (others => '0');
			cmem_rd_data                        <= (others => (others => '0'));
			constant_mem_rd_cntr                <= 0;
			effective_addr_en					<= '0';
			constant_memory_cntrl_state_machine <= IDLE;
		elsif (rising_edge(clk_in)) then
			case constant_memory_cntrl_state_machine is
				when IDLE =>
					cmem_addr_i          <= (others => '0');
					cmem_size_i          <= (others => '0');
					cmem_en              <= '0';
					data_out             <= (others => (others => (others => '0')));
					addr_i               <= (others => (others => '0'));
					reg_i                <= (others => '0');
					cmem_rd_data         <= (others => (others => '0'));
					constant_mem_rd_cntr <= 0;
					rdy_out              <= '0';
					if(en = '1') then
						if (rd_wr_type_in = READ) then
							cmem_addr_i                         <= addr_in(0)(ADDRESS_SIZE - 1 downto 0);
							cmem_size_i                         <= cmem_size;
							cmem_en                             <= '1';
							constant_memory_cntrl_state_machine <= READ_CONSTANT_MEM;
						elsif (rd_wr_type_in = READ_GATHER) then
							reg_i                               <= addr_in(0);
							effective_addr_en                   <= '1';
							constant_memory_cntrl_state_machine <= CALC_EFFECTIVE_ADDR;
						end if;
					end if;
					
				when READ_CONSTANT_MEM =>
					cmem_en <= '0';
					if (cmem_rd_wr_done_o = '1') then
						for i in 0 to CORES - 1 loop
							data_out(i)(0) <= cmem_rd_data_o;
						end loop;
						rdy_out                             <= '1';
						constant_memory_cntrl_state_machine <= IDLE;
					end if;
					
				when GATHER_CONSTANT_MEM =>
					if (constant_mem_rd_cntr < CORES) then
						if (mask_in(constant_mem_rd_cntr) = '1') then
							cmem_addr_i                         <= std_logic_vector(resize(unsigned(addr_i(constant_mem_rd_cntr)), ADDRESS_SIZE));
							cmem_size_i                         <= cmem_size;
							cmem_en                             <= '1';
							constant_memory_cntrl_state_machine <= GATHER_CONSTANT_WAIT;
						else
							cmem_en                            <= '0';
							cmem_rd_data(constant_mem_rd_cntr) <= (others => '0');
							constant_mem_rd_cntr               <= constant_mem_rd_cntr + 1;
						end if;
					else
						cmem_en <= '0';
						for i in 0 to CORES - 1 loop
							data_out(i)(0) <= cmem_rd_data(i);
						end loop;
						constant_mem_rd_cntr                <= 0;
						rdy_out                             <= '1';
						constant_memory_cntrl_state_machine <= IDLE;
					end if;
					
				when GATHER_CONSTANT_WAIT =>
					cmem_en <= '0';
					if (cmem_rd_wr_done_o = '1') then
						cmem_rd_data(constant_mem_rd_cntr)  <= cmem_rd_data_o;
						constant_mem_rd_cntr                <= constant_mem_rd_cntr + 1;
						constant_memory_cntrl_state_machine <= GATHER_CONSTANT_MEM;
					end if;
					
				when CALC_EFFECTIVE_ADDR =>
					effective_addr_en <= '0';
					if (effective_addr_rdy_o = '1') then
						addr_i                              <= addr_o;
						constant_memory_cntrl_state_machine <= GATHER_CONSTANT_MEM;
					end if;
					
				when others =>
					constant_memory_cntrl_state_machine <= IDLE;
			end case;
		end if;
	end process;

	with sm_type_in select shift_i <=
		"00001" when SM_U16,
		"00001" when SM_S16,
		"00010" when SM_U32,
		"00000" when others;

	with sm_type_in select cmem_size <=
		"001" when SM_U8,
		"010" when SM_U16,
		"010" when SM_S16,
		"100" when SM_U32,
		"000" when SM_NONE;

	uEffectiveAddress : effective_address
		generic map(
			ARB_GPRS_EN      => ARB_GPRS_EN,
			ARB_ADDR_REGS_EN => ARB_ADDR_REGS_EN
		)
		port map(
			reset                => reset,
			clk_in               => clk_in,
			en                   => effective_addr_en,
			reg_in               => reg_i,
			addr_reg_in          => addr_reg_i, --addr_hi_lo,
			addr_imm_in          => addr_imm_in,
			shift_in             => shift_i,
			gprs_req_out         => gprs_req_out,
			gprs_ack_out         => gprs_ack_out,
			gprs_grant_in        => gprs_grant_in,
			gprs_en_out          => gprs_en_out,
			gprs_reg_num_out     => gprs_reg_num_out,
			gprs_data_type_out   => gprs_data_type_out,
			gprs_rd_data_in      => gprs_rd_data_in,
			gprs_rdy_in          => gprs_rdy_in,
			addr_regs_req_out    => addr_regs_req_out,
			addr_regs_ack_out    => addr_regs_ack_out,
			addr_regs_grant_in   => addr_regs_grant_in,
			addr_regs_en_out     => addr_regs_en_out,
			addr_regs_reg_out    => addr_regs_reg_out,
			addr_regs_rd_data_in => addr_regs_rd_data_in,
			addr_regs_rdy_in     => addr_regs_rdy_in,
			addr_out             => addr_o,
			rdy_out              => effective_addr_rdy_o
		);

	uMemoryController : memory_controller
		generic map(
			ADDRESS_SIZE => ADDRESS_SIZE
		)
		port map(
			reset           => reset,
			clk_in          => clk_in,
			en              => cmem_en,
			mem_addr_in     => cmem_addr_i,
			mem_size_in     => cmem_size_i,
			mem_wr_data_in  => (others => '0'),
			mem_wr_en_in    => '0',
			mem_addr_out    => cmem_addr_out,
			mem_wr_en_out   => cmem_wr_en_out,
			mem_wr_data_out => cmem_wr_data_out,
			mem_rd_data_in  => cmem_rd_data_in,
			mem_rd_data_out => cmem_rd_data_o,
			mem_rd_wr_done  => cmem_rd_wr_done_o
		);

end arch;

