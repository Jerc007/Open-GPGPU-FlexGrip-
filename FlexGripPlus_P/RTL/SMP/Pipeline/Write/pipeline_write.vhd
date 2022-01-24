----------------------------------------------------------------------------------
-- Company:          Univerity of Massachusetts 
-- Engineer:         Kevin Andryc
-- 
-- Create Date:      17:50:27 09/19/2010  
-- Module Name:      pipeline_write - arch 
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

entity pipeline_write is
	generic(
		SHMEM_ADDR_SIZE : integer := 14;				-- Shared Mem.
		GMEM_ADDR_SIZE  : integer := 18					-- Global Mem
	);
	port(
		reset                      : in  std_logic;
		clk_in                     : in  std_logic;
		pipeline_execute_done      : in  std_logic;
		pipeline_stall_in          : in  std_logic;
		warp_id_in                 : in  std_logic_vector(4 downto 0);
		warp_lane_id_in            : in  std_logic_vector(1 downto 0);
		cta_id_in                  : in  std_logic_vector(3 downto 0);
		initial_mask_in            : in  std_logic_vector(31 downto 0);
		current_mask_in            : in  std_logic_vector(31 downto 0);
		shmem_base_addr_in         : in  std_logic_vector(SHMEM_ADDR_SIZE - 1 downto 0);
		gprs_base_addr_in          : in  std_logic_vector(8 downto 0);
		next_pc_in                 : in  std_logic_vector(31 downto 0);
		warp_state_in              : in  warp_state_type;
		instr_opcode_in            : in  instr_opcode_type;
		temp_vector_register_in    : in  temp_vector_register;
		dest_in                    : in  std_logic_vector(31 downto 0);
		instruction_mask_in        : in  std_logic_vector(31 downto 0);
		instruction_flags_in       : in  vector_flag_register;
		dest_data_type_in          : in  data_type;
		dest_mem_type_in           : in  mem_type;
		dest_mem_opcode_in         : in  mem_opcode_type;
		addr_hi_in                 : in  std_logic;
		addr_lo_in                 : in  std_logic_vector(1 downto 0);
		addr_imm_in                : in  std_logic;
		addr_inc_in                : in  std_logic;
		mov_size_in                : in  std_logic_vector(2 downto 0);
		write_pred_in              : in  std_logic;
		set_pred_in                : in  std_logic;
		set_pred_reg_in            : in  std_logic_vector(1 downto 0);
		sm_type_in                 : in  std_logic_vector(1 downto 0);
		gprs_base_addr_out         : out gprs_addr_array;
		gprs_reg_num_out           : out gprs_reg_array;
		gprs_lane_id_out           : out warp_lane_id_array;
		gprs_wr_en_out             : out wr_en_array;
		gprs_wr_data_out           : out vector_register;
		gprs_rd_data_in            : in  vector_register;
		pred_regs_warp_id_out      : out warp_id_array;
		pred_regs_warp_lane_id_out : out warp_lane_id_array;
		pred_regs_reg_num_out      : out reg_num_array;
		pred_regs_wr_en_out        : out wr_en_array;
		pred_regs_wr_data_out      : out vector_flag_register;
		pred_regs_rd_data_in       : in  vector_flag_register;
		addr_regs_warp_id_out      : out warp_id_array;
		addr_regs_warp_lane_id_out : out warp_lane_id_array;
		addr_regs_reg_num_out      : out reg_num_array;
		addr_regs_wr_en_out        : out wr_en_array;
		addr_regs_wr_data_out      : out vector_register;
		addr_regs_rd_data_in       : in  vector_register;
		shmem_addr_out             : out std_logic_vector(SHMEM_ADDR_SIZE - 1 downto 0);
		shmem_wr_en_out            : out std_logic;
		shmem_wr_data_out          : out std_logic_vector(7 downto 0);
		shmem_rd_data_in           : in  std_logic_vector(7 downto 0);
		gmem_addr_out              : out std_logic_vector(GMEM_ADDR_SIZE - 1 downto 0);
		gmem_wr_en_out             : out std_logic;
		gmem_wr_data_out           : out std_logic_vector(7 downto 0);
		gmem_rd_data_in            : in  std_logic_vector(7 downto 0);
		warp_id_out                : out std_logic_vector(4 downto 0);
		warp_lane_id_out           : out std_logic_vector(1 downto 0);
		cta_id_out                 : out std_logic_vector(3 downto 0);
		initial_mask_out           : out std_logic_vector(31 downto 0);
		current_mask_out           : out std_logic_vector(31 downto 0);
		shmem_base_addr_out        : out std_logic_vector(SHMEM_ADDR_SIZE - 1 downto 0);
		gprs_addr_out              : out std_logic_vector(8 downto 0);
		next_pc_out                : out std_logic_vector(31 downto 0);
		warp_state_out             : out warp_state_type;
		pipeline_stall_out         : out std_logic;
		pipeline_write_done        : out std_logic
	);
