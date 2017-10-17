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
	regDest,branch,memRead,memToReg,memWrite,ALUSrc,regWrite,jump: out std_logic;
	ALUOp: out std_logic_vector(1 downto 0)
);
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

------------------------Signals----------
signal A, P, L, E, instruction, J, C, D, H, F, M, N, G,K, Q: std_logic_vector(31 downto 0); 
signal regDest, jump, branch, memRead, memToReg, memWrite, ALUSrc, regWrite, zero, R: std_logic;
--signal Q: std_logic_vector(27 downto 0);
signal B: std_logic_vector(4 downto 0);
signal Operation: std_logic_vector(3 downto 0);
signal ALU_Op: std_logic_vector(1 downto 0);
-----------------------Main-----------------------
begin

P1: pc port map(clk,P,A);
A1: InstMemory port map(A, instruction);
A2: ALUADD port map(A, "00000000000000000000000000000100", L);
A3: ShiftLeft2Jump port map(instruction(25 downto 0), L(31 downto 28), Q);
--C1: concatenate port map(jump_addr, , concatenate1);
A4: Control port map(instruction(31 downto 26),regDest,branch,memRead,memToReg,memWrite,ALUSrc,regWrite,jump,ALU_Op);
M1: mux5 port map(instruction(20 downto 16), instruction(15 downto 11),regDest, B);
A5: registers port map(instruction(25 downto 21), instruction(20 downto 16),B,J,clk,RegWrite,C,D);
A6: signextend port map(instruction(15 downto 0), E);
A7: alucontrol port map( ALU_Op,instruction(5 downto 0), Operation);
M2: mux32 port map(D, E, ALUSrc, F);
A8: ALU port map(C,F,Operation,G,zero,overflow);
A9: DataMemory port map(D,G,clk,memread,memwrite,H);
M3: mux32 port map (G,H,memToReg,J);
A11: ShiftLeft2 port map(E, K);
A12: ALUADD port map(L,K,M);

R <= branch and zero;

M4: mux32 port map(L,M,R,N);
M5: mux32 port map(N,Q,jump,P);

end structural;

