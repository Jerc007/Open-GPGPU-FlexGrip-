----------------------------------------------------------------------------------
-- Company:          Univerity of Massachusetts 
-- Engineer:         Kevin Andryc
-- 
-- Create Date:      17:50:27 09/19/2010  
-- Module Name:      warp_checker - arch 
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

entity warp_checker is
	generic(
		SHMEM_ADDR_SIZE : integer := 14
	);
	port(
		clk_in                  : in  std_logic;
		host_reset              : in  std_logic;
		reset                   : in  std_logic;
		en                      : in  std_logic;
		warp_id_in              : in  std_logic_vector(4 downto 0);
		warp_lane_id_in         : in  std_logic_vector(1 downto 0);
		cta_id_in               : in  std_logic_vector(3 downto 0);
		initial_mask_in         : in  std_logic_vector(31 downto 0);
		current_mask_in         : in  std_logic_vector(31 downto 0);
		shmem_base_addr_in      : in  std_logic_vector(SHMEM_ADDR_SIZE - 1 downto 0);
		gprs_base_addr_in       : in  std_logic_vector(8 downto 0);
		next_pc_in              : in  std_logic_vector(31 downto 0);
		warp_state_in           : in  warp_state_type;
		warps_per_block_in      : in  std_logic_vector(5 downto 0);
		warp_pool_addr_out      : out std_logic_vector(4 downto 0);
		warp_pool_wr_en_out     : out std_logic;
		warp_pool_wr_data_out   : out std_logic_vector(127 downto 0);
		warp_state_addr_out     : out std_logic_vector(4 downto 0);
		warp_state_wr_en_out    : out std_logic;
		warp_state_wr_data_out  : out std_logic_vector(1 downto 0);
		fence_regs_fence_en_out : out fence_regs_std_array;
		fence_regs_fence_en_ld  : out fence_regs_std_array;
		fence_regs_cta_id_in    : in  fence_regs_vector_array;
		fence_regs_fence_en_in  : in  fence_regs_std_array;
		warps_done_mask_out     : out std_logic_vector(MAX_WARPS - 1 downto 0);
		pipeline_stall_out      : out std_logic
	);
end warp_checker;

architecture arch of warp_checker is
	
	type warp_checker_state_type is (IDLE, CHECK_FENCE_WAIT, CHECK_FENCE, SET_WARPS_ACTIVE, DONE);
	signal warp_checker_state_machine : warp_checker_state_type;

	signal cta_id_mask     : std_logic_vector(MAX_WARPS - 1 downto 0);
	signal cta_id_mask_rev : std_logic_vector(MAX_WARPS - 1 downto 0);
	signal fence_id_mask   : std_logic_vector(MAX_WARPS - 1 downto 0);

	signal warp_id_addr    : integer range 0 to MAX_WARPS;
	signal warp_cntr       : std_logic_vector(5 downto 0);
	signal warps_done_mask : std_logic_vector(MAX_WARPS - 1 downto 0);
	
	
