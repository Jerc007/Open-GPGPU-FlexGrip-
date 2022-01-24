----------------------------------------------------------------------------------
-- Company:          Univerity of Massachusetts 
-- Engineer:         Kevin Andryc
-- 
-- Create Date:      17:50:27 09/19/2010  
-- Module Name:      stack - arch 
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

entity stack is
	generic(
		STACK_DEPTH : integer := 256;
		DATA_WIDTH  : integer := 64
	);
	port(
		clk_in      : in  std_logic;    --Clock for the stack.
		reset       : in  std_logic;
		stack_en    : in  std_logic;    --Enable the stack. Otherwise neither push nor pop will happen.
		data_in     : in  std_logic_vector(DATA_WIDTH - 1 downto 0); --Data to be pushed to stack
		data_out    : out std_logic_vector(DATA_WIDTH - 1 downto 0); --Data popped from the stack.
		push_en     : in  std_logic;    --active low for POP and active high for PUSH.
		stack_full  : out std_logic;    --Goes high when the stack is full.
		stack_empty : out std_logic     --Goes high when the stack is empty.
	);
end stack;

architecture arch of stack is
	
	type mem_type is array (STACK_DEPTH - 1 downto 0) of std_logic_vector(DATA_WIDTH - 1 downto 0);
	signal stack_mem : mem_type;
	signal stack_ptr : integer;
	signal full      : std_logic;
	signal empty     : std_logic;

begin
	
	stack_full  <= full;
	stack_empty <= empty;

	pStack : process(clk_in, reset)
	begin
		if (reset = '1') then
			stack_mem <= (others => (others => '0'));
			stack_ptr <= STACK_DEPTH - 1;
		elsif (rising_edge(clk_in)) then
			if (stack_en = '1' and push_en = '1' and full = '0') then
				--Data pushed to the current address.
				stack_mem(stack_ptr) <= data_in;
				if (stack_ptr /= 0) then
					stack_ptr <= stack_ptr - 1;
				end if;
			end if;
			if (stack_en = '1' and push_en = '0' and empty = '0') then
				--Data has to be taken from the next highest address(empty descending type stack).
				if (stack_ptr /= STACK_DEPTH - 1) then
					data_out  <= stack_mem(stack_ptr + 1);
					stack_ptr <= stack_ptr + 1;
				end if;
			end if;
		end if;
	end process;

	process(stack_ptr)
	begin
		--setting full and empty flags
		if (stack_ptr = 0) then
			full  <= '1';
			empty <= '0';
		elsif (stack_ptr = STACK_DEPTH - 1) then
			full  <= '0';
			empty <= '1';
		else
			full  <= '0';
			empty <= '0';
		end if;
	end process;

end arch;

