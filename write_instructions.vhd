-- Company:          Univerity of Massachusetts 
-- Engineer:         Kevin Andryc
-- 
-- Create Date:      17:50:27 09/19/2010  
-- Module Name:      write_instructions - arch 
-- Project Name:     GPGPU
-- Target Devices: 
-- Tool versions:    ISE 13.3
-- Description: 
--      This module writes instructions to the main memory.
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
-- MODIFIED GIANLUCA ROASCIO - SET SYSTEM MEMORY WIDTH TO 32 BITS
----------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity write_instructions is
	generic(
		APPLICATION   : string  := "TP"; --change for every app					
		MEM_ADDR_SIZE : integer := 32
	);
	port(
		clk           : in  std_logic;
		reset         : in  std_logic;
		en            : in  std_logic;
		mem_addr_out  : out std_logic_vector(MEM_ADDR_SIZE - 1 downto 0);
		mem_data_out  : out std_logic_vector(31 downto 0);
		mem_wr_en_out : out std_logic;
		done          : out std_logic
	);
end write_instructions;

architecture arch of write_instructions is
	component matrix_mult_sass_instructions
		port(
			instruction_pointer_in : in  integer;
			num_instructions_out   : out integer;
			instruction_out        : out std_logic_vector(31 downto 0)
		);
	end component;

	component matrix_mult_cubin_instructions
		port(
			instruction_pointer_in : in  integer;
			num_instructions_out   : out integer;
			instruction_out        : out std_logic_vector(31 downto 0)
		);
	end component;

	component autocor_instructions
		port(
			instruction_pointer_in : in  integer;
			num_instructions_out   : out integer;
			instruction_out        : out std_logic_vector(31 downto 0)
		);
	end component;

	component transpose_instructions
		port(
			instruction_pointer_in : in  integer;
			num_instructions_out   : out integer;
			instruction_out        : out std_logic_vector(31 downto 0)
		);
	end component;

	component twice_kernel_instructions
		port(
			instruction_pointer_in : in  integer;
			num_instructions_out   : out integer;
			instruction_out        : out std_logic_vector(31 downto 0)
		);
	end component;

	component bitonic_sort_instructions
		port(
			instruction_pointer_in : in  integer;
			num_instructions_out   : out integer;
			instruction_out        : out std_logic_vector(31 downto 0)
		);
	end component;

	component reduction_instructions
		port(
			instruction_pointer_in : in  integer;
			num_instructions_out   : out integer;
			instruction_out        : out std_logic_vector(31 downto 0)
		);
	end component;
    
    component tp_instructions
		port(
			instruction_pointer_in : in  integer;
			num_instructions_out   : out integer;
			instruction_out        : out std_logic_vector(31 downto 0)
		);
	end component;

    component TP_long_instructions
		port(
			instruction_pointer_in : in  integer;
			num_instructions_out   : out integer;
			instruction_out        : out std_logic_vector(31 downto 0)
		);
	end component;
	
    component TP_short_instructions
		port(
			instruction_pointer_in : in  integer;
			num_instructions_out   : out integer;
			instruction_out        : out std_logic_vector(31 downto 0)
		);
	end component;
	
	--type write_instructions_state_type is (IDLE, WRITE_INSTRUCTION_BYTE_0, WRITE_INSTRUCTION_BYTE_1, WRITE_INSTRUCTION_BYTE_2, WRITE_INSTRUCTION_BYTE_3, WRITE_DONE);
	type write_instructions_state_type is (IDLE, WRITE_INSTRUCTION, WRITE_DONE);
	signal write_instructions_state_machine : write_instructions_state_type;

	signal max_instruction_length : integer;
	signal instruction_pointer    : integer; -- range 0 to max_instruction_length;
	signal instruction_i          : std_logic_vector(31 downto 0);
	signal mem_addr_i             : std_logic_vector(MEM_ADDR_SIZE - 1 downto 0);

