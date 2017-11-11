
 --------------------------- ALU ADD ---------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALUADD is

	port( signal_1, signal_2: in std_logic_vector(31 downto 0);
		result: out std_logic_vector(31 downto 0));
end entity;
-- ALU Add
architecture Behavioral of ALUADD is

	begin
		process(signal_1,signal_2) 
		begin	
			result <= std_logic_vector((unsigned(signal_1) +unsigned(signal_2)));
		end process;
end architecture behavioral;
