----------------------------------------------------------------------------------
-- Company:          Univerity of Massachusetts 
-- Engineer:         Kevin Andryc
-- 
-- Create Date:      17:50:27 09/19/2010  
-- Module Name:      memory_controller - arch 
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

entity memory_controller is
	generic(
		ADDRESS_SIZE : integer := 32
	);
	port(
		reset           : in  std_logic;
		clk_in          : in  std_logic;
		en              : in  std_logic;
		mem_addr_in     : in  std_logic_vector(ADDRESS_SIZE - 1 downto 0);
		mem_size_in     : in  std_logic_vector(2 downto 0);
		mem_wr_data_in  : in  std_logic_vector(31 downto 0);
		mem_wr_en_in    : in  std_logic;
		mem_addr_out    : out std_logic_vector(ADDRESS_SIZE - 1 downto 0);
		mem_wr_en_out   : out std_logic;
		mem_wr_data_out : out std_logic_vector(7 downto 0);
		mem_rd_data_in  : in  std_logic_vector(7 downto 0);
		mem_rd_data_out : out std_logic_vector(31 downto 0);
		mem_rd_wr_done  : out std_logic
	);
end memory_controller;

architecture arch of memory_controller is
	
	type memory_controller_state_type is (IDLE, WRITE_MEM, READ_MEM);
	signal memory_controller_state_machine : memory_controller_state_type;

begin
	
	pMemoryController : process(clk_in, reset)
		variable write_data    : std_logic_vector(31 downto 0);
		variable read_data     : std_logic_vector(31 downto 0);
		variable mem_rd_wr_cnt : unsigned(2 downto 0);
	begin
		if (reset = '1') then
			mem_addr_out                    <= (others => '0');
			mem_wr_en_out                   <= '0';
			mem_rd_data_out                 <= (others => '0');
			mem_rd_wr_cnt                   := (others => '0');
			mem_rd_wr_done                  <= '0';
			memory_controller_state_machine <= IDLE;
			read_data                       := (others => '0');
			write_data                      := (others => '0');
			mem_wr_data_out                 <= (others => '0');
		elsif (rising_edge(clk_in)) then
			case memory_controller_state_machine is
				when IDLE =>
					mem_rd_wr_cnt  := (others => '0');
					read_data      := (others => '0');
					mem_wr_en_out  <= '0';
					mem_rd_wr_done <= '0';
					if(en = '1') then
						mem_addr_out <= std_logic_vector(unsigned(mem_addr_in) + mem_rd_wr_cnt);

						if(mem_wr_en_in = '1') then -- write the first turn
							write_data      := mem_wr_data_in;
							mem_wr_data_out <= write_data(7 downto 0);
							mem_wr_en_out   <= '1';

							mem_rd_wr_cnt                   := mem_rd_wr_cnt + 1;
							memory_controller_state_machine <= WRITE_MEM;
						else            -- prepare for first read
							mem_wr_en_out <= '0';

							memory_controller_state_machine <= READ_MEM;
						end if;
					end if;
					
				when WRITE_MEM =>
					if(mem_rd_wr_cnt < unsigned(mem_size_in)) then
						mem_addr_out <= std_logic_vector(unsigned(mem_addr_in) + mem_rd_wr_cnt);
						case mem_rd_wr_cnt is
							when "001"  => mem_wr_data_out <= write_data(15 downto 8);
							when "010"  => mem_wr_data_out <= write_data(23 downto 16);
							when "011"  => mem_wr_data_out <= write_data(31 downto 24);
							when others => null;
						end case;

						mem_rd_wr_cnt                   := mem_rd_wr_cnt + 1;
						memory_controller_state_machine <= WRITE_MEM;
					else
						mem_addr_out                    <= (others => '0');
						mem_wr_en_out                   <= '0';
						mem_rd_wr_cnt                   := (others => '0');
						mem_rd_wr_done                  <= '1';
						memory_controller_state_machine <= IDLE;
					end if;
					
				when READ_MEM =>
					if(mem_rd_wr_cnt < unsigned(mem_size_in)) then
						case mem_rd_wr_cnt is
							when "000" => read_data := x"000000"   & mem_rd_data_in;
							when "001" => read_data(15 downto 8)  := mem_rd_data_in;
							when "010" => read_data(23 downto 16) := mem_rd_data_in;
							when "011" => read_data(31 downto 24) := mem_rd_data_in; -- Last byte read done

							when others => null;
						end case;

						mem_rd_wr_cnt := mem_rd_wr_cnt + 1;
						if(mem_rd_wr_cnt < unsigned(mem_size_in)) then
							mem_addr_out                    <= std_logic_vector(unsigned(mem_addr_in) + mem_rd_wr_cnt);
							memory_controller_state_machine <= READ_MEM;
						else
							mem_rd_data_out 				<= read_data;
							mem_addr_out                    <= (others => '0');
							mem_wr_en_out                   <= '0';
							mem_rd_wr_cnt                   := (others => '0');
							mem_rd_wr_done                  <= '1';
							memory_controller_state_machine <= IDLE;
						end if;
					end if;
			--when others =>
			--	memory_controller_state_machine <= IDLE;
			end case;
		end if;
	end process;
end arch;

