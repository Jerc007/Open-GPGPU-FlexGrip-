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

entity effective_address is
	generic(
		ARB_GPRS_EN      : std_logic := '0';
		ARB_ADDR_REGS_EN : std_logic := '0'
	);
	port(
		reset                : in  std_logic;
		clk_in               : in  std_logic;
		en                   : in  std_logic;
		reg_in               : in  std_logic_vector(31 downto 0);
		addr_reg_in          : in  std_logic_vector(2 downto 0);
		addr_imm_in          : in  std_logic;
		shift_in             : in  std_logic_vector(4 downto 0);
		gprs_req_out         : out std_logic;
		gprs_ack_out         : out std_logic;
		gprs_grant_in        : in  std_logic;
		gprs_en_out          : out std_logic;
		gprs_reg_num_out     : out std_logic_vector(8 downto 0);
		gprs_data_type_out   : out data_type;
		--gprs_mask_out          : out std_logic_vector(CORES - 1 downto 0); -- (others => '1')
		--gprs_rd_wr_en_out      : out std_logic;								-- '0'
		gprs_rd_data_in      : in  vector_word_register_array;
		gprs_rdy_in          : in  std_logic;
		addr_regs_req_out    : out std_logic;
		addr_regs_ack_out    : out std_logic;
		addr_regs_grant_in   : in  std_logic;
		addr_regs_en_out     : out std_logic;
		addr_regs_reg_out    : out std_logic_vector(1 downto 0);
		--addr_regs_mask_out     : out std_logic_vector(CORES - 1 downto 0);  -- (others => '1')
		--addr_regs_rd_wr_en_out : out std_logic;								-- '0'
		addr_regs_rd_data_in : in  vector_register;
		addr_regs_rdy_in     : in  std_logic;
		addr_out             : out vector_register;
		rdy_out              : out std_logic
	);
end effective_address;

architecture arch of effective_address is
	
	component bshift
		port(
			datain    : in  std_logic_vector(31 downto 0);
			direction : in  std_logic;
			count     : in  std_logic_vector(4 downto 0);
			dataout   : out std_logic_vector(31 downto 0)
		);
	end component;

	type effective_addr_state_type is (IDLE, REQUEST_VECTOR_REGISTERS,
		                               READ_VECTOR_REGISTERS, REQUEST_ADDR_REGISTERS,
		                               READ_ADDR_REGISTERS, EFFECTIVE_ADDR_DONE);
	signal effective_addr_state_machine : effective_addr_state_type;

	signal offset_reg     : vector_register;
	signal reg_shifted    : std_logic_vector(31 downto 0);
	signal addr_reg_num_i : std_logic_vector(2 downto 0);
	
