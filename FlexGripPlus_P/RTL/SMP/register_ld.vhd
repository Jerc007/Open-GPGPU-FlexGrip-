----------------------------------------------------------------------------------
-- Company:          Univerity of Massachusetts 
-- Engineer:         Kevin Andryc
-- 
-- Create Date:      17:50:27 09/19/2010  
-- Module Name:      register_ld - arch 
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
use IEEE.STD_LOGIC_1164.ALL;

entity register_ld is
    generic ( 
        width       : integer := 4
    );
    port (
        clk         : in std_logic;
        reset       : in std_logic;
        D           : in std_logic_vector(Width - 1 downto 0);
        Ld          : in std_logic;
        Q           : out std_logic_vector(Width - 1 downto 0)
    );
end register_ld;

architecture arch of register_ld is

begin
    pRegister : process(clk, reset) is
    begin
        if (reset = '1') then
            Q       <= (others => '0');
        elsif (rising_edge(clk)) then
            if (Ld = '1') then
                Q   <= D;
            end if;
        end if;
    end process;
end arch;
