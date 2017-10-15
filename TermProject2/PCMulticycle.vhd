library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity PCMulticycle is
port(clk,d:in std_logic;
     AddressIn:in std_logic_vector(31 downto 0);
     AddressOut:out std_logic_vector(31 downto 0));
end PCMulticycle;

architecture behavioral of PCMulticycle is
	signal address: std_logic_vector(31 downto 0):= "00000000000000000000000000000000";
        signal constant_four: std_logic_vector(31 downto 0):= "00000000000000000000000000000100";

	begin
	process(clk,AddressIn)
		begin	
		if clk'event and clk = '1' then
			Address <= AddressIn + constant_four;
			AddressOut <= Address;
		end if;
	end process;
end behavioral; 
