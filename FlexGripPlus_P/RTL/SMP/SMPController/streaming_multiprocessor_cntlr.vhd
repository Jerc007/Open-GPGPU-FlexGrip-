----------------------------------------------------------------------------------
-- Company:          Univerity of Massachusetts 
-- Engineer:         Kevin Andryc
-- 
-- Create Date:      17:50:27 09/19/2010  
-- Module Name:      streaming_multiprocessor_cntlr - arch 
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

entity streaming_multiprocessor_cntlr is
	generic(SHMEM_ADDR_SIZE : integer := 14);
	port(
		clk_in                      : in  std_logic;
		host_reset                  : in  std_logic;
		smp_run_en                  : in  std_logic;
		warp_generator_done         : in  std_logic;
		warp_scheduler_done         : in  std_logic;
		threads_per_block_in        : in  std_logic_vector(11 downto 0);
		num_blocks_in               : in  std_logic_vector(3 downto 0);
		shmem_base_addr_in          : in  std_logic_vector(31 downto 0);
		shmem_size_in               : in  std_logic_vector(31 downto 0);
		parameter_size_in           : in  std_logic_vector(15 downto 0);
		gprs_size_in                : in  std_logic_vector(8 downto 0);
		block_x_in                  : in  std_logic_vector(15 downto 0);
		block_y_in                  : in  std_logic_vector(15 downto 0);
		block_z_in                  : in  std_logic_vector(15 downto 0);
		grid_x_in                   : in  std_logic_vector(15 downto 0);
		grid_y_in                   : in  std_logic_vector(15 downto 0);
		block_idx_in                : in  std_logic_vector(15 downto 0);
		gpgpu_config_reg_cs_out     : out std_logic;
		gpgpu_config_reg_rw_out     : out std_logic;
		gpgpu_config_reg_adr_out    : out std_logic_vector(31 downto 0);
		gpgpu_config_reg_rd_data_in : in  std_logic_vector(31 downto 0);
		shmem_addr_out              : out std_logic_vector(SHMEM_ADDR_SIZE - 1 downto 0);
		shmem_wr_en_out             : out std_logic;
		shmem_wr_data_out           : out std_logic_vector(7 downto 0);
		gprs_base_addr_out          : out gprs_addr_array;
		gprs_reg_num_out            : out gprs_reg_array;
		gprs_lane_id_out            : out warp_lane_id_array;
		gprs_wr_en_out              : out wr_en_array;
		gprs_wr_data_out            : out vector_register;
		warps_per_block_out         : out std_logic_vector(5 downto 0);
		smp_configuration_en        : out std_logic;
		warp_generator_en           : out std_logic;
		smp_done                    : out std_logic
	);
end streaming_multiprocessor_cntlr;

architecture arch of streaming_multiprocessor_cntlr is
	
	constant HEADER_SIZE : integer := 16;
	constant PARAM_SIZE  : integer := 112;   --16;

	type smp_cntlr_state_type is (IDLE, CALC_BLOCK_IDS, CALC_BLOCK_IDS_WAIT, WRITE_BLOCK_IDS_SHMEM_1, WRITE_BLOCK_IDS_SHMEM_2,
		                          READ_SHMEM_PARAMS, READ_SHMEM_PARAMS_WAIT, WRITE_PARAMS_SHMEM_1, WRITE_PARAMS_SHMEM_2,
		                          WRITE_PARAMS_SHMEM_3, WRITE_PARAMS_SHMEM_4,
								  
								  CALC_WARPS_PER_BLOCK, CALC_WARPS_PER_BLOCK_WAIT,
		                          WARP_GEN_WAIT, CALC_THREAD_IDS_BLOCK_INC, CALC_THREAD_IDS, CALC_THREAD_IDS_WAIT,
		                          CALC_THREAD_IDS_WRITE, WARP_SCHED_WAIT);
							
	signal smp_cntlr_state_machine : smp_cntlr_state_type;

	type header_data_array is array (HEADER_SIZE - 1 downto 0) of std_logic_vector(15 downto 0);
	signal header_data_i : header_data_array;

	signal write_data_cnt : integer range 0 to (HEADER_SIZE + PARAM_SIZE);
	signal header_index   : integer range 0 to HEADER_SIZE;

	signal block_id_calc_en    : std_logic;
	signal idx_i               : std_logic_vector(15 downto 0);
	signal shmem_param_idx_i   : std_logic_vector(15 downto 0);
	signal block_id_x_o        : std_logic_vector(15 downto 0);
	signal block_id_y_o        : std_logic_vector(15 downto 0);
	signal block_id_calc_valid : std_logic;

	signal warps_per_block_en : std_logic;
	signal warps_per_block_o  : std_logic_vector(5 downto 0);
	signal warps_per_block_i  : std_logic_vector(5 downto 0);
	signal warps_per_block_dv : std_logic;

	signal thread_id_calc_en : std_logic;
	signal shmem_addr_i      : std_logic_vector(47 downto 0);
	signal x_indx_i          : std_logic_vector(15 downto 0);
	signal y_indx_i          : std_logic_vector(15 downto 0);
	signal z_indx_i          : std_logic_vector(15 downto 0);
	signal thread_id_o       : std_logic_vector(31 downto 0);
	signal thread_lane_id_o  : std_logic_vector(7 downto 0);
	signal warp_id_o         : std_logic_vector(31 downto 0);
	signal warp_lane_id_o    : std_logic_vector(5 downto 0);
	signal thread_id_i       : std_logic_vector(31 downto 0);
	signal thread_lane_id_i  : integer range 0 to CORES - 1;
	signal gprs_base_addr_i  : std_logic_vector(40 downto 0);
	signal warp_lane_id_i    : std_logic_vector(5 downto 0);
	signal thread_id_calc_dv : std_logic;

	signal flag : std_logic;
	
	
