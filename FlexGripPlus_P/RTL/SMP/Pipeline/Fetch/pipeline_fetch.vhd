----------------------------------------------------------------------------------
-- Company:          Univerity of Massachusetts 
-- Engineer:         Kevin Andryc
-- 
-- Create Date:      17:50:27 09/19/2010  
-- Module Name:      pipeline_fetch - arch 
-- Project Name:     GPGPU
-- Target Devices: 
-- Tool versions:    ISE 10.1
-- Description: 
--      This module fetches instructions from the main memory.
--      Note: The instructions are stored in little-endian format.
--            For example: 0xaabbccdd is stored as
--                         mem[0] <= "dd"
--                         mem[1] <= "cc"
--                         mem[2] <= "bb"
--                         mem[3] <= "aa"
----------------------------------------------------------------------------
-- Revisions:       
--  REV:        Date:           Description:
--  0.1.a       9/13/2010       Created Top level file
----------------------------------------------------------------------------
-- [Boyang Du] [TODO]
-- 1. [DONE] Change sync reset to async
-- 2. [FIXME] DONE/STALL state is wasting 1-2 clock cycles
----------------------------------------------------------------------------
-- COMPLETELY REVISED GIANLUCA ROASCIO 
-- Changed instruction memory width from 8 to 32 bits
----------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.gpgpu_package.all;

entity pipeline_fetch is
	generic(
		MEM_ADDR_SIZE   : integer := 32;
		SHMEM_ADDR_SIZE : integer := 14
	);
	port(
		reset               : in  std_logic;
		clk_in              : in  std_logic;
		
		fetch_en            : in  std_logic;
		pass_en             : in  std_logic;
		pipeline_stall_in   : in  std_logic;
		
		program_cntr_in     : in  std_logic_vector(31 downto 0);
		warp_id_in          : in  std_logic_vector(4 downto 0);
		warp_lane_id_in     : in  std_logic_vector(1 downto 0);
		cta_id_in           : in  std_logic_vector(3 downto 0);
		initial_mask_in     : in  std_logic_vector(31 downto 0);
		current_mask_in     : in  std_logic_vector(31 downto 0);
		
		shmem_base_addr_in  : in  std_logic_vector(SHMEM_ADDR_SIZE - 1 downto 0);
		gprs_size_in        : in  std_logic_vector(8 downto 0);
		gprs_base_addr_in   : in  std_logic_vector(8 downto 0);
		--mem_wr_data_a_out   : out std_logic_vector(7 downto 0);
		--mem_addr_a_out      : out std_logic_vector(MEM_ADDR_SIZE - 1 downto 0);
		mem_addr_out        : out std_logic_vector(MEM_ADDR_SIZE - 1 downto 0);
		--mem_wr_en_a_out     : out std_logic;
		--mem_rd_data_a_in    : in  std_logic_vector(SYSMEM_DATA_SIZE-1 downto 0);
		mem_rd_data_in      : in  std_logic_vector(SYSMEM_DATA_SIZE-1 downto 0);
		--mem_wr_data_b_out   : out std_logic_vector(7 downto 0);
		--mem_addr_b_out      : out std_logic_vector(MEM_ADDR_SIZE - 1 downto 0);
		--mem_wr_en_b_out     : out std_logic;
		--mem_rd_data_b_in    : in  std_logic_vector(7 downto 0);
		
		program_cntr_out    : out std_logic_vector(31 downto 0);
		warp_id_out         : out std_logic_vector(4 downto 0);
		warp_lane_id_out    : out std_logic_vector(1 downto 0);
		cta_id_out          : out std_logic_vector(3 downto 0);
		initial_mask_out    : out std_logic_vector(31 downto 0);
		current_mask_out    : out std_logic_vector(31 downto 0);
		shmem_base_addr_out : out std_logic_vector(SHMEM_ADDR_SIZE - 1 downto 0);
		gprs_size_out       : out std_logic_vector(8 downto 0);
		gprs_base_addr_out  : out std_logic_vector(8 downto 0);
		next_pc_out         : out std_logic_vector(31 downto 0);
		instruction_out     : out std_logic_vector(63 downto 0);
		
		pipeline_stall_out  : out std_logic;
		pipeline_fetch_done : out std_logic
	);
