library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library WORK;
use WORK.UTILS.ALL;

entity comp_Register is
    port (
        d:      in t_array;
        clk:    in std_logic;
        q:      out t_array
    );

end comp_Register;

architecture Behavioral of comp_Register is

begin

    process(clk)
    begin

        if rising_edge(clk) then
            q <= d;
        end if;

    end process;

end architecture Behavioral;
