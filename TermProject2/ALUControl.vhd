------------------------------------------------------
-- ECEC 355 Computer Architecture
-- MIPS Single Cycle Datapath
-- Dagmawi  Mulugeta - ALU Control
------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

-- ALU Logic
entity alucontrol is

	port (  aluop: in STD_LOGIC_VECTOR(1 downto 0); func: in STD_LOGIC_VECTOR(5 downto 0); 
		operation: out STD_LOGIC_VECTOR(0 to 3)	
);

end alucontrol;


architecture behavioral of alucontrol is	  
begin
	process(func,aluop)
	begin
        -- process ALU OP control signal and perform logic (set operation to be performed)
	--  00 -> load word | store word
	--  01 -> branch on equal 
	--  10 -> R - type
	--  11 -> Shift Left and Shift Right
			case aluop is
				when "00" =>
					operation <= "0010";
				when "01" =>
					operation <= "0110";
				when "10" =>
					case func is
						when "100000" =>
							operation <= "0010";
						when "100010" =>
							operation <= "0110";
						when "100100" =>
							operation <= "0000";
						when "100101" =>
							operation <= "0001";
						when "101010" =>
							operation <= "0111";
					        when "000000" => 
						        operation <= "1111";
						when others =>
							operation <= "0000";
					end case;
				when "11" =>
					operation <= "0011";
				when others =>
					operation <= "0000";
			end case;
	end process;
end behavioral;
