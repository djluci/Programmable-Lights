library ieee;
use ieee.std_logic_1164.all;

entity lightrom_pulse is
    port (
        addr : in std_logic_vector(3 downto 0);
        data : out std_logic_vector(2 downto 0)
    );
end entity;

architecture rtl of lightrom_pulse is
begin
    data <= 
        "000" when addr = "0000" else -- clear LR      00000000
        "011" when addr = "0001" else -- add 1 to LR   00000001
        "010" when addr = "0010" else -- shift LR left 00000010
        "010" when addr = "0011" else -- shift LR left 00000100
        "010" when addr = "0100" else -- shift LR left 00001000
        "001" when addr = "0101" else -- shift LR right 00000100
        "001" when addr = "0110" else -- shift LR right 00000010
        "001" when addr = "0111" else -- shift LR right 00000001
        "001" when addr = "1000" else -- shift LR right 00000000
        "011" when addr = "1001" else -- add 1 to LR   00000001
        "010" when addr = "1010" else -- shift LR left 00000010
        "010" when addr = "1011" else -- shift LR left 00000100
        "001" when addr = "1100" else -- shift LR right 00000010
        "001" when addr = "1101" else -- shift LR right 00000001
        "100" when addr = "1110" else -- sub 1 from LR  00000000
        "000";                        -- clear LR      00000000
end rtl;