library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity FP_Subtractor is
	port(   fp_a, fp_b:in std_logic_vector(31 downto 0);
		clk, operator: in std_logic;
		underflow: out std_logic;
		zero: out std_logic;
                fp_result:out std_logic_vector(31 downto 0));
end FP_Subtractor;


architecture behav of FP_Subtractor is

begin 
	process(fp_a,fp_b,clk)

	variable sign_a, sign_b, sign_result : std_logic;
	variable exp_a,exp_b, exp_result,align_counter: unsigned(7 downto 0);
	variable fract_a,fract_b, fract_result: unsigned(24 downto 0);
	variable temp_a, temp_b, signed_frac_result : unsigned(25 downto 0);

	begin 

	-------- SETUP -----------
	sign_a := fp_a(31);                                   sign_b := fp_b(31);
	exp_a := unsigned(fp_a(30 downto 23));                exp_b  := unsigned(fp_b(30 downto 23));
	fract_a := unsigned('0' & '1' & fp_a(22 downto 0));   fract_b  := unsigned('0' & '1' & fp_b(22 downto 0));
	underflow <= '0';


	if(exp_a < exp_b) then
		align_counter := exp_b - exp_a;
		while (align_counter /= 0) loop
			fract_a := unsigned('0' & fract_a(24 downto 1));
			align_counter := align_counter - 1;
		end loop;
		exp_result := exp_b;
	elsif(exp_b < exp_a) then
		align_counter := exp_a - exp_b;
		while (align_counter /= 0) loop
			fract_b := unsigned('0' & fract_b(24 downto 1));
			align_counter := align_counter - 1;
		end loop;
		exp_result := exp_a;
	else
		exp_result := exp_a;
	end if;

	temp_a := unsigned('0' & fract_a);
	temp_b := unsigned('0' & fract_b);

	if(sign_a = '1') then
		 temp_a := not(temp_a) + "00000000000000000000000001";
	end if;

	if(sign_b = '1') then
		 temp_b := not(temp_b) + "00000000000000000000000001";
	end if;

	signed_frac_result := temp_a - temp_b;
	sign_result := signed_frac_result(25);


	if(sign_result = '1')then
		fract_result := not(signed_frac_result(24 downto 0)) + "0000000000000000000000001";
	else
		fract_result := signed_frac_result(24 downto 0);
	end if;


	while((fract_result(23) /= '1') and (exp_result /= 1)) loop
		fract_result := unsigned(fract_result(23 downto 0) & '0');
		exp_result := exp_result - 1;
		if exp_result = 1 then
			underflow <= '1';
		end if;
	end loop;

	fp_result <= (sign_result) & std_logic_vector(exp_result(7 downto 0)) & std_logic_vector(fract_result(22 downto 0)) ;

	end process;
end behav;

