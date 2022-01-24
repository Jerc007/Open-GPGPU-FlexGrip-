----------------------------------------------------------------------------------
-- Company:          Univerity of Massachusetts 
-- Engineer:         Kevin Andryc
-- 
-- Create Date:      17:50:27 09/19/2010  
-- Module Name:      shift_register - arch 
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

use work.gpgpu_package.all;

    entity shift_register is
        generic (
            n           : integer   := 4
        );
        port ( 
            clk         : in  std_logic;
            reset       : in  std_logic;
            d           : in  std_logic_vector(31 downto 0);
            q           : out std_logic_vector(31 downto 0)
        );
    end shift_register;

architecture arch of shift_register is

    type shift_reg_array is array(n-1 downto 0) of std_logic_vector(31 downto 0);
    
    signal shift_reg_i  : shift_reg_array;
    
begin

    pShiftRegister : process (clk, reset)
    begin
        
            if (reset = '1') then
                shift_reg_i                     <= (others => (others => '0'));
            elsif (rising_edge(clk)) then
                shift_reg_i(n-1 downto 0)       <= d & shift_reg_i(n-1 downto 1);
            end if;
    end process;
    
    q   <= shift_reg_i(0);
    
end arch;
