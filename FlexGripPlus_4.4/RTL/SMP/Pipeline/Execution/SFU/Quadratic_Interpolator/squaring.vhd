library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.gpgpu_package.all;

entity squaring is
	generic(
		word_bits	:natural:=17
	);
	port(
		d_in				:in std_logic_vector(word_bits-1 downto 0);		
		d_out				:out std_logic_vector((word_bits*2)-1 downto 0)
	);
end entity;

architecture behav of squaring is
	-- signals for partial products
	
	-- If word_bits is even 
	--shared variable tam_a:integer := ((word_bits-4)/2)-1;
	-- If word_bits is odd
	constant tam_a:integer := ((word_bits-5)/2);
	
	type matrix is array (tam_a downto 0) of std_logic_vector((word_bits*2)-1-9 downto 0);
	
	signal a:matrix:=(others=>(others=>'0'));
	signal l:std_logic_vector((word_bits*2)-1 downto 0):=(others=>'0');
	
	-- signals for FA and HA	
	type adders is array (tam_a-1 downto 0) of std_logic_vector((word_bits*2)-1-11 downto 0);
	signal out_add:adders:=(others=>(others=>'0'));
	signal carry_out:adders:=(others=>(others=>'0'));
	
	signal last_row_add		:std_logic_vector((word_bits*2)-1 downto 0):=(others=>'0');
	signal last_row_carry	:std_logic_vector((word_bits*2)-1 downto 0):=(others=>'0');
