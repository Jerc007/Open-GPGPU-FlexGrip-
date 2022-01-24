----------------------------------------------------------------------------------
-- Company:          Univerity of Massachusetts 
-- Engineer:         Kevin Andryc
-- 
-- Create Date:      17:50:27 09/19/2010  
-- Module Name:      scalar_processor - arch 
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

entity scalar_processor is
	port(
		alu_opcode_in  		: in  alu_opcode_type;
		instr_subop_in 		: in  std_logic_vector(2 downto 0);
		instr_marker_in		: in  instr_marker_type; -- ADDED GIANLUCA ROASCIO
		src1_in             : in  std_logic_vector(31 downto 0);
		src2_in             : in  std_logic_vector(31 downto 0);
		src3_in             : in  std_logic_vector(31 downto 0);
		src1_neg_in         : in  std_logic;							-- NOT USED
		src2_neg_in         : in  std_logic;							-- NOT USED
		src3_neg_in         : in  std_logic;
		carry_in            : in  std_logic;
		saturate_in         : in  std_logic;
		w32_in              : in  std_logic;
		is_signed_in        : in  std_logic;
		abs_saturate_in     : in  std_logic_vector(1 downto 0);
		cvt_neg_in          : in  std_logic;
		cvt_type_in         : in  std_logic_vector(2 downto 0);
		set_cond_in         : in  std_logic_vector(2 downto 0);
		carry_out           : out std_logic;
		overflow_out        : out std_logic;
		sign_out            : out std_logic;
		zero_out            : out std_logic;
		result_out          : out std_logic_vector(31 downto 0)
	);
end scalar_processor;

architecture arch of scalar_processor is
	signal srca_i : std_logic_vector(31 downto 0);
	signal srcb_i : std_logic_vector(31 downto 0);

	signal srca_iaddsub_i : std_logic_vector(31 downto 0);
	signal srcb_iaddsub_i : std_logic_vector(31 downto 0);

	signal src_a_neg_i : std_logic;
	signal src_b_neg_i : std_logic;
	signal src_c_neg_i : std_logic;

	signal sub_en_i    : std_logic;
	signal carry_i     : std_logic;
	signal w32_i       : std_logic;
	signal is_signed_i : std_logic;
	signal saturate_i  : std_logic;

	signal sum_o          : std_logic_vector(31 downto 0);
	signal carry_o        : std_logic;
	signal overflow_o     : std_logic;
	signal product_o      : std_logic_vector(31 downto 0);
	signal sll_o          : std_logic_vector(31 downto 0);
	signal srl_o          : std_logic_vector(31 downto 0);
	signal neg_o          : std_logic_vector(31 downto 0);
	signal and_o          : std_logic_vector(31 downto 0);
	signal or_o           : std_logic_vector(31 downto 0);
	signal xor_o          : std_logic_vector(31 downto 0);
	signal max_o          : std_logic_vector(31 downto 0);
	signal min_o          : std_logic_vector(31 downto 0);
	signal convert_o      : std_logic_vector(31 downto 0);
	signal compute_pred_o : std_logic_vector(31 downto 0);
	signal sign_o         : std_logic;
	signal zero_o         : std_logic;
	-- ADDED GIANLUCA ROASCIO
	signal sign_fl	      : std_logic;
	signal zero_fl		  : std_logic;

