library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity AND2 is
	port(x,y:in std_logic;z:out std_logic);
end AND2;
-- AND Operation on Two inputs
architecture behav of AND2 is
begin 
	z <= x and y;
end behav;