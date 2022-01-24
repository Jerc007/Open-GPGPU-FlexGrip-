-- Proyecto				: SFU IEEE754
-- Nombre de archivo	: SFU.vhd
-- Titulo				: Special Function Unit  
-----------------------------------------------------------------------------	
-- Descripcion			: This unit performs the floating point operations
--						  sin(x), cos(x), rsqrt(x), log2(x) and exp2(x) using
--						IEE754 standard and operational compliant with GPU G80
--						architecture
--
-----------------------------------------------------------------------------	
-- Universidad Pedagogica y Tecnologica de Colombia.
-- Facultad de ingenieria.
-- Escuela de ingenieria Electronica - extension Tunja.
-- 
-- Autor: 
-- Abril 2020
-----------------------------------------------------------------------------	


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.gpgpu_package.all;


entity sfu_proc is
port(clk_i	  :in std_logic;	--input clock
	 rst_n	  :in std_logic;	--reset active low
	 start_i  :in std_logic;	--start operation
	 src1_i	  :in vector_register; --IEE754 input data
	 selop_i  :in std_logic_vector(2 downto 0); --operation selection
	 Result_o :out vector_register; --IEE754 result data output
	 stall_o  :out std_logic --stall signal 
);
end entity sfu_proc;


architecture structure of sfu_proc is 
constant HALF_CORES		:integer := CORES/2; 
constant LOG_HALF_CORES	:integer := log2(HALF_CORES);

type src_sfu_type is array(0 to 1) of std_logic_vector(31 downto 0);
type half_vector is array (HALF_CORES - 1 downto 0) of std_logic_vector(31 downto 0); 
signal reg_src_i : vector_register;
signal Hreg_dst_o,Lreg_dst_o : half_vector;

signal src_sfu_sub_i : src_sfu_type;
signal dst_sfu_sub_i : src_sfu_type;

signal stall_s :std_logic_vector(1 downto 0);

type states is(IDLE, START, EXECUTE, DONE);
signal ns,ps :states;

signal count_i :unsigned(LOG_HALF_CORES-1 downto 0);

signal en_count,load_count,en_dec,en_input, start_s : std_logic;

begin 
stall_s <=(others=>'0');

gSpecialFunctionUnit: for i in 0 to 1 generate
	uSpecialFunctionUnit : sfu
		port map(
		--clk_i	  => clk_i,	  
		--rst_n	  => rst_n,	  
		--start_i   => start_s,
		src1_i	  => src_sfu_sub_i(i),	  
		selop_i   => selop_i,  
		Result_o  => dst_sfu_sub_i(i) 
		--stall_o   => stall_s(i) 
		);
end generate; 


input_registers: process(clk_i,rst_n)
	begin
		if rst_n='0' then
			reg_src_i <= (others=>(others=>'0'));
		elsif rising_edge(clk_i) then
			if en_input='1' then
				reg_src_i <= src1_i;
			end if;
		end if;
	end process;

output_registersL: process(clk_i,rst_n)
	begin
		if rst_n='0' then
			Lreg_dst_o <= (others=>(others=>'0'));
		elsif rising_edge(clk_i) then
			if en_dec='1' then
				Lreg_dst_o(to_integer(count_i)) <= dst_sfu_sub_i(0);
			end if;
		end if;
	end process;

output_registersH: process(clk_i,rst_n)
	begin
		if rst_n='0' then
			Hreg_dst_o <= (others=>(others=>'0'));
		elsif rising_edge(clk_i) then
			if en_dec='1' then
				Hreg_dst_o(to_integer(count_i)) <= dst_sfu_sub_i(1);
			end if;
		end if;
	end process;

gOutData: for i in 0 to HALF_CORES-1 generate
	Result_o(i+HALF_CORES)<=Hreg_dst_o(i);
	Result_o(i) <= Lreg_dst_o(i);
	end generate;

src_sfu_sub_i(0)<=reg_src_i(to_integer(count_i));
src_sfu_sub_i(1)<=reg_src_i(to_integer(count_i)+HALF_CORES);


counter: process(clk_i,rst_n)
	begin
		if rst_n='0' then
			count_i <=(others=>'0');
		elsif rising_edge(clk_i) then
			if en_count='1' then
				if load_count='1' then
					count_i <= (others=>'0');
				else
					count_i <= count_i + 1;
				end if;
			end if;
		end if;
	end process;

---next states
nex_state:process(ps,stall_s,start_i,count_i)
	begin
		case ps is
			when IDLE =>
				if(start_i='1') then
					ns <= START;
				else
					ns <= IDLE;
				end if;
			when START =>
				ns <= EXECUTE;
			when EXECUTE =>
				if (stall_s(0)='0' and stall_s(1)='0') then
					if(count_i=(HALF_CORES-1)) then
						ns <= DONE;
					else
						ns <= START;
					end if;
				else
					ns <= EXECUTE;
				end if;
			when DONE =>
				ns <= IDLE;
			when others =>
				ns <= IDLE;
		end case;
	end process;


---present states
present_state:process(clk_i,rst_n)
	begin
		if rst_n='0' then
			ps <= IDLE;
		elsif rising_edge(clk_i) then
			ps <= ns;
		end if;
	end process;
	

---next states
output_logic:process(ps,stall_s,start_i,count_i)
	begin
		case ps is
			when IDLE =>
				stall_o <= '1';
				en_count <= '1';
				load_count <= '1';
				start_s <= '0';
				en_dec	<= '0';
				if(start_i='1') then
					en_input <= '1';					
				else
					en_input <= '0';					
				end if;
			when START =>
				stall_o <= '1';
				en_count <= '0';
				load_count <= '0';
				start_s <= '1';
				en_input <= '0';
				en_dec	<= '0';					
			when EXECUTE =>
				start_s <= '0';
				stall_o <= '1';
				en_input <= '0';
				if (stall_s(0)='0' and stall_s(1)='0') then
					if(count_i=(HALF_CORES-1)) then
						en_count <= '1';
						load_count <= '1';
						en_dec	<= '1';
					else
						en_count <= '1';
						load_count <= '0';
						en_dec	<= '1';
					end if;
				else
					en_count <= '0';
					load_count <= '0';
					en_dec	<= '0';					
				end if;
			when DONE =>
				stall_o <= '0';
				en_count <= '1';
				load_count <= '1';
				start_s <= '0';
				en_input <= '0';
				en_dec	<= '0';	
			when others =>
				stall_o <= '1';
				en_count <= '1';
				load_count <= '1';
				start_s <= '0';
				en_input <= '0';
				en_dec	<= '0';	
		end case;
	end process;

end structure;