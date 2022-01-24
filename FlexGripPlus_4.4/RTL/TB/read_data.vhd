----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    12:52:09 03/20/2013
-- Design Name:
-- Module Name:    read_data - Behavioral
-- Project Name:
-- Target Devices:
-- Tool versions:
-- Description:
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use std.textio.all;
use work.txt_util.all;

use work.gpgpu_package.all;

entity read_data is
	generic(
		MEM_ADDR_SIZE : integer := 32
	);
	port(
		clk               : in  std_logic;
		reset             : in  std_logic;
		en                : in  std_logic;
		mem_start_addr_in : in  std_logic_vector(MEM_ADDR_SIZE - 1 downto 0);
		mem_read_size_in  : in  std_logic_vector(MEM_ADDR_SIZE - 1 downto 0);
		mem_size_in       : in  std_logic_vector(2 downto 0);
		mem_addr_out      : out std_logic_vector(MEM_ADDR_SIZE - 1 downto 0);
		mem_wr_en_out     : out std_logic;
		mem_wr_data_out   : out std_logic_vector(7 downto 0);
		mem_rd_data_in    : in  std_logic_vector(7 downto 0);
		read_data_out     : out std_logic_vector(31 downto 0);
		read_data_rdy_out : out std_logic;
		done              : out std_logic
	);
end read_data;

architecture Behavioral of read_data is

	type read_data_state_type is (IDLE, READ_MEM, READ_WAIT, READ_DONE);
	signal read_data_state_machine : read_data_state_type;

	signal mem_en_i         : std_logic;
	signal mem_start_addr_i : std_logic_vector(MEM_ADDR_SIZE - 1 downto 0);
	signal mem_read_size_i  : std_logic_vector(MEM_ADDR_SIZE - 1 downto 0);

	signal mem_addr_i    : std_logic_vector(MEM_ADDR_SIZE - 1 downto 0);
	signal mem_size_i    : std_logic_vector(2 downto 0);
	signal mem_wr_data_i : std_logic_vector(31 downto 0);
	signal mem_wr_en_i   : std_logic;

	signal mem_rd_cnt           : std_logic_vector(MEM_ADDR_SIZE - 1 downto 0);
	signal mem_rd_data_o        : std_logic_vector(31 downto 0);
	signal mem_rd_wr_done_o     : std_logic;

begin

	pReadData : process(clk, reset)
		file read_data_log : text open write_mode is "gpgpu_rdata.log";
	begin
		if (reset = '1') then
			mem_start_addr_i        <= (others => '0');
			mem_read_size_i         <= (others => '0');
			mem_en_i                <= '0';
			mem_addr_i              <= (others => '0');
			mem_size_i              <= (others => '0');
			mem_wr_data_i           <= (others => '0');
			mem_wr_en_i             <= '0';
			mem_rd_cnt              <= (others => '0');
			read_data_out           <= (others => '0');
			read_data_rdy_out       <= '0';
			done                    <= '0';
			read_data_state_machine <= IDLE;
		elsif (rising_edge(clk)) then
			case read_data_state_machine is
				when IDLE =>
					mem_en_i          <= '0';
					mem_addr_i        <= (others => '0');
					mem_wr_data_i     <= (others => '0');
					mem_wr_en_i       <= '0';
					mem_rd_cnt        <= (others => '0');
					read_data_rdy_out <= '0';
					done              <= '0';
					if(en = '1') then
						mem_start_addr_i        <= mem_start_addr_in;
						mem_read_size_i         <= mem_read_size_in;
						mem_size_i              <= mem_size_in;
						read_data_state_machine <= READ_MEM;
					end if;

				when READ_MEM =>
					read_data_rdy_out <= '0';
					if (unsigned(mem_rd_cnt) < unsigned(mem_read_size_i) + 1) then
						mem_en_i                <= '1';
						mem_addr_i              <= mem_start_addr_i;
						read_data_state_machine <= READ_WAIT;
					else
						done                    <= '1';
						read_data_state_machine <= IDLE;
					end if;

				when READ_WAIT =>
					mem_en_i             <= '0';
					if(mem_rd_wr_done_o = '1') then
						mem_start_addr_i        <= std_logic_vector(unsigned(mem_start_addr_i) + 4);
						mem_rd_cnt              <= std_logic_vector(unsigned(mem_rd_cnt) + 1);
						read_data_out           <= mem_rd_data_o;
						read_data_rdy_out       <= '1';
						read_data_state_machine <= READ_MEM;

						print(read_data_log, hstr(mem_start_addr_i) & string'(" ") & hstr(mem_rd_data_o));
						--print(read_data_log, hstr(mem_rd_data_o)); --to get rid of line number

					end if;

				when others =>
					read_data_state_machine <= IDLE;
			end case;
		end if;
	end process;

	uMemoryController : memory_controller
		generic map(
			ADDRESS_SIZE => MEM_ADDR_SIZE
		)
		port map(
			reset           => reset,
			clk_in          => clk,
			en              => mem_en_i,
			mem_addr_in     => mem_addr_i,
			mem_size_in     => mem_size_i,
			mem_wr_data_in  => mem_wr_data_i,
			mem_wr_en_in    => mem_wr_en_i,
			mem_addr_out    => mem_addr_out,
			mem_wr_en_out   => mem_wr_en_out,
			mem_wr_data_out => mem_wr_data_out,
			mem_rd_data_in  => mem_rd_data_in,
			mem_rd_data_out => mem_rd_data_o,
			mem_rd_wr_done  => mem_rd_wr_done_o
		);

end Behavioral;
