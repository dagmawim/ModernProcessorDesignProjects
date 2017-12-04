library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity under_fp_result_mux is
	port(   
		funct:in std_logic_vector(5 downto 0);

		add_underflow:in std_logic;
                add_fp_result:in std_logic_vector(31 downto 0);

		sub_underflow:in std_logic;
                sub_fp_result:in std_logic_vector(31 downto 0);

		mult_underflow:in std_logic;
                mult_fp_result:in std_logic_vector(31 downto 0);

		div_underflow:in std_logic;
                div_fp_result:in std_logic_vector(31 downto 0);

		underflow:out std_logic;
                fp_result:out std_logic_vector(31 downto 0));
end under_fp_result_mux;

architecture behav of under_fp_result_mux is
begin
process(funct,add_underflow,add_fp_result,sub_underflow,sub_fp_result,
	      mult_underflow,mult_fp_result,div_underflow,div_fp_result)
	begin
		case funct is
			-- condition on funct
			when "000001" => -- FP Addition
				underflow<=add_underflow;
                		fp_result<=add_fp_result;
			when "000010" => -- FP Subtraction
				underflow<=sub_underflow;
                		fp_result<=sub_fp_result;
			when "000011" => -- FP Multiplication
				underflow<=mult_underflow;
                		fp_result<=mult_fp_result;
			when "000100"=> -- FP Division
				underflow<=div_underflow;
                		fp_result<=div_fp_result;
			when others=> -- No Selection --------- MAYBE THESE SHOULD BE X's ?
				underflow<='0';
                		fp_result<=(others=>'0');
		end case;
	end process;
end behav;
