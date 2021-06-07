library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library WORK;
use WORK.UTILS.ALL;

entity Testbench is
--  Port ( );
end Testbench;

architecture Behavioral of Testbench is

    -- Network I/O
    signal net_input:           t_array(0 to input_size - 1) := (3.0, 4.0, 1.0, 5.0);

    signal clk:                 std_logic := '0';

    signal net_output:          t_array(0 to output_size - 1);

    -- clock
    constant clock_half_period: time := 1 ns;

    -- Network component
    component Network is
    port (

        net_input:              in t_array(0 to input_size - 1);

        clk:                    in std_logic;

        net_output:             out t_array(0 to output_size - 1)

    );
    end component Network;

begin

    clk <= not(clk) after clock_half_period;

    network_impl: Network
    port map (

        net_input => net_input,
        clk => clk,
        net_output => net_output

    );

end Behavioral;
