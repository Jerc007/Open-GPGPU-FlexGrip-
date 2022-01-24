----------------------------------------------------------------------------------
-- Company:          Univerity of Massachusetts 
-- Engineer:         Kevin Andryc
-- 
-- Create Date:      17:50:27 09/19/2010  
-- Module Name:      warp_generator - arch 
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

entity warp_generator is
	generic(SHMEM_ADDR_SIZE : integer := 14 );
	port(
		clk_in                  : in  std_logic;
		host_reset              : in  std_logic;
		en                      : in  std_logic;
		num_blocks_in           : in  std_logic_vector(3 downto 0);
		warps_per_block_in      : in  std_logic_vector(5 downto 0);
		shmem_base_addr_in      : in  std_logic_vector(31 downto 0);
		shmem_size_in           : in  std_logic_vector(31 downto 0);
		gprs_size_in            : in  std_logic_vector(8 downto 0);
		
		warp_pool_addr_out      : out std_logic_vector(4 downto 0);
		warp_pool_wr_en_out     : out std_logic;
		warp_pool_wr_data_out   : out std_logic_vector(127 downto 0);
		warp_state_addr_out     : out std_logic_vector(4 downto 0);
		warp_state_wr_en_out    : out std_logic;
		warp_state_wr_data_out  : out std_logic_vector(1 downto 0);
		
		fence_regs_cta_id_out   : out fence_regs_vector_array;
		fence_regs_cta_id_ld    : out fence_regs_std_array;
		fence_regs_fence_en_out : out fence_regs_std_array;
		fence_regs_fence_en_ld  : out fence_regs_std_array;
		num_warps_out           : out std_logic_vector(4 downto 0);
		warp_gen_done			: out std_logic
	);
end warp_generator;

architecture arch of warp_generator is
	type warp_generator_state_type is (IDLE, CALC_WARP_ID, CALC_WARP_ID_WAIT, WRITE_WARP, WARP_GEN_COMPLETE);
	signal warp_generator_state_machine : warp_generator_state_type;

	constant use_npc      : std_logic                     := '0';
	constant initial_mask : std_logic_vector(31 downto 0) := x"FFFFFFFF";
	constant current_mask : std_logic_vector(31 downto 0) := x"FFFFFFFF";
	constant next_pc      : std_logic_vector(31 downto 0) := x"00000000";

	signal block_num_cnt       : std_logic_vector(3 downto 0);
	signal warps_per_block_cnt : std_logic_vector(11 downto 0);

	signal warp_id_calc_en_i : std_logic;
	signal block_num_i       : std_logic_vector(3 downto 0);
	signal shmem_addr_i      : std_logic_vector(35 downto 0);
	signal warp_num_i        : std_logic_vector(4 downto 0);
	signal warp_id_calc_dv_o : std_logic;
	signal gprs_base_addr_o  : std_logic_vector(8 downto 0);
	signal warp_id_o         : std_logic_vector(4 downto 0);

	signal warp_id_addr : integer range 0 to MAX_WARPS;
	
	
