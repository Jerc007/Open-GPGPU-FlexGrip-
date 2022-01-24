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

entity global_memory_controller is
	generic(
		ADDRESS_SIZE     : integer   := 32;
		ARB_GPRS_EN      : std_logic := '0';
		ARB_ADDR_REGS_EN : std_logic := '0'
	);
	port(
		reset                : in  std_logic;
		clk_in               : in  std_logic;
		en                   : in  std_logic;
		data_in              : in  vector_word_register_array;
		addr_in              : in  std_logic_vector(31 downto 0);
		mask_in              : in  std_logic_vector(CORES - 1 downto 0);
		rd_wr_type_in        : in  mem_opcode_type;
		data_type_in         : in  data_type;
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
		gmem_addr_out        : out std_logic_vector(ADDRESS_SIZE - 1 downto 0);
		gmem_wr_en_out       : out std_logic;
		gmem_wr_data_out     : out std_logic_vector(7 downto 0);
		gmem_rd_data_in      : in  std_logic_vector(7 downto 0);
		data_out             : out vector_word_register_array;
		rdy_out              : out std_logic
	);
end global_memory_controller;

architecture arch of global_memory_controller is
	type global_memory_cntrl_state_type is (IDLE, GATHER_GLOBAL_MEM, GATHER_GLOBAL_WAIT, SCATTER_GLOBAL_MEM, SCATTER_GLOBAL_WAIT, CALC_EFFECTIVE_ADDR);
	signal global_memory_cntrl_state_machine : global_memory_cntrl_state_type;

	signal addr_hi_i_3           : std_logic_vector(2 downto 0);
	signal addr_reg_i            : std_logic_vector(2 downto 0);
	signal gmem_addr_i           : std_logic_vector(ADDRESS_SIZE - 1 downto 0);
	signal gmem_size_i           : std_logic_vector(2 downto 0);
	signal gmem_wr_en_i          : std_logic;
	signal gmem_en               : std_logic;
	signal addr                  : vector_register;
	signal effective_addr_en     : std_logic;
	signal addr_o                : vector_register;
	signal addr_inc              : unsigned(2 downto 0);
	signal effective_addr_rdy_o  : std_logic;
	signal gmem_rd_data          : vector_word_register_array;
	signal shift_i               : std_logic_vector(4 downto 0);
	signal gmem_size             : std_logic_vector(2 downto 0);
	signal gmem_rd_data_o        : std_logic_vector(31 downto 0);
	signal gmem_wr_data_i        : std_logic_vector(31 downto 0);
	signal gmem_rd_wr_done_o     : std_logic;
	signal gmem_regs             : integer range 0 to 4;
	signal global_mem_rd_wr_cntr : integer range 0 to CORES;
	signal global_mem_regs_cntr  : integer range 0 to 4;
	signal next_read_write_state : global_memory_cntrl_state_type;

