------------------------------------------------------
-- ECEC 355 Computer Architecture
-- MIPS Single Cycle Datapath
-- Dagmawi  Mulugeta - Instruction Memory
------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
--use IEEE.std_logic_arith.all;
--use ieee.std_logic_unsigned.all;
use IEEE.numeric_std.all;


entity InstMemory is
	port (  address: in STD_LOGIC_VECTOR (31 downto 0);
		ReadData: out STD_LOGIC_VECTOR(31 downto 0) );
end InstMemory;



architecture behavioral of InstMemory is	  

-- 128 byte instruction memory (32 rows * 4 bytes/row)
type ins_array is array(0 to 31) of STD_LOGIC_VECTOR(31 downto 0);

signal ins_mem: ins_array := (
        X"02959820",  
        X"8d100000",  
        X"8d110004",   
        X"0296b822",     
        X"ad130008",     
        X"00000000",  
        X"00000000",       
        X"00000000",     
        X"00000000",         
        X"00000000",
        X"00000000", 
        X"00000000", -- mem 10 
        X"00000000", 
        X"00000000",
        X"00000000",
        X"00000000",
        X"00000000",
        X"00000000",
        X"00000000",
        X"00000000",  
        X"00000000", -- mem 20
        X"00000000",
        X"00000000",
        X"00000000",
        X"00000000", 
        X"00000000",
        X"00000000",
        X"00000000",
        X"00000000",
        X"00000000", 
        X"00000000", -- mem 30
        X"00000000");

begin
	ReadData <= ins_mem(to_integer(unsigned(address(31 downto 2))));
end behavioral;
