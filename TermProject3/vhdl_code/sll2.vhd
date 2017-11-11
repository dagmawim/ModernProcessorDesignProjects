library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ShiftLeft2Jump is
port(	x: in std_logic_vector(25 downto 0); y:in std_logic_vector(3 downto 0); -- std_ulogic_vector
	z: out std_logic_vector(31 downto 0)
);
end ShiftLeft2Jump;

-- shift left instruction 
architecture df of ShiftLeft2Jump is
begin 
	z<= y&x&"00";
end df;

