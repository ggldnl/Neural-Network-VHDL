library IEEE;
use IEEE.MATH_REAL.ALL;

package utils is

    constant input_size:        integer := 4;
    constant hidden_1_size:     integer := 3;
    constant hidden_2_size:     integer := 3;
    constant output_size:       integer := 2;

    type t_array is array (integer range <>) of integer;

    type t_matrix_hidden_1 is array (integer range <>) of t_array(0 to input_size - 1);
    type t_matrix_hidden_2 is array (integer range <>) of t_array(0 to hidden_1_size - 1);
    type t_matrix_output is array (integer range <>) of t_array(0 to hidden_2_size - 1);

    constant weights_hidden_1:
        t_matrix_hidden_1(0 to hidden_1_size - 1)
        := ((90, 1200, 900, -190),
            (-600, -500, -400, -400),
            (330, 300, 200, -2500));

    constant weights_hidden_2:
        t_matrix_hidden_2(0 to hidden_2_size - 1)
        := ((90, -800, 1200),
            (300, -1200, 20),
            (-1600, 200, 300));

    constant weights_output:
        t_matrix_output(0 to output_size - 1)
        := ((-2300, 90, -1050),
            (500, -300, -120));

    constant biases_hidden_1:
        t_array(0 to hidden_1_size - 1)
        := (others => 0);

    constant biases_hidden_2:
        t_array(0 to hidden_2_size - 1)
        := (others => 0);

    constant biases_output:
        t_array(0 to output_size - 1)
        := (others => 0);

end package utils;
