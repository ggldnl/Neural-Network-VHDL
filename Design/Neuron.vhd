library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library WORK;
use WORK.UTILS.ALL;

entity Neuron is
    generic (
        size:       integer
    );
    port (
        clk:        in std_logic;
        weight_row: in t_array(0 to size - 1);
        input_arr:  in t_array(0 to size - 1);
        bias:       in integer;
        output_val: out integer
    );
end Neuron;

architecture Behavioral of Neuron is

begin

    process(clk)
        variable sum: integer := 0;
    begin

        if rising_edge(clk) then

            for i in weight_row'range loop
                sum := sum + (weight_row(i) * input_arr(i));
            end loop;
            sum := sum + bias;

            -- ReLU
            if sum < 0 then
                output_val <= 0;
            else
                output_val <= sum;
            end if;

            sum := 0;

        end if;

  end process;

end Behavioral;
