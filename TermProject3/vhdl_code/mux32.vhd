library ieee;
use ieee.std_logic_1164.all;
entity mux32 is
port(x, y:in std_logic_vector(31 downto 0); sel:std_logic;
	z:out std_logic_vector(31 downto 0));
end mux32;

-- 32 bit mux dependent on selector 
architecture behav1 of mux32 is-- with if .. elsif
begin
  process(x, y, sel)
    begin
	-- if selector 0 assign x to z else assign y to z
        if sel='0' then
          z<=x;
        else
          z<=y;
	
        end if;
    end process;
  end behav1;
 
