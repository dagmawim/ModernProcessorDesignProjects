------------------------------------------------------
-- ECEC 355 Computer Architecture
-- MIPS Single Cycle Datapath
-- Dagmawi  Mulugeta - Program Counter
------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

-- Code for program counter
entity pc is

	port (  clk: in STD_LOGIC; AddressIn: in STD_LOGIC_VECTOR(31 downto 0); 
		AddressOut: out STD_LOGIC_VECTOR(31 downto 0)	
);

end pc;


architecture behavioral of pc is	  
	signal address: std_logic_vector(31 downto 0):= "00000000000000000000000000000000";

	begin
	-- Process a clock event and perform logic 
	process(clk)
		begin
		AddressOut <= address;
		if clk='0' and clk'event then
			address <= AddressIn;
		end if;
		
	end process;
end behavioral;
