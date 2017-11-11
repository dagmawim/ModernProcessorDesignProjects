library ieee;
use ieee.std_logic_1164.all;
entity mux5 is
port(x, y:in std_logic_vector(4 downto 0); sel:std_logic;
	z:out std_logic_vector(4 downto 0));
end mux5;

-- 5 bit mux dependent on the selector
architecture behav1 of mux5 is-- with if .. elsif
begin
-- process inputs and selector
  process(x, y, sel)
    begin
	-- if selector 0 assign x to z
        if sel='0' then
          z<=x;
	-- if selector 1 assign y to z
        else
          z<=y;
	
        end if;
    end process;
  end behav1;
 
