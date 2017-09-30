library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity concatenate is
port(x: in std_logic_vector(27 downto 0);
x1: in std_logic_vector(3 downto 0);
z: out std_logic_vector(31 downto 0));
end concatenate;

architecture df of concatenate is
begin

z<= x1&x;

end df;
