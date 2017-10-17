library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sll26 is
port(	x: in std_logic_vector(25 downto 0); -- std_ulogic_vector
	y: out std_logic_vector(27 downto 0)
);
end sll26;

architecture df of sll26 is
begin 
	y<= x&"00";
end df;

