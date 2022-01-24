----------------------------------------------------------------------------------
-- Company:          Univerity of Massachusetts 
-- Engineer:         Kevin Andryc
-- 
-- Create Date:      17:50:27 09/19/2010  
-- Module Name:      increment_address - arch 
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

entity increment_address is
	port(
		reset                  : in  std_logic;
		clk_in                 : in  std_logic;
		en                     : in  std_logic;
		addr_reg_in            : in  std_logic_vector(1 downto 0);
		data_type_in           : in  data_type;
		mask_in                : in  std_logic_vector(CORES - 1 downto 0);
		imm_in                 : in  std_logic_vector(31 downto 0);
		addr_regs_en_out       : out std_logic;
		addr_regs_reg_num_out  : out std_logic_vector(1 downto 0);
		addr_regs_wr_data_out  : out vector_register;
		addr_regs_mask_out     : out std_logic_vector(CORES - 1 downto 0);
		addr_regs_rd_wr_en_out : out std_logic;
		addr_regs_rd_data_in   : in  vector_register;
		addr_regs_rdy_in       : in  std_logic;
		rdy_out                : out std_logic
	);
end increment_address;

architecture arch of increment_address is
	
	type incr_addr_state_type is (IDLE, READ_ADDR_REGS, WRITE_ADDR_REGS);
	signal incr_addr_state_machine : incr_addr_state_type;

	signal inc_i      : std_logic_vector(31 downto 0);
	signal addr_reg_i : std_logic_vector(1 downto 0);
	signal mask_i     : std_logic_vector(CORES - 1 downto 0);
	
begin
	
	inc_i <= std_logic_vector(unsigned(imm_in)) when ((data_type_in = DT_U8) or (data_type_in = DT_S8))
		else std_logic_vector(shift_left(unsigned(imm_in), 1)) when ((data_type_in = DT_U16) or (data_type_in = DT_S16))
		else std_logic_vector(shift_left(unsigned(imm_in), 2)) when ((data_type_in = DT_U32) or (data_type_in = DT_S32) or (data_type_in = DT_F32))
		else std_logic_vector(shift_left(unsigned(imm_in), 3)) when ((data_type_in = DT_U64) or (data_type_in = DT_F64))
		else std_logic_vector(shift_left(unsigned(imm_in), 4));

	pIncrementAddress : process(clk_in, reset)
	begin
		if (reset = '1') then
			addr_reg_i              <= (others => '0');
			mask_i                  <= (others => '0');
			addr_regs_en_out        <= '0';
			addr_regs_rd_wr_en_out  <= '0';
			addr_regs_wr_data_out   <= (others => (others => '0'));
			addr_regs_mask_out      <= (others => '0');
			rdy_out                 <= '0';
			incr_addr_state_machine <= IDLE;

		elsif (rising_edge(clk_in)) then
			case incr_addr_state_machine is
				when IDLE =>
					rdy_out                <= '0';
					addr_regs_en_out       <= '0';
					addr_regs_rd_wr_en_out <= '0';
					addr_regs_wr_data_out  <= (others => (others => '0'));
					addr_regs_mask_out     <= (others => '0');
					if(en = '1') then
						addr_reg_i              <= addr_reg_in;
						mask_i                  <= mask_in;
						addr_regs_en_out        <= '1';
						addr_regs_reg_num_out   <= addr_reg_in;
						addr_regs_wr_data_out   <= (others => (others => '0'));
						addr_regs_mask_out      <= (others => '1');
						addr_regs_rd_wr_en_out  <= '0';
						incr_addr_state_machine <= READ_ADDR_REGS;
					end if;
					
				when READ_ADDR_REGS =>
					if (addr_regs_rdy_in = '1') then
						for i in 0 to CORES - 1 loop						-- lo esta haciendo para cada nucleo, como volverlo redundante????
							case mask_i(i) is
								when '0' =>
									addr_regs_wr_data_out(i) <= addr_regs_rd_data_in(i);
								when others =>
									addr_regs_wr_data_out(i) <= std_logic_vector(unsigned(addr_regs_rd_data_in(i)) + unsigned(inc_i));
							end case;
						end loop;
						addr_regs_en_out        <= '1';
						addr_regs_reg_num_out   <= addr_reg_i;
						addr_regs_rd_wr_en_out  <= '1';
						addr_regs_mask_out      <= (others => '1');
						incr_addr_state_machine <= WRITE_ADDR_REGS;
					end if;
					
				when WRITE_ADDR_REGS =>
					addr_regs_en_out <= '0';
					if (addr_regs_rdy_in = '1') then
						rdy_out                 <= '1';
						incr_addr_state_machine <= IDLE;
					end if;
			-- when others =>
			--	incr_addr_state_machine <= IDLE;
			end case;
		end if;
	end process;

end arch;

