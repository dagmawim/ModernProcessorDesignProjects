library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity shifter is 
port(x : in std_logic_vector(31 downto 0); 
     shamft: in std_logic_vector(4 downto 0);
     LR: in std_logic;
     Y: out std_logic_vector(31 downto 0));
end shifter;


architecture behavioral of shifter is
        begin
		process(LR,x,shamft)
			begin       		
			case LR is
				when '0' =>
					Y <= std_logic_vector(shift_left(unsigned(x), to_integer(unsigned(shamft))));
				when '1' =>
					Y <= std_logic_vector(shift_right(unsigned(x), to_integer(unsigned(shamft))));
				when others =>
					-- Need to think this out Nothing should happen but should work just fine

			end case;
		end process;
end architecture behavioral;