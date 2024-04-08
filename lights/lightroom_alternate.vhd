library ieee;
use ieee.std_logic_1164.all;

entity lightrom_alternating is
    port (
        addr : in std_logic_vector(3 downto 0);
        data : out std_logic_vector(2 downto 0)
    );
end entity;

architecture rtl of lightrom_alternating is
begin
    data <= 
        "000" when addr = "0000" else -- clear LR      00000000
        "101" when addr = "0001" else -- bit invert LR 11111111
        "010" when addr = "0010" else -- shift LR left 11111110
        "001" when addr = "0011" else -- shift LR right 01111111
        "010" when addr = "0100" else -- shift LR left 01111110
        "001" when addr = "0101" else -- shift LR right 00111111
        "010" when addr = "0110" else -- shift LR left 00111110
        "001" when addr = "0111" else -- shift LR right 00011111
        "111" when addr = "1000" else -- rotate LR left 00111111
        "111" when addr = "1001" else -- rotate LR left 01111110
        "111" when addr = "1010" else -- rotate LR left 11111100
        "111" when addr = "1011" else -- rotate LR left 11111000
        "111" when addr = "1100" else -- rotate LR left 11110000
        "111" when addr = "1101" else -- rotate LR left 11100000
        "101" when addr = "1110" else -- bit invert LR 00011111
        "011";                        -- add 1 to LR    00011111
end rtl;