# Abstract

VHDL implementation of a DFF neural network. The network is made up of 4 logical layers:
- an input layer;
- two hidden layers;
- an output layer.

You can change this structure as explained below.

This repo consists of 3 folders:
- the **Design** folder, containing the VHDL sources;
- the **Constraints** folder, containing the constraints (a single constraint for the clock signal);
- the **Simulation** folder, containing testbenches for the simulation;


## Sources

### Utils

Layers are implemented by chaining neurons one after another. Each neuron manages its weights and bias in order to compute the output and propagate it. We can organize all the weights related to a layer in a matrix: the i-th row will contain the weights for the neuron of index i in the layer. This way we'll only need to represent 3 layers for the network as the weights between two layers will be managed by the rightmost one. I used this convention to represent the parameters.

- input - hidden 1

<i>
<pre align="center">
w<sub>h1,1-i1</sub>    w<sub>h1,1-i2</sub>    w<sub>h1,1-i3</sub>    w<sub>h1,1-i4</sub>
w<sub>h1,2-i1</sub>    w<sub>h1,2-i2</sub>    w<sub>h1,2-i3</sub>    w<sub>h1,2-i4</sub>
w<sub>h1,3-i1</sub>    w<sub>h1,3-i2</sub>    w<sub>h1,3-i3</sub>    w<sub>h1,3-i4</sub>
</pre>
</i>

- hidden 1 - hidden 2

<i>
<pre align="center">
w<sub>h2,1-h1,1</sub>    w<sub>h2,1-h1,2</sub>    w<sub>h2,1-h1,3</sub>
w<sub>h2,2-h1,1</sub>    w<sub>h2,2-h1,2</sub>    w<sub>h2,2-h1,3</sub>
w<sub>h2,3-h1,1</sub>    w<sub>h2,3-h1,2</sub>    w<sub>h2,3-h1,3</sub>
</pre>
</i>

- hidden 2 - output

<i>
<pre align="center">
w<sub>o1-h2,1</sub>    w<sub>o1-h2,2</sub>    w<sub>o1-h2,3</sub>
w<sub>o2-h2,1</sub>    w<sub>o2-h2,2</sub>    w<sub>o2-h2,3</sub>
</pre>
</i>

The biases will be organized in vectors in a similar way:

- input - hidden 1

<i>
<pre align="center">
b<sub>h1,1</sub>    b<sub>h1,2</sub>    b<sub>h1,3</sub>
</pre>
</i>

- hidden 1 - hidden 2

<i>
<pre align="center">
b<sub>h2,1</sub>    b<sub>h2,2</sub>    b<sub>h2,3</sub>
</pre>
</i>

- hidden 2 - output

<i>
<pre align="center">
b<sub>o1</sub>    b<sub>o1</sub>
</pre>
</i>

In the code we have somthing like this:
- input - hidden 1 weights
```
constant weights_hidden_1:
	t_matrix_hidden_1(0 to hidden_1_size - 1)
	:=	((90, 1200, 900, -190),
		(-600, -500, -400, -400),
		(330, 300, 200, -2500));
```
- hidden 1 biases
```
constant biases_hidden_1: t_array(0 to hidden_1_size - 1)
	:= (others => 0);
```

Note that the weights and biases are represented as integers in order to implement the circuit, as the reals are not synthesizable.

`t_array` represents a vector, `t_matrix` represents a matrix. In the latter case we have to fix the dimension based on the layer for which it contains the weights.
```
type t_matrix_hidden_1 is array (integer range <>)
	of t_array(0 to input_size - 1);

type t_matrix_hidden_2 is array (integer range <>)
	of t_array(0 to hidden_1_size - 1);

type t_matrix_output is array (integer range <>)
	of t_array(0 to hidden_2_size - 1);
```
These constants establish the number of neurons for each layer:
```
constant input_size: integer := 4;
constant hidden_1_size: integer := 3;
constant hidden_2_size: integer := 3;
constant output_size: integer := 2;
```

You can configure the network by editing the `Utils.vhd` file, changing the constants for the number of neurons in each layer, the weight matrices and bias vectors.
Keep in mind that by changing the number of neurons in a layer you have to adjust its weight matrix and bias vector accordingly.

The activation function used is the `ReLU`.

```
-- ReLU
if sum < 0 then
	output_val <= 0;
else
	output_val <= sum;
end if;
```

To change it just edit the `Neuron.vhd` file.

### Network

The generated circuit will only implement the feedforward phase. The network must be trained at a high level, we have to extract the weights and biases, convert them from floats (usually they are real) to integers and put them in the respective matrices in the `Utils` file.

To create and train a network and for the parameter extraction you can refer to this [framework](https://github.com/ggldnl/Neural-Network-Java).

The number of layers cannot be changed that easily, as we did with the other parameters by editing the `Utils` file. You will need to change the code in the `Network` file.

The following section of code represents the construction of the layers and the connection between them. As you can see, the output of each layer is the input for the next one.

```
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
```

To add a new layer, let's say between hidden_1 and hidden_2, you'll need to do something like this:

```
generate_hidden_mid: for i in 0 to hidden_mid_size - 1 generate
	n_hidden_mid: Neuron
	generic map (
		size => hidden_1_size
	)
	port map (
		clk => clk,
		weight_row => weights_hidden_mid(i),
		input_arr => activation_hidden_1,
		bias => biases_hidden_mid(i),
		output_val => activation_hidden_mid(i)
	);
end generate;
```

Note that:
- the number of the input elements for each neuron of the new layer (`size`) is the size of the previous layer (`hidden_1`);
- you have to add a weight matrix (`weights_hidden_mid`) in the `Utils.vhd` file;
- you have to add a bias vector (`biases_hidden_mid`) in the 'Utils.vhd` file;
- the input for the new layer is the output of the previous one (`activation_hidden_1`);
- you have to add a new `t_array` signal for the activation of the new layer (`activation_hidden_mid`) that will also be the input for the next layer (`hidden_2`);

## Simulation

As mentioned above, in order to synthesize the circuit we cannot use reals in the VHDL code. If all we want to do is a simulation (using the testbenches) we can simply convert all the integers to real in each source (even in the `Neuron` file).
