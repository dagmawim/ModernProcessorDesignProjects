library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Memory is
port(WriteData:in std_logic_vector(31 downto 0);
     Address:in std_logic_vector(31 downto 0);
     MemRead,MemWrite,clk:in std_logic;
     ReadData:out std_logic_vector(31 downto 0));
end Memory;

architecture behavioral of Memory is
type mem_array is array(0 to 127) of STD_LOGIC_VECTOR (7 downto 0);

signal data_mem: mem_array := (
    
 	--Instruction Block
	--"8d100028",  --		lw $s0,40($t0)
    	--"8d11002c",  --		lw $s1,44($t0)  
    	--"12300002",  --		beq $s0,$s1,12  
    	--"02959820",  --		add $s3,$s4,$s5
    	--"08000006",  --		j 24   
    	--"02959822",  --L:  		sub $s3,$s4,$s5	
    	--"ad130030",  --exit: 		sw $s3,48($t0)     
    
    X"8d", -- 0 
    X"10",
    X"00",
    X"28",     
   
    X"8d", -- 4
    X"11",
    X"00",
    X"2c",           
    
    X"12", -- 8
    X"30",
    X"00", 
    X"02",  
    
    X"02", -- 12
    X"95",
    X"98",
    X"20",  
    
    X"08", --16
    X"00",
    X"00",
    X"06",  
    
    X"02", --20
    X"95",
    X"98",
    X"22", 
    
    X"ad", --24
    X"13",
    X"00",
    X"30", 
    
    X"00", --28
    X"00",
    X"00",
    X"00",
    
    X"00", --32
    X"00",  
    X"00", 
    X"00",
    
    X"00", --36
    X"00",
    X"00", 
    X"00",

    X"00", --40
    X"00",  
    X"00", 
    X"04",
    
    X"FF", --44
    X"FF",
    X"FF", 
    X"FB",

    X"00", --48
    X"00",  
    X"00", 
    X"00",
    
    X"00", --52
    X"00",
    X"00", 
    X"00",

    X"00", --56
    X"00",  
    X"00", 
    X"00",
    
    X"00", --60
    X"00",
    X"00", 
    X"00",

    X"00", --64
    X"00",  
    X"00", 
    X"00",
    
    X"00", --68
    X"00",
    X"00", 
    X"00",

    X"00", --72
    X"00",  
    X"00", 
    X"00",
    
    X"00", --76
    X"00",
    X"00", 
    X"00",

    X"00", --80
    X"00",  
    X"00", 
    X"00",
    
    X"00", --84
    X"00",
    X"00", 
    X"00",

    X"00", --88
    X"00",  
    X"00", 
    X"00",
    
    X"00", --92
    X"00",
    X"00", 
    X"00",

    X"00", --96
    X"00",  
    X"00", 
    X"00",
    
    X"00", --100
    X"00",
    X"00", 
    X"00",

    X"00", --104
    X"00",  
    X"00", 
    X"00",
    
    X"00", --108
    X"00",
    X"00", 
    X"00",

    X"00", --112
    X"00",  
    X"00", 
    X"00",
    
    X"00", --116
    X"00",
    X"00", 
    X"00",

    X"00", --120
    X"00",  
    X"00", 
    X"00",
    
    X"00", --124
    X"00",
    X"00", 
    X"00"); --127

begin 
	process(MemRead,MemWrite,WriteData,Address,clk)
	begin
	if (MemRead='1') then --  --not sure about the clk 
		--convert 4 bytes into 32 bit instr/data word
		ReadData <= (data_mem(conv_integer(Address))   & 
			     data_mem(conv_integer(Address)+1) & 
                             data_mem(conv_integer(Address)+2) & 
                             data_mem(conv_integer(Address)+3));
	
	elsif (MemWrite='1') and falling_edge(clk) then --
		--parse the 32 bit WriteData into the byte addressed memory
		data_mem(conv_integer(Address))   <= WriteData(31 downto 24);
		data_mem(conv_integer(Address)+1) <= WriteData(23 downto 16);
		data_mem(conv_integer(Address)+2) <= WriteData(15 downto 8);
		data_mem(conv_integer(Address)+3) <= WriteData(7 downto 0);
	else 
		-- Do Nothing
	end if;
	end process;
end behavioral;