end pipeline_write;

architecture arch of pipeline_write is
	type write_state_type is (IDLE, 
							  WRITE_GPRS, 
							  WRITE_SHMEM, 
							  WRITE_GMEM, 
							  WRITE_LMEM, 
							  WRITE_ADDR, 
							  CHECK_PRED_REGS, 
							  COMPUTE_PRED_REGS, 
							  WRITE_PRED_REGS, 
							  CHECK_INCREMENT_ADDR, 
							  INCREMENT_ADDR,
							  DONE
	);
	signal write_state_machine : write_state_type;

	signal addr_imm_i : std_logic;

	signal inc_addr_en_i        : std_logic;
	signal inc_addr_reg_i       : std_logic_vector(1 downto 0);
	signal inc_addr_data_type_i : data_type;
	signal inc_addr_mask_i      : std_logic_vector(CORES - 1 downto 0);
	signal inc_addr_imm_i       : std_logic_vector(31 downto 0);
	signal inc_addr_rdy_o       : std_logic;

	signal compute_pred_data_i      : vector_register;
	signal compute_pred_flags_i     : vector_flag_register;
	signal compute_pred_data_type_i : data_type;
	signal compute_pred_flags_o     : vector_flag_register;

	signal gprs_en_i        : std_logic;
	signal gprs_reg_num_i   : std_logic_vector(8 downto 0);
	signal gprs_wr_data_i   : vector_word_register_array;
	signal gprs_data_type_i : data_type;
	signal gprs_mask_i      : std_logic_vector(CORES - 1 downto 0);
	signal gprs_rd_wr_en_i  : std_logic;
	signal gprs_rd_data_o   : vector_word_register_array;
	signal gprs_rdy_o       : std_logic;

	signal write_gprs_en        : std_logic;
	signal write_gprs_reg_num   : std_logic_vector(8 downto 0);
	signal write_gprs_wr_data   : vector_word_register_array;
	signal write_gprs_data_type : data_type;
	signal write_gprs_mask      : std_logic_vector(CORES - 1 downto 0);
	signal write_gprs_rd_wr_en  : std_logic;
	--signal write_gprs_rd_data   : vector_word_register_array; -- REMOVED GIANLUCA ROASCIO
	signal write_gprs_rdy       : std_logic;

	signal shmem_gprs_en        : std_logic;
	signal shmem_gprs_reg_num   : std_logic_vector(8 downto 0);
	-- signal shmem_gprs_wr_data   : vector_word_register_array;
	signal shmem_gprs_data_type : data_type;
	signal shmem_gprs_rd_data   : vector_word_register_array;
	signal shmem_gprs_rdy       : std_logic;

	signal gmem_gprs_en        : std_logic;
	signal gmem_gprs_reg_num   : std_logic_vector(8 downto 0);
	-- signal gmem_gprs_wr_data   : vector_word_register_array;
	signal gmem_gprs_data_type : data_type;
	signal gmem_gprs_rd_data   : vector_word_register_array;
	signal gmem_gprs_rdy       : std_logic;

	signal addr_regs_en_i       : std_logic;
	signal addr_regs_reg_num_i  : std_logic_vector(1 downto 0);
	signal addr_regs_wr_data_i  : vector_register;
	signal addr_regs_mask_i     : std_logic_vector(CORES - 1 downto 0);
	signal addr_regs_rd_wr_en_i : std_logic;
	signal addr_regs_rd_data_o  : vector_register;
	signal addr_regs_rdy_o      : std_logic;

	signal write_addr_regs_en       : std_logic;
	signal write_addr_regs_reg_num  : std_logic_vector(1 downto 0);
	signal write_addr_regs_wr_data  : vector_register;
	signal write_addr_regs_mask     : std_logic_vector(CORES - 1 downto 0);
	signal write_addr_regs_rd_wr_en : std_logic;
	--signal write_addr_regs_rd_data  : vector_register; -- REMOVED GIANLUCA ROASCIO
	signal write_addr_regs_rdy      : std_logic;

	signal inc_addr_regs_en       : std_logic;
	signal inc_addr_regs_reg_num  : std_logic_vector(1 downto 0);
	signal inc_addr_regs_wr_data  : vector_register;
	signal inc_addr_regs_mask     : std_logic_vector(CORES - 1 downto 0);
	signal inc_addr_regs_rd_wr_en : std_logic;
	signal inc_addr_regs_rd_data  : vector_register;
	signal inc_addr_regs_rdy      : std_logic;

	signal shmem_addr_regs_en      : std_logic;
	signal shmem_addr_regs_reg_num : std_logic_vector(1 downto 0);
	signal shmem_addr_regs_rd_data : vector_register;
	signal shmem_addr_regs_rdy     : std_logic;

	signal gmem_addr_regs_en      : std_logic;
	signal gmem_addr_regs_reg_num : std_logic_vector(1 downto 0);
	signal gmem_addr_regs_rd_data : vector_register;
	signal gmem_addr_regs_rdy     : std_logic;

	signal pred_regs_en_i       : std_logic;
	signal pred_regs_num_i      : std_logic_vector(1 downto 0);
	signal pred_regs_wr_data_i  : vector_flag_register;
	signal pred_regs_mask_i     : std_logic_vector(CORES - 1 downto 0);
	signal pred_regs_rd_wr_en_i : std_logic;
	--signal pred_regs_rd_data_o  : vector_flag_register; -- REMOVED GIANLUCA ROASCIO
	signal pred_regs_rdy_o      : std_logic;

	signal shmem_en_i         : std_logic;
	signal shmem_wr_data_i    : vector_word_register_array;
	signal shmem_addr_i       : std_logic_vector(31 downto 0);
	signal shmem_rd_wr_type_i : mem_opcode_type;
	signal shmem_sm_type_i    : sm_type;
	signal shmem_mask_i       : std_logic_vector(CORES - 1 downto 0);
	--signal shmem_rd_data_o    : vector_word_register_array; -- REMOVED GIANLUCA ROASCIO
	signal shmem_rdy_o        : std_logic;

	signal gmem_en_i         : std_logic;
	signal gmem_wr_data_i    : vector_word_register_array;
	signal gmem_addr_i       : std_logic_vector(31 downto 0);
	signal gmem_rd_wr_type_i : mem_opcode_type;
	signal gmem_data_type_i  : data_type;
	signal gmem_mask_i       : std_logic_vector(CORES - 1 downto 0);
	--signal gmem_rd_data_o    : vector_word_register_array; -- REMOVED GIANLUCA ROASCIO
	signal gmem_rdy_o        : std_logic;

	signal mask_i : std_logic_vector(CORES - 1 downto 0);

	signal mv_size_to_sm_type_o   : sm_type;
	signal mv_size_to_data_type_o : data_type;
	signal sm_type_to_data_type_o : data_type;

	signal write_select : std_logic_vector(2 downto 0);

	signal data_type_in : data_type;
	
