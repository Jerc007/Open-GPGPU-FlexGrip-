-- ---------------------------------------------------------------------------
-- (2009) Benjamin Krill <ben@codiert.org>
--
-- "THE BEER-WARE LICENSE" (Revision 42):
-- ben@codiert.org wrote this file. As long as you retain this notice you can
-- do whatever you want with this stuff. If we meet some day, and you think
-- this stuff is worth it, you can buy me a beer in return Benjamin Krill
-- ---------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity arbiter is
	generic(
		CNT : integer := 7
	);
	port(
		clk   : in  std_logic;
		rst   : in  std_logic;
		req   : in  std_logic_vector(CNT - 1 downto 0);
		ack   : in  std_logic;
		grant : out std_logic_vector(CNT - 1 downto 0)
	);
end arbiter;

architecture arch of arbiter is
	
	signal grant_q  : std_logic_vector(CNT - 1 downto 0);
	signal pre_req  : std_logic_vector(CNT - 1 downto 0);
	signal sel_gnt  : std_logic_vector(CNT - 1 downto 0);
	signal isol_lsb : std_logic_vector(CNT - 1 downto 0);
	signal mask_pre : std_logic_vector(CNT - 1 downto 0);
	signal win      : std_logic_vector(CNT - 1 downto 0);
	
begin
	
	grant    <= grant_q;
	mask_pre <= req and not (std_logic_vector(unsigned(pre_req) - 1) or pre_req); -- Mask off previous winners
	sel_gnt  <= mask_pre and std_logic_vector(unsigned(not (mask_pre)) + 1); -- Select new winner
	isol_lsb <= req and std_logic_vector(unsigned(not (req)) + 1); -- Isolate least significant set bit.
	win      <= sel_gnt when mask_pre /= (CNT - 1 downto 0 => '0') else isol_lsb;

	pArbiter : process(clk, rst)
	begin
		if (rst = '1') then
			pre_req <= (others => '0');
			grant_q <= (others => '0');
		elsif rising_edge(clk) then
			if ((ack = '1') or (grant_q = (CNT - 1 downto 0 => '0'))) then
				pre_req <= win;
				grant_q <= win;
			end if;
-- REMOVED GIANLUCA ROASCIO: IF IDENTICAL TO THE PREVIOUS, NO NEED
--			if ((grant_q = (CNT - 1 downto 0 => '0')) or (ack = '1')) then
--				grant_q <= win;
--			end if;
		end if;
	end process;

end arch;