begin
	
	
	pSMPCntlrStateMachine : process(clk_in, host_reset)
		variable x_cnt : std_logic_vector(15 downto 0);
		variable y_cnt : std_logic_vector(15 downto 0);
		variable z_cnt : std_logic_vector(15 downto 0);
	begin
		if (host_reset = '1') then
			smp_cntlr_state_machine  <= IDLE;
			shmem_addr_out           <= (others => '0');
			shmem_wr_en_out 		 <= '0';
			shmem_wr_data_out        <= (others => '0');
			gpgpu_config_reg_cs_out  <= '0';
			gpgpu_config_reg_rw_out  <= '1';
			gpgpu_config_reg_adr_out <= (others => '0');
			warps_per_block_out      <= (others => '0');
			smp_configuration_en     <= '1';
			smp_done                 <= '0';
			warp_generator_en        <= '0';
			gprs_wr_en_out           <= (others => '0');
			gprs_base_addr_out       <= (others => (others => '0'));
			gprs_reg_num_out         <= (others => (others => '0'));
			gprs_lane_id_out         <= (others => (others => '0'));
			gprs_wr_data_out         <= (others => (others => '0'));
			block_id_calc_en         <= '0';
			shmem_addr_i             <= (others => '0');
			idx_i                    <= (others => '0');
			shmem_param_idx_i        <= (others => '0');
			header_data_i            <= (others => (others => '0'));
			write_data_cnt           <= 0;
			header_index             <= 0;
			warps_per_block_i        <= (others => '0');
			warps_per_block_en       <= '0';
			x_cnt                    := (others => '0');
			y_cnt                    := (others => '0');
			z_cnt                    := (others => '0');
			x_indx_i                 <= (others => '0');
			y_indx_i                 <= (others => '0');
			z_indx_i                 <= (others => '0');
			thread_lane_id_i         <= 0;
			gprs_base_addr_i         <= (others => '0');
			warp_lane_id_i           <= (others => '0');
			thread_id_i              <= (others => '0');
			flag                     <= '0';
		elsif (rising_edge(clk_in)) then
			case smp_cntlr_state_machine is
				when IDLE =>
					block_id_calc_en         <= '0';
					shmem_addr_i             <= (others => '0');
					idx_i                    <= (others => '0');
					shmem_param_idx_i        <= (others => '0');
					header_data_i            <= (others => (others => '0'));
					shmem_addr_out           <= (others => '0');
					shmem_wr_en_out          <= '0';
					shmem_wr_data_out        <= (others => '0');
					gprs_wr_en_out           <= (others => '0');
					gpgpu_config_reg_cs_out  <= '0';
					gpgpu_config_reg_rw_out  <= '1';
					gpgpu_config_reg_adr_out <= (others => '0');
					write_data_cnt           <= 0;
					header_index             <= 0;
					warps_per_block_i        <= (others => '0');
					warps_per_block_en       <= '0';
					warps_per_block_out      <= (others => '0');
					thread_id_calc_en        <= '0';
					x_cnt                    := (others => '0');
					y_cnt                    := (others => '0');
					z_cnt                    := (others => '0');
					x_indx_i                 <= (others => '0');
					y_indx_i                 <= (others => '0');
					z_indx_i                 <= (others => '0');
					thread_lane_id_i         <= 0;
					gprs_base_addr_i         <= (others => '0');
					warp_lane_id_i           <= (others => '0');
					smp_configuration_en     <= '1';
					smp_done                 <= '0';
					warp_generator_en        <= '0';
					flag                     <= '0';
					if (smp_run_en = '1') then
						smp_cntlr_state_machine <= CALC_BLOCK_IDS;
					end if;

				when CALC_BLOCK_IDS =>
					write_data_cnt    <= 0;
					header_index      <= 0;
					shmem_wr_en_out <= '0';
					shmem_wr_data_out <= (others => '0');
					if (unsigned(idx_i) < unsigned(num_blocks_in)) then
						block_id_calc_en        <= '1';
						shmem_addr_i            <= std_logic_vector(unsigned(shmem_base_addr_in) + (unsigned(shmem_size_in) * unsigned(idx_i)));
						header_data_i(0)        <= x"0000";
						header_data_i(1)        <= block_x_in;
						header_data_i(2)        <= block_y_in;
						header_data_i(3)        <= block_z_in;
						header_data_i(4)        <= grid_x_in;
						header_data_i(5)        <= grid_y_in;
						smp_cntlr_state_machine <= CALC_BLOCK_IDS_WAIT;
					else
						smp_cntlr_state_machine <= CALC_WARPS_PER_BLOCK;
					end if;

				when CALC_BLOCK_IDS_WAIT =>
					block_id_calc_en <= '0';
					if (block_id_calc_valid = '1') then
						header_data_i(6)        <= block_id_x_o;
						header_data_i(7)        <= block_id_y_o;
						idx_i                   <= std_logic_vector(unsigned(idx_i) + 1);
						smp_cntlr_state_machine <= WRITE_BLOCK_IDS_SHMEM_1;
					end if;

				when WRITE_BLOCK_IDS_SHMEM_1 =>
					shmem_wr_en_out         <= '1';
					shmem_wr_data_out       <= header_data_i(header_index)(7 downto 0);
					shmem_addr_out          <= std_logic_vector(unsigned(shmem_addr_i(SHMEM_ADDR_SIZE - 1 downto 0)) + to_unsigned(write_data_cnt, SHMEM_ADDR_SIZE));
					write_data_cnt          <= write_data_cnt + 1;
					smp_cntlr_state_machine <= WRITE_BLOCK_IDS_SHMEM_2;

				when WRITE_BLOCK_IDS_SHMEM_2 =>
					shmem_wr_en_out <= '1';
					shmem_wr_data_out <= header_data_i(header_index)(15 downto 8);
					shmem_addr_out    <= std_logic_vector(unsigned(shmem_addr_i(SHMEM_ADDR_SIZE - 1 downto 0)) + to_unsigned(write_data_cnt, SHMEM_ADDR_SIZE));
					if (write_data_cnt < HEADER_SIZE - 1) then
						write_data_cnt          <= write_data_cnt + 1;
						header_index            <= header_index + 1;
						smp_cntlr_state_machine <= WRITE_BLOCK_IDS_SHMEM_1;
					else
						smp_cntlr_state_machine <= READ_SHMEM_PARAMS;
					end if;

				when READ_SHMEM_PARAMS =>
					shmem_wr_en_out <= '0';
					shmem_wr_data_out <= (others => '0');
					shmem_addr_out    <= (others => '0');
					if (unsigned(shmem_param_idx_i) < unsigned(parameter_size_in)) then
						gpgpu_config_reg_cs_out  <= '1';
						gpgpu_config_reg_adr_out <= std_logic_vector(unsigned(CONFIG_PARAMS_START) + unsigned(shmem_param_idx_i));
						smp_cntlr_state_machine  <= READ_SHMEM_PARAMS_WAIT;
					else
						shmem_param_idx_i       <= (others => '0');
						gpgpu_config_reg_cs_out <= '0';
						smp_cntlr_state_machine <= CALC_BLOCK_IDS;
					end if;

				when READ_SHMEM_PARAMS_WAIT =>
					shmem_param_idx_i       <= std_logic_vector(unsigned(shmem_param_idx_i) + 1);
					write_data_cnt          <= write_data_cnt + 1;
					smp_cntlr_state_machine <= WRITE_PARAMS_SHMEM_1;

				when WRITE_PARAMS_SHMEM_1 =>
					shmem_wr_en_out <= '1';
					shmem_wr_data_out       <= gpgpu_config_reg_rd_data_in(7 downto 0);		-- not sent, broken bus???
					shmem_addr_out          <= std_logic_vector(unsigned(shmem_addr_i(SHMEM_ADDR_SIZE - 1 downto 0)) + to_unsigned(write_data_cnt, SHMEM_ADDR_SIZE));
					write_data_cnt          <= write_data_cnt + 1;
					smp_cntlr_state_machine <= WRITE_PARAMS_SHMEM_2;

				when WRITE_PARAMS_SHMEM_2 =>
					shmem_wr_en_out <= '1';
					shmem_wr_data_out       <= gpgpu_config_reg_rd_data_in(15 downto 8);   -- not sent, broken bus???
					shmem_addr_out          <= std_logic_vector(unsigned(shmem_addr_i(SHMEM_ADDR_SIZE - 1 downto 0)) + to_unsigned(write_data_cnt, SHMEM_ADDR_SIZE));
					write_data_cnt          <= write_data_cnt + 1;
					smp_cntlr_state_machine <= WRITE_PARAMS_SHMEM_3;

				when WRITE_PARAMS_SHMEM_3 =>
					shmem_wr_en_out <= '1';
					shmem_wr_data_out       <= gpgpu_config_reg_rd_data_in(23 downto 16);
					shmem_addr_out          <= std_logic_vector(unsigned(shmem_addr_i(SHMEM_ADDR_SIZE - 1 downto 0)) + to_unsigned(write_data_cnt, SHMEM_ADDR_SIZE));
					write_data_cnt          <= write_data_cnt + 1;
					smp_cntlr_state_machine <= WRITE_PARAMS_SHMEM_4;
				
				when WRITE_PARAMS_SHMEM_4 =>
					shmem_wr_en_out <= '1';
					shmem_wr_data_out       <= gpgpu_config_reg_rd_data_in(31 downto 24);
					shmem_addr_out          <= std_logic_vector(unsigned(shmem_addr_i(SHMEM_ADDR_SIZE - 1 downto 0)) + to_unsigned(write_data_cnt, SHMEM_ADDR_SIZE));
					smp_cntlr_state_machine <= READ_SHMEM_PARAMS;
					
				when CALC_WARPS_PER_BLOCK =>
					warps_per_block_en      <= '1';
					smp_cntlr_state_machine <= CALC_WARPS_PER_BLOCK_WAIT;
				
				when CALC_WARPS_PER_BLOCK_WAIT =>
					warps_per_block_en <= '0';
					if (warps_per_block_dv = '1') then
						idx_i                   <= (others => '0');
						warps_per_block_i       <= warps_per_block_o;
						warps_per_block_out     <= warps_per_block_o;
						smp_cntlr_state_machine <= CALC_THREAD_IDS;
					end if;
				
				when CALC_THREAD_IDS_BLOCK_INC =>
					if (unsigned(idx_i) < unsigned(num_blocks_in)) then
						smp_cntlr_state_machine <= CALC_THREAD_IDS;
						flag                    <= '0';
					else
						if (flag = '0') then
							thread_id_calc_en       <= '1';
							smp_cntlr_state_machine <= CALC_THREAD_IDS_WAIT;
							flag                    <= '1';
						else
							warp_generator_en       <= '1';
							smp_cntlr_state_machine <= WARP_GEN_WAIT;
						end if;
					end if;
				
				when CALC_THREAD_IDS =>
					gprs_wr_en_out(thread_lane_id_i) <= '0';
					if (unsigned(x_cnt) < unsigned(block_x_in)) then
						x_cnt                   := std_logic_vector(unsigned(x_cnt) + 1);
						x_indx_i                <= std_logic_vector(unsigned(x_cnt) - 1);
						y_indx_i                <= y_cnt;
						z_indx_i                <= z_cnt;
						thread_id_calc_en       <= '1';
						smp_cntlr_state_machine <= CALC_THREAD_IDS_WAIT;
					else
						x_cnt := x"0001";
						y_cnt := std_logic_vector(unsigned(y_cnt) + 1);
						if (unsigned(y_cnt) < unsigned(block_y_in)) then
							x_indx_i                <= std_logic_vector(unsigned(x_cnt) - 1);
							y_indx_i                <= y_cnt;
							z_indx_i                <= z_cnt;
							thread_id_calc_en       <= '1';
							smp_cntlr_state_machine <= CALC_THREAD_IDS_WAIT;
						else
							y_cnt := (others => '0');
							z_cnt := std_logic_vector(unsigned(z_cnt) + 1);
							if (unsigned(z_cnt) < unsigned(block_z_in)) then
								x_indx_i                <= std_logic_vector(unsigned(x_cnt) - 1);
								y_indx_i                <= y_cnt;
								z_indx_i                <= z_cnt;
								thread_id_calc_en       <= '1';
								smp_cntlr_state_machine <= CALC_THREAD_IDS_WAIT;
							else
								x_cnt                   := (others => '0');
								y_cnt                   := (others => '0');
								z_cnt                   := (others => '0');
								idx_i                   <= std_logic_vector(unsigned(idx_i) + 1);
								smp_cntlr_state_machine <= CALC_THREAD_IDS_BLOCK_INC;
							end if;
						end if;
					end if;
				
				when CALC_THREAD_IDS_WAIT =>
					thread_id_calc_en <= '0';
					if (thread_id_calc_dv = '1') then
						thread_id_i             <= thread_id_o;
						thread_lane_id_i        <= to_integer(unsigned(thread_lane_id_o));
						gprs_base_addr_i        <= std_logic_vector(unsigned(warp_id_o) * unsigned(gprs_size_in));
						warp_lane_id_i          <= warp_lane_id_o;
						smp_cntlr_state_machine <= CALC_THREAD_IDS_WRITE;
					end if;
				
				when CALC_THREAD_IDS_WRITE =>
					-- MODIFIED GIANLUCA ROASCIO - WHEN REACHING CALC_THREAD_IDS_BLOCK_INC, SHOULD NOT WRITE ANYTHING
					gprs_base_addr_out(thread_lane_id_i) <= gprs_base_addr_i(8 downto 0);
					gprs_reg_num_out(thread_lane_id_i)   <= (others => '0');
					gprs_lane_id_out(thread_lane_id_i)   <= warp_lane_id_i(1 downto 0);
					--gprs_wr_en_out(thread_lane_id_i)     <= '1';
					gprs_wr_data_out(thread_lane_id_i)   <= thread_id_i;
					if (flag = '0') then
						smp_cntlr_state_machine <= CALC_THREAD_IDS;
						gprs_wr_en_out(thread_lane_id_i)     <= '1';
					else
						smp_cntlr_state_machine <= CALC_THREAD_IDS_BLOCK_INC;
						gprs_wr_en_out(thread_lane_id_i)     <= '0';
					end if;
				
				when WARP_GEN_WAIT =>
					warp_generator_en <= '0';
					if (warp_generator_done = '1') then
						smp_configuration_en    <= '0';
						smp_cntlr_state_machine <= WARP_SCHED_WAIT;
					end if;
				
				when WARP_SCHED_WAIT =>
					smp_configuration_en <= '0';
					smp_done             <= '0';

					if (warp_scheduler_done = '1') then
						smp_configuration_en    <= '1';
						smp_done                <= '1';
						smp_cntlr_state_machine <= IDLE;
					end if;
			-- when others =>
			--	smp_cntlr_state_machine <= IDLE;
			end case;
		end if;
	end process;

	uBlockIdCalc : block_id_calc
		port map(
			clk            => clk_in,
			en             => block_id_calc_en,
			block_idx_in   => block_idx_in,
			grid_x_in      => grid_x_in,
			idx_in         => idx_i,
			block_id_x_out => block_id_x_o,
			block_id_y_out => block_id_y_o,
			valid          => block_id_calc_valid
		);

	uWarpsPerBlock : warps_per_block_calc
		port map(
			clk                  => clk_in,
			en                   => warps_per_block_en,
			threads_per_block_in => threads_per_block_in,
			warp_size_in         => WARP_SIZE,
			warps_per_block_out  => warps_per_block_o,
			data_valid_out       => warps_per_block_dv
		);

	uThreadIdCalc : thread_id_calc
		port map(
			clk                => clk_in,
			en                 => thread_id_calc_en,
			block_x_in         => block_x_in,
			block_y_in         => block_y_in,
			block_z_in         => block_z_in,
			num_cores_in       => std_logic_vector(to_unsigned(CORES, 8)),
			warp_size_in       => WARP_SIZE,
			warps_per_block_in => warps_per_block_i,
			block_indx_in      => idx_i,
			x_indx_in          => x_indx_i,
			y_indx_in          => y_indx_i,
			z_indx_in          => z_indx_i,
			thread_id_out      => thread_id_o,
			thread_lane_id_out => thread_lane_id_o,
			warp_id_out        => warp_id_o,
			warp_lane_id_out   => warp_lane_id_o,
			data_valid         => thread_id_calc_dv
		);
end arch;