begin

	inc_addr_reg_i <= (others => '0');

	pPipelineWrite : process(clk_in, reset)
	begin
		if (reset = '1') then
			addr_imm_i           <= '0';
			inc_addr_en_i        <= '0';
			inc_addr_mask_i      <= (others => '0');
			inc_addr_imm_i       <= (others => '0');
			compute_pred_data_i  <= (others => (others => '0'));
			compute_pred_flags_i <= (others => (others => '0'));
			pred_regs_en_i       <= '0';
			pred_regs_num_i      <= (others => '0');
			pred_regs_wr_data_i  <= (others => (others => '0'));
			pred_regs_mask_i     <= (others => '0');
			pred_regs_rd_wr_en_i <= '0';
			write_select         <= (others => '0');
			pipeline_write_done  <= '0';
			pipeline_stall_out   <= '0';
			write_state_machine  <= IDLE;
			warp_id_out          <= (others => '0');
			warp_lane_id_out     <= (others => '0');
			cta_id_out           <= (others => '0');
			initial_mask_out     <= (others => '0');
			current_mask_out     <= (others => '0');
			shmem_base_addr_out  <= (others => '0');
			gprs_addr_out        <= (others => '0');
			next_pc_out          <= (others => '0');
			warp_state_out       <= READY;

			shmem_en_i         <= '0';
			shmem_wr_data_i    <= (others => (others => (others => '0')));
			shmem_addr_i       <= (others => '0');
			shmem_rd_wr_type_i <= READ;
			shmem_sm_type_i    <= SM_NONE;
			shmem_mask_i       <= (others => '0');

			gmem_en_i         <= '0';
			gmem_mask_i       <= (others => '0');
			gmem_wr_data_i    <= (others => (others => (others => '0')));
			gmem_addr_i       <= (others => '0');
			gmem_rd_wr_type_i <= READ;
			gmem_data_type_i  <= DT_UNKNOWN;

			write_gprs_en       <= '0';
			write_gprs_wr_data  <= (others => (others => (others => '0')));
			write_gprs_rd_wr_en <= '0';
			write_gprs_mask     <= (others => '0');
			write_gprs_reg_num  <= (others => '0');

			write_addr_regs_en       <= '0';
			write_addr_regs_reg_num  <= (others => '0');
			write_addr_regs_wr_data  <= (others => (others => '0'));
			write_addr_regs_mask     <= (others => '0');
			write_addr_regs_rd_wr_en <= '0';

		elsif (rising_edge(clk_in)) then
			case write_state_machine is
				when IDLE =>
					pipeline_write_done <= '0';
					write_addr_regs_en  <= '0';
					write_gprs_en       <= '0';
					shmem_en_i          <= '0';
					gmem_en_i           <= '0';
					if(pipeline_execute_done = '1') then
						pipeline_stall_out <= '1';
						addr_imm_i         <= addr_imm_in;
						if ((instr_opcode_in = NOP) or (dest_data_type_in = DT_NONE) or (dest_mem_type_in = UNKNOWN)) then -- decode the type of ins.
							write_state_machine <= CHECK_PRED_REGS;
						elsif (dest_mem_type_in = REG) then
							write_gprs_en       <= '1';							-- habilita la escritura sobre el vector de registros.
							write_gprs_reg_num  <= dest_in(8 downto 0);			-- define la direccion de escritura de acuerdo con la instruccion.
							write_gprs_rd_wr_en <= '1';							-- prepara la escritura del vector de registros.
							for i in 0 to CORES - 1 loop						-- no dedundante. opera en modo SIMD.
								write_gprs_wr_data(i) <= temp_vector_register_in(i)(TEMP_REG_DEST);
							end loop;
							write_gprs_data_type <= dest_data_type_in;
							write_gprs_mask      <= mask_i;
							write_select         <= "000";						-- seleccion del multiplexor.
							write_state_machine  <= WRITE_GPRS;
						elsif (dest_mem_type_in = MEM_SHARED) then
							shmem_en_i <= '1';
							for i in 0 to CORES - 1 loop						-- data to be stored in the shared  mem.
								shmem_wr_data_i(i) <= temp_vector_register_in(i)(TEMP_REG_SRC3);
							end loop;
							shmem_rd_wr_type_i <= dest_mem_opcode_in;
							shmem_sm_type_i    <= mv_size_to_sm_type_o;
							shmem_mask_i       <= mask_i;
							addr_imm_i         <= addr_imm_in;
							if (addr_inc_in = '1') then						-- address of the shared memory.
								shmem_addr_i <= (others => '0');
							else
								shmem_addr_i <= dest_in;
							end if;
							write_select        <= "001";					-- seleccion delmultiplexor de salida del bus.
							write_state_machine <= WRITE_SHMEM;
						elsif (dest_mem_type_in = MEM_GLOBAL) then
							gmem_en_i <= '1';
							for i in 0 to CORES - 1 loop					-- data for glob mem.	
								gmem_wr_data_i(i) <= temp_vector_register_in(i)(TEMP_REG_DEST);
							end loop;
							gmem_addr_i         <= dest_in;
							gmem_rd_wr_type_i   <= dest_mem_opcode_in;
							gmem_data_type_i    <= mv_size_to_data_type_o;
							gmem_mask_i         <= mask_i;
							addr_imm_i          <= addr_imm_in;
							write_select        <= "010";					-- seleccion del multiplexor
							write_state_machine <= WRITE_GMEM;
						elsif (dest_mem_type_in = ADDRESS) then
							write_addr_regs_en       <= '1';
							write_addr_regs_reg_num  <= dest_in(1 downto 0);
							write_addr_regs_rd_wr_en <= '1';
							for i in 0 to CORES - 1 loop
								write_addr_regs_wr_data(i) <= temp_vector_register_in(i)(TEMP_REG_DEST)(0);			-- why tridimentions???
							end loop;
							write_addr_regs_mask <= mask_i;
							addr_imm_i           <= '1';
							write_select         <= "000";					-- seleccion del multiplexor de salida.
							write_state_machine  <= WRITE_ADDR;
						end if;
					else
						pipeline_stall_out <= '0';
					end if;

				when WRITE_GPRS =>
					write_gprs_en <= '0';
					if (write_gprs_rdy = '1') then
						write_gprs_rd_wr_en <= '0';							-- desactiva el proceso de escritura del dato sobre el vector de regs.
						write_state_machine <= CHECK_PRED_REGS;
					end if;

				when WRITE_SHMEM =>
					shmem_en_i <= '0';
					if (shmem_rdy_o = '1') then
						shmem_rd_wr_type_i  <= READ_GATHER;
						write_state_machine <= CHECK_PRED_REGS;
					end if;

				when WRITE_GMEM =>
					gmem_en_i <= '0';
					if (gmem_rdy_o = '1') then
						gmem_rd_wr_type_i   <= READ_GATHER;
						write_state_machine <= CHECK_PRED_REGS;
					end if;

				when WRITE_ADDR =>
					write_addr_regs_en <= '0';
					if (write_addr_regs_rdy = '1') then
						write_addr_regs_rd_wr_en <= '0';
						write_state_machine      <= CHECK_PRED_REGS;
					end if;

				when CHECK_PRED_REGS =>
					if (write_pred_in = '1') then
						for i in 0 to CORES - 1 loop
							compute_pred_data_i(i) <= temp_vector_register_in(i)(TEMP_REG_DEST)(0);
						end loop;
						compute_pred_flags_i     <= instruction_flags_in;
						compute_pred_data_type_i <= dest_data_type_in;
						write_state_machine      <= COMPUTE_PRED_REGS;
					else
						write_state_machine <= CHECK_INCREMENT_ADDR;
					end if;

				when COMPUTE_PRED_REGS =>
					if (set_pred_in = '1') then
						pred_regs_en_i       <= '1';
						pred_regs_num_i      <= set_pred_reg_in;
						pred_regs_wr_data_i  <= compute_pred_flags_o;
						pred_regs_mask_i     <= mask_i;
						pred_regs_rd_wr_en_i <= '1';
						write_state_machine  <= WRITE_PRED_REGS;
					else
						write_state_machine <= DONE;
					end if;

				when WRITE_PRED_REGS =>
					pred_regs_en_i <= '0';
					if (pred_regs_rdy_o = '1') then
						pred_regs_rd_wr_en_i <= '0';
						write_state_machine  <= CHECK_INCREMENT_ADDR;
					end if;

				when CHECK_INCREMENT_ADDR =>
					if (addr_inc_in = '1') then
						inc_addr_en_i <= '1';
						if (dest_mem_type_in = MEM_SHARED) then
							inc_addr_data_type_i <= mv_size_to_data_type_o;
							inc_addr_imm_i       <= dest_in;
						else
							inc_addr_data_type_i <= sm_type_to_data_type_o;
							inc_addr_imm_i       <= dest_in;
						end if;
						inc_addr_mask_i     <= mask_i;
						write_select        <= "101";
						write_state_machine <= INCREMENT_ADDR;
					else
						write_state_machine <= DONE;
					end if;

				when INCREMENT_ADDR =>
					inc_addr_en_i <= '0';
					if (inc_addr_rdy_o = '1') then
						write_state_machine <= DONE;
					end if;

				when DONE =>
					if (pipeline_stall_in = '0') then
						warp_id_out         <= warp_id_in;
						warp_lane_id_out    <= warp_lane_id_in;
						cta_id_out          <= cta_id_in;
						initial_mask_out    <= initial_mask_in;
						current_mask_out    <= current_mask_in;
						shmem_base_addr_out <= shmem_base_addr_in;
						gprs_addr_out       <= gprs_base_addr_in;
						next_pc_out         <= next_pc_in;
						warp_state_out      <= warp_state_in;
						pipeline_write_done <= '1';
						write_state_machine <= IDLE;
					end if;
				when OTHERS =>
					write_state_machine <= IDLE;
			end case;
		end if;
	end process;

	gMask8 : if (CORES = 8) generate
		pMask8 : process(warp_lane_id_in, instruction_mask_in)
		begin
			case warp_lane_id_in is
				when "00" =>
					mask_i(7 downto 0) <= instruction_mask_in(7 downto 0);
				when "01" =>
					mask_i(7 downto 0) <= instruction_mask_in(15 downto 8);
				when "10" =>
					mask_i(7 downto 0) <= instruction_mask_in(23 downto 16);
				when "11" =>
					mask_i(7 downto 0) <= instruction_mask_in(31 downto 24);
				when others =>
					mask_i(7 downto 0) <= instruction_mask_in(7 downto 0);
			end case;
		end process;
	end generate;

	gMask16 : if (CORES = 16) generate
		pMask16 : process(warp_lane_id_in, instruction_mask_in)
		begin
			case warp_lane_id_in is
				when "00" =>
					for i in 0 to CORES - 1 loop
						mask_i(i) <= instruction_mask_in(i);
					end loop;
				when "01" =>
					for i in 0 to CORES - 1 loop
						mask_i(i) <= instruction_mask_in(i + 16);
					end loop;
				when others =>
					for i in 0 to CORES - 1 loop
						mask_i(i) <= instruction_mask_in(i);
					end loop;
			end case;
		end process;
	end generate;

	gMask32 : if (CORES = 32) generate
		mask_i <= instruction_mask_in;
	end generate;

	uConvertDataTypes : convert_data_types
		port map(
			mov_size_in                => mov_size_in,
			conv_type_in               => CT_NONE,
			reg_type_in                => RT_NONE,
			data_type_in               => data_type_in,
			sm_type_in                 => sm_type_in,
			mem_type_in                => "000",
			mv_size_to_sm_type_out     => mv_size_to_sm_type_o,
			data_type_to_sm_type_out   => open,
			sm_type_to_sm_type_out     => open,
			mem_type_to_sm_type_out    => open,
			conv_type_to_reg_type_out  => open,
			reg_type_to_data_type_out  => open,
			mv_size_to_data_type_out   => mv_size_to_data_type_o,
			conv_type_to_data_type_out => open,
			sm_type_to_data_type_out   => sm_type_to_data_type_o,
			mem_type_to_data_type_out  => open,
			sm_type_to_cvt_type_out    => open,
			mem_type_to_cvt_type_out   => open
		);

	uIncrementAddress : increment_address
		port map(
			reset                  => reset,
			clk_in                 => clk_in,
			en                     => inc_addr_en_i,
			addr_reg_in            => inc_addr_reg_i,
			data_type_in           => inc_addr_data_type_i,
			mask_in                => inc_addr_mask_i,
			imm_in                 => inc_addr_imm_i,
			addr_regs_en_out       => inc_addr_regs_en,
			addr_regs_reg_num_out  => inc_addr_regs_reg_num,
			addr_regs_wr_data_out  => inc_addr_regs_wr_data,
			addr_regs_mask_out     => inc_addr_regs_mask,
			addr_regs_rd_wr_en_out => inc_addr_regs_rd_wr_en,
			addr_regs_rd_data_in   => inc_addr_regs_rd_data,
			addr_regs_rdy_in       => inc_addr_regs_rdy,
			rdy_out                => inc_addr_rdy_o
		);

	uComputePredFlags : compute_pred_flags
		port map(
			data_in      => compute_pred_data_i,
			flags_in     => compute_pred_flags_i,
			data_type_in => compute_pred_data_type_i,
			flags_out    => compute_pred_flags_o
		);

	uVectorRegisterFileController : vector_register_controller
		port map(
			reset              => reset,
			clk_in             => clk_in,
			en                 => gprs_en_i,
			lane_id_in         => warp_lane_id_in,
			base_addr_in       => gprs_base_addr_in,
			reg_num_in         => gprs_reg_num_i,
			data_in            => gprs_wr_data_i,
			data_type_in       => gprs_data_type_i,
			mask_in            => gprs_mask_i,
			rd_wr_en_in        => gprs_rd_wr_en_i,
			gprs_base_addr_out => gprs_base_addr_out,
			gprs_reg_num_out   => gprs_reg_num_out,
			gprs_lane_id_out   => gprs_lane_id_out,
			gprs_wr_en_out     => gprs_wr_en_out,
			gprs_wr_data_out   => gprs_wr_data_out,
			gprs_rd_data_in    => gprs_rd_data_in,
			data_out           => gprs_rd_data_o,
			rdy_out            => gprs_rdy_o
		);

	gprs_en_i <= write_gprs_en when (write_select = "000")
		else shmem_gprs_en when (write_select = "001")
		else gmem_gprs_en when (write_select = "010")
		else '0';

	gprs_reg_num_i <= write_gprs_reg_num when (write_select = "000")
		else shmem_gprs_reg_num when (write_select = "001")
		else gmem_gprs_reg_num when (write_select = "010")
		else (others => '0');

	gprs_wr_data_i <= write_gprs_wr_data when (write_select = "000")
		-- else shmem_gprs_wr_data when (write_select = "001")
		-- else gmem_gprs_wr_data when (write_select = "010")
		else (others => (others => (others => '0')));

	gprs_data_type_i <= write_gprs_data_type when (write_select = "000")
		else shmem_gprs_data_type when (write_select = "001")
		else gmem_gprs_data_type when (write_select = "010")
		else DT_NONE;

	gprs_mask_i <= write_gprs_mask when (write_select = "000")
		-- else shmem_gprs_mask when (write_select = "001")
		-- else gmem_gprs_mask when (write_select = "010")
		else (others => '1') when (write_select = "001")
		else (others => '1') when (write_select = "010")
		else (others => '0');

	gprs_rd_wr_en_i <= write_gprs_rd_wr_en when (write_select = "000")
		-- else shmem_gprs_rd_wr_en when (write_select = "001")
		-- else gmem_gprs_rd_wr_en when (write_select = "010")
		else '0';

	--write_gprs_rd_data <= gprs_rd_data_o when (write_select = "000") else (others => (others => (others => '0'))); -- REMOVED GIANLUCA ROASCIO
	shmem_gprs_rd_data <= gprs_rd_data_o when (write_select = "001") else (others => (others => (others => '0')));
	gmem_gprs_rd_data  <= gprs_rd_data_o when (write_select = "010") else (others => (others => (others => '0')));

	write_gprs_rdy <= gprs_rdy_o when (write_select = "000") else '0';
	shmem_gprs_rdy <= gprs_rdy_o when (write_select = "001") else '0';
	gmem_gprs_rdy  <= gprs_rdy_o when (write_select = "010") else '0';

	uAddressRegisterController : address_register_controller
		port map(
			reset                      => reset,
			clk_in                     => clk_in,
			en                         => addr_regs_en_i,
			warp_id_in                 => warp_id_in,
			lane_id_in                 => warp_lane_id_in,
			reg_num_in                 => addr_regs_reg_num_i,
			data_in                    => addr_regs_wr_data_i,
			mask_in                    => addr_regs_mask_i,
			rd_wr_en_in                => addr_regs_rd_wr_en_i,
			addr_regs_warp_id_out      => addr_regs_warp_id_out,
			addr_regs_warp_lane_id_out => addr_regs_warp_lane_id_out,
			addr_regs_reg_num_out      => addr_regs_reg_num_out,
			addr_regs_wr_en_out        => addr_regs_wr_en_out,
			addr_regs_wr_data_out      => addr_regs_wr_data_out,
			addr_regs_rd_data_in       => addr_regs_rd_data_in,
			data_out                   => addr_regs_rd_data_o,
			rdy_out                    => addr_regs_rdy_o
		);

	addr_regs_en_i <= write_addr_regs_en when (write_select = "000")
		else shmem_addr_regs_en when (write_select = "001")
		else gmem_addr_regs_en when (write_select = "010")
		else inc_addr_regs_en when (write_select = "101")
		else '0';

	addr_regs_reg_num_i <= write_addr_regs_reg_num when (write_select = "000")
		else shmem_addr_regs_reg_num when (write_select = "001")
		else gmem_addr_regs_reg_num when (write_select = "010")
		else inc_addr_regs_reg_num when (write_select = "101")
		else (others => '0');

	addr_regs_wr_data_i <= write_addr_regs_wr_data when (write_select = "000")
		-- else shmem_addr_regs_wr_data when (write_select = "001")
		-- else gmem_addr_regs_wr_data when (write_select = "010")
		else inc_addr_regs_wr_data when (write_select = "101")
		else (others => (others => '0'));

	addr_regs_mask_i <= write_addr_regs_mask when (write_select = "000")
		-- else shmem_addr_regs_mask when (write_select = "001")
		-- else gmem_addr_regs_mask when (write_select = "010")
		else (others => '1') when (write_select = "001")
		else (others => '1') when (write_select = "010")
		else inc_addr_regs_mask when (write_select = "101")
		else (others => '0');

	addr_regs_rd_wr_en_i <= write_addr_regs_rd_wr_en when (write_select = "000")
		-- else shmem_addr_regs_rd_wr_en when (write_select = "001")
		-- else gmem_addr_regs_rd_wr_en when (write_select = "010")
		else inc_addr_regs_rd_wr_en when (write_select = "101")
		else '0';

	--write_addr_regs_rd_data <= addr_regs_rd_data_o when (write_select = "000") else (others => (others => '0')); -- REMOVED GIANLUCA ROASCIO
	shmem_addr_regs_rd_data <= addr_regs_rd_data_o when (write_select = "001") else (others => (others => '0'));
	gmem_addr_regs_rd_data  <= addr_regs_rd_data_o when (write_select = "010") else (others => (others => '0'));
	inc_addr_regs_rd_data   <= addr_regs_rd_data_o when (write_select = "101") else (others => (others => '0'));

	write_addr_regs_rdy <= addr_regs_rdy_o when (write_select = "000") else '0';
	shmem_addr_regs_rdy <= addr_regs_rdy_o when (write_select = "001") else '0';
	gmem_addr_regs_rdy  <= addr_regs_rdy_o when (write_select = "010") else '0';
	inc_addr_regs_rdy   <= addr_regs_rdy_o when (write_select = "101") else '0';

	uPredicateRegsiterController : predicate_register_controller
		port map(
			reset                      => reset,
			clk_in                     => clk_in,
			en                         => pred_regs_en_i,
			warp_id_in                 => warp_id_in,
			lane_id_in                 => warp_lane_id_in,
			reg_num_in                 => pred_regs_num_i,
			data_in                    => pred_regs_wr_data_i,
			mask_in                    => pred_regs_mask_i,
			rd_wr_en_in                => pred_regs_rd_wr_en_i,
			pred_regs_warp_id_out      => pred_regs_warp_id_out,
			pred_regs_warp_lane_id_out => pred_regs_warp_lane_id_out,
			pred_regs_reg_num_out      => pred_regs_reg_num_out,
			pred_regs_wr_en_out        => pred_regs_wr_en_out,
			pred_regs_wr_data_out      => pred_regs_wr_data_out,
			pred_regs_rd_data_in       => pred_regs_rd_data_in,
			--data_out                   => pred_regs_rd_data_o, -- MODIFIED GIANLUCA ROASCIO
			data_out				   => open,
			rdy_out                    => pred_regs_rdy_o
		);

	uSharedMemoryController : shared_memory_controller
		generic map(
			ADDRESS_SIZE     => SHMEM_ADDR_SIZE,
			ARB_ADDR_REGS_EN => '0'
		)
		port map(
			reset                => reset,
			clk_in               => clk_in,
			en                   => shmem_en_i,
			data_in              => shmem_wr_data_i,
			base_addr_in         => shmem_base_addr_in,
			addr_in              => shmem_addr_i,
			mask_in              => shmem_mask_i,
			rd_wr_type_in        => shmem_rd_wr_type_i,
			sm_type_in           => shmem_sm_type_i,
			addr_lo_in           => addr_lo_in,
			addr_hi_in           => addr_hi_in,
			addr_imm_in          => addr_imm_i,
			gprs_req_out         => open,
			gprs_ack_out         => open,
			gprs_grant_in        => '0',
			gprs_en_out          => shmem_gprs_en,
			gprs_reg_num_out     => shmem_gprs_reg_num,
			gprs_data_type_out   => shmem_gprs_data_type,
			gprs_rd_data_in      => shmem_gprs_rd_data,
			gprs_rdy_in          => shmem_gprs_rdy,
			addr_regs_req_out    => open,
			addr_regs_ack_out    => open,
			addr_regs_grant_in   => '0',
			addr_regs_en_out     => shmem_addr_regs_en,
			addr_regs_reg_out    => shmem_addr_regs_reg_num,
			addr_regs_rd_data_in => shmem_addr_regs_rd_data,
			addr_regs_rdy_in     => shmem_addr_regs_rdy,
			shmem_addr_out       => shmem_addr_out,
			shmem_wr_en_out      => shmem_wr_en_out,
			shmem_wr_data_out    => shmem_wr_data_out,
			shmem_rd_data_in     => shmem_rd_data_in,
			--data_out             => shmem_rd_data_o, -- MODIFIED GIANLUCA ROASCIO
			data_out			 => open,
			rdy_out              => shmem_rdy_o
		);

	uGlobalMemoryController : global_memory_controller
		generic map(
			ADDRESS_SIZE     => GMEM_ADDR_SIZE,
			ARB_ADDR_REGS_EN => '0'
		)
		port map(
			reset                => reset,
			clk_in               => clk_in,
			en                   => gmem_en_i,
			data_in              => gmem_wr_data_i,
			addr_in              => gmem_addr_i,
			mask_in              => gmem_mask_i,
			rd_wr_type_in        => gmem_rd_wr_type_i,
			data_type_in         => gmem_data_type_i,
			addr_lo_in           => addr_lo_in,
			addr_hi_in           => addr_hi_in,
			addr_imm_in          => addr_imm_i,
			gprs_req_out         => open,
			gprs_ack_out         => open,
			gprs_grant_in        => '0',
			gprs_en_out          => gmem_gprs_en,
			gprs_reg_num_out     => gmem_gprs_reg_num,
			gprs_data_type_out   => gmem_gprs_data_type,
			gprs_rd_data_in      => gmem_gprs_rd_data,
			gprs_rdy_in          => gmem_gprs_rdy,
			addr_regs_req_out    => open,
			addr_regs_ack_out    => open,
			addr_regs_grant_in   => '0',
			addr_regs_en_out     => gmem_addr_regs_en,
			addr_regs_reg_out    => gmem_addr_regs_reg_num,
			addr_regs_rd_data_in => gmem_addr_regs_rd_data,
			addr_regs_rdy_in     => gmem_addr_regs_rdy,
			gmem_addr_out        => gmem_addr_out,
			gmem_wr_en_out       => gmem_wr_en_out,
			gmem_wr_data_out     => gmem_wr_data_out,
			gmem_rd_data_in      => gmem_rd_data_in,
			--data_out             => gmem_rd_data_o, -- MODIFIED GIANLUCA ROASCIO
			data_out			 => open,
			rdy_out              => gmem_rdy_o
		);
end arch;

