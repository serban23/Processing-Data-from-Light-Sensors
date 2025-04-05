
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top_level is
  Port (clk:in std_logic;
        pmod_in: in std_logic_vector (7 downto 0);
        sw: in std_Logic_vector(3 downto 0);
        seg: out std_logic_vector(6 downto 0);
        an: out std_logic_vector(3 downto 0) );
end top_level;

architecture Behavioral of top_level is

component preluare_date is
  Port ( clk: in std_logic;
         pmod_in: in std_logic_vector (7 downto 0);
         init_tready: in std_logic;
         init_tdata: out std_logic_vector (15 downto 0);
         init_tvalid: out std_logic);
end component;

component prelucrare_date is
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
end component;

component control_operatii is
  Port ( clk: in std_logic;
         sw: in std_logic_vector (3 downto 0);
         op_tready: in std_logic;
         op_tvalid: out std_logic;
         op_tdata: out std_logic_vector(2 downto 0));
end component;

component afisare_date is
    Port (
        clk     : in  STD_LOGIC;            
        data_tdata : in  STD_LOGIC_VECTOR(15 downto 0); 
        data_tvalid : in STD_LOGIC;
        data_tready: out STD_LOGIC;
        seg     : out STD_LOGIC_VECTOR(6 downto 0);
        an      : out STD_LOGIC_VECTOR(3 downto 0)
    );
end component;

signal initd, datad: std_logic_vector(15 downto 0):=(others=>'0');
signal initv,initr,datav,datar,opv,opr: std_logic:='0';
signal opd: std_logic_vector(2 downto 0);

begin

preluare: preluare_date port map (clk, pmod_in, initr, initd, initv);
prelucrare: prelucrare_date port map (clk, initv, initd, initr, opv, opd, opr, datav, datad, datar);
control: control_operatii port map (clk, sw, opr, opv, opd);
afisare: afisare_date port map (clk, datad, datav, datar, seg, an);

end Behavioral;
