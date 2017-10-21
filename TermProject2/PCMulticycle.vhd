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
        --signal constant_four: std_logic_vector(31 downto 0):= "00000000000000000000000000000100";

	begin
	process(AddressIn,d,clk)
		begin	
			--falling_edge(clk) and 
		--if clk'event and clk='1' then
			--Address <= AddressIn;
			--AddressOut <= Address;
			--AddressOut <= AddressIn;
		--end if;

		AddressOut <= address;
		if clk='0' and clk'event  and d ='1' then
			address <= AddressIn;
		end if;
	end process;
end behavioral; 
