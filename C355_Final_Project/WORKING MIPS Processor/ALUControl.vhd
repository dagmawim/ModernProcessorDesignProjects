------------------------------------------------------
-- ECEC 355 Computer Architecture
-- MIPS Single Cycle Datapath
-- Dagmawi  Mulugeta - ALU Control
------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
entity alucontrol is

	port (  func: in STD_LOGIC_VECTOR(5 downto 0); aluop: in STD_LOGIC_VECTOR(1 downto 0);
		output: out STD_LOGIC_VECTOR(0 to 3)	
);

end alucontrol;


architecture behavioral of alucontrol is	  
begin
process(func,aluop)
	begin
			case aluop is
				when "00" =>
					output <= "0010";
				when "01" =>
					output <= "0110";
				when "10" =>
					case func is
						when "100000" =>
							output <= "0010";
						when "100010" =>
							output <= "0110";
						when "100100" =>
							output <= "0000";
						when "100101" =>
							output <= "0001";
						when "101010" =>
							output <= "0111";
					        when "000000" => 
						        output <= "1111"; 
						when others =>
							output <= "0000";
					end case;
				when "11" =>
					output <= "0011";
				when others =>
					output <= "0000";
			end case;
	end process;
end behavioral;
