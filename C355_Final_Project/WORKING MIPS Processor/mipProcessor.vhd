--MIPS Processor
library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity mipsProcessor is
	port(
		clk: in std_logic
);
end entity;

architecture structural of mipsProcessor is


-------------------------Components-------------------
component pc
	port (  upcoming: in STD_LOGIC_VECTOR(31 downto 0); ck: in STD_LOGIC;
		current: out STD_LOGIC_VECTOR(31 downto 0)	
);
end component;


component control_unit
port( 	opcode: in std_logic_vector(5 downto 0);
	regDest: out std_logic;
	branch: out std_logic;
	jump: out std_logic;
	memRead: out std_logic;
	memToReg: out std_logic;
	ALUOp: out std_logic_vector(1 downto 0);
	memWrite: out std_logic;
	ALUSrc: out std_logic;
	regWrite: out std_logic
);
end component;


component ALU
	-- assigning ports for the ALU (input and output)
	port( signal_1, signal_2: in std_logic_vector(31 downto 0);
		operation : in std_logic_vector(3 downto 0); shift : in std_logic_vector(4 downto 0);
		zero: out std_logic;
		result: out std_logic_vector(31 downto 0));
end component;


component instructionMemory
	port (  address: in STD_LOGIC_VECTOR (31 downto 0); ck: in STD_LOGIC;
		instruction: out STD_LOGIC_VECTOR(31 downto 0) );
end component;


component alucontrol

	port (  func: in STD_LOGIC_VECTOR(5 downto 0); aluop: in STD_LOGIC_VECTOR(1 downto 0);
		output: out STD_LOGIC_VECTOR(3 downto 0)	
);

end component;


component sign_extend
	port(signIn: in std_logic_vector(15 downto 0); --16 bit
		signOut: out std_logic_vector(31 downto 0) --32 bit
);
end component;


component ALUADD
	-- assigning ports for the ALU (input and output)
	port( signal_1, signal_2: in std_logic_vector(31 downto 0);
		result: out std_logic_vector(31 downto 0));
end component;


component regfile
Port ( Readreg1 : in std_logic_vector(4 downto 0); -- assuming read register 1 and 2 are 5 bits long and write reg is as well
       Readreg2 : in std_logic_vector(4 downto 0);
       writereg : in std_logic_vector(4 downto 0);
       RegWr : in std_logic;		-- reg write from the control unit
       clk : in std_logic;		-- clock
       WriteData:in std_logic_vector(31 downto 0);	-- write data should be 32 bits
       ReadData1 : out std_logic_vector(31 downto 0);		-- output of register unit is 32 bits long 
       ReadData2 : out std_logic_vector(31 downto 0));
end component;


component memory
	port (
		address, write_data: in STD_LOGIC_VECTOR (31 downto 0);
		MemWrite, MemRead,ck: in STD_LOGIC;
		read_data: out STD_LOGIC_VECTOR (31 downto 0)
	);
end component;


component sll26 is
port(	x: in std_logic_vector(25 downto 0); -- std_ulogic_vector
	y: out std_logic_vector(27 downto 0)
);
end component; 


component sll32 is
port(	x: in std_logic_vector(31 downto 0); -- std_ulogic_vector
	y: out std_logic_vector(31 downto 0)
);
end component;


component mux5 is
port(x0, x1:in std_logic_vector(4 downto 0); sel:std_logic;
	y:out std_logic_vector(4 downto 0));
end component;


component mux32 is
port(x0, x1:in std_logic_vector(31 downto 0); sel:std_logic;
	y:out std_logic_vector(31 downto 0));
end component;


component concatenate is
	port(x: in std_logic_vector(27 downto 0);
	x1: in std_logic_vector(3 downto 0);
	z: out std_logic_vector(31 downto 0));
end component;





------------------------Signals----------
signal cur_pc: std_logic_vector(31 downto 0);
signal next_pc, pc_p4, sign_extended, instruction, write_back_data, reg_read_1, reg_read_2, mem_read_data, ALU_2, shift_sig, branch_addr, br_not_addr, ALU_Result: std_logic_vector(31 downto 0); 
signal regDest, jump, branch, memRead, memToReg, memWrite, ALUSrc, regWrite, zero1, branch_control: std_logic;
signal jump_addr: std_logic_vector(27 downto 0);
signal writeRegister: std_logic_vector(4 downto 0);
signal ALU_Control: std_logic_vector(3 downto 0);
signal ALU_Op: std_logic_vector(1 downto 0);
signal concatenate1: std_logic_vector(31 downto 0);



-----------------------Main-----------------------
begin

P1: pc port map(next_pc, clk, cur_pc);
A1: instructionMemory port map(cur_pc, clk, instruction);
A2: ALUADD port map(cur_pc, "00000000000000000000000000000100", pc_p4);
A3: sll26 port map(instruction(25 downto 0), jump_addr);
C1: concatenate port map(jump_addr, pc_p4(31 downto 28), concatenate1);
A4: control_unit port map(instruction(31 downto 26), regDest, branch, jump, memRead, memToReg, ALU_Op, memWrite, ALUSrc, regWrite);

M1: mux5 port map(instruction(20 downto 16), instruction(15 downto 11),regDest, writeRegister);
A5: regfile port map(instruction(25 downto 21), instruction(20 downto 16), writeRegister, regWrite, clk, write_back_data, reg_read_1, reg_read_2);
A6: sign_extend port map(instruction(15 downto 0), sign_extended);
A7: alucontrol port map(instruction(5 downto 0), ALU_Op, ALU_Control);

M2: mux32 port map(reg_read_2, sign_extended, ALUSrc, ALU_2);
A8: ALU port map(reg_read_1, ALU_2, ALU_Control,instruction(10 downto 6), zero1, ALU_result);
A9: memory port map(ALU_Result, reg_read_2, memWrite, memRead, clk, mem_read_data);
M3: mux32 port map (ALU_Result,mem_read_data, memToReg, write_back_data);
A11: sll32 port map(sign_extended, shift_sig);

A12: ALUADD port map(pc_p4, shift_sig, branch_addr);

branch_control <= branch and zero1;

M4: mux32 port map(pc_p4, branch_addr, branch_control, br_not_addr);
M5: mux32 port map(br_not_addr, concatenate1, jump, next_pc);

end structural;