begin
	
	addr_hi_i_3 <= "00" & addr_hi_in;
	addr_reg_i  <= (to_stdlogicvector(to_bitvector(addr_hi_i_3) sll 2)) or ("0" & addr_lo_in);

	pGlobalMemoryController : process(clk_in, reset)
	begin
		if (reset = '1') then
			gmem_addr_i                       <= (others => '0');
			gmem_size_i                       <= (others => '0');
			gmem_wr_data_i                    <= (others => '0');
			gmem_wr_en_i                      <= '0';
			gmem_en                           <= '0';
			data_out                          <= (others => (others => (others => '0')));
			rdy_out                           <= '0';
			addr                              <= (others => (others => '0'));
			gmem_rd_data                      <= (others => (others => (others => '0')));
			addr_inc                          <= (others => '0');
			global_mem_rd_wr_cntr             <= 0;
			global_mem_regs_cntr              <= 0;
			effective_addr_en                 <= '0';
			next_read_write_state             <= IDLE;
			global_memory_cntrl_state_machine <= IDLE;
		elsif (rising_edge(clk_in)) then
			case global_memory_cntrl_state_machine is
				when IDLE =>
					gmem_addr_i           <= (others => '0');
					gmem_size_i           <= (others => '0');
					gmem_wr_data_i        <= (others => '0');
					gmem_wr_en_i          <= '0';
					gmem_en               <= '0';
					data_out              <= (others => (others => (others => '0')));
					addr                  <= (others => (others => '0'));
					gmem_rd_data          <= (others => (others => (others => '0')));
					global_mem_rd_wr_cntr <= 0;
					global_mem_regs_cntr  <= 0;
					addr_inc              <= (others => '0');
					rdy_out               <= '0';
					effective_addr_en     <= '0';

					if(en = '1') then
						if ((rd_wr_type_in = READ_GATHER) or (rd_wr_type_in = WRITE_SCATTER)) then
							effective_addr_en <= '1';
							if (rd_wr_type_in = READ_GATHER) then
								next_read_write_state <= GATHER_GLOBAL_MEM;
							else
								next_read_write_state <= SCATTER_GLOBAL_MEM;
							end if;
							global_memory_cntrl_state_machine <= CALC_EFFECTIVE_ADDR;
						end if;
					end if;
					
				when GATHER_GLOBAL_MEM =>
					if (global_mem_rd_wr_cntr < CORES) then
						if (mask_in(global_mem_rd_wr_cntr) = '1') then
							gmem_addr_i <= std_logic_vector(unsigned(addr(global_mem_rd_wr_cntr)(ADDRESS_SIZE - 1 downto 0)) + addr_inc);
							gmem_size_i                       <= gmem_size;
							gmem_wr_en_i                      <= '0';
							gmem_en                           <= '1';
							global_mem_regs_cntr              <= global_mem_regs_cntr + 1;
							global_memory_cntrl_state_machine <= GATHER_GLOBAL_WAIT;
						else
							gmem_en <= '0';
							for i in 0 to 3 loop
								gmem_rd_data(global_mem_rd_wr_cntr)(i) <= (others => '0');
							end loop;
							global_mem_rd_wr_cntr <= global_mem_rd_wr_cntr + 1;
						end if;
					else
						gmem_en                           <= '0';
						data_out                          <= gmem_rd_data;
						-- ADDED GIANLUCA ROASCIO - WHEN DT IS SIGNED, NUMBERS ARE TO BE SIGN-EXTENDED
						for i in 0 to CORES-1 loop
							if(data_type_in = DT_S16) then
								if(gmem_rd_data(i)(0)(15) = '1') then
									data_out(i)(0) <= x"FFFF0000" or gmem_rd_data(i)(0);
								else
									data_out(i)(0) <= gmem_rd_data(i)(0);
								end if;
							elsif(data_type_in = DT_S8) then
								if(gmem_rd_data(i)(0)(7) = '1') then
									data_out(i)(0) <= x"FFFFFF00" or gmem_rd_data(i)(0);
								else
									data_out(i)(0) <= gmem_rd_data(i)(0);
								end if;
							end if;
						end loop;
						global_mem_rd_wr_cntr             <= 0;
						rdy_out                           <= '1';
						global_memory_cntrl_state_machine <= IDLE;
					end if;
					
				when GATHER_GLOBAL_WAIT =>
					gmem_en <= '0';
					if (gmem_rd_wr_done_o = '1') then
						gmem_rd_data(global_mem_rd_wr_cntr)(global_mem_regs_cntr - 1) <= gmem_rd_data_o;
						if (global_mem_regs_cntr < gmem_regs) then
							addr_inc <= addr_inc + 4;
						else
							addr_inc              <= (others => '0');
							global_mem_regs_cntr  <= 0;
							global_mem_rd_wr_cntr <= global_mem_rd_wr_cntr + 1;
						end if;
						global_memory_cntrl_state_machine <= GATHER_GLOBAL_MEM;
					end if;
					
				when SCATTER_GLOBAL_MEM =>
					if (global_mem_rd_wr_cntr < CORES) then
						if (mask_in(global_mem_rd_wr_cntr) = '1') then
							gmem_wr_data_i <= data_in(global_mem_rd_wr_cntr)(global_mem_regs_cntr);
							gmem_addr_i    <= std_logic_vector(unsigned(addr(global_mem_rd_wr_cntr)(ADDRESS_SIZE - 1 downto 0)) + addr_inc);
							gmem_size_i                       <= gmem_size;
							gmem_wr_en_i                      <= '1';
							gmem_en                           <= '1';
							global_mem_regs_cntr              <= global_mem_regs_cntr + 1;
							global_memory_cntrl_state_machine <= SCATTER_GLOBAL_WAIT;
						else
							gmem_en               <= '0';
							gmem_wr_en_i          <= '0';
							gmem_wr_data_i        <= (others => '0');
							global_mem_rd_wr_cntr <= global_mem_rd_wr_cntr + 1;
						end if;
					else
						gmem_en                           <= '0';
						gmem_wr_en_i                      <= '0';
						gmem_wr_data_i                    <= (others => '0');
						global_mem_rd_wr_cntr             <= 0;
						rdy_out                           <= '1';
						global_memory_cntrl_state_machine <= IDLE;
					end if;
					
				when SCATTER_GLOBAL_WAIT =>
					gmem_en      <= '0';
					gmem_wr_en_i <= '0';
					if (gmem_rd_wr_done_o = '1') then
						if (global_mem_regs_cntr < gmem_regs) then
							addr_inc <= addr_inc + "100";
						else
							addr_inc              <= (others => '0');
							global_mem_regs_cntr  <= 0;
							global_mem_rd_wr_cntr <= global_mem_rd_wr_cntr + 1;
						end if;
						global_memory_cntrl_state_machine <= SCATTER_GLOBAL_MEM;
					end if;
					
				when CALC_EFFECTIVE_ADDR =>
					effective_addr_en <= '0';
					if (effective_addr_rdy_o = '1') then
						addr                              <= addr_o;
						global_memory_cntrl_state_machine <= next_read_write_state;
					end if;
					
			-- when others =>
			--	global_memory_cntrl_state_machine <= IDLE;
			end case;
		end if;
	end process;

	pShiftAmount : process(data_type_in)
	begin
		case data_type_in is
			when DT_U16  => shift_i <= "00001";
			when DT_S16  => shift_i <= "00001";
			when DT_U32  => shift_i <= "00010";
			when DT_S32  => shift_i <= "00010";
			when DT_U64  => shift_i <= "00011";
			when DT_U128 => shift_i <= "00100";
			when others  => shift_i <= "00000";
		end case;
	end process;

	pMemorySize : process(data_type_in)
	begin
		case data_type_in is
			when DT_U8   => gmem_size <= "001";
			-- MODIFIED GIANLUCA ROASCIO - BYTE DIMENSION OF DT_S8 IS JUST 1
			--when DT_S8   => gmem_size <= "010";
			when DT_S8   => gmem_size <= "001";
			when DT_U16  => gmem_size <= "010";
			when DT_S16  => gmem_size <= "010";
			when DT_U32  => gmem_size <= "100";
			when DT_S32  => gmem_size <= "100";
			when DT_U64  => gmem_size <= "100";
			when DT_U128 => gmem_size <= "100";
			when others  => gmem_size <= "001";
		end case;
	end process;

	pMemoryRegisters : process(data_type_in)
	begin
		case data_type_in is
			when DT_U8   => gmem_regs <= 1;
			when DT_S8   => gmem_regs <= 1;
			when DT_U16  => gmem_regs <= 1;
			when DT_S16  => gmem_regs <= 1;
			when DT_U32  => gmem_regs <= 1;
			when DT_S32  => gmem_regs <= 1;
			when DT_U64  => gmem_regs <= 2;
			when DT_U128 => gmem_regs <= 4;
			when others  => gmem_regs <= 1;
		end case;
	end process;

	uEffectiveAddress : effective_address
		generic map(
			ARB_GPRS_EN      => ARB_GPRS_EN,
			ARB_ADDR_REGS_EN => ARB_ADDR_REGS_EN
		)
		port map(
			reset                => reset,
			clk_in               => clk_in,
			en                   => effective_addr_en,
			reg_in               => addr_in,
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
			en              => gmem_en,
			mem_addr_in     => gmem_addr_i,
			mem_size_in     => gmem_size_i,
			mem_wr_data_in  => gmem_wr_data_i,
			mem_wr_en_in    => gmem_wr_en_i,
			mem_addr_out    => gmem_addr_out,
			mem_wr_en_out   => gmem_wr_en_out,
			mem_wr_data_out => gmem_wr_data_out,
			mem_rd_data_in  => gmem_rd_data_in,
			mem_rd_data_out => gmem_rd_data_o,
			mem_rd_wr_done  => gmem_rd_wr_done_o
		);

end arch;

