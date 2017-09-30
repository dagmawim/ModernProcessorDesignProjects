----------------------------------REGISTER----------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;
 
 
use IEEE.STD_LOGIC_ARITH.ALL; -- initializing variable which will be used for conversion
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity regfile is
Port ( Readreg1 : in std_logic_vector(4 downto 0); -- assuming read register 1 and 2 are 5 bits long and write reg is as well
       Readreg2 : in std_logic_vector(4 downto 0);
       writereg : in std_logic_vector(4 downto 0);
       RegWr : in std_logic;		-- reg write from the control unit
      clk : in std_logic;		-- clock
     WriteData:in std_logic_vector(31 downto 0);	-- write data should be 32 bits
     ReadData1 : out std_logic_vector(31 downto 0);		-- output of register unit is 32 bits long 
     ReadData2 : out std_logic_vector(31 downto 0));
end regfile;
 
architecture comp of regfile is
type reg_file is array (0 to 31) of std_logic_vector(31 downto 0);  -- generating register file

signal regarray:reg_file:=(
x"00000000",x"00000000",x"00000000",x"00000000",  --0
x"00000000",x"00000000",x"00000000",x"00000000",  --4
x"00000000",x"00000000",x"00000000",x"00000000",  --8
x"00000000",x"00000000",x"00000000",x"00000000",  --12
x"00000000",x"00000000",x"00000000",x"00000000",  --16
x"00000000",x"00000000",x"00000000",x"00000000",  --20
x"00000000",x"00000000",x"00000000",x"00000000",  --24
x"00000000",x"00000000",x"00000000",x"00000000"); --28

begin  -- hard coding register file above

process(RegWr,clk)		-- processing off of the clock event and reg write signal obtained from control unit
variable addr_a,addr_b,addr_w:integer;   -- initializing variable which will be used for conversion
begin
addr_a:=CONV_INTEGER(Readreg1);  -- converting the 5 bit binary to integer and storing within respective variable
addr_b:=CONV_INTEGER(Readreg2);
addr_w:=CONV_INTEGER(writereg);
ReadData1<=regarray(addr_a);-- read data should be contents of register(i)with i being the numerical value of the 5 bit binary  ** Note 5 bit binary (11111) == 31
ReadData2<=regarray(addr_b);

if (Regwr='1' and clk'event) then 
	regarray(addr_w)<= WriteData;
end if;


end process;
end comp;