begin
	
	addr_reg_num_i <= addr_reg_in;

	pEffectiveAddress : process(clk_in, reset)
	begin
		if (reset = '1') then
			addr_regs_req_out <= '0';
			addr_regs_ack_out <= '0';
			addr_regs_en_out  <= '0';
			addr_regs_reg_out <= (others => '0');

			gprs_req_out       <= '0';
			gprs_ack_out       <= '0';
			gprs_en_out        <= '0';
			gprs_reg_num_out   <= (others => '0');
			gprs_data_type_out <= DT_UNKNOWN;
			addr_out           <= (others => (others => '0'));
			rdy_out            <= '0';

			offset_reg                   <= (others => (others => '0'));
			effective_addr_state_machine <= IDLE;
		elsif (rising_edge(clk_in)) then
			case effective_addr_state_machine is
				when IDLE =>
					addr_regs_req_out <= '0';
					addr_regs_ack_out <= '0';
					addr_regs_en_out  <= '0';
					gprs_req_out      <= '0';
					gprs_ack_out      <= '0';
					gprs_en_out       <= '0';
					offset_reg        <= (others => (others => '0'));
					rdy_out           <= '0';
					if(en = '1') then
						if (addr_imm_in = '1') then
							offset_reg <= (others => reg_shifted);
							if (addr_reg_in /= "000") then
								if (ARB_ADDR_REGS_EN = '1') then
									addr_regs_req_out            <= '1';
									addr_regs_ack_out            <= '0';
									effective_addr_state_machine <= REQUEST_ADDR_REGISTERS;
								else
									addr_regs_en_out             <= '1';
									addr_regs_reg_out            <= addr_reg_num_i(1 downto 0);
									effective_addr_state_machine <= READ_ADDR_REGISTERS;
								end if;
							else
								effective_addr_state_machine <= EFFECTIVE_ADDR_DONE;
							end if;
						else
							if (ARB_GPRS_EN = '1') then
								gprs_req_out                 <= '1';
								gprs_ack_out                 <= '0';
								effective_addr_state_machine <= REQUEST_VECTOR_REGISTERS;
							else
								gprs_en_out                  <= '1';
								gprs_reg_num_out             <= reg_in(8 downto 0);
								gprs_data_type_out           <= DT_U32;
								effective_addr_state_machine <= READ_VECTOR_REGISTERS;
							end if;
						end if;
					end if;
					
				when REQUEST_VECTOR_REGISTERS =>
					if (gprs_grant_in = '1') then
						gprs_req_out                 <= '0';
						gprs_en_out                  <= '1';
						gprs_reg_num_out             <= reg_in(8 downto 0);
						gprs_data_type_out           <= DT_U32;
						effective_addr_state_machine <= READ_VECTOR_REGISTERS;
					end if;
					
				when READ_VECTOR_REGISTERS =>
					gprs_en_out <= '0';
					if (gprs_rdy_in = '1') then
						for i in 0 to CORES - 1 loop
							offset_reg(i) <= gprs_rd_data_in(i)(0);
						end loop;
						if (addr_reg_in /= "000") then
							if (ARB_ADDR_REGS_EN = '1') then
								addr_regs_req_out            <= '1';
								addr_regs_ack_out            <= '0';
								effective_addr_state_machine <= REQUEST_ADDR_REGISTERS;
							else
								addr_regs_en_out             <= '1';
								addr_regs_reg_out            <= addr_reg_num_i(1 downto 0);
								effective_addr_state_machine <= READ_ADDR_REGISTERS;
							end if;
						else
							effective_addr_state_machine <= EFFECTIVE_ADDR_DONE;
						end if;
						gprs_ack_out <= '1';
					end if;
					
				when REQUEST_ADDR_REGISTERS =>
					if (addr_regs_grant_in = '1') then
						addr_regs_req_out            <= '0';
						addr_regs_en_out             <= '1';
						addr_regs_reg_out            <= addr_reg_num_i(1 downto 0);
						effective_addr_state_machine <= READ_ADDR_REGISTERS;
					end if;
					
				when READ_ADDR_REGISTERS =>
					addr_regs_en_out <= '0';
					if (addr_regs_rdy_in = '1') then
						for i in 0 to CORES - 1 loop
							offset_reg(i) <= std_logic_vector(unsigned(offset_reg(i)) + unsigned(addr_regs_rd_data_in(i)));
						end loop;
						addr_regs_ack_out            <= '1';
						effective_addr_state_machine <= EFFECTIVE_ADDR_DONE;
					end if;
					
				when EFFECTIVE_ADDR_DONE =>
					addr_regs_req_out            <= '0';
					addr_regs_ack_out            <= '0';
					addr_regs_en_out             <= '0';
					gprs_req_out                 <= '0';
					gprs_ack_out                 <= '0';
					gprs_en_out                  <= '0';
					addr_out                     <= offset_reg;
					rdy_out                      <= '1';
					effective_addr_state_machine <= IDLE;
			--when others =>
			--	effective_addr_state_machine <= IDLE;
			end case;
		end if;
	end process;

	uBarrelShifter : bshift
		port map(
			datain    => reg_in,
			direction => '0',           -- left
			count     => shift_in,
			dataout   => reg_shifted
		);

end arch;

