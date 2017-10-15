library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Memory is
port(WriteData:in std_logic_vector(31 downto 0);
     Address:in std_logic_vector(31 downto 0);
     MemRead,MemWrite:in std_logic;
     ReadData:out std_logic_vector(31 downto 0));
end Memory;

architecture behavioral of Memory is
type mem_array is array(0 to 31) of STD_LOGIC_VECTOR (31 downto 0);

signal data_mem: mem_array := (
    X"00000000", -- initialize data memory
    X"00000000", -- mem 1
    X"00000000",
    X"00000000",
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
	process(MemRead, MemWrite,WriteData, Address)
	begin
	if MemRead='1' then
		-- fetch memory contents at the location specified by address and write
		-- to ReadData output signal
		-- Need to look more into this as to why 6 downto 2 in single cycle
		ReadData <= data_mem(conv_integer(Address));
	elsif MemWrite ='1' then
		--Memory contents at the location specified by address is overwritten with --WriteData content
		data_mem(conv_integer(Address)) <= WriteData;
	else 
		-- Do Nothing
	end if;
	end process;
end behavioral;
