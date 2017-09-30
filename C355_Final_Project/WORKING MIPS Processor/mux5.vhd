library ieee;
use ieee.std_logic_1164.all;
entity mux5 is
port(x0, x1:in std_logic_vector(4 downto 0); sel:std_logic;
	y:out std_logic_vector(4 downto 0));
end mux5;

architecture behav1 of mux5 is-- with if .. elsif
begin
  process(x0, x1, sel)
    begin
        if sel='0' then
          y<=x0;
        else
          y<=x1;
	
        end if;
    end process;
  end behav1;
 
