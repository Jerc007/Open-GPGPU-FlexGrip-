----------------------------------------------------------------------------------
-- Company:          Univerity of Massachusetts 
-- Engineer:         Kevin Andryc
-- 
-- Create Date:      17:50:27 09/19/2010  
-- Module Name:      warp_scheduler - arch 
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

entity warp_scheduler is
	generic(
		SHMEM_ADDR_SIZE : integer := 14
	);
	port(
		clk_in                 : in  std_logic;
		host_reset             : in  std_logic;
		reset                  : in  std_logic;
		pipeline_stall_in      : in  std_logic;
		--num_blocks_in          : in  std_logic_vector(3 downto 0); -- REMOVED GIANLUCA ROASCIO
		num_warps_in           : in  std_logic_vector(4 downto 0);
		gprs_size_in           : in  std_logic_vector(8 downto 0);
		warps_done_mask_in     : in  std_logic_vector(MAX_WARPS - 1 downto 0);
		warp_pool_addr_out     : out std_logic_vector(4 downto 0);
		warp_pool_wr_en_out    : out std_logic;
		warp_pool_wr_data_out  : out std_logic_vector(127 downto 0);
		warp_pool_rd_data_in   : in  std_logic_vector(127 downto 0);			-- instruction pool in SIMD mode
		warp_state_addr_out    : out std_logic_vector(4 downto 0);
		warp_state_wr_en_out   : out std_logic;
		warp_state_wr_data_out : out std_logic_vector(1 downto 0);
		warp_state_rd_data_in  : in  std_logic_vector(1 downto 0);
		program_cntr_out       : out std_logic_vector(31 downto 0);
		warp_id_out            : out std_logic_vector(4 downto 0);
		warp_lane_id_out       : out std_logic_vector(1 downto 0);
		cta_id_out             : out std_logic_vector(3 downto 0);
		initial_mask_out       : out std_logic_vector(31 downto 0);
		current_mask_out       : out std_logic_vector(31 downto 0);
		shmem_base_addr_out    : out std_logic_vector(SHMEM_ADDR_SIZE - 1 downto 0);
		gprs_size_out          : out std_logic_vector(8 downto 0);
		gprs_base_addr_out     : out std_logic_vector(8 downto 0);
		done                   : out std_logic;
		pipeline_warpunit_done : out std_logic;
		fetch_en               : out std_logic
	);
end warp_scheduler;

architecture arch of warp_scheduler is
	type warp_scheduler_state_type is (IDLE,
		                               READ_FIRST_WARP,
		                               SCHEDULE_FIRST_WARP,
		                               SCHEDULE_WARP_LANE_0,
		                               SCHEDULE_WARP_NEXT_LANE,
		                               SCHEDULE_WARP_GAP,
		                               SCHEDULE_WARP32_STATE_WAIT,
		                               SCHEDULE_WARP_DONE);
	signal warp_scheduler_state_machine : warp_scheduler_state_type;
	signal warp_scheduler_next_state    : warp_scheduler_state_type;

	signal warps_done_mask : std_logic_vector(MAX_WARPS - 1 downto 0);

	signal warp_id_cnt   : std_logic_vector(4 downto 0);
	signal warp_lane_cnt : std_logic_vector(1 downto 0);
	signal program_cntr  : std_logic_vector(31 downto 0);
	