begin
	
	
	pWarpGeneratorStateMachine : process(clk_in, host_reset)
	begin
		if (host_reset = '1') then
			warp_pool_wr_en_out          <= '0';
			warp_pool_addr_out           <= (others => '0');
			warp_pool_wr_data_out        <= (others => '0');
			warp_state_wr_data_out       <= (others => '0');
			warp_state_addr_out          <= (others => '0');
			warp_state_wr_en_out         <= '0';
			block_num_cnt                <= (others => '0');
			warps_per_block_cnt          <= (others => '0');
			block_num_i                  <= (others => '0');
			warp_num_i                   <= (others => '0');
			warp_id_calc_en_i            <= '0';
			num_warps_out                <= (others => '0');
			warp_gen_done                         <= '0';
			warp_generator_state_machine <= IDLE;
		elsif (rising_edge(clk_in)) then
			case warp_generator_state_machine is
				when IDLE =>
					warp_pool_wr_en_out <= '0';
					warp_pool_addr_out      <= (others => '0');
					warp_pool_wr_data_out   <= (others => '0');
					warp_state_wr_data_out  <= (others => '0');
					warp_state_addr_out     <= (others => '0');
					warp_state_wr_en_out <= '0';
					fence_regs_cta_id_out   <= (others => (others => '0'));
					fence_regs_cta_id_ld    <= (others => '0');
					fence_regs_fence_en_out <= (others => '0');
					fence_regs_fence_en_ld  <= (others => '0');
					block_num_cnt           <= (others => '0');
					warps_per_block_cnt     <= (others => '0');
					block_num_i             <= (others => '0');
					warp_num_i              <= (others => '0');
					shmem_addr_i            <= (others => '0');
					warp_id_calc_en_i       <= '0';
					warp_gen_done                    <= '0';
					if(en = '1') then
						warp_generator_state_machine <= CALC_WARP_ID;			-- define of warp ID:
					end if;
				when CALC_WARP_ID =>
					warp_pool_wr_en_out <= '0';
					warp_state_wr_en_out <= '0';
					fence_regs_cta_id_out   <= (others => (others => '0'));
					fence_regs_cta_id_ld    <= (others => '0');
					fence_regs_fence_en_out <= (others => '0');
					fence_regs_fence_en_ld  <= (others => '0');
					if (unsigned(block_num_cnt) < unsigned(num_blocks_in)) then			-- checking the limit of block in the config of SMP.
						if (unsigned(warps_per_block_cnt) < unsigned(warps_per_block_in)) then		-- checking the limit warps per block.
							block_num_i                  <= block_num_cnt;
							shmem_addr_i                 <= std_logic_vector(unsigned(shmem_base_addr_in) + (unsigned(block_num_cnt) * unsigned(shmem_size_in)));
							warp_num_i                   <= warps_per_block_cnt(4 downto 0);
							warp_id_calc_en_i            <= '1';
							warps_per_block_cnt          <= std_logic_vector(unsigned(warps_per_block_cnt) + 1);
							warp_generator_state_machine <= CALC_WARP_ID_WAIT;
						else
							warps_per_block_cnt <= (others => '0');
							block_num_cnt       <= std_logic_vector(unsigned(block_num_cnt) + 1);
						end if;
					else
						warp_generator_state_machine <= WARP_GEN_COMPLETE;
					end if;
				when CALC_WARP_ID_WAIT =>
					warp_id_calc_en_i <= '0';
					if (warp_id_calc_dv_o = '1') then
						warp_id_addr                 <= to_integer(unsigned(warp_id_o));
						warp_generator_state_machine <= WRITE_WARP;
					end if;						
					-- Definition of a warp pool line (includes the characteristics of a the mask ID, the address warp ID and the Divergence mask)
				when WRITE_WARP =>                       --              14 (123 - 110)            4 (109-106)    9 (105-97)       1 (96)  32 (95-64) 32 (63-32)       32 (31-0)
					warp_pool_wr_data_out <= "0000" & shmem_addr_i(SHMEM_ADDR_SIZE - 1 downto 0) & block_num_i & gprs_base_addr_o & use_npc & next_pc & initial_mask & current_mask;
					warp_pool_addr_out                    <= warp_id_o;
					warp_pool_wr_en_out  <= '1';
					warp_state_wr_data_out                <= "00";    -- READY state
					warp_state_addr_out                   <= warp_id_o;
					warp_state_wr_en_out <= '1';
					fence_regs_cta_id_out(warp_id_addr)   <= block_num_i;
					fence_regs_cta_id_ld(warp_id_addr)    <= '1';
					fence_regs_fence_en_out(warp_id_addr) <= '0';
					fence_regs_fence_en_ld(warp_id_addr)  <= '1';
					warp_generator_state_machine          <= CALC_WARP_ID;
				when WARP_GEN_COMPLETE =>
					num_warps_out                  <= std_logic_vector(unsigned(warp_id_o) + 1);
					warp_gen_done                  <= '1';
					warp_generator_state_machine <= IDLE;
			--when others =>
			-- 	warp_generator_state_machine <= IDLE;
			end case;
		end if;
	end process;

	uWarpIdCalc : warp_id_calc
		port map(
			clk                => clk_in,
			reset              => host_reset,
			en                 => warp_id_calc_en_i,
			block_num_in       => block_num_i,
			gprs_size_in       => gprs_size_in,
			warp_num_in        => warp_num_i,
			warps_per_block_in => warps_per_block_in,
			data_valid_out     => warp_id_calc_dv_o,
			warp_id_out        => warp_id_o,
			gprs_base_addr_out => gprs_base_addr_o
		);
		
		
end arch;

