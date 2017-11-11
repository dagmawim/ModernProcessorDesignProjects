library ieee;
use ieee.std_logic_1164.all;

entity IFIDPR is 
	port (	CLK: in std_logic;
		LIN,IIN: in std_logic_vector(31 downto 0);
		LOUT, IOUT: out std_logic_vector(31 downto 0));
end IFIDPR;

architecture behav of IFIDPR is
	begin
		process(CLK)
			begin
				if rising_edge(CLK) then
					IOUT <= IIN;
					LOUT <= LIN;
				end if;
		end process;
end behav;
