library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_TEXTIO.ALL;
use IEEE.NUMERIC_STD.ALL;

entity prelucrare_date is
  Port ( clk: in std_logic;
         init_tvalid: in std_logic;
         init_tdata: in std_logic_vector (15 downto 0);
         init_tready: out std_logic;
         op_tvalid: in std_logic;
         op_tdata: in std_logic_vector(2 downto 0);
         op_tready: out std_logic;
         data_tvalid: out std_logic;
         data_tdata: out std_logic_vector (15 downto 0);
         data_tready: in std_logic );
end prelucrare_date;

architecture Behavioral of prelucrare_date is

type state_type is (READ, WRITE);
signal state : state_type := READ;
signal data: std_logic_vector(15 downto 0):=(others=>'0');

type valori_type is array (0 to 4) of INTEGER;
signal valori: valori_type;

signal min: integer:=100;
signal max: integer:=1000;

signal write_ptr : integer range 0 to 4 := 0;
signal prev: std_logic_vector (15 downto 0):=(others=>'0');

begin

data_tdata<= data;
data_tvalid <= '1' when state=READ else '0';

process(clk)
variable minval: integer;
variable maxval: integer;
variable sum: integer;
variable avg: integer;
begin
    
    if rising_edge(clk) then
        case state is
            when READ =>
            
                init_tready<='1';
                op_tready<='1';
                
                if init_tvalid='1' and op_tvalid='1' then
                    case op_tdata is
                        when "000" => --valori initiale
                            data<= init_tdata;
                      
                        when "001" => --filtrare valori intre minim si maxim
                            if (to_integer(unsigned(init_tdata)) > min and to_integer(unsigned(init_tdata)) < max) then
                                data<=init_tdata;
                            else
                                data<=(others=>'0');
                            end if;
                      
                        when "010" => --agregare (media ultimelor 5 valori)
                            sum:=0;
                            avg:=0;
                            sum := valori(0) + valori(1) + valori(2) + valori(3) +valori(4);
                            avg := sum / 5;
                            data <= std_logic_vector(to_unsigned(avg, 16));
                            
                        when "011" => -- statistica 1: cea mai mica valoare dintre ultimele 5
                            minval:=0;
                            minval := valori(0); -- Ini?ializare cu prima valoare din tabloul `valori`
                            for i in 1 to 4 loop
                                if valori(i) < minval then
                                    minval := valori(i); -- Actualizãm `minval` cu valoarea mai micã
                                end if;
                            end loop;
                            data <= std_logic_vector(to_unsigned(minval, data'length));
                     
                        when "100" => -- statistica 2: cea mai mare valoare dintre ultimele 5
                            maxval:=0;
                            maxval := valori(0); -- Ini?ializare cu prima valoare din tabloul `valori`
                            for i in 1 to 4 loop
                                if valori(i) > maxval then
                                    maxval := valori(i); -- Actualizãm `minval` cu valoarea mai micã
                                end if;
                            end loop;
                            data <= std_logic_vector(to_unsigned(maxval, data'length));
                            
                        when others => data <= (others=>'0');
                    end case;
                    
                    if to_integer(unsigned(init_tdata)) /= to_integer(unsigned(prev)) then
                        valori(write_ptr) <= to_integer(unsigned(init_tdata));
                        write_ptr <= (write_ptr + 1) mod 5;
                        prev<=init_tdata;
                    end if;
                    
                    state<=WRITE;
                end if;
            when WRITE =>
                if data_tready='1' then
                    state<= READ;
                end if;
        end case;
    end if;
end process;

end Behavioral;
