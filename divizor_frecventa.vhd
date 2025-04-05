library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity divizor_frecventa is
    Port ( clk_in    : in  std_logic; 
           clk_out   : out std_logic  
           );
end divizor_frecventa;

architecture Behavioral of divizor_frecventa is

    -- Numãrul de cicluri de clock necesar pentru a atinge 5 secunde (presupunând un clk_in de 50 MHz)
    constant N: integer := 250000000;
    signal counter : integer:= 1;
    signal temp : std_logic := '0'; 

begin

process(clk_in)
begin
    if rising_edge(clk_in) then
        if counter = N-1 then
            counter <= 0;        
            temp <= not temp; 
        else
            counter <= counter + 1;
        end if;
    end if;
    clk_out <= temp;
end process;

end Behavioral;
