library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- FSM Control for multicycle mips CPU
-- This design is based on the FSM given on pp 339 of Textbook form ECEC 412 Fall 2017 Drexel University

entity MulticycleControl is
port(Opcode:in std_logic_vector(5 downto 0); clk:in std_logic;
     RegDst, RegWrite, ALUSrcA, IRWrite, MemtoReg, MemWrite, MemRead, IorD, PCWrite, PCWriteCond:out std_logic;
     ALUSrcB, ALUOp, PCSource:out std_logic_vector(1 downto 0));
end MulticycleControl;


architecture behav of MulticycleControl is
type states is (s0, s1, s2, s3, s4, s5, s6, s7, s8, s9); -- states for FSM
signal current_state : states := s0; --Start at state s0
begin 
	process(clk)
	begin

	if clk='1' then
	case current_state is
		when s0 =>
			--First line is deassertions from previous states
			PCWriteCond<='0'; MemWrite<='0';RegDst <= '0'; RegWrite<='0';MemtoReg <= '0';PCWrite <= '0'; 
			--Second line is assertions and high values for current state
			ALUSrcA <= '0'; IorD <= '0'; ALUSrcB <= "01"; ALUOp <= "00"; PCSource <="00";MemRead <= '1'; IRWrite <= '1'; PCWrite <= '1';
			current_state <= s1;
		when s1 =>
			MemRead <= '0';IRWrite <= '0';PCWrite <= '0';-- Not sure about this
			ALUSrcA <= '0';ALUSrcB <= "11"; ALUOp <= "00";
			case Opcode is 
				when "000010" =>               -- J type
					current_state <= s9;
				when "000100" =>               -- beq type
					current_state <= s8;
				when "100011" | "101011"=>     -- lw or sw
					current_state <= s2;
				when "000000" =>               -- R type
					current_state <= s6;
				when others =>
					current_state <= s1;
			end case;
		when s2 =>
			ALUSrcA <= '1';ALUSrcB <= "10";ALUOp <= "00";
			case Opcode is
				when "100011" =>                 --lw
					current_state <= s3;
				when "101011" =>                 --sw
					current_state <= s5;
				when others =>
					current_state <= s2;
			end case;
		when s3 =>
			IorD <= '1';MemRead<='1';
			current_state <= s4;
		when s4 =>
			MemRead<='0'; -- deassertion
			RegDst <= '0'; MemtoReg <= '1'; RegWrite<='1';
			current_state <= s0;
		when s5 =>
			IorD <= '1'; MemWrite<='1';
			current_state <= s0;
		when s6 =>
			ALUSrcA <= '1';ALUSrcB <= "00";ALUOp <= "10";
			current_state <= s7;
		when s7 =>
			RegDst <= '1';MemtoReg <= '0'; RegWrite<='1';
			current_state <= s0;
		when s8 =>
			ALUSrcA <= '1'; ALUSrcB <= "00";ALUOp <= "01"; PCSource <= "01";PCWriteCond<='1';
			current_state <= s0;
		when s9 =>
			PCSource <= "10";PCWrite<='1';
			current_state <= s0;
		when others => -- if any others commands, just stay in state s0
			current_state <= s0;
	end case;
	end if;
	end process;
end behav;