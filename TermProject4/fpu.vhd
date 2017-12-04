library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity FPU is
port(
	fp_a:in std_logic_vector(31 downto 0);
	fp_b:in std_logic_vector(31 downto 0);
	clk:in std_logic;
	funct:in std_logic_vector(5 downto 0);
	zero: out std_logic;
	overflow:out std_logic;
	underflow:out std_logic;
	fp_result:out std_logic_vector(31 downto 0));
end entity FPU;
	

architecture struct of FPU is

---------------------	COMPONENTS   -------------------------
-- ADDER--
component FP_ADDER is
port(   fp_a, fp_b	:	in std_logic_vector(31 downto 0);
	clk, operator	:	in std_logic;
	overflow	:	out std_logic;
	underflow	: 	out std_logic;
        fp_result	:	out std_logic_vector(31 downto 0));
end component FP_ADDER;

-- SUBTRACTOR--
component FP_Subtractor is
port(   fp_a, fp_b	:	in std_logic_vector(31 downto 0);
	clk, operator	: 	in std_logic;
	underflow	: 	out std_logic;
	zero		: 	out std_logic;
        fp_result	:	out std_logic_vector(31 downto 0));
end component FP_Subtractor;

-- MULTIPLIER--
component FP_MULTIPLIER is
port (	fp_a		:	in std_logic_vector(31 downto 0);
	fp_b		:	in std_logic_vector(31 downto 0);
	clk		:	in std_logic;
	zero		:	out std_logic;
	overflow	:	out std_logic;
	underflow	:	out std_logic;
	fp_result	:	out std_logic_vector(31 downto 0));
end component FP_MULTIPLIER;

--DIVIDER--
component FP_DIVIDER is
port ( fp_a      	: 	in std_logic_vector(31 downto 0);
       fp_b      	: 	in std_logic_vector(31 downto 0);
       clk       	: 	in std_logic;
       zero      	: 	out std_logic;
       overflow  	: 	out std_logic;
       underflow 	: 	out std_logic;
       fp_result 	: 	out std_logic_vector(31 downto 0));
end component FP_DIVIDER;

-- Overflow Mux
component over_Mux is
port(   
	funct		:	in std_logic_vector(5 downto 0);
	add_overflow	:	in std_logic;
	mult_overflow	:	in std_logic;
	div_overflow	:	in std_logic;		
	overflow	:	out std_logic);
end component over_Mux;

-- Underflow and FP Result Mux
component under_fp_result_mux is
port(   
	funct		:	in std_logic_vector(5 downto 0);

	add_underflow	:	in std_logic;
        add_fp_result	:	in std_logic_vector(31 downto 0);

	sub_underflow	:	in std_logic;
        sub_fp_result	:	in std_logic_vector(31 downto 0);

	mult_underflow	:	in std_logic;
        mult_fp_result	:	in std_logic_vector(31 downto 0);

	div_underflow	:	in std_logic;
        div_fp_result	:	in std_logic_vector(31 downto 0);

	underflow	:	out std_logic;
        fp_result	:	out std_logic_vector(31 downto 0));
end component under_fp_result_mux;

-- Zero Mux
component zeroMux is
port(   
	funct		:	in std_logic_vector(5 downto 0);
	sub_zero	:	in std_logic;
	mult_zero	:	in std_logic;
	div_zero	:	in std_logic;
	zero		:	out std_logic);
end component zeroMux;


--------------------- INTERNAL SIGNALS -------------------------
-- Adder --
signal s_add_overflow: std_logic;
signal s_add_underflow: std_logic;
signal s_add_fp_result: std_logic_vector(31 downto 0);

-- Subtractor --
signal s_sub_underflow: std_logic;
signal s_sub_zero: std_logic;
signal s_sub_fp_result: std_logic_vector(31 downto 0);

-- Multiplier --
signal s_mult_zero: std_logic;
signal s_mult_overflow: std_logic;
signal s_mult_underflow: std_logic;
signal s_mult_fp_result: std_logic_vector(31 downto 0);

-- Divider --
signal s_div_zero: std_logic;
signal s_div_overflow: std_logic;
signal s_div_underflow: std_logic;
signal s_div_fp_result: std_logic_vector(31 downto 0);

--------------------- MAIN ----------------------------
begin

A1:FP_ADDER port map(		--In
				fp_a,
		     		fp_b,
				clk,
				'0',
				
				--Out
				s_add_overflow,
				s_add_underflow,
				s_add_fp_result);

S1:FP_SUBTRACTOR port map(	--In
				fp_a,
				fp_b,
				clk,
				'0',
				
				--Out
				s_sub_underflow,
				s_sub_zero,
				s_sub_fp_result);

M1:FP_MULTIPLIER port map(	--In
				fp_a,
				fp_b,
				clk,
				
				--Out
				s_mult_zero,
				s_mult_overflow,
				s_mult_underflow,
				s_mult_fp_result);
 
D1:FP_DIVIDER port map(		--In
				fp_a,
				fp_b,
				clk,
				
				--Out
				s_div_zero,
				s_div_overflow,
				s_div_underflow,
				s_div_fp_result);
 
OM1:OVER_MUX port map(		--In
				funct,
				s_add_overflow,
				s_mult_overflow,
				s_div_overflow,
				
				--Out
				overflow);

UFPM1:UNDER_FP_RESULT_MUX port map(	--Int
					funct,
					s_add_underflow,
					s_add_fp_result,
		
					s_sub_underflow,
				        s_sub_fp_result,

					s_mult_underflow,
					s_mult_fp_result,

					s_div_underflow,
					s_div_fp_result,
				
					--Out
					underflow,
                			fp_result);

Z1: ZEROMUX port map(			--In   
					funct,
					s_sub_zero,
					s_mult_zero,
					s_div_zero,
				
					--Out
					zero);

end struct;