begin
	
	
	pWarpChecker : process(clk_in, host_reset, reset)
	begin
		if (host_reset = '1' or reset = '1') then
			warp_id_addr               <= 0;
			warp_cntr                  <= (others => '0');
			warp_pool_addr_out         <= (others => '0');
			warp_pool_wr_en_out <= '0';
			warp_pool_wr_data_out      <= (others => '0');
			warps_done_mask            <= (others => '0');
			fence_regs_fence_en_out    <= (others => '0');
			fence_regs_fence_en_ld     <= (others => '0');
			warps_done_mask_out        <= (others => '0');
			warp_state_addr_out        <= (others => '0');
			warp_state_wr_en_out <= '0';
			warp_state_wr_data_out     <= (others => '0');
			pipeline_stall_out         <= '0';
			warp_checker_state_machine <= IDLE;
		elsif (rising_edge(clk_in)) then
			case warp_checker_state_machine is
				when IDLE =>
					warp_cntr    <= (others => '0');
					warp_id_addr <= to_integer(unsigned(warp_id_in));
					if(en = '1') then
						pipeline_stall_out <= '1';
						if (warp_lane_id_in = std_logic_vector(to_unsigned(WARP_LANES - 1, 2))) then 	-- comparator of warp lanes with the warp lane id (limited to 99 max (practical 32 or 24))
							warp_pool_addr_out    <= warp_id_in;
							warp_pool_wr_en_out <= '1';
							-- line for warp pool memory.
							warp_pool_wr_data_out <= "0000" & shmem_base_addr_in & cta_id_in & gprs_base_addr_in & '0' & next_pc_in & initial_mask_in & current_mask_in;
							warp_state_addr_out   <= warp_id_in;
							warp_state_wr_en_out <= '1';
							if (warp_state_in = FINISHED) then
								warp_state_wr_data_out                            <= encode_warp_state(FINISHED);
								warps_done_mask(to_integer(unsigned(warp_id_in))) <= '1';
								warp_checker_state_machine                        <= DONE;
							elsif (warp_state_in = WAITING_FENCE) then
								fence_regs_fence_en_out(to_integer(unsigned(warp_id_in))) <= '1';
								fence_regs_fence_en_ld(to_integer(unsigned(warp_id_in)))  <= '1';
								warp_state_wr_data_out                                    <= encode_warp_state(WAITING_FENCE);
								warp_checker_state_machine                                <= CHECK_FENCE_WAIT;
							else
								warp_state_wr_data_out     <= encode_warp_state(READY);
								warp_checker_state_machine <= DONE;
							end if;
						else
							warp_checker_state_machine <= DONE;
						end if;
					else
						pipeline_stall_out         <= '0';
						warps_done_mask_out        <= warps_done_mask;
						warp_pool_addr_out         <= (others => '0');
						warp_pool_wr_en_out <= '0';
						warp_pool_wr_data_out      <= (others => '0');
						warp_state_addr_out        <= (others => '0');
						warp_state_wr_en_out <= '0';
						warp_state_wr_data_out     <= (others => '0');
						warp_checker_state_machine <= IDLE;
					end if;
				when CHECK_FENCE_WAIT =>
					warp_pool_addr_out                   <= (others => '0');
					warp_pool_wr_en_out <= '0';
					warp_pool_wr_data_out                <= (others => '0');
					warp_state_addr_out                  <= (others => '0');
					warp_state_wr_en_out <= '0';
					warp_state_wr_data_out               <= (others => '0');
					fence_regs_fence_en_ld(warp_id_addr) <= '0';
					warp_checker_state_machine           <= CHECK_FENCE;
				when CHECK_FENCE =>
					if (cta_id_mask_rev = fence_id_mask) then
						warp_checker_state_machine <= SET_WARPS_ACTIVE;
					else
						warp_checker_state_machine <= DONE;
					end if;
				when SET_WARPS_ACTIVE =>
					if (unsigned(warp_cntr) < MAX_WARPS) then
						if (cta_id_mask_rev(to_integer(unsigned(warp_cntr))) = '1') then
							fence_regs_fence_en_out(to_integer(unsigned(warp_cntr))) <= '0';
							fence_regs_fence_en_ld(to_integer(unsigned(warp_cntr)))  <= '1';
							warp_state_addr_out                                      <= warp_cntr(4 downto 0);
							warp_state_wr_en_out <= '1';
							warp_state_wr_data_out                                   <= encode_warp_state(READY);
						else
							warp_state_wr_en_out <= '0';
						end if;

						warp_cntr <= std_logic_vector(unsigned(warp_cntr) + 1);
					else
						warp_cntr                  <= (others => '0');
						warp_checker_state_machine <= DONE;
					end if;
				when DONE =>
					pipeline_stall_out         <= '0';
					warp_pool_addr_out         <= (others => '0');
					warp_pool_wr_en_out <= '0';
					warp_pool_wr_data_out      <= (others => '0');
					warp_state_addr_out        <= (others => '0');
					warp_state_wr_en_out <= '0';
					warp_state_wr_data_out     <= (others => '0');
					warps_done_mask_out        <= warps_done_mask;
					warp_checker_state_machine <= IDLE;
			-- when others =>
			--	warp_checker_state_machine <= IDLE;
			end case;
		end if;
	end process;

	gCheckFence : for i in 0 to MAX_WARPS - 1 generate
		cta_id_mask(i)   <= '1' when (fence_regs_cta_id_in(i) = cta_id_in) else '0';
		fence_id_mask(i) <= fence_regs_fence_en_in(i) when (fence_regs_cta_id_in(i) = cta_id_in) else '0';
	end generate;

	process(cta_id_in, warps_per_block_in, cta_id_mask)
	begin
		if(cta_id_in = "0000") then
			cta_id_mask_rev <= (others => '0');
			for i in 0 to MAX_WARPS - 1 loop
				if(unsigned(warps_per_block_in) > i) then
					cta_id_mask_rev(i) <= cta_id_mask(i);
				else
					cta_id_mask_rev(i) <= '0';
				end if;
			end loop;
		else
			cta_id_mask_rev <= cta_id_mask;
		end if;
	end process;

end arch;