begin
	
	warp_pool_wr_en_out   <= '0';
	warp_pool_wr_data_out <= (others => '0');
			
	pWarpSchedulerStateMachine : process(clk_in, host_reset, reset)
	begin
		if (host_reset = '1' or reset = '1') then
			program_cntr_out             <= (others => '0');
			warp_id_out                  <= (others => '0');
			warp_lane_id_out             <= (others => '0');
			cta_id_out                   <= (others => '0');
			initial_mask_out             <= (others => '0');
			current_mask_out             <= (others => '0');
			shmem_base_addr_out          <= (others => '0');
			gprs_size_out                <= (others => '0');
			gprs_base_addr_out           <= (others => '0');
			warp_lane_cnt                <= (others => '0');
			warp_id_cnt                  <= (others => '0');
			program_cntr                 <= (others => '0');
			warp_pool_addr_out           <= (others => '0');
			warp_state_addr_out          <= (others => '0');
			warp_state_wr_en_out <= '0';
			warp_state_wr_data_out       <= (others => '0');
			done                         <= '0';
			pipeline_warpunit_done       <= '0';
			fetch_en                     <= '0';
			warp_scheduler_next_state    <= IDLE;
			warp_scheduler_state_machine <= IDLE;
		elsif (rising_edge(clk_in)) then
			case warp_scheduler_state_machine is
				when IDLE =>
					done                         <= '0';
					pipeline_warpunit_done       <= '0';
					fetch_en                     <= '0';
					warp_scheduler_state_machine <= SCHEDULE_FIRST_WARP;
					
				when SCHEDULE_FIRST_WARP =>
					-- id 0 lane_id 0
					shmem_base_addr_out <= warp_pool_rd_data_in(123 downto 110);
					cta_id_out          <= warp_pool_rd_data_in(109 downto 106);
					gprs_base_addr_out  <= warp_pool_rd_data_in(105 downto 97);
					initial_mask_out    <= warp_pool_rd_data_in(63 downto 32);
					current_mask_out    <= warp_pool_rd_data_in(31 downto 0);
					program_cntr_out    <= warp_pool_rd_data_in(95 downto 64);
					gprs_size_out       <= gprs_size_in;

					warp_id_out      <= warp_id_cnt;
					warp_lane_id_out <= warp_lane_cnt;

					if (CORES /= 32) then   -- 8 or 16 case
						warp_lane_cnt          <= std_logic_vector(unsigned(warp_lane_cnt) + 1);
						warp_pool_addr_out     <= warp_id_cnt;
						warp_state_addr_out    <= warp_id_cnt; -- write current warp active
						warp_state_wr_en_out   <= '1';
						warp_state_wr_data_out <= encode_warp_state(ACTIVE);
						pipeline_warpunit_done <= '1';

						fetch_en                     <= '1';
						warp_scheduler_state_machine <= SCHEDULE_WARP_GAP;
						warp_scheduler_next_state    <= SCHEDULE_WARP_NEXT_LANE;

					elsif (unsigned(warp_id_cnt) < unsigned(num_warps_in) - 1) then
						warp_id_cnt                  <= std_logic_vector(unsigned(warp_id_cnt) + 1);
						warp_lane_cnt                <= (others => '0');
						warp_state_addr_out          <= warp_id_cnt;
						warp_state_wr_en_out         <= '1';
						warp_state_wr_data_out       <= encode_warp_state(ACTIVE);
						pipeline_warpunit_done       <= '1';
						fetch_en                     <= '1';
						warp_scheduler_state_machine <= SCHEDULE_WARP32_STATE_WAIT;
					else
						warp_id_cnt                  <= (others => '0');
						warp_lane_cnt                <= (others => '0');
						warp_pool_addr_out           <= (others => '0');
						warp_state_addr_out          <= warp_id_cnt;
						warp_state_wr_en_out 		 <= '1';
						warp_state_wr_data_out       <= encode_warp_state(ACTIVE);
						pipeline_warpunit_done       <= '1';
						fetch_en                     <= '1';
						warp_scheduler_state_machine <= SCHEDULE_WARP32_STATE_WAIT;
					end if;
				
				when SCHEDULE_WARP32_STATE_WAIT =>
					-- read next warp pool and state
					warp_pool_addr_out           <= warp_id_cnt;
					warp_state_addr_out          <= warp_id_cnt;
					warp_state_wr_en_out         <= '0';
					-- ADDED GIANLUCA ROASCIO - ALSO fetch_en AND pipeline_warpunit_done HAVE TO BE SET TO 0, OTHERWISE THE PIPELINE REMAINS STALLED
					pipeline_warpunit_done       <= '0';
					fetch_en                     <= '0';
					warp_scheduler_state_machine <= SCHEDULE_WARP_LANE_0;
				
				when SCHEDULE_WARP_LANE_0 =>
					if (warps_done_mask_in = warps_done_mask) then
						warp_scheduler_state_machine <= SCHEDULE_WARP_DONE;
					elsif (warp_state_rd_data_in = encode_warp_state(READY)) then -- ready
						if (CORES /= 32) then
							if (pipeline_stall_in = '0') then
								-- issue current warp lane
								warp_id_out            <= warp_id_cnt;
								warp_lane_id_out       <= warp_lane_cnt;
								shmem_base_addr_out    <= warp_pool_rd_data_in(123 downto 110);
								cta_id_out             <= warp_pool_rd_data_in(109 downto 106);
								gprs_base_addr_out     <= warp_pool_rd_data_in(105 downto 97);
								initial_mask_out       <= warp_pool_rd_data_in(63 downto 32);
								current_mask_out       <= warp_pool_rd_data_in(31 downto 0);
								program_cntr_out       <= warp_pool_rd_data_in(95 downto 64);
								gprs_size_out          <= gprs_size_in;
								pipeline_warpunit_done <= '1';
								fetch_en               <= '1';

								warp_lane_cnt          <= std_logic_vector(unsigned(warp_lane_cnt) + 1);
								warp_state_addr_out    <= warp_id_cnt; -- current warp as active
								warp_state_wr_en_out   <= '1';
								warp_state_wr_data_out <= encode_warp_state(ACTIVE);

								warp_scheduler_state_machine <= SCHEDULE_WARP_GAP;
								warp_scheduler_next_state    <= SCHEDULE_WARP_NEXT_LANE;
							else
								pipeline_warpunit_done <= '0';
								fetch_en               <= '0';
							end if;
						else
							if (pipeline_stall_in = '0') then
								-- issue current warp
								warp_id_out            <= warp_id_cnt;
								warp_lane_id_out       <= warp_lane_cnt;
								shmem_base_addr_out    <= warp_pool_rd_data_in(123 downto 110);
								cta_id_out             <= warp_pool_rd_data_in(109 downto 106);
								gprs_base_addr_out     <= warp_pool_rd_data_in(105 downto 97);
								initial_mask_out       <= warp_pool_rd_data_in(63 downto 32);
								current_mask_out       <= warp_pool_rd_data_in(31 downto 0);
								program_cntr_out       <= warp_pool_rd_data_in(95 downto 64);
								gprs_size_out          <= gprs_size_in;
								pipeline_warpunit_done <= '1';
								fetch_en               <= '1';

								warp_state_addr_out    <= warp_id_cnt; -- current warp as active
								warp_state_wr_en_out   <= '1';
								warp_state_wr_data_out <= encode_warp_state(ACTIVE);

								-- prepare for next warp
								if (unsigned(warp_id_cnt) < unsigned(num_warps_in) - 1) then
									warp_id_cnt         <= std_logic_vector(unsigned(warp_id_cnt) + 1);
								else
									warp_id_cnt         <= (others => '0');
								end if;

								warp_lane_cnt <= (others => '0');
								warp_scheduler_state_machine <= SCHEDULE_WARP32_STATE_WAIT;
							else
								pipeline_warpunit_done <= '0';
								fetch_en               <= '0';
							end if;
						end if;
					elsif (warp_state_rd_data_in = encode_warp_state(FINISHED)) then -- finished
						if (pipeline_stall_in = '0') then
							if (unsigned(warp_id_cnt) < unsigned(num_warps_in) - 1) then
								warp_lane_cnt        <= (others => '0');
								warp_id_cnt 		 <= std_logic_vector(unsigned(warp_id_cnt) + 1);
							else
								warp_id_cnt          <= (others => '0');
								warp_lane_cnt        <= (others => '0');
							end if;

							pipeline_warpunit_done    <= '0'; ---MM: CHANGED TO 0 , as fetch is only on lane 0
							fetch_en                  <= '0';
							-- MODIFIED GIANLUCA ROASCIO - WHEN A WARP ENDS, THE SCHEDULER WAS ENTERING IN AN ENDLESS LOOP
							--warp_scheduler_next_state <= SCHEDULE_WARP32_STATE_WAIT;
							warp_scheduler_state_machine <= SCHEDULE_WARP32_STATE_WAIT;
						end if;
					elsif (warp_state_rd_data_in = encode_warp_state(WAITING_FENCE)) then -- WAITING_FENCE
						if (pipeline_stall_in = '0') then
							if (unsigned(warp_id_cnt) < unsigned(num_warps_in) - 1) then
								warp_lane_cnt        <= (others => '0');
								-- UNCOMMENTED GIANLUCA ROASCIO - THIS LINE WAS COMMENTED, MAKING THE WARP COUNTER STOP
								warp_id_cnt 		 <= std_logic_vector(unsigned(warp_id_cnt) + 1);	
							else
								warp_id_cnt          <= (others => '0');
								warp_lane_cnt        <= (others => '0');
							end if;

							pipeline_warpunit_done    <= '0'; ---MM: CHANGED TO 0 , as fetch is only on lane 0
							fetch_en                  <= '0';
							-- MODIFIED GIANLUCA ROASCIO - SAME PROBLEM OF ABOVE, ENDLESS LOOP BECAUSE OF WRONG NAMING OF THE STATE VARIABLE
							--warp_scheduler_next_state <= SCHEDULE_WARP32_STATE_WAIT;
							warp_scheduler_state_machine <= SCHEDULE_WARP32_STATE_WAIT;
						end if;
					else
						if (unsigned(warp_id_cnt) <= unsigned(num_warps_in) - 1) then
							warp_lane_cnt        <= (others => '0');
						else
							warp_id_cnt          <= (others => '0');
							warp_lane_cnt        <= (others => '0');
						end if;
						pipeline_warpunit_done       <= '0';
						fetch_en                     <= '0';
						warp_scheduler_state_machine <= SCHEDULE_WARP32_STATE_WAIT;
					end if;

				when SCHEDULE_WARP_NEXT_LANE =>
					warp_state_wr_en_out <= '0';
					warp_state_wr_data_out <= (others => '0');
					if (unsigned(warp_lane_cnt) < WARP_LANES - 1) then -- lanes 1 and 2
						if (pipeline_stall_in = '0') then
							warp_lane_cnt       <= std_logic_vector(unsigned(warp_lane_cnt) + 1);
							warp_id_out         <= warp_id_cnt;
							warp_lane_id_out    <= warp_lane_cnt;
							shmem_base_addr_out <= warp_pool_rd_data_in(123 downto 110);
							cta_id_out          <= warp_pool_rd_data_in(109 downto 106);
							gprs_base_addr_out  <= warp_pool_rd_data_in(105 downto 97);
							initial_mask_out    <= warp_pool_rd_data_in(63 downto 32);
							current_mask_out    <= warp_pool_rd_data_in(31 downto 0);
							program_cntr_out    <= warp_pool_rd_data_in(95 downto 64);
							gprs_size_out       <= gprs_size_in;

							pipeline_warpunit_done       <= '1'; ---MM: CHANGED TO 0 , as fetch is only on lane 0
							fetch_en                     <= '0';
							warp_scheduler_state_machine <= SCHEDULE_WARP_GAP;
							warp_scheduler_next_state    <= SCHEDULE_WARP_NEXT_LANE;
						else
							pipeline_warpunit_done <= '0';
							fetch_en               <= '0';
						end if;
					else                -- lane 3
						if (pipeline_stall_in = '0') then
							if (unsigned(warp_id_cnt) < unsigned(num_warps_in) - 1) then
								warp_id_cnt <= std_logic_vector(unsigned(warp_id_cnt) + 1);

								warp_pool_addr_out   <= std_logic_vector(unsigned(warp_id_cnt) + 1);
								warp_state_addr_out  <= std_logic_vector(unsigned(warp_id_cnt) + 1);
								warp_state_wr_en_out <= '0';
							else
								warp_id_cnt <= (others => '0');

								warp_pool_addr_out   <= (others => '0');
								warp_state_addr_out  <= (others => '0');
								warp_state_wr_en_out <= '0';
							end if;

							warp_lane_cnt    <= (others => '0');
							warp_id_out      <= warp_id_cnt;
							warp_lane_id_out <= warp_lane_cnt;

							shmem_base_addr_out          <= warp_pool_rd_data_in(123 downto 110);
							cta_id_out                   <= warp_pool_rd_data_in(109 downto 106);
							gprs_base_addr_out           <= warp_pool_rd_data_in(105 downto 97);
							initial_mask_out             <= warp_pool_rd_data_in(63 downto 32);
							current_mask_out             <= warp_pool_rd_data_in(31 downto 0);
							program_cntr_out             <= warp_pool_rd_data_in(95 downto 64);
							gprs_size_out                <= gprs_size_in;
							pipeline_warpunit_done       <= '1'; ---MM: CHANGED TO 0 , as fetch is only on lane 0
							fetch_en                     <= '0';
							warp_scheduler_state_machine <= SCHEDULE_WARP_GAP;
							warp_scheduler_next_state    <= SCHEDULE_WARP_LANE_0;
						else
							pipeline_warpunit_done <= '0';
						end if;
					end if;
					
				when SCHEDULE_WARP_GAP =>
					-- Just to wait for fecth's response
					warp_state_wr_en_out         <= '0';
					pipeline_warpunit_done       <= '0';
					fetch_en                     <= '0';
					warp_scheduler_state_machine <= warp_scheduler_next_state;
				
				when SCHEDULE_WARP_DONE =>
					done                         <= '1';
					warp_scheduler_state_machine <= SCHEDULE_WARP_DONE;
				when others =>
					warp_scheduler_state_machine <= IDLE;
			end case;
		end if;
	end process;

	uWarpsDoneLUT : warps_done_lut
		port map(
			clk_in          => clk_in,
			host_reset      => host_reset,
			num_warps_in    => num_warps_in,
			warps_done_mask => warps_done_mask
		);
end arch;

