-- Floating-Point Multiplier
-- ECEC 412 - Term Project 4
-- 11/27/17

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FP_MULTIPLIER is
port (	fp_a		:	in	std_logic_vector(31 downto 0);
	fp_b		:	in	std_logic_vector(31 downto 0);
	clk		:	in	std_logic;
	zero		:	out 	std_logic;
	overflow	:	out	std_logic;
	underflow	:	out	std_logic;
	fp_result	:	out	std_logic_vector(31 downto 0));
end entity FP_MULTIPLIER;

architecture behav of FP_MULTIPLIER is
begin
	process(fp_a, fp_b, clk)

	-- Define variables for sign, exponent (bias and unbias) and fraction for operand a and operand b and the results	
	variable fp_a_sign: std_logic := '0';
	variable fp_a_exponent_bias: unsigned(7 downto 0) := (others=>'0');
	variable fp_a_exponent_unbias: signed(7 downto 0) := (others=>'0');
	variable fp_a_fraction: unsigned(23 downto 0) := (others=>'0'); -- 24bits; bit 23 will account for hidden bit

	variable fp_b_sign: std_logic := '0';
	variable fp_b_exponent_bias: unsigned(7 downto 0) := (others=>'0');
	variable fp_b_exponent_unbias: signed(7 downto 0) := (others=>'0');
	variable fp_b_fraction: unsigned(23 downto 0) := (others=>'0'); -- 24bits; bit 23 will account for hidden bit

	variable result_sign: std_logic := '0';
	variable result_exponent_bias: unsigned(7 downto 0) := (others=>'0');
	variable result_exponent_unbias: signed(7 downto 0) := (others=>'0');
	variable result_fraction: unsigned(47 downto 0) := (others=>'0'); -- two 24 bit fractions (consider hidden bit)l
	
	-- Bit 23 = hidden bit; Bit 24 = store potential carry
	variable operand1		: unsigned(24 downto 0) := (others=>'0');
	variable operand2		: unsigned(24 downto 0) := (others=>'0');
	variable temp_sum		: unsigned(24 downto 0) := (others=>'0');

	-- Define operation related variables
	variable shift_add_counter	: unsigned(4 downto 0);

	begin
--		if rising_edge(clk) then
			fp_a_sign		:= fp_a(31);
			fp_a_exponent_bias	:= unsigned(fp_a(30 downto 23));
			fp_a_exponent_unbias	:= signed(fp_a_exponent_bias + "10000001"); --unbias = bias + -127 (-127 is represented in 2's comp)
			fp_a_fraction	 	:= unsigned('1' & fp_a(22 downto 0));
			
			fp_b_sign		:= fp_b(31);
			fp_b_exponent_bias	:= unsigned(fp_b(30 downto 23));
			fp_b_exponent_unbias	:= signed(fp_b_exponent_bias + "10000001"); --unbias = bias + -127 (-127 is represented in 2's comp)
			fp_b_fraction		:= unsigned('1' & fp_b(22 downto 0));

			overflow <= '0';
			underflow <= '0';
			zero <= '0';

			-- Set sign of result
			-- If sign of fp_a is the same as sign of fp_b -- result_sign = 0
			-- If sign of fp_a is different than sign of fp_b -- result_sign = 1 
			result_sign := fp_a_sign xor fp_b_sign;

			--Floating Point Arthimetic based on Flowchart on pg. 322
			-- Check for zero 
			if (fp_a_exponent_bias = 0 and fp_a_fraction = 2**23) then
				-- Set zero signal to 1
				zero	 			<= '1';
				result_sign 			:= '0';
				result_exponent_bias 		:= "00000000";
				result_fraction(45 downto 23) 	:= "00000000000000000000000";
			elsif (fp_b_exponent_bias = 0 and fp_b_fraction = 2**23) then
				-- Set zero signal to 1
				zero	 			<= '1';
				result_sign 			:= '0';
				result_exponent_bias 		:= "00000000";
				result_fraction(45 downto 23) 	:= "00000000000000000000000";

			-- Floating Point Multiplication
			else
				-- Add exponents
				result_exponent_unbias		:= fp_a_exponent_unbias + fp_b_exponent_unbias;
				
				--Check for Overflow
				if (result_exponent_unbias > 127) then
					overflow		<= '1';
				--Check for Underflow
				elsif (result_exponent_unbias < -126) then
					underflow		<= '1';
				end if;
				
				-- Apply bias to unbiased exponent
				result_exponent_bias		:= unsigned(result_exponent_unbias + "01111111"); --bias= unbias +127

				shift_add_counter		:= b"11000";
				result_fraction(23 downto 0)	:= fp_b_fraction;	
				operand1			:= unsigned('0' & fp_a_fraction);
				
				-- Implementing Shihao's Pseudocode; multiply significands
				while (shift_add_counter /= 0) loop -- 24 iterations
					if (result_fraction(0) = '1') then
						operand2			:= unsigned('0' & result_fraction(47 downto 24));
						temp_sum			:= operand1 + operand2;

						result_fraction(47 downto 24) 	:= temp_sum(23 downto 0);
						result_fraction(46 downto 0) 	:= result_fraction(47 downto 1);
						result_fraction(47)		:= temp_sum(24);
						
					else
						result_fraction(46 downto 0) 	:= result_fraction(47 downto 1);
						result_fraction(47)		:= '0';
					end if;
					shift_add_counter			:= shift_add_counter - 1;
				end loop;

				-- Normalize result 
				if (result_fraction(47) = '1') then
					-- overflow may happen here
					if (result_exponent_bias = 254) then
						overflow <= '1';
					end if;
					
					result_fraction 	:= unsigned('0' & result_fraction(47 downto 1));
					result_exponent_bias 	:= result_exponent_bias + 1;
				end if;
			end if;
			fp_result <= result_sign & std_logic_vector(result_exponent_bias) & std_logic_vector(result_fraction(45 downto 23));
--	end if;
end process;

end behav;