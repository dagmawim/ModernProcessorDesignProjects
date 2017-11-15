------------------------------------------------------
-- ECEC 355 Computer Architecture
-- MIPS Single Cycle Datapath
-- Cem Sahin - 08/04/2009
-- modified 07/21/2015, 02/03/2017
------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
entity DataMemory is
	port(   WriteData:in std_logic_vector(31 downto 0);
     		Address:in std_logic_vector(31 downto 0);
     		Clk,MemRead,MemWrite:in std_logic;
     		ReadData:out std_logic_vector(31 downto 0));
end DataMemory;

-- Data Memory 
architecture behavioral of DataMemory is	  

type mem_array is array(0 to 31) of STD_LOGIC_VECTOR (31 downto 0);

-- 32 bit memory
signal data_mem: mem_array := (
    X"00000000", -- initialize data memory
    X"00000000", -- mem 1
    X"00000000",
    X"00000004",
    X"00000000",
    X"00000000",
    X"00000000",
    X"00000004",
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

readdata <= data_mem(conv_integer(address(6 downto 2))) when MemRead = '1';

-- perform memwrite conditioning on clock event
mem_process: process(address, writedata,clk)
begin
	if clk'event then
		if (MemWrite = '1') then
			data_mem(conv_integer(address(6 downto 2))) <= writedata;
		end if;
	end if;
end process mem_process;

end behavioral;