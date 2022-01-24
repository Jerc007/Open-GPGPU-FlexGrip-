----------------------------------------------------------------------------------
-- Company:          Univerity of Massachusetts 
-- Engineer:         Kevin Andryc
-- 
-- Create Date:      17:50:27 09/19/2010  
-- Module Name:      read_vector_register - arch 
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

entity predicate_register_controller is
	port(
		reset                      : in  std_logic;
		clk_in                     : in  std_logic;
		en                         : in  std_logic;
		warp_id_in                 : in  std_logic_vector(4 downto 0);
		lane_id_in                 : in  std_logic_vector(1 downto 0);
		reg_num_in                 : in  std_logic_vector(1 downto 0);
		data_in                    : in  vector_flag_register;
		mask_in                    : in  std_logic_vector(CORES - 1 downto 0);
		rd_wr_en_in                : in  std_logic;
		pred_regs_warp_id_out      : out warp_id_array;
		pred_regs_warp_lane_id_out : out warp_lane_id_array;
		pred_regs_reg_num_out      : out reg_num_array;
		pred_regs_wr_en_out        : out wr_en_array;
		pred_regs_wr_data_out      : out vector_flag_register;
		pred_regs_rd_data_in       : in  vector_flag_register;
		data_out                   : out vector_flag_register;
		rdy_out                    : out std_logic
	);
end predicate_register_controller;

architecture arch of predicate_register_controller is
begin
	
	data_out <= pred_regs_rd_data_in;

	pPredicateRegisterController : process(clk_in, reset)
	begin
		if (reset = '1') then
			pred_regs_warp_id_out      <= (others => (others => '0'));
			pred_regs_warp_lane_id_out <= (others => (others => '0'));
			pred_regs_reg_num_out      <= (others => (others => '0'));
			pred_regs_wr_en_out        <= (others => '0');
			pred_regs_wr_data_out      <= (others => (others => '0'));
			rdy_out                    <= '0';
		elsif (rising_edge(clk_in)) then
			pred_regs_warp_id_out      <= (others => (others => '0'));
			pred_regs_warp_lane_id_out <= (others => (others => '0'));
			pred_regs_reg_num_out      <= (others => (others => '0'));
			pred_regs_wr_en_out        <= (others => '0');
			pred_regs_wr_data_out      <= (others => (others => '0'));
			rdy_out                    <= '0';
			if(en = '1') then
				if (rd_wr_en_in = '1') then
					pred_regs_warp_id_out      <= (others => warp_id_in);
					pred_regs_warp_lane_id_out <= (others => lane_id_in);
					pred_regs_reg_num_out      <= (others => reg_num_in);
					for i in 0 to CORES - 1 loop
						pred_regs_wr_en_out(i) <= mask_in(i);
					end loop;
					pred_regs_wr_data_out <= data_in;
					rdy_out               <= '1';
				else
					pred_regs_warp_id_out      <= (others => warp_id_in);
					pred_regs_warp_lane_id_out <= (others => lane_id_in);
					pred_regs_reg_num_out      <= (others => reg_num_in);
					pred_regs_wr_en_out        <= (others => '0');
					rdy_out                    <= '1';

				end if;
			end if;
		end if;
	end process;
end arch;

