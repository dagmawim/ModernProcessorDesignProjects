library ieee;
use ieee.std_logic_1164.all;

entity MEMWBPR is
	port(CLK: in std_logic;
	WBCTRLIN:in std_logic_vector(1 downto 0);
	HIN,DIN:in std_logic_vector(31 downto 0);
	BIN:in std_logic_vector(4 downto 0);
	WBCTRLOUT:out std_logic_vector(1 downto 0);
	HOUT,DOUT:out std_logic_vector(31 downto 0);
	BOUT:out std_logic_vector(4 downto 0));

end MEMWBPR;

architecture behav of MEMWBPR is 
begin 
	process(clk)
	begin 
		if rising_edge(CLK) then
			WBCTRLOUT <= WBCTRLIN;
			HOUT <= HIN;
			DOUT <= DIN;
			BOUT <= BIN;
		end if;
	end process;
end behav;