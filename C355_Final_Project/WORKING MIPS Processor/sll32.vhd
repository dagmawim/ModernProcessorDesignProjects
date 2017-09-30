library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sll32 is
port(	x: in std_logic_vector(31 downto 0); -- std_ulogic_vector
	y: out std_logic_vector(31 downto 0)
);
end sll32;

architecture df of sll32 is
begin 
	y<= std_logic_vector(unsigned(x) sll 2);
end df;
