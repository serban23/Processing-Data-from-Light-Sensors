
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use STD.TEXTIO.ALL;
use IEEE.STD_LOGIC_TEXTIO.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity preluare_date is
  Port ( clk: in std_logic;
         pmod_in: in std_logic_vector (7 downto 0);
         init_tready: in std_logic;
         init_tdata: out std_logic_vector (15 downto 0);
         init_tvalid: out std_logic);
end preluare_date;

architecture Behavioral of preluare_date is

type state_type is (READ, WRITE);
signal state : state_type := READ;
signal res: std_logic_vector(15 downto 0):=(others=>'0');
signal temp_val : unsigned(15 downto 0);

begin

init_tdata <= res;
init_tvalid <= '1' when state = READ else '0';

process(clk)
begin
    if rising_edge(clk) then
        case state is
            when READ => -- Scalam valoarea dupa ce am mapat-o pe Arduino
                temp_val <= (unsigned(pmod_in) * 4);
                res <= std_logic_vector(temp_val);
                state <= WRITE;

            when WRITE => 
                if init_tready = '1' then
                    state <= READ; -- Trecem înapoi la starea de citire
                end if;
        end case;
    end if;
end process;

end Behavioral;

