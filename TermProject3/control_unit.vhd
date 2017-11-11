library ieee;
use ieee.std_logic_1164.all;

entity Control is
port( 	opcode: in std_logic_vector(5 downto 0);
	wb:out std_logic_vector(1 downto 0);
 	m:out std_logic_vector(2 downto 0);
	ex:out std_logic_vector(3 downto 0));
end Control;

-- Control Behavior
architecture behav of Control is
	signal regDest, branch, memRead, memToReg, memWrite, ALUSrc, regWrite, jump: std_logic;
 	signal ALUOp:std_logic_vector(1 downto 0);
	begin 

	process(opcode)
	begin
		case opcode is
			-- condition on opcode
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

	wb <= regWrite & memToReg;  --Regwrite is higher order index...(1) and (0) is memToReg
	m <= branch & memread & memWrite;
	ex <= regDest & ALUOp & ALUSrc;


end behav;

