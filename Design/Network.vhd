library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library WORK;
use WORK.UTILS.ALL;

entity Network is
    port (

        net_input:              in t_array(0 to input_size - 1);

        clk:                    in std_logic;

        net_output:             out t_array(0 to output_size - 1)

    );
end Network;

architecture Behavioral of Network is

    signal sync_net_input:      t_array(0 to input_size - 1);
    signal sync_net_output:     t_array(0 to output_size - 1);

    signal activation_hidden_1: t_array(0 to hidden_1_size - 1);
    signal activation_hidden_2: t_array(0 to hidden_2_size - 1);

    component Neuron is
    generic (
        size:                   integer
    );
    port (
        clk:                    in std_logic;
        weight_row:             in t_array(0 to size - 1);
        input_arr:              in t_array(0 to size - 1);
        bias:                   in integer;
        output_val:             out integer
    );
    end component Neuron;

    component comp_Register is
    port (
        d:                      in t_array;
        clk:                    in std_logic;
        q:                      out t_array
    );
    end component comp_Register;

begin

    input_register: comp_Register
    port map (
        d => net_input,
        clk => clk,
        q => sync_net_input
    );

    output_register: comp_Register
    port map (
        d => sync_net_output,
        clk => clk,
        q => net_output
    );

    generate_hidden_1: for i in 0 to hidden_1_size - 1 generate
        n_hidden_1: Neuron
        generic map (
            size => input_size
        )
        port map (
            clk => clk,
            weight_row => weights_hidden_1(i),
            input_arr => sync_net_input,
            bias => biases_hidden_1(i),
            output_val => activation_hidden_1(i)
        );
    end generate;

    generate_hidden_2: for i in 0 to hidden_2_size - 1 generate
        n_hidden_2: Neuron
        generic map (
            size => hidden_1_size
        )
        port map (
            clk => clk,
            weight_row => weights_hidden_2(i),
            input_arr => activation_hidden_1,
            bias => biases_hidden_2(i),
            output_val => activation_hidden_2(i)
        );
    end generate;

    generate_output: for i in 0 to output_size - 1 generate
        n_output: Neuron
        generic map (
            size => hidden_2_size
        )
        port map (
            clk => clk,
            weight_row => weights_output(i),
            input_arr => activation_hidden_2,
            bias => biases_output(i),
            output_val => sync_net_output(i)
        );
    end generate;

end Behavioral;