begin
	
	gMATRIX_MULT_SASS : if APPLICATION = "MATRIX_MULT_SASS" generate
		uMatrixMultSassInstructions : matrix_mult_sass_instructions
			port map(
				instruction_pointer_in => instruction_pointer,
				num_instructions_out   => max_instruction_length,
				instruction_out        => instruction_i
			);
	end generate;

	gMATRIX_MULT_CUBIN : if APPLICATION = "MATRIX_MULT_CUBIN" generate
		uMatrixMultCubinInstructions : matrix_mult_cubin_instructions
			port map(
				instruction_pointer_in => instruction_pointer,
				num_instructions_out   => max_instruction_length,
				instruction_out        => instruction_i
			);
	end generate;

	gAUTOCOR : if APPLICATION = "AUTOCORR" generate
		uAutocorInstructions : autocor_instructions
			port map(
				instruction_pointer_in => instruction_pointer,
				num_instructions_out   => max_instruction_length,
				instruction_out        => instruction_i
			);
	end generate;

	gTRANSPOSE : if APPLICATION = "TRANSPOSE" generate
		uTransposeInstructions : transpose_instructions
			port map(
				instruction_pointer_in => instruction_pointer,
				num_instructions_out   => max_instruction_length,
				instruction_out        => instruction_i
			);
	end generate;


	gBITONIC_SORT : if APPLICATION = "BITONIC_SORT" generate
		uBitonicSortInstructions : bitonic_sort_instructions
			port map(
				instruction_pointer_in => instruction_pointer,
				num_instructions_out   => max_instruction_length,
				instruction_out        => instruction_i
			);
	end generate;

	gREDUCTION : if APPLICATION = "REDUCTION" generate
		uReductionInstructions : reduction_instructions
			port map(
				instruction_pointer_in => instruction_pointer,
				num_instructions_out   => max_instruction_length,
				instruction_out        => instruction_i
			);
	end generate;

    gTP : if APPLICATION = "TP" generate
		uTPInstructions : tp_instructions
			port map(
				instruction_pointer_in => instruction_pointer,
				num_instructions_out   => max_instruction_length,
				instruction_out        => instruction_i
			);
	end generate;
	
	gTP_LONG : if APPLICATION = "TP_LONG" generate
		uTP_long_Instructions : TP_long_instructions
			port map(
				instruction_pointer_in => instruction_pointer,
				num_instructions_out   => max_instruction_length,
				instruction_out        => instruction_i
			);
	end generate;

	gTP_SHORT : if APPLICATION = "TP_SHORT" generate
		uTP_short_Instructions : TP_short_instructions
			port map(
				instruction_pointer_in => instruction_pointer,
				num_instructions_out   => max_instruction_length,
				instruction_out        => instruction_i
			);
	end generate;	

	pWriteInstruction : process(clk)
	begin
		if (rising_edge(clk)) then
			if (reset = '1') then
				mem_addr_i                       <= (others => '0');
				mem_wr_en_out <= '0';
				mem_addr_out                     <= (others => '0');
				mem_data_out                     <= (others => '0');
				done                             <= '0';
				instruction_pointer              <= 0;
				write_instructions_state_machine <= IDLE;
			else
				case write_instructions_state_machine is
					when IDLE =>
						done <= '0';
						if(en = '1') then
							--write_instructions_state_machine <= WRITE_INSTRUCTION_BYTE_0;
							write_instructions_state_machine <= WRITE_INSTRUCTION;
						end if;
					when WRITE_INSTRUCTION =>
						if (instruction_pointer < max_instruction_length) then
							mem_wr_en_out <= '1';
							mem_addr_out                     <= mem_addr_i;
							--mem_data_out                     <= instruction_i(7 downto 0);
							mem_data_out                     <= instruction_i(31 downto 0);
							mem_addr_i                       <= std_logic_vector(unsigned(mem_addr_i) + 1);
							instruction_pointer              <= instruction_pointer + 1;
							--write_instructions_state_machine <= WRITE_INSTRUCTION_BYTE_1;
							write_instructions_state_machine <= WRITE_INSTRUCTION;
						else
							mem_wr_en_out <= '0';
							mem_addr_out                     <= mem_addr_i;
							mem_data_out                     <= (others => '0');
							done                             <= '1';
							write_instructions_state_machine <= WRITE_DONE;
						end if;
					--when WRITE_INSTRUCTION_BYTE_1 =>
					--	mem_wr_en_out <= '1';
					--	mem_addr_out                     <= mem_addr_i;
					--	mem_data_out                     <= instruction_i(15 downto 8);
					--	mem_addr_i                       <= std_logic_vector(unsigned(mem_addr_i) + 1);
					--	write_instructions_state_machine <= WRITE_INSTRUCTION_BYTE_2;
					--when WRITE_INSTRUCTION_BYTE_2 =>
					--	mem_wr_en_out <= '1';
					--	mem_addr_out                     <= mem_addr_i;
					--	mem_data_out                     <= instruction_i(23 downto 16);
					--	mem_addr_i                       <= std_logic_vector(unsigned(mem_addr_i) + 1);
					--	write_instructions_state_machine <= WRITE_INSTRUCTION_BYTE_3;
					--when WRITE_INSTRUCTION_BYTE_3 =>
					--	mem_wr_en_out <= '1';
					--	mem_addr_out                     <= mem_addr_i;
					--	mem_data_out                     <= instruction_i(31 downto 24);
					--	mem_addr_i                       <= std_logic_vector(unsigned(mem_addr_i) + 1);
					--	instruction_pointer              <= instruction_pointer + 1;
					--	write_instructions_state_machine <= WRITE_INSTRUCTION_BYTE_0;
					when WRITE_DONE =>
						done <= '0';
					--when others =>
					--	write_instructions_state_machine <= IDLE;
				end case;
			end if;
		end if;
	end process;

end arch;

