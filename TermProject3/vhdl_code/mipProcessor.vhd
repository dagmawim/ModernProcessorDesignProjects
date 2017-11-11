--MIPS Processor
library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity CPU is
generic(lBit:natural:=32);
	port(
		clk: in std_logic;
		Overflow:out std_logic
	);
end entity;

architecture structural of CPU is


-------------------------Components-------------------
-- Programn Counter Component
component pc
	port ( clk: in STD_LOGIC; AddressIn: in STD_LOGIC_VECTOR(31 downto 0); 
	       AddressOut: out STD_LOGIC_VECTOR(31 downto 0));
end component;

-- Control Unit Component
component Control
port( 	opcode: in std_logic_vector(5 downto 0);
	wb:out std_logic_vector(1 downto 0);
 	m:out std_logic_vector(2 downto 0);
	ex:out std_logic_vector(3 downto 0));
end component;

-- ALU Component
component ALU
	-- assigning ports for the ALU (input and output)
	port(a,b:in std_logic_vector(lBit-1 downto 0);
	  Oper:in std_logic_vector(3 downto 0);
	  Result:buffer std_logic_vector(lBit-1 downto 0);
	  Zero,Overflow:buffer std_logic);
end component;

-- Instruction Memory Component
component InstMemory
	port (  address: in STD_LOGIC_VECTOR (31 downto 0);
		ReadData: out STD_LOGIC_VECTOR(31 downto 0) );
end component;

-- ALU Control Component
component alucontrol
	port (  aluop: in STD_LOGIC_VECTOR(1 downto 0); func: in STD_LOGIC_VECTOR(5 downto 0); 
		operation: out STD_LOGIC_VECTOR(0 to 3)	);
end component;

-- Sign Extend Component
component signextend
	port( x: in std_logic_vector(15 downto 0); --16 bit
	y: out std_logic_vector(31 downto 0)); --32 bit
end component;

-- ALU Input Output
component ALUADD
	-- assigning ports for the ALU (input and output)
	port( signal_1, signal_2: in std_logic_vector(31 downto 0);
	      result: out std_logic_vector(31 downto 0));
end component;

-- Register Control
component registers
	Port ( RR1,RR2,WR : in std_logic_vector(4 downto 0); -- assuming read register 1 and 2 are 5 bits long and write reg is as well
       		WD:in std_logic_vector(31 downto 0);	-- write data should be 32 bits       
       		clk, RegWrite : in std_logic;		-- reg write from the control unit
       		RD1,RD2 : out std_logic_vector(31 downto 0)		-- output of register unit is 32 bits long 
      		);
end component;

-- Data Memory Component
component DataMemory
	port(   WriteData:in std_logic_vector(31 downto 0);
     		Address:in std_logic_vector(31 downto 0);
     		Clk,MemRead,MemWrite:in std_logic;
     		ReadData:out std_logic_vector(31 downto 0));
end component;

--  SHIFT LEFT AND JUMP Component
component ShiftLeft2Jump is
	port(	x: in std_logic_vector(25 downto 0); y:in std_logic_vector(3 downto 0); -- std_ulogic_vector
		z: out std_logic_vector(31 downto 0)
	);
end component; 

-- SHIFT LEFT COMPONENT
component ShiftLeft2 is
port(	x: in std_logic_vector(31 downto 0); -- std_ulogic_vector
	y: out std_logic_vector(31 downto 0)
);
end component;

-- 5 BIT MUX COMPONENT
component mux5 is
	port(   x,y:in std_logic_vector (4 downto 0); sel:in std_logic;
     		z:out std_logic_vector(4 downto 0));
end component;

-- 32 BIT MUX COMPONENT
component mux32 is
	port(   x, y:in std_logic_vector(31 downto 0); sel:std_logic;
		z:out std_logic_vector(31 downto 0));
end component;

component IFIDPR 
	port (	CLK: in std_logic;
		LIN,IIN: in std_logic_vector(31 downto 0);
		LOUT, IOUT: out std_logic_vector(31 downto 0));
end component;

