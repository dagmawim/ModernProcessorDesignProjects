library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

--extend 16 bits to 32 bits
entity sign_extend is
port(
	signIn: in std_logic_vector(15 downto 0); --16 bit
	signOut: out std_logic_vector(31 downto 0) --32 bit
);
end sign_extend;

architecture behav of sign_extend is
begin
	signOut <= std_logic_vector(resize(signed(signin), signOut'length));
end behav;

