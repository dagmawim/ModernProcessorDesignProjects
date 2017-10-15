library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MUX3Way is
port(w,x,y:in std_logic_vector(31 downto 0);
     sel: in std_logic_vector(1 downto 0);
     z:out std_logic_vector(31 downto 0));
end MUX3Way;

architecture behavioral of MUX3Way is
	begin
	process(sel,w,x,y)
		begin
		if (sel = "00") then
			-- w treated as input zero
			z <= w;
		elsif(sel ="01") then
			-- x treated as input 1
			z<=x;
		elsif(sel ="10") then
			-- y treated as input 2
			z<=y;
		else
			-- do nothing
		end if;
end process;
end behavioral;
