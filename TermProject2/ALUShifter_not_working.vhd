

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- generating ALU object
entity ALUShifter is
	-- assigning ports for the ALU (input and output)
	port( signal_1, signal_2: in std_logic_vector(31 downto 0);
		operation : in std_logic_vector(3 downto 0); 
		zero: out std_logic;
		result: out std_logic_vector(31 downto 0));
end entity;



-- generating an ALU's behavior
architecture Behavioral of ALUShifter is

component shifter
  port(x : in std_logic_vector(31 downto 0); 
     shamft: in std_logic_vector(4 downto 0);
     LR: in std_logic;
     Y: out std_logic_vector(31 downto 0));
end component;

	--signal temp: std_logic_vector(32 downto 0);
      signal sht: integer;
      signal  shamft : std_logic_vector(4 downto 0);
	begin
	process(signal_1,signal_2,operation)
      
	variable var1,var2,var3:integer;
	VARIABLE LR : std_logic;
	begin
		zero <= '0';
		case operation is
			when "0010" =>
				result <= std_logic_vector((unsigned(signal_1)+unsigned(signal_2)));
				zero <= '0';
			when "0110" =>
				result <= std_logic_vector(unsigned(signal_1) - unsigned(signal_2));
				if std_logic_vector(unsigned(signal_1) - unsigned(signal_2)) = "00000000000000000000000000000000" then
					zero <= '1';
				end if;
			when "0001" =>
				result <= signal_1 or signal_2;
				zero <= '0';
			when "0000" =>
				--result <=signal_1 and signal_2;
				var1:= CONV_INTEGER(signal_1);
				var2:= CONV_INTEGER(signal_1);
				var3:= var1 * var2;
				result <= std_logic_vector(to_unsigned(var3,32));
				zero <= '0';
			when "0111" =>
				if signal_1 < signal_2 then
					result <= x"00000001";
				end if;
				if signal_1 > signal_2 then
					result <= x"00000000";
				end if;
				zero <= '0';
			when "1111" => -- COME BACK AND THINK ABOUT THIS!!!!!!! WHY 1111
				--result <= std_logic_vector(unsigned(signal_2) sll to_integer(unsigned(shift)));
				--sht <= to_integer(unsigned(shift));
                               if signal_2(5 downto 0) = "000000" then
                                    shamft <= signal_2(10 downto 6);
				    LR := '1';
                                    result <= shifter(signal_1, shamft,LR);
                                end if;
                               if signal_2(5 downto 0) = "000010" then
                                     shamft <= signal_2(10 downto 6);
			             LR := '0';
                                     result <= shifter(signal_1, shamft, LR);
                                end if;


			when others  =>
				result <= x"00000000";	
				zero <= '0';		
		end case;
	end process;
end architecture behavioral;
