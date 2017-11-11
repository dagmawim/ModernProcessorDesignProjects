--------------------------------------------------ALU ------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- generating ALU object
entity ALU is
generic(n:natural:=32);
port(a,b:in std_logic_vector(n-1 downto 0);
	  Oper:in std_logic_vector(3 downto 0);
	  Result:buffer std_logic_vector(n-1 downto 0);
	  Zero,Overflow:buffer std_logic);
 end ALU;


-- generating an ALU's behavior
architecture Behavioral of ALU is
	--signal temp: std_logic_vector(32 downto 0);
       	--signal sht: integer;
	signal shift:std_logic_vector(4 downto 0);

	begin
	process(a,b,Oper,shift)
        
	variable var1,var2,var3:integer;
	begin
		zero <= '0';
		shift <= b(10 downto 6);
		-- condition on operation
		case Oper is
			when "0000" =>
				result <=a and b;
				--var1:= CONV_INTEGER(a);
				--var2:= CONV_INTEGER(a);
				--var3:= var1 * var2;
				--result <= std_logic_vector(to_unsigned(var3,32));
				zero <= '0';
			when "0001" =>
				result <= a or b;
				zero <= '0';
			when "0010" =>
				result <= std_logic_vector((unsigned(a)+unsigned(b)));
				zero <= '0';
			when "0110" =>
				result <= std_logic_vector(unsigned(a) - unsigned(b));
				if std_logic_vector(unsigned(a) - unsigned(b)) = "00000000000000000000000000000000" then
					zero <= '1';
				end if;
			when "0111" =>
				if a < b then
					result <= x"00000001";
				end if;
				if a > b then
					result <= x"00000000";
				end if;
				zero <= '0';
			when "1111" =>
				result <= std_logic_vector(unsigned(a) sll to_integer(unsigned(shift)));
				--sht <= to_integer(unsigned(shift));
			--when NOR condition here
			when "1100" =>
				result <= not(a or b);
			when others  =>
				result <= x"00000000";	
				zero <= '0';		
		end case;
	end process;
end architecture behavioral;




