-- Log2 IEEE754 case detect
library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;
	
entity SFU_Exceptions is
	port 	  (	i_data_input			: in std_logic_vector(31 downto 0);
				i_data_sin_cos			: in std_logic_vector(31 downto 0);
				i_oper_result			: in std_logic_vector(31 downto 0);				
				i_selop					: in std_logic_vector(2 downto 0);
				o_result_solved 		: out std_logic_vector(31 downto 0));
end entity SFU_Exceptions;

architecture SFU_Exceptions_arch of SFU_Exceptions is
signal s_sin_exeption 		:std_logic_vector(31 downto 0) :=(others=>'0');
signal s_cos_exeption 		:std_logic_vector(31 downto 0) :=(others=>'0');
signal s_rsqrt_exeption 	:std_logic_vector(31 downto 0) :=(others=>'0');
signal s_log2_exeption 		:std_logic_vector(31 downto 0) :=(others=>'0');
signal s_ex2_exeption 		:std_logic_vector(31 downto 0) :=(others=>'0');
signal s_rcp_exeption 		:std_logic_vector(31 downto 0) :=(others=>'0');
signal s_sqrt_exeption 		:std_logic_vector(31 downto 0) :=(others=>'0');

	
begin
	
-- sine especial exceptions solve

IEEESin:process(i_data_input,i_data_sin_cos,i_oper_result)
begin
	if i_data_sin_cos(30 downto 23)=X"FF" then
		s_sin_exeption <= X"FFFFFFFF";
	else
		if (i_data_input(23 downto 0)=X"000000") then
			s_sin_exeption <= i_oper_result(31)&"000"&X"0000000";
		else
			s_sin_exeption <= i_oper_result;
		end if;
	end if;
end process;


IEEECos:process(i_data_input,i_data_sin_cos,i_oper_result)
begin
	if i_data_sin_cos(30 downto 23)=X"FF" then
		s_cos_exeption <= X"FFFFFFFF";
	else
		if (i_data_input(23 downto 0)=X"000000") then
			s_cos_exeption <= i_oper_result(31)&"0111111100000000000000000000000";
		else
			s_cos_exeption <= i_oper_result;
		end if;
	end if;
end process;



IEEERsqrt:process(i_data_input,i_oper_result)
begin
	if i_data_input(31) = '1' then
			if i_data_input(30 downto 23)= X"00" then
				s_rsqrt_exeption <= X"FF800000";		-- -inf
			else
				s_rsqrt_exeption <= X"FFFFFFFF";		-- NaN
			end if;

		else
			if i_data_input(30 downto 23) = X"00" then
				s_rsqrt_exeption <= X"7F800000";		-- +inf
			elsif i_data_input(30 downto 23) = X"FF" then
				if i_data_input(22 downto 0) = "00000000000000000000000" then
					s_rsqrt_exeption <= X"00000000";	
				else
					s_rsqrt_exeption <= X"FFFFFFFF"; -- NaN
				end if;
			else
				s_rsqrt_exeption <= i_oper_result; 		-- (dont care)
			end if;
		end if;
end process;



IEEELog2:process(i_data_input,i_oper_result)
begin
		if i_data_input(30 downto 23) = X"00" then
			s_log2_exeption		<= X"FF800000"; --inf
	
		elsif  i_data_input(30 downto 23)= X"FF" then
			if i_data_input(31) = '0' and i_data_input(22 downto 0) = "00000000000000000000000" then
				s_log2_exeption <= X"7F800000"; --+inf
			else	
				s_log2_exeption <= X"FFFFFFFF"; --nan
			end if;
	
		--elsif	i_data_input(30 downto 23) = X"7F" and i_data_input(22 downto 0) = "00000000000000000000000" and i_data_input(31) = '0' then
		--	s_log2_exeption <= X"00000000";
		
		elsif i_data_input(31) = '1' then
			s_log2_exeption <= X"FFFFFFFF";
			
		else
			s_log2_exeption <= i_oper_result;
		end if;
end process;



