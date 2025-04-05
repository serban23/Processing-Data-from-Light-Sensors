library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;
use ieee.numeric_std.all;

entity seven_segment_display is
     Port (
        clk      : in  STD_LOGIC;                      
        num      : in  STD_LOGIC_VECTOR(15 downto 0); 
        anodes   : out STD_LOGIC_VECTOR(3 downto 0);  
        cathodes : out STD_LOGIC_VECTOR(6 downto 0)   
    );
end seven_segment_display;

architecture Behavioral of seven_segment_display is

component number_splitter is
  Port ( nr: in std_logic_vector(15 downto 0);
         d1: out std_logic_vector(3 downto 0);
         d2: out std_logic_vector(3 downto 0);
         d3: out std_logic_vector(3 downto 0);
         d4: out std_logic_vector(3 downto 0));
end component;

component binary_to_ssd is
  Port (digit: in std_logic_vector(3 downto 0);
        ssd:out std_logic_vector(6 downto 0));
end component;

type states is (s0, s1, s2, s3);
signal present_state, next_state: states;
signal d1,d2,d3,d4: std_logic_vector(3 downto 0):="0000";
signal dd1,dd2,dd3,dd4: std_logic_vector(6 downto 0):=(others=>'0');
signal outp: std_logic_vector (0 to 3);
signal counter: integer range 0 to 199999:=0;
signal tym: std_logic:='0';
signal clk_out: std_logic;
signal WY : std_logic_vector (6 downto 0);
signal WE : std_logic_vector (3 downto 0);

    
begin
    
ns: number_splitter port map (num, d1, d2, d3, d4);
bs1: binary_to_ssd port map (d1,dd1);
bs2: binary_to_ssd port map (d2,dd2);
bs3: binary_to_ssd port map (d3,dd3);
bs4: binary_to_ssd port map (d4,dd4);

process (present_state)
begin   
    case present_state is
        when s0 =>
            outp <= "0111";
            next_state <= s1;                
        when s1 =>
            outp <= "1011";
            next_state <= s2;    
        when s2 =>
            outp <= "1101";
            next_state <= s3;
        when s3 =>
            outp <= "1110";
            next_state <= s0;
    end case;
end process;

--frequency divider
process (clk)
begin                       
    if rising_edge(clk) then
        if (counter = 199999) then
            tym <= not tym;
            counter <= 0;
        else
            counter <= counter+1;
        end if;
    end if;
end process;

clk_out <= tym;

--state changing
process (clk_out)
begin
    if rising_edge(clk_out) then
        present_state <= next_state;
    end if;
end process;

anodes(0)<=outp(0);
anodes(1)<=outp(1);
anodes(2)<=outp(2);
anodes(3)<=outp(3);

--set of bits for 7-segment display
WE <= outp(3) & outp(2) & outp(1) & outp(0);

with WE select
WY <=  dd4 when "0111", 
       dd3 when "1011", 
       dd2 when "1101", 
       dd1 when "1110", 
       "1000000" when others; 

cathodes<=WY;
   
end Behavioral;