library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ShiftLeft2 is
-- Shifts elements by two( multiply by 2 )
port(	x: in std_logic_vector(31 downto 0); 
	y: out std_logic_vector(31 downto 0));

end ShiftLeft2;

architecture df of ShiftLeft2 is
	signal temp: std_logic_vector(33 downto 0);
	
	begin 
	--Adds two zeros at the end and takes the first 32 bits
		temp <= (x&"00");
		y<= temp(31 downto 0);
end df;

