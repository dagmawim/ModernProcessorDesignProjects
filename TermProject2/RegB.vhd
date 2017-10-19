library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity RegB is
port(x:in std_logic_vector(31 downto 0);
     clk:in std_logic;
     y:out std_logic_vector(31 downto 0));
end RegB;
 
architecture behav of RegB is
	begin
		process(clk)
			begin
				if rising_edge(clk) then --on rising edge of clk 
					y <= x; -- store value of x in y
				end if;
		end process;
end behav;