begin
	
	srca_i <= src1_in;

	srcb_i <= src2_in;

	srca_iaddsub_i <= product_o when (alu_opcode_in = IMAD24) else src1_in;

	srcb_iaddsub_i <= src3_in when (alu_opcode_in = IMAD24 or alu_opcode_in = IMAD24C) else src2_in; 
	--MM: removed "or (is_full_normal_in = '1')" from the condition statement

	src_a_neg_i <= '1' when (alu_opcode_in = ISUB) else '0';

	src_b_neg_i <= src3_neg_in when (alu_opcode_in = IADD) else '0';

	src_c_neg_i <= src3_neg_in;

	-- MODIFIED GIANLUCA ROASCIO - REDUNDANCE OF INFORMATION, IF src_a_neg_i IS ALREADY SET, sub_en_i MUST NOT BE SET OTHERWISE THE NEGATION IS MADE TWICE
	--sub_en_i <= '1' when (alu_opcode_in = ISUB) else '0';
	sub_en_i <= '0';

	w32_i <= '1' when ((alu_opcode_in = IMAD24) or (alu_opcode_in = IMAD24C)) else w32_in; 

	carry_i <= carry_in when ((alu_opcode_in = IADDC) or (alu_opcode_in = IMAD24C)) else '0';

	is_signed_i <= is_signed_in when (alu_opcode_in = IMAD24 and instr_marker_in = IMM) -- ADDED CONDITION GIANLUCA ROASCIO - SPECIFIC FOR IMAD32I
		else '1' when (((alu_opcode_in = IMAD24) or (alu_opcode_in = IMAD24C)) and 
			((instr_subop_in = "001") or (instr_subop_in = "100") or (instr_subop_in = "111"))) 
		else '0' when (((alu_opcode_in = IMAD24) or (alu_opcode_in = IMAD24C))	and 
			((instr_subop_in = "000") or (instr_subop_in = "010") or (instr_subop_in = "011") or (instr_subop_in = "101") or (instr_subop_in = "110"))) 
		else is_signed_in;

	saturate_i <= '1' when (((alu_opcode_in = IMAD24) or (alu_opcode_in = IMAD24C)) 
						and (instr_subop_in = "101")) else 
					'0' when (((alu_opcode_in = IMAD24) or (alu_opcode_in = IMAD24C)) and 
							((instr_subop_in = "000") or (instr_subop_in = "001") or
							(instr_subop_in = "010") or (instr_subop_in = "011") or 
							(instr_subop_in = "100") or (instr_subop_in = "110") or 
							(instr_subop_in = "111"))) else 
					saturate_in;

	uIAddSubtract : integer_add_subtract
		port map(
			a_in         => srca_iaddsub_i,
			a_neg_in     => src_a_neg_i,
			b_in         => srcb_iaddsub_i,
			b_neg_in     => src_b_neg_i,
			carry_in     => carry_i,
			saturate_in  => saturate_i,
			sub_en       => sub_en_i,
			w32_in       => w32_i,
			carry_out    => carry_o,
			overflow_out => overflow_o,
			result_out   => sum_o
		);

	uIMult24 : integer_mult_24
		port map(
			a_in         => srca_i,
			a_neg_in     => src_a_neg_i,
			b_in         => srcb_i,
			b_neg_in     => src_b_neg_i,
			is_signed_in => is_signed_i,
			--w32_in       => w32_i, -- MODIFIED GIANLUCA ROASCIO
			w32_in       => w32_in,
			result_out   => product_o
		);

	uShiftLogical : shift_logical
		port map(
			a_in         => srca_i,
			b_in         => srcb_i,
			is_signed_in => is_signed_i,
			w32_in       => w32_i,
			sll_out      => sll_o,
			srl_out      => srl_o
		);

	uBoolean : boolean_functions
		port map(
			a_in    => srca_i,
			b_in    => srcb_i,
			and_out => and_o,
			neg_out => neg_o,
			or_out  => or_o,
			xor_out => xor_o
		);

	uMinMax : min_max						-- is this new for the processor???
		port map(
			a_in         => srca_i,
			b_in         => srcb_i,
			is_signed_in => is_signed_i,
			w32_in       => w32_i,
			max_out      => max_o,
			min_out      => min_o
		);

	uConvertIntInt : convert_int_int
		port map(
			a_in            => srca_i,
			abs_saturate_in => abs_saturate_in,
			cvt_neg_in      => cvt_neg_in,
			cvt_type_in     => cvt_type_in,
			w32_in          => w32_i,
			result_out      => convert_o
		);

	uComputeSetPredI : compute_set_pred_i
		port map(
			is_signed_in => is_signed_i,
			set_cond_in  => set_cond_in,
			src_1_in     => srca_i,
			src_2_in     => srcb_i,
			w32_in       => w32_i,
			result_out   => compute_pred_o,
			sign_out     => sign_o,
			zero_out     => zero_o
		);

	result_out <= sum_o when ((alu_opcode_in = IADD) or (alu_opcode_in = IADDC) or (alu_opcode_in = ISUB) or 
							(alu_opcode_in = IMAD24) or (alu_opcode_in = IMAD24C)) else 
				  min_o when (alu_opcode_in = work.gpgpu_package.MIN) else 
				  max_o when (alu_opcode_in = MAX) else 
				  sll_o when (alu_opcode_in = SHL) else 
				  srl_o when (alu_opcode_in = SHR) else 
				  and_o when (alu_opcode_in = AND_OP) else 
				  or_o when (alu_opcode_in = OR_OP) else 
				  xor_o when (alu_opcode_in = XOR_OP) else 
				  neg_o when (alu_opcode_in = NEG_OP) else
				  product_o when (alu_opcode_in = IMUL24) else 
				  convert_o when (alu_opcode_in = CVT) else 
				  compute_pred_o when (alu_opcode_in = SET) else  
				  x"00000000";

	-- ADDED GIANLUCA ROASCIO
	zero_fl <= '1' when (result_out = x"00000000") else '0';
	sign_fl <= '1' when (is_signed_i = '1' and result_out(31) = '1' and w32_i = '1') 
		  else '1' when (is_signed_i = '1' and result_out(15) = '1' and w32_i = '0')
		  else '0'; 

	carry_out    <= carry_o;
	overflow_out <= overflow_o;
	-- MODIFIED GIANLUCA ROASCIO
	--sign_out     <= sign_o;
	sign_out     <= sign_o when (alu_opcode_in = SET) else sign_fl;
	--zero_out     <= zero_o;
	zero_out     <= zero_o when (alu_opcode_in = SET) else zero_fl;

end arch;