end pipeline_fetch;

architecture arch of pipeline_fetch is
	
	--type fetch_state_type is (IDLE, READ_BYTES_0_1, READ_BYTES_2_3, READ_BYTES_4_5, READ_BYTES_6_7, STALL);
	type fetch_state_type is (IDLE, READ_FIRST_HALF, READ_SECOND_HALF, STALL);
	signal fetch_state_machine : fetch_state_type;

	--signal long_instruction_en : std_logic;
	
	signal instruction_i 	: std_logic_vector(63 downto 0);
	signal next_pc_i 		: std_logic_vector(31 downto 0);
	
	
begin
	
	
	--mem_wr_en_a_out 	<= '0';		-- fixed to 0, as read only access to memory
	--mem_wr_en_b_out     <= '0';     -- fixed to 0, as read only access to memory
	--mem_wr_data_a_out   <= (others => '0');
	--mem_wr_data_b_out   <= (others => '0');
			
	-- Memory Fetch State Machine
	pPipelineFetchStateMachine : process(clk_in, reset)
	begin
		if (reset = '1') then
			--mem_addr_a_out      <= (others => '0');
			--mem_addr_b_out      <= (others => '0');
			mem_addr_out      <= (others => '0');
			next_pc_out         <= (others => '0');
			program_cntr_out    <= (others => '0');
			warp_id_out         <= (others => '0');
			warp_lane_id_out    <= (others => '0');
			cta_id_out          <= (others => '0');
			initial_mask_out    <= (others => '0');
			current_mask_out    <= (others => '0');
			shmem_base_addr_out <= (others => '0');
			gprs_size_out       <= (others => '0');
			gprs_base_addr_out  <= (others => '0');
			next_pc_out         <= (others => '0');
			instruction_out     <= (others => '0');
			next_pc_i		    <= (others => '0');
			
			--long_instruction_en <= '0';
			pipeline_stall_out  <= '0';
			pipeline_fetch_done     <= '0';
			instruction_i <= (others => '0');
			fetch_state_machine <= IDLE;
		elsif (rising_edge(clk_in)) then
			case fetch_state_machine is
				when IDLE =>
					--long_instruction_en 	<= '0';
					pipeline_fetch_done     <= '0';
					if(fetch_en = '1') then
						--mem_addr_a_out      <= program_cntr_in(MEM_ADDR_SIZE - 1 downto 0);
						--mem_addr_b_out      <= std_logic_vector(unsigned(program_cntr_in(MEM_ADDR_SIZE - 1 downto 0)) + 1);
						mem_addr_out        <= "00" & program_cntr_in(MEM_ADDR_SIZE - 1 downto 2);
						pipeline_stall_out  <= '1';
						--fetch_state_machine <= READ_BYTES_0_1;
						fetch_state_machine <= READ_FIRST_HALF;
					elsif(pass_en = '1') then  -- [TODO] What is 'pass' for
						pipeline_stall_out  <= '1';
						fetch_state_machine <= STALL;
					else
						pipeline_stall_out  <= '0';
						fetch_state_machine <= IDLE;	
					end if;
				when READ_FIRST_HALF =>
					instruction_i(63 downto 32) <= (others => '0');			-- linea no necesaria
					instruction_i(31 downto 0)  <= mem_rd_data_in;
					mem_addr_out                <= std_logic_vector(unsigned(mem_addr_out(MEM_ADDR_SIZE - 1 downto 0)) + 1);
					if (mem_rd_data_in(0) = '1') then -- long instruction
						next_pc_i         	<= std_logic_vector(unsigned(program_cntr_in) + 8);
						fetch_state_machine <= READ_SECOND_HALF;
					else
						next_pc_i        	<= std_logic_vector(unsigned(program_cntr_in) + 4);
						-- The fetch is done here
						fetch_state_machine <= STALL;
					end if;
				when READ_SECOND_HALF =>
					instruction_i(63 downto 32) <= mem_rd_data_in;
					-- The fetch is done here
					fetch_state_machine <= STALL;

				--when READ_BYTES_0_1 =>
				--	instruction_i(63 downto 32) <= (others => '0');			-- linea no necesaria
				--	instruction_i(7 downto 0)   <= mem_rd_data_a_in;
				--	instruction_i(15 downto 8)  <= mem_rd_data_b_in;
				--	mem_addr_a_out                <= std_logic_vector(unsigned(program_cntr_in(MEM_ADDR_SIZE - 1 downto 0)) + 2);
				--	mem_addr_b_out                <= std_logic_vector(unsigned(program_cntr_in(MEM_ADDR_SIZE - 1 downto 0)) + 3);
				--	long_instruction_en           <= mem_rd_data_a_in(0);
				--	fetch_state_machine           <= READ_BYTES_2_3;
				--when READ_BYTES_2_3 =>
				--	instruction_i(63 downto 32) <= (others => '0');
				--	instruction_i(23 downto 16) <= mem_rd_data_a_in;
				--	instruction_i(31 downto 24) <= mem_rd_data_b_in;
				--	if (long_instruction_en = '1') then -- long instruction
				--		mem_addr_a_out      <= std_logic_vector(unsigned(program_cntr_in(MEM_ADDR_SIZE - 1 downto 0)) + 4);
				--		mem_addr_b_out      <= std_logic_vector(unsigned(program_cntr_in(MEM_ADDR_SIZE - 1 downto 0)) + 5);
				--		next_pc_i         	<= std_logic_vector(unsigned(program_cntr_in) + 8);
				--		fetch_state_machine <= READ_BYTES_4_5;
				--	else
				--		next_pc_i        	<= std_logic_vector(unsigned(program_cntr_in) + 4);
				--		-- The fetch is done here
				--		fetch_state_machine <= STALL;
				--	end if;
				--when READ_BYTES_4_5 =>
				--	instruction_i(39 downto 32) <= mem_rd_data_a_in;
				--	instruction_i(47 downto 40) <= mem_rd_data_b_in;
				--	mem_addr_a_out                <= std_logic_vector(unsigned(program_cntr_in(MEM_ADDR_SIZE - 1 downto 0)) + 6);
				--	mem_addr_b_out                <= std_logic_vector(unsigned(program_cntr_in(MEM_ADDR_SIZE - 1 downto 0)) + 7);
				--	fetch_state_machine           <= READ_BYTES_6_7;
				--when READ_BYTES_6_7 =>
				--	instruction_i(55 downto 48) <= mem_rd_data_a_in;
				--	instruction_i(63 downto 56) <= mem_rd_data_b_in;
				--	-- The fetch is done here
				--	fetch_state_machine <= STALL;
				when STALL =>  -- state to check stall status
					-- The first entry of this state is when data is ready in instruction_i and next_pc_i
					if(pipeline_stall_in = '0') then
						-- NO STALL, register all data to output
						program_cntr_out    <= program_cntr_in;
						warp_id_out         <= warp_id_in;
						warp_lane_id_out    <= warp_lane_id_in;
						cta_id_out          <= cta_id_in;
						initial_mask_out    <= initial_mask_in;
						current_mask_out    <= current_mask_in;
						shmem_base_addr_out <= shmem_base_addr_in;
						gprs_size_out       <= gprs_size_in;
						gprs_base_addr_out  <= gprs_base_addr_in;
						
						instruction_out 	<= instruction_i;
						next_pc_out 		<= next_pc_i;
						pipeline_fetch_done <= '1';		-- signal next stage
						pipeline_stall_out  <= '0'; 	-- signal previous stage
						fetch_state_machine <= IDLE;  	-- multi-cycle stage, set stall out (GO BACK TO IDLE) to release previous stage
					else
						pipeline_fetch_done <= '0';
						pipeline_stall_out  <= '1';
						fetch_state_machine <= STALL;
					end if;
				--when others =>
				--	fetch_state_machine <= IDLE;
			end case;
		end if;
	end process;

end arch;