IEEEEx2:process(i_data_input,i_oper_result)
begin

	if i_data_input(31)='1' then
		if i_data_input(30 downto 23) = X"F0" and i_data_input(22 downto 0) = "00000000000000000000000" then -- input = -inf; output=0
			s_ex2_exeption <= X"00000000";
		elsif i_data_input(30 downto 23) = X"0F" and i_data_input(22 downto 0) = "00000000000000000000000" then -- input = +inf; output=+inf
			s_ex2_exeption <= X"7f800000";
		elsif i_data_input(30 downto 23) = X"FF" and i_data_input(22 downto 0) /= "00000000000000000000000" then -- input = NAN; output=NAN
			s_ex2_exeption <= i_data_input;
		elsif i_data_input(30 downto 23) = X"00" and i_data_input(22 downto 0) = "00000000000000000000000" then -- input = zero/+/-subnormal; output=+1
			s_ex2_exeption <= X"3f800000";
		else  -- input = normal ; output=2**-x
			s_ex2_exeption <= i_oper_result;
		end if;
	else
		s_ex2_exeption <= i_oper_result;
	end if;


	-- if i_data_input(31)='1' and i_data_input(30 downto 23) = X"00" then -- -inf
	-- 	s_ex2_exeption <= (others=>'0'); -- NaN +inf
	-- elsif i_data_input(31)='1' and i_data_input(30 downto 23) = X"FF" then --+inf nan
	-- 	s_ex2_exeption <='0'&i_data_input(30 downto 0);
	-- else
	-- 	s_ex2_exeption <=i_oper_result;
	-- end if;

end process;



IEEERcp:process(i_data_input,i_oper_result)
begin
	if i_data_input(31)='1' then
		if i_data_input(30 downto 23) = X"FF" and i_data_input(22 downto 0) = "00000000000000000000000" then
			s_rcp_exeption <= X"80000000";
		elsif i_data_input(30 downto 23) = X"FF" and i_data_input(22 downto 0) /= "00000000000000000000000" then
			s_rcp_exeption <= i_data_input;
		elsif i_data_input(30 downto 23) = X"00" then
			s_rcp_exeption <= X"ff800000";
		else 
			s_rcp_exeption <= i_oper_result;
		end if;
	else
		if i_data_input(30 downto 23) = X"FF" and i_data_input(22 downto 0) = "00000000000000000000000" then
			s_rcp_exeption <= X"00000000";
		elsif i_data_input(30 downto 23) = X"FF" and i_data_input(22 downto 0) /= "00000000000000000000000" then
			s_rcp_exeption <= i_data_input;
		elsif i_data_input(30 downto 23) = X"00" then
			s_rcp_exeption <= X"7f800000";
		else 
			s_rcp_exeption <= i_oper_result;
		end if;
	end if;
end process;



IEEESqrt:process(i_data_input,i_oper_result)
begin
	if i_data_input(31)='1' then
		if i_data_input(30 downto 23) = X"FF" and i_data_input(22 downto 0) = "00000000000000000000000" then
			s_sqrt_exeption <= X"ffffffff";
		elsif i_data_input(30 downto 23) = X"FF" and i_data_input(22 downto 0) /= "00000000000000000000000" then
			s_sqrt_exeption <= X"ffffffff";
		elsif i_data_input(30 downto 23) = X"00" then
			s_sqrt_exeption <= X"ff800000";
		else 
			s_sqrt_exeption <= X"ffffffff";
		end if;
	else
		if i_data_input(30 downto 23) = X"FF" and i_data_input(22 downto 0) = "00000000000000000000000" then
			s_sqrt_exeption <= X"7f800000";
		elsif i_data_input(30 downto 23) = X"FF" and i_data_input(22 downto 0) /= "00000000000000000000000" then
			s_sqrt_exeption <= X"ffffffff";
		elsif i_data_input(30 downto 23) = X"00" then
			s_sqrt_exeption <= X"00000000";
		else 
			s_sqrt_exeption <= i_oper_result;
		end if;
	end if;

end process;	


with i_selop select
	o_result_solved <= 	s_sin_exeption 	 when "000",
						s_cos_exeption 	 when "001",
						s_rsqrt_exeption when "010",
						s_log2_exeption  when "011",
						s_ex2_exeption 	 when "100",
						s_rcp_exeption 	 when "101",
						s_sqrt_exeption  when "110",
						i_data_input     when others;


	
end SFU_Exceptions_arch;