component IDEXPR
	port( clk: in std_logic;
 	WBCTRLIN:in std_logic_vector(1 downto 0);
 	MCTRLIN:in std_logic_vector(2 downto 0);
	EXCTRLIN:in std_logic_vector(3 downto 0);
	LIN,CIN,DIN,EIN:in std_logic_vector(31 downto 0);
	RTIN,RDIN:in std_logic_vector(4 downto 0);
	WBCTRLOUT:out std_logic_vector(1 downto 0);
	MCTRLOUT:out std_logic_vector(2 downto 0);
	EXCTRLOUT:out std_logic_vector(3 downto 0);
	LOUT,COUT,DOUT,EOUT:out std_logic_vector(31 downto 0);
	RTOUT,RDOUT:out std_logic_vector(4 downto 0));
end component;

component EXMEMPR
    port (clk:in std_logic;
	  WBCTRLIN:in std_logic_vector(1 downto 0);
     	  MCTRLIN: in std_logic_vector(2 downto 0);
     	  MIN:in std_logic_vector(31 downto 0);
     	  ZIN:in std_logic;
     	  GIN,DIN:in std_logic_vector(31 downto 0);
     	  BIN:in std_logic_vector(4 downto 0);
          
	  WBCTRLOUT:out std_logic_vector(1 downto 0);
     	  MCTRLOUT: out std_logic_vector(2 downto 0);
     	  MOUT:out std_logic_vector(31 downto 0);
     	  ZOUT:out std_logic;
     	  GOUT,DOUT:out std_logic_vector(31 downto 0);
     	  BOUT:out std_logic_vector(4 downto 0));
end component;

component MEMWBPR
	port(CLK: in std_logic;
	WBCTRLIN:in std_logic_vector(1 downto 0);
	HIN,DIN:in std_logic_vector(31 downto 0);
	BIN:in std_logic_vector(4 downto 0);
	WBCTRLOUT:out std_logic_vector(1 downto 0);
	HOUT,DOUT:out std_logic_vector(31 downto 0);
	BOUT:out std_logic_vector(4 downto 0));
end component;


------------------------Signals----------
signal LIF, MMEM, P, A, IIF, LID, instruction, J, CID, DID, EID, LEX, CEX, DEX, EEX, K, MEX, F, GEX, HMEM, HWB, GMEM, DMEM, GWB: std_logic_vector(31 downto 0);
signal PCSrc, ZEX, ZMEM: std_logic;
signal BWB, RTEX, RDEX, BEX, BMEM: std_logic_vector(4 downto 0);
signal wb, wbex, wbmem, wbwb: std_logic_vector(1 downto 0);
signal m, memex, memmem: std_logic_vector(2 downto 0);
signal ex, exex, Operation: std_logic_vector(3 downto 0);

-----------------------Main-----------------------
begin

M1: mux32 port map(LIF,MMEM,PCSrc,P);
P1: pc port map(clk,P,A);
A1: ALUADD port map(A, "00000000000000000000000000000100", LIF);
I1: InstMemory port map(A, IIF);
IFID1: IFIDPR port map(clk, LIF, IIF, LID, instruction);
R1: registers port map(instruction(25 downto 21), instruction(20 downto 16), BWB, J, clk, WBWB(1), CID, DID);
S1: signextend port map(instruction(15 downto 0), EID);
C1: Control port map(instruction(31 downto 26), WB, M, EX);
IDEX1: IDEXPR port map( clk, WB, M, EX, LID, CID, DID, EID, instruction(20 downto 16), instruction(15 downto 11),
			WBEX, MEMEX, EXEX, LEX, CEX, DEX, EEX, RTEX,RDEX);
S2: ShiftLeft2 port map(EEX, K);
A2: ALUADD port map(LEX,K,MEX);
M2: mux32 port map(DEX, EEX, EXEX(0), F);
A3: ALU port map(CEX,F,Operation,GEX, ZEX,overflow);
A4: alucontrol port map(EXEX(2 downto 1), EEX(5 downto 0), Operation);
M3: mux5 port map(RTEX, RDEX, EXEX(3), BEX);
E1: EXMEMPR port map(clk, WBEX, MEMEX, MEX, ZEX, GEX, DEX, BEX,
 	WBMEM, MEMMEM, MMEM, ZMEM, GMEM, DMEM, BMEM);

PCSrc <= MEMMEM(2) and ZMEM;

D1: DataMemory port map(DMEM,GMEM,clk,MEMMEM(1),MEMMEM(0),HMEM);

M4: MEMWBPR port map(clk, WBMEM, HMEM, GMEM, BMEM, 
	WBWB,HWB,GWB,BWB); --NOT SURE IF IT IS GMEM OR DMEM, ask group

M5: mux32 port map (GWB, HWB, WBWB(0), J);

end structural;

