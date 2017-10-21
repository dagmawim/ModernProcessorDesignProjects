----------------------------------REGISTER----------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_ARITH.ALL; -- initializing variable which will be used for conversion
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity registers is

Port ( RR1,RR2,WR : in std_logic_vector(4 downto 0); -- assuming read register 1 and 2 are 5 bits long and write reg is as well
       WD:in std_logic_vector(31 downto 0);	-- write data should be 32 bits       
       clk, RegWrite : in std_logic;		-- reg write from the control unit
       RD1,RD2 : out std_logic_vector(31 downto 0)		-- output of register unit is 32 bits long 
      );
end registers;
 
architecture comp of registers is
type reg_file is array (0 to 31) of std_logic_vector(31 downto 0);  -- generating register file
-- register signals 32 32 bit registers
signal regarray:reg_file:=(
x"00000000",x"00000000",x"00000000",x"00000000",  --0
x"00000000",x"00000000",x"00000000",x"00000000",  --4
x"00000004",x"00000000",x"00000000",x"00000000",  --8
x"00000000",x"00000000",x"00000000",x"00000000",  --12
x"00000000",x"00000000",x"0000000d",x"00000004",  --16
x"00000000",x"00000000",x"00000000",x"00000000",  --20
x"00000000",x"00000000",x"00000000",x"00000000",  --24
x"00000000",x"00000000",x"00000000",x"00000000"); --28

begin  -- hard coding register file above

-- condition on register write signal and clock 
process(RegWrite,clk)		-- processing off of the clock event and reg write signal obtained from control unit
variable addr_a,addr_b,addr_w:integer;   -- initializing variable which will be used for conversion
begin
addr_a:=CONV_INTEGER(RR1);  -- converting the 5 bit binary to integer and storing within respective variable
addr_b:=CONV_INTEGER(RR2);
addr_w:=CONV_INTEGER(WR);
RD1<=regarray(addr_a);-- read data should be contents of register(i)with i being the numerical value of the 5 bit binary  ** Note 5 bit binary (11111) == 31
RD2<=regarray(addr_b);

if (RegWrite='1' and rising_edge(clk)) then 
	regarray(addr_w)<= WD;
end if;


end process;
end comp;





