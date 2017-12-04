library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity over_Mux is
	port(   
		funct:in std_logic_vector(5 downto 0);
		add_overflow:in std_logic;
		mult_overflow:in std_logic;
		div_overflow:in std_logic;		
		overflow:out std_logic);
end over_Mux;

architecture behav of over_Mux is
begin
process(funct,add_overflow,mult_overflow,div_overflow)
	begin
		case funct is
			-- condition on funct
			when "000001" => -- FP Addition
				overflow<=add_overflow;
			when "000011" => -- FP Multiplication
				overflow<=mult_overflow;
			when "000100"=> -- FP Division
				overflow<=div_overflow;
			when others=> -- No Selection --------- MAYBE THIS SHOULD BE X?
				overflow<='0';
		end case;
	end process;
end behav;
