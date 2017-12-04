library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity zeroMux is
	port(   
		funct:in std_logic_vector(5 downto 0);
		sub_zero:in std_logic;
		mult_zero:in std_logic;
		div_zero:in std_logic;
		zero:out std_logic);
end zeroMux;

architecture behav of zeroMux is
begin
process(funct,sub_zero,mult_zero,div_zero)
	begin
		case funct is
			when "000010" => -- FP Subtraction
				zero<=sub_zero;
			when "000011" => -- FP Multiplication
				zero<=mult_zero;
			when "000100"=> -- FP Division
				zero<=div_zero;
			when others=> -- No Selection --
				zero<='0';
		end case;
	end process;
end behav;
