------------------------------------------------------
-- ECEC 355 Computer Architecture
-- MIPS Single Cycle Datapath
-- Dagmawi  Mulugeta - Program Counter
------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity pc is

	port (  upcoming: in STD_LOGIC_VECTOR(31 downto 0); ck: in STD_LOGIC;
		current: out STD_LOGIC_VECTOR(31 downto 0)	
);

end pc;


architecture behavioral of pc is	  
	signal address: std_logic_vector(31 downto 0):= "00000000000000000000000000000000";

	begin

	process(ck)
		begin
		current <= address;
		if ck='0' and ck'event then
			address <= upcoming;
		end if;
		
	end process;
end behavioral;
