
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity number_splitter is
  Port ( nr: in std_logic_vector(15 downto 0);
         d1: out std_logic_vector(3 downto 0);
         d2: out std_logic_vector(3 downto 0);
         d3: out std_logic_vector(3 downto 0);
         d4: out std_logic_vector(3 downto 0) );
end number_splitter;

architecture Behavioral of number_splitter is
  signal num : integer;
begin
  num <= to_integer(unsigned(nr));
  d1 <= std_logic_vector(to_unsigned(num mod 10, 4));
  d2 <= std_logic_vector(to_unsigned(num / 10 mod 10, 4));
  d3 <= std_logic_vector(to_unsigned(num / 100 mod 10, 4));
  d4<= std_logic_vector(to_unsigned(num/1000 mod 10, 4));
end Behavioral;
