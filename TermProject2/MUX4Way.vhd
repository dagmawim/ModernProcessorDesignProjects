library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MUX4Way is
port(v,w,x,y:in std_logic_vector(31 downto 0);
     sel: in std_logic_vector(1 downto 0);
     z:out std_logic_vector(31 downto 0));
end MUX4Way;

architecture behavioral of MUX4Way is
begin
	process(sel,v,w,x,y)
	begin
		if (sel="00") then
			-- v treated as input zero
			z <= v;
		elsif(sel ="01") then
			-- w treated as input 1
			z <= w;
		elsif(sel ="10") then
			-- x treated as input 2
			z <= x;
		elsif(sel ="11") then
			-- y treated as input 3
			z <= y;
		else
			-- do nothing
		end if;
end process;
end behavioral;


