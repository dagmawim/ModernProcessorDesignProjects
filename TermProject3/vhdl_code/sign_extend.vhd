library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

--extend 16 bits to 32 bits
entity SignExtend  is
port(
	x: in std_logic_vector(15 downto 0); --16 bit
	y: out std_logic_vector(31 downto 0) --32 bit
);
end SignExtend;

-- sign extend an x by y length
architecture behav of SignExtend is
begin
	y <= std_logic_vector(resize(signed(x), y'length));
end behav;

