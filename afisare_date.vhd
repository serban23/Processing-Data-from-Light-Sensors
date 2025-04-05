library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity afisare_date is
    Port (
        clk     : in  STD_LOGIC;            
        data_tdata : in  STD_LOGIC_VECTOR(15 downto 0); 
        data_tvalid : in STD_LOGIC;
        data_tready: out STD_LOGIC;
        seg     : out STD_LOGIC_VECTOR(6 downto 0);
        an      : out STD_LOGIC_VECTOR(3 downto 0)
    );
end afisare_date;

architecture Behavioral of afisare_date is

component seven_segment_display is
     Port (
        clk      : in  STD_LOGIC;                      
        num      : in  STD_LOGIC_VECTOR(15 downto 0); 
        anodes   : out STD_LOGIC_VECTOR(3 downto 0);  
        cathodes : out STD_LOGIC_VECTOR(6 downto 0) 
    );
end component;

type state_type is (READ, WRITE);
signal state : state_type := READ;
signal data: std_logic_vector (15 downto 0) := (others =>'0');

begin

process (clk)
begin

if rising_edge(clk) then
    case state is
        when READ =>
            data_tready<='1';
            if data_tvalid ='1' then
                data<=data_tdata;
                state<=WRITE;
            else
                data<=(others=>'0');
            end if;
        when WRITE =>
            data_tready<='0';
            state<=READ;
    end case;
end if;
end process;

ssd: seven_segment_display port map (clk, data, an, seg);

end Behavioral;
