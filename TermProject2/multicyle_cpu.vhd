------------------------------------------------------
-- ECEC 355 Computer Architecture
-- MIPS Single Cycle Datapath
-- Not Dagmawi Mulugeta - Instruction Memory
------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
--use IEEE.std_logic_arith.all;
--use ieee.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity MulticycleCPU is
	 generic(bit_length:natural:=32);
	 port(clk:in std_logic; 
		CarryOut, Overflow:out std_logic);
end MulticycleCPU;

architecture struct of MulticycleCPU is
	  
-- Programn Counter Component
component PCMulticycle
	port(clk,d:in std_logic;  AddressIn:in std_logic_vector(31 downto 0);
             AddressOut:out std_logic_vector(31 downto 0));
end component;

component MUX3Way
	port(w,x:in std_logic_vector(31 downto 0);y:in std_logic_vector(27 downto 0);
     sel: in std_logic_vector(1 downto 0);
     z:out std_logic_vector(31 downto 0));
end component;

component IR 
	port(x: in STD_LOGIC_VECTOR (31 downto 0);clk, IRWrite:in STD_LOGIC;
	    y: out STD_LOGIC_VECTOR(31 downto 0) );
end component;


component MDR
	port(x:in std_logic_vector(31 downto 0); clk:in std_logic;
     	     y:out std_logic_vector(31 downto 0));
end component;

component registers
	port ( RR1,RR2,WR : in std_logic_vector(4 downto 0); WD:in std_logic_vector(31 downto 0); clk, RegWrite : in std_logic;		
               RD1,RD2 : out std_logic_vector(31 downto 0));
end component;

component RegA
	port(x:in std_logic_vector(31 downto 0); clk:in std_logic;
     	     y:out std_logic_vector(31 downto 0));
end component;

component MUX4Way
	port(v,w,x,y:in std_logic_vector(31 downto 0); sel: in std_logic_vector(1 downto 0);
             z:out std_logic_vector(31 downto 0));
end component;

component MulticycleControl
	port(Opcode:in std_logic_vector(5 downto 0); clk:in std_logic;
     	     RegDst, RegWrite, ALUSrcA, IRWrite, MemtoReg, MemWrite, MemRead, IorD, PCWrite, PCWriteCond:out std_logic;
     	     ALUSrcB, ALUOp, PCSource:out std_logic_vector(1 downto 0));
end component;

component Memory
	port(WriteData:in std_logic_vector(31 downto 0); Address:in std_logic_vector(31 downto 0); 
	     MemRead,MemWrite,clk:in std_logic;
             ReadData:out std_logic_vector(31 downto 0));
end component;

component RegB
	port(x:in std_logic_vector(31 downto 0); clk:in std_logic;
             y:out std_logic_vector(31 downto 0));
end component;


-- 5 BIT MUX COMPONENT
component mux5 is
	port(x,y:in std_logic_vector (4 downto 0); sel:in std_logic;
     	    z:out std_logic_vector(4 downto 0));
end component;

-- 32 BIT MUX COMPONENT
component mux32 is
	port(x, y:in std_logic_vector(31 downto 0); sel:std_logic;
	     z:out std_logic_vector(31 downto 0));
end component;




component SignExtend is
port(
	x: in std_logic_vector(15 downto 0); --16 bit
	y: out std_logic_vector(31 downto 0) --32 bit
);
end component;

component ShiftLeft2 is
-- Shifts elements by two( multiply by 2 )
	port(	x: in std_logic_vector(31 downto 0); 
		y: out std_logic_vector(31 downto 0));
end component;

component alucontrol is

	port (  aluop: in STD_LOGIC_VECTOR(1 downto 0); func: in STD_LOGIC_VECTOR(5 downto 0); 
		operation: out STD_LOGIC_VECTOR(0 to 3)	
);

end component;


component ALU is
	-- assigning ports for the ALU (input and output)
	port(a,b:in std_logic_vector(bit_length-1 downto 0);
	  Oper:in std_logic_vector(3 downto 0);
	  Result:buffer std_logic_vector(bit_length-1 downto 0);
	  Zero,Overflow:buffer std_logic);
end component;


component sll26 is
port(	x: in std_logic_vector(25 downto 0); -- std_ulogic_vector
	y: out std_logic_vector(27 downto 0)
);
end component;

component AND2 is
	port(x,y:in std_logic;z:out std_logic);
end component;

component OR2 is
	port(x,y:in std_logic;z:out std_logic);
end component;




--signals--
signal C: std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
signal E,F,G,H,I,J,L,M,N,P,Q,R,S,T,U,instruction: std_logic_vector(31 downto 0);
signal V: std_logic_vector(27 downto 0);
signal W,D, RegDst, RegWrite, ALUSrcA, IRWrite, MemtoReg, MemWrite, MemRead, IorD, PCWrite, PCWriteCond, Zero: std_logic; 
signal ALUSrcB, ALUOp, PCSource: std_logic_vector(1 downto 0);
signal constant_four: std_logic_vector(31 downto 0):= "00000000000000000000000000000100";
signal operation: STD_LOGIC_VECTOR(3 downto 0);
signal K:std_logic_vector(4 downto 0);
------

begin
P1:  PCMulticycle port map(clk,D,C,E);
M1:  mux32 port map(E,F,IorD,G);
ME2: Memory port map(H,G,MemRead,MemWrite,clk,I);
IR1: IR port map(I,clk,IRWrite,instruction);
MR1: MDR port map(I,clk,J);
M2:  mux5 port map(instruction(20 downto 16), instruction(15 downto 11),RegDst, K);
M3:  mux32 port map(F,J,MemtoReg,L);
C1:  MulticycleControl port map(instruction(31 downto 26), clk, RegDst, RegWrite, ALUSrcA, IRWrite, MemtoReg, 
				MemWrite, MemRead,IorD, PCWrite, PCWriteCond, ALUSrcB, ALUOp, PCSource);
S1:  SignExtend port map(instruction(15 downto 0), Q);
SL1: ShiftLeft2 port map(Q, R);
RE1: registers port map(instruction(25 downto 21), instruction(20 downto 16),K,L,clk,RegWrite,M,N);
A1:  RegA port map(M, clk, P);
B1:  RegB port map(N, clk, H);
M4:  mux32 port map(E,P, ALUSrcA,S);
M5:  MUX4Way port map(H, constant_four, Q, R, ALUSrcB, T);
AL1: alucontrol port map(ALUOp,instruction(5 downto 0), operation);
--AL2: ALUShifter port map(S, T, operation, Zero,U);
AL2: ALU port map(S, T,operation,U, Zero,overflow);
AL3: RegA port map(U,clk,F);
SL2: sll26 port map(instruction(25 downto 0),V);
M6:  MUX3Way port map(U,F,V,PCSource,C);
AN1: AND2 port map(PCWriteCond, Zero, W);
O1:  OR2 port map(PCWrite, W, D);


end struct;
