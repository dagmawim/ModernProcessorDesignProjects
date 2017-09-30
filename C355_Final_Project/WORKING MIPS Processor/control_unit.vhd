library ieee;
use ieee.std_logic_1164.all;

entity control_unit is
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
end control_unit;

architecture behav of control_unit is
begin 
process(opcode)
begin
case opcode is
	when "000000" => -- Rtypes
		regDest<= '1';
		branch<= '0';
		jump<='0';
		memRead<='0';
		memToReg<='0';
		ALUOp<="10";
		memWrite<='0';
		ALUSrc<='0';
		regWrite<='1';
	when "100011" => --lw
		regDest<= '0';
		branch<='0';
		jump<='0';
		memRead<='1';
		memToReg<='1';
		ALUOp<="00";
		memWrite<='0';
		ALUSrc<='1';
		regWrite<='1';
	when "101011" => --sw
		regDest<='0';
		branch<='0';
		jump<='0';
		memRead<='0';
		memToReg<='0';
		ALUOp<="00";
		memWrite<='1';
		ALUSrc<='1';
		regWrite<='0';
	when "000010"=> --j
		regDest<='0';
		branch<='0';
		jump<='1';
		memRead<='0';
		memToReg<='0';
		ALUOp<="00";
		memWrite<='0';
		ALUSrc<='0';
		regWrite<='0';
	when "000100"=> --beq
		regDest<='0';
		branch<='1';
		jump<='0';
		memRead<='0';
		memToReg<='0';
		ALUOp<="01";
		memWrite<='0';
		ALUSrc<='0';
		regWrite<='0';
	when "001000"=> -- addi/subi (subi: immeadiate will be negative)
		regDest<='0';
		branch<='0';
		jump<='0';
		memRead<='0';
		memToReg<='0';
		ALUOp<="00"; 
		memWrite<='0';
		ALUSrc<='1';
		regWrite<='1';
	when "001100"=> ---andi
		regDest<='0';
		branch<='0';
		jump<='0';
		memRead<='0';
		memToReg<='0';
		ALUOp<="00"; --?
		memWrite<='0';
		ALUSrc<='0';
		regWrite<='1';
	when others=>
		regDest<='0';
		branch<='0';
		jump<='0';
		memRead<='0';
		memToReg<='0';
		ALUOp<="00";
		memWrite<='0';
		ALUSrc<='0';
		regWrite<='0';
	
end case;
end process;
end behav;