begin
	-----------------------------------------------------------------------------------------------------
	-- Generation of L
	-----------------------------------------------------------------------------------------------------
	gen_l:process(d_in)
	begin
		l(0) <= d_in(0);
		l(1) <= '0';
		l(2) <= d_in(1) and (not d_in(0));
		l(3) <= (d_in(1) xor d_in(2)) and d_in(0);
		
		for i in 4 to (word_bits*2)-3 loop
			if (i mod 2) = 0 then
				-- it's even
				l(i) <= (((not d_in((i-4)/2)) or (not d_in((i+2)/2))) and (not d_in((i-2)/2)) and d_in(i/2)) or ((d_in(i/2) xor d_in((i+2)/2)) and d_in((i-4)/2));
			else
				-- it's odd
				l(i) <= (d_in((i-3)/2) and (d_in((i-1)/2) xor d_in((i+1)/2))) or (d_in((i-5)/2) and d_in((i-1)/2) and d_in((i+1)/2));
			end if;
		end loop;
		
		l((word_bits*2)-2) <= ((not d_in(word_bits-2)) or d_in(word_bits-3)) and d_in(word_bits-1);
		l((word_bits*2)-1) <= d_in(word_bits-1) and d_in(word_bits-2);
	end process;
	
	-----------------------------------------------------------------------------------------------------
	-- Generation of a
	-----------------------------------------------------------------------------------------------------
	gen_a:process(d_in)
		variable index :integer:=0;
	begin
		for i in 0 to tam_a loop
			index := 0;
			for j in 4+i to word_bits-i-1 loop
				a(i)(index+(i*2)) <= d_in(i) and d_in(j);
				index := index + 1;
			end loop;
			
			for j in 1+i to word_bits-i-5 loop
				a(i)(index+(i*2)) <= d_in(word_bits-i-1) and d_in(j);
				index := index + 1;
			end loop;
		end loop;
	end process;
	
	-----------------------------------------------------------------------------------------------------
	-- Adder generation
	-----------------------------------------------------------------------------------------------------
	gen_adder:process(a,out_add,carry_out,last_row_add,last_row_carry,l)
		variable index :integer:=0;
	begin
		for i in 0 to tam_a-1 loop
			for j in 0 to (word_bits*2)-1-11-(i*4) loop
				if i = tam_a-1 then
					if j = 0 then
						-- the first half adder
						out_add(i)(j+(i*2)) <= a(i)(j+2+(2*i)) xor a(i+1)(j+2+(2*i));
						carry_out(i)(j+(i*2)) <= a(i)(j+2+(2*i)) and a(i+1)(j+2+(2*i));
					elsif j = (word_bits*2)-1-11-(i*4)-1 or j = (word_bits*2)-1-11-(i*4) then
						-- the final and penultimate half adder
						out_add(i)(j+(i*2)) <= a(i)(j+2+(2*i)) xor carry_out(i)(j-1+(2*i));
						carry_out(i)(j+(i*2)) <= a(i)(j+2+(2*i)) and carry_out(i)(j-1+(2*i));
					else
						-- the rest full adders
						out_add(i)(j+(i*2)) <= a(i)(j+2+(2*i)) xor a(i+1)(j+2+(2*i)) xor carry_out(i)(j-1+(2*i));
						carry_out(i)(j+(i*2)) <= (a(i)(j+2+(2*i)) and a(i+1)(j+2+(2*i))) or ((a(i)(j+2+(2*i)) xor a(i+1)(j+2+(2*i))) and carry_out(i)(j-1+(2*i)));
					end if;
				else
					if j = 0 then
						-- the first half adder
						out_add(i)(j+(i*2)) <= a(i)(j+2+(2*i)) xor a(i+1)(j+2+(2*i));
						carry_out(i)(j+(i*2)) <= a(i)(j+2+(2*i)) and a(i+1)(j+2+(2*i));
					elsif j = 1 then
						-- the first full adder
						out_add(i)(j+(i*2)) <= a(i)(j+2+(2*i)) xor a(i+1)(j+2+(2*i)) xor carry_out(i)(j-1+(2*i));
						carry_out(i)(j+(i*2)) <= (a(i)(j+2+(2*i)) and a(i+1)(j+2+(2*i))) or ((a(i)(j+2+(2*i)) xor a(i+1)(j+2+(2*i))) and carry_out(i)(j-1+(2*i)));
					elsif j = (word_bits*2)-1-11-(i*4) then
						-- the final half adder
						out_add(i)(j+(i*2)) <= a(i)(j+2+(2*i)) xor carry_out(i)(j-1+(2*i));
						carry_out(i)(j+(i*2)) <= a(i)(j+2+(2*i)) and carry_out(i)(j-1+(2*i));
					elsif j = (word_bits*2)-1-11-(i*4)-1 then
						-- the final full adder
						out_add(i)(j+(i*2)) <= a(i)(j+2+(2*i)) xor carry_out(i+1)(j-1+(2*i)) xor carry_out(i)(j-1+(2*i));
						carry_out(i)(j+(i*2)) <= (a(i)(j+2+(2*i)) and carry_out(i+1)(j-1+(2*i))) or ((a(i)(j+2+(2*i)) xor carry_out(i+1)(j-1+(2*i))) and carry_out(i)(j-1+(2*i)));
					else
						-- the rest of full adders
						out_add(i)(j+(i*2)) <= a(i)(j+2+(2*i)) xor out_add(i+1)(j+(2*i)) xor carry_out(i)(j-1+(2*i));
						carry_out(i)(j+(i*2)) <= (a(i)(j+2+(2*i)) and out_add(i+1)(j+(2*i))) or ((a(i)(j+2+(2*i)) xor out_add(i+1)(j+(2*i))) and carry_out(i)(j-1+(2*i)));
					end if;
				end if;
			end loop;
		end loop;
		
		--------------------------------------------
		-- final row (L)
		--------------------------------------------
		
		last_row_add(4 downto 0) <= l(4 downto 0);
		
		-- first HA
		last_row_add(5) <= l(5) xor a(0)(0);
		last_row_carry(5) <= l(5) and a(0)(0);
		
		-- first FA
		last_row_add(6) <= l(6) xor a(0)(1) xor last_row_carry(5);
		last_row_carry(6) <= (l(6) and a(0)(1)) or ((l(6) xor a(0)(1)) and last_row_carry(5));
		
		for i in 7 to (word_bits*2)-1-1 loop
			if i = (word_bits*2)-1-3 then
				-- the final full adder
				last_row_add(i) <= l(i) xor carry_out(0)(i-8) xor last_row_carry(i-1);
				last_row_carry(i) <= (l(i) and carry_out(0)(i-8)) or ((l(i) xor carry_out(0)(i-8)) and last_row_carry(i-1));
			elsif i = (word_bits*2)-1-2 or i = (word_bits*2)-1-1 then
				-- the final two half adder
				last_row_add(i) <= l(i) xor last_row_carry(i-1);
				last_row_carry(i) <= l(i) and last_row_carry(i-1);
			else
				-- the rest of full adders
				last_row_add(i) <= l(i) xor out_add(0)(i-7) xor last_row_carry(i-1);
				last_row_carry(i) <= (l(i) and out_add(0)(i-7)) or ((l(i) xor out_add(0)(i-7)) and last_row_carry(i-1));
			end if;
		end loop;
		
		-- the final or gate
		last_row_add((word_bits*2)-1) <= l((word_bits*2)-1) or last_row_carry((word_bits*2)-2);
	end process;
	
	d_out <= last_row_add;
end architecture;