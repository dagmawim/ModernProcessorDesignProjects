library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity FP_DIVIDER is
port ( fp_a      : in std_logic_vector(31 downto 0);
       fp_b      : in std_logic_vector(31 downto 0);
       clk       : in std_logic;
       zero      : out std_logic;
       overflow  : out std_logic;
       underflow : out std_logic;
       fp_result : out std_logic_vector(31 downto 0));
end FP_DIVIDER;

architecture behav of FP_DIVIDER is
begin
   process(fp_a, fp_b, clk)
   -- Variables for A sign, exponent, and mantissa
   variable a_sign : std_logic;
   variable a_exponent : std_logic_vector(7 downto 0);
   variable a_mantissa : std_logic_vector(22 downto 0);
   -- Variables for B sign, exponent, and mantissa
   variable b_sign : std_logic;
   variable b_exponent : std_logic_vector(7 downto 0);
   variable b_mantissa : std_logic_vector(22 downto 0);
   -- Variables for result sign, exponent, and mantissa
   variable result_sign : std_logic;
   variable result_exponent : std_logic_vector(7 downto 0);
   variable result_mantissa : std_logic_vector(22 downto 0);
   -- holds the result of the division of the mantissas
   variable quotient : std_logic_vector(25 downto 0);
   variable remainder : std_logic_vector(24 downto 0);
   variable temp_rem : std_logic_vector(24 downto 0);
   variable ext_exp : std_logic_vector(8 downto 0); -- needs extra bit for overflow & underflow
   begin
      -- Initialize sign, exponent, and mantissa variables for A and B
      a_sign := fp_a(31);
      a_exponent := fp_a(30 downto 23);
      a_mantissa := fp_a(22 downto 0);
      b_sign := fp_b(31);
      b_exponent := fp_b(30 downto 23);
      b_mantissa := fp_b(22 downto 0);

      -- Set zero, overflow, underflow to 0
      zero <= '0';
      overflow <= '0';
      underflow <= '0';

      -- Set result sign bit
      result_sign := a_sign xor b_sign;

      -- Check for 0/b or a/inf; result = 0
      if (a_exponent=0 or b_exponent="11111111") then
         result_exponent := "00000000";
         result_mantissa := (others=>'0');
         zero <= '1';
      else
         -- Check for a/0 or inf/b; result = inf
         if (b_exponent=0 or a_exponent=255) then
            result_exponent := "11111111";
            result_mantissa := (others=>'0');
         else
            -- Subtract exponents and add bias
            ext_exp := ('0' & a_exponent) - ('0' & b_exponent) + 127;
            -- Divide mantissas
            remainder := "01" & a_mantissa;
            for i in 25 downto 0 loop
               temp_rem := remainder - ("01" & b_mantissa);
               if ( temp_rem(24)='0' ) then 
                  quotient(i):='1';
                  remainder := temp_rem;
               else
                  quotient(i):='0';
               end if;
               remainder := remainder(23 downto 0) & '0';
            end loop;
            quotient := quotient + 1;
            if (quotient(25)='1') then
               result_mantissa := quotient(24 downto 2);
            else
               result_mantissa := quotient(23 downto 1);
               ext_exp := ext_exp - 1;
            end if;
            -- Check for underflow or overflow
            if (ext_exp(8)='1') then
               if (ext_exp(7)='1') then
                  underflow <= '1';
               else
                  overflow <= '1';
               end if;
            else
               result_exponent := ext_exp(7 downto 0);
            end if;
         end if;
      end if;
      fp_result(22 downto 0) <= result_mantissa;
      fp_result(30 downto 23) <= result_exponent;
      fp_result(31) <= result_sign;
   end process;
end behav;