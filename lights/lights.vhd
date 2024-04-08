-- lights.vhd
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; -- To use the unsigned type

entity lights is
    port(
        clk      : in  std_logic;
        reset    : in  std_logic;
        lightsig : out std_logic_vector(7 downto 0);
        IRView   : out std_logic_vector(2 downto 0);
        PCView   : out unsigned(3 downto 0)
    );
end entity lights;

architecture rtl of lights is
    -- Enumerated type for the state machine
    type state_type is (sFetch, sExecute);
    
    -- Internal signals declaration
    signal IR       : std_logic_vector(2 downto 0);
    signal PC       : unsigned(3 downto 0);
    signal LR       : unsigned(7 downto 0);
    signal ROMvalue : std_logic_vector(2 downto 0);
    signal state    : state_type;

    -- lightrom component declaration
    component lightrom
        port(
            addr : in std_logic_vector(3 downto 0);
            data : out std_logic_vector(2 downto 0)
        );
    end component;

begin

    -- Instantiation of lightrom component
    lightrom_instance: lightrom
        port map(
            addr => std_logic_vector(PC),
            data => ROMvalue
        );

    -- State Machine Process
    process (clk, reset)
    begin
        if reset = '1' then
            PC <= (others => '0');
            IR <= "000";
            LR <= (others => '0');
            state <= sFetch;
        elsif (rising_edge(clk)) then
            case state is
                when sFetch =>
                    IR <= ROMvalue;
                    PC <= PC + 1;
                    state <= sExecute;
                when sExecute =>
                    case IR is
                        when "000" =>
									 LR <= (others => '0');  -- Load "00000000" into the LR
								when "001" =>
                            LR <= '0' & LR(7 downto 1); -- shift the LR right by one position, fill from the left with a '0'
								when "010" =>
                            LR <= LR(6 downto 0) & '0'; -- shift the LR left by one position, fill from the right with a '0'
								when "011" =>
                            LR <= LR + 1; -- add 1 to the LR
								when "100" =>
									 LR <= LR - 1; -- subtract 1 from the LR
							   when "101" =>
									 LR <= not LR; -- invert all of the bits of the LR
							   when "110" =>
									 LR <= LR(0) & LR(7 downto 1); -- rotate the LR right by one position (rightmost bit becomes leftmost bit)
							   when "111" =>
									 LR <= LR(6 downto 0) & LR(7); -- rotate the LR left by one position (leftmost bit becomes rightmost bit)
							   when others =>
									-- do nothing or handle any unexpected IR values
                    end case;
                    state <= sFetch;
            end case;
        end if;
    end process;

    -- Concurrent assignments for the outputs
    IRView <= IR;
    lightsig <= std_logic_vector(LR);
    PCView <= PC;

end rtl;