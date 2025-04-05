library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity control_operatii is
  Port ( clk: in std_logic;
         sw: in std_logic_vector (3 downto 0);
         op_tready: in std_logic;
         op_tvalid: out std_logic;
         op_tdata: out std_logic_vector(2 downto 0));
end control_operatii;

architecture Behavioral of control_operatii is

type state_type is (READ, WRITE);
signal state : state_type := READ;
signal res: std_logic_vector(2 downto 0):=(others=>'0');

begin

op_tdata<=res;
op_tvalid <= '1' when state=READ else '0';

process(clk)
begin
    if rising_edge(clk) then
        case state is
            when READ =>
                case sw is
                    when "0000" => res<="000";
                    when "0001" => res<="001";
                    when "0010" => res<="010";
                    when "0100" => res<="011";
                    when "1000" => res<="100";
                    when others => res<="000";
                end case;
                state<=WRITE;
                
            when WRITE =>
                if op_tready ='1' then
                    state<=READ;
                end if;
        end case;
    end if;
end process;

end Behavioral;
