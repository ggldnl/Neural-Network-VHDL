library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library WORK;
use WORK.UTILS.ALL;

entity Neuron_testbench is
--  Port ( );
end Neuron_testbench;

architecture Behavioral of Neuron_testbench is

    signal input_arr:   t_array(0 to input_size - 1) := (3.0, 4.0, 1.0, 5.0);
    signal output_val:  real := 0.0;
    signal clk:         std_logic := '0';

    -- clock
    constant clock_half_period: time := 1 ns;

    component Neuron is
    port (
        clk:                    in std_logic;
        weight_row:             in t_array;
        input_arr:              in t_array;
        bias:                   in real;
        output_val:             out real
    );
    end component Neuron;

begin

    clk <= not(clk) after clock_half_period;

    neuron_impl: Neuron
    port map (
        clk => clk,
        weight_row => weights_hidden_1(0),
        input_arr => input_arr,
        bias => biases_hidden_1(0),
        output_val => output_val
    );

end Behavioral;
