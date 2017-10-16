library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity RegA is
port(x:in std_logic_vector(31 downto 0);
     clk:in std_logic;
     y:out std_logic_vector(31 downto 0));
end RegA;
 
architecture behav of RegA is
	begin
		process(clk)
			begin
				if clk = '1' and clk'event then --on rising edge of clk
					y <= x; -- store value of x in y
				end if;
		end process;
end behav;

 