library ieee;
use ieee.std_logic_1164.all;

-- Register EX/MEM Stage
entity EXMEMPR is
    port (clk:in std_logic;
	  WBCTRLIN:in std_logic_vector(1 downto 0);
     	  MCTRLIN: in std_logic_vector(2 downto 0);
     	  MIN:in std_logic_vector(31 downto 0);
     	  ZIN:in std_logic;
     	  GIN,DIN:in std_logic_vector(31 downto 0);
     	  BIN:in std_logic_vector(4 downto 0);
          
	  WBCTRLOUT:out std_logic_vector(1 downto 0);
     	  MCTRLOUT: out std_logic_vector(2 downto 0);
     	  MOUT:out std_logic_vector(31 downto 0);
     	  ZOUT:out std_logic;
     	  GOUT,DOUT:out std_logic_vector(31 downto 0);
     	  BOUT:out std_logic_vector(4 downto 0)
	);
end;


architecture behave of EXMEMPR is
    begin
        process(clk)
        begin
            if rising_edge(clk) then
                WBCTRLOUT <= WBCTRLIN;
		MCTRLOUT <= MCTRLIN;
		MOUT <= MIN;
		ZOUT <= ZIN;
		GOUT <= GIN;
		DOUT <= DIN;
		BOUT <= BIN;
            end if;
        end process;
   end;