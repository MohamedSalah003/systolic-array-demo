# Systolic Array Demo

This repository contains a Verilog demo for a `3x3` systolic array used for matrix multiplication, plus the presentation file used to explain the idea visually.

## Repository Contents

- `labs/systolic_array_3x3/pe.v`: one processing element that forwards `a` and `b` and accumulates `a*b`
- `labs/systolic_array_3x3/systolic_array_3x3.v`: nine PEs connected as a 3x3 array
- `labs/systolic_array_3x3/tb_systolic_array_3x3.v`: testbench with the same numeric example used in the slides
- `presentation/systolic_vs_cpu.html`: interactive presentation comparing CPU-style matrix multiplication and a systolic array

## Architecture

Each processing element does three things on every clock:

- receives `a_in` from the left and `b_in` from the top
- adds `a_in * b_in` into its local accumulator
- forwards `a_in` to the right and `b_in` downward

That local communication pattern is why systolic arrays are fast and hardware-friendly.

## Architecture Diagram

```text
                 b_top_0         b_top_1         b_top_2
                    |               |               |
                    v               v               v
              +------------+  +------------+  +------------+
a_left_0 ---> |   PE_00    |->|   PE_01    |->|   PE_02    |
              | acc -> c00 |  | acc -> c01 |  | acc -> c02 |
              +------------+  +------------+  +------------+
                    |               |               |
                    v               v               v
              +------------+  +------------+  +------------+
a_left_1 ---> |   PE_10    |->|   PE_11    |->|   PE_12    |
              | acc -> c10 |  | acc -> c11 |  | acc -> c12 |
              +------------+  +------------+  +------------+
                    |               |               |
                    v               v               v
              +------------+  +------------+  +------------+
a_left_2 ---> |   PE_20    |->|   PE_21    |->|   PE_22    |
              | acc -> c20 |  | acc -> c21 |  | acc -> c22 |
              +------------+  +------------+  +------------+
```

`A` data moves from left to right.

`B` data moves from top to bottom.

Each PE computes:

```text
acc_out <= acc_out + (a_in * b_in)
```

## Bus Map

External input buses:

- `a_left_0`, `a_left_1`, `a_left_2`: inject rows of matrix `A`
- `b_top_0`, `b_top_1`, `b_top_2`: inject columns of matrix `B`
- `clk`: global synchronous clock
- `rst_n`: active-low reset
- `clear`: clears all PE accumulators before a new matrix multiply

Internal horizontal buses for `A` flow:

- `a_00_to_01`: from `PE_00` to `PE_01`
- `a_01_to_02`: from `PE_01` to `PE_02`
- `a_10_to_11`: from `PE_10` to `PE_11`
- `a_11_to_12`: from `PE_11` to `PE_12`
- `a_20_to_21`: from `PE_20` to `PE_21`
- `a_21_to_22`: from `PE_21` to `PE_22`

Internal vertical buses for `B` flow:

- `b_00_to_10`: from `PE_00` to `PE_10`
- `b_01_to_11`: from `PE_01` to `PE_11`
- `b_02_to_12`: from `PE_02` to `PE_12`
- `b_10_to_20`: from `PE_10` to `PE_20`
- `b_11_to_21`: from `PE_11` to `PE_21`
- `b_12_to_22`: from `PE_12` to `PE_22`

Output accumulator buses:

- `c00`, `c01`, `c02`: first row of result matrix `C`
- `c10`, `c11`, `c12`: second row of result matrix `C`
- `c20`, `c21`, `c22`: third row of result matrix `C`

## PE Internal Diagram

One processing element in `labs/systolic_array_3x3/pe.v` looks like this internally:

```text
                    +------------------------------------+
                    |               PE(i,j)              |
                    |                                    |
a_in -------------->|                                    |--------------> a_out
                    |         +----------------+         |
                    |         | a_out register |         |
                    |         +----------------+         |
                    |                                    |
b_in -------------->|                                    |--------------> b_out
                    |         +----------------+         |
                    |         | b_out register |         |
                    |         +----------------+         |
                    |                                    |
                    |   a_in -----------+                |
                    |                   |                |
                    |                   v                |
                    |              +---------+           |
                    |              |   MUL   |           |
                    |              +---------+           |
                    |                   |                |
                    |   b_in -----------+                |
                    |                   v                |
                    |              +---------+           |
                    | acc_out ---->|  ADD    |---------->| acc_out
                    |              +---------+           |
                    |                   ^                |
                    |                   |                |
                    |            +--------------+        |
                    |            | acc register |        |
                    |            +--------------+        |
                    |                                    |
                    | clear -> acc_out = 0               |
                    | rst_n -> reset all registers       |
                    +------------------------------------+
```

PE behavior every clock cycle:

- `a_out <= a_in`
- `b_out <= b_in`
- `acc_out <= acc_out + (a_in * b_in)`

Control behavior:

- if `rst_n = 0`, all registers are reset to zero
- if `clear = 1`, the accumulator is cleared to zero for a new matrix multiplication

So each PE has three main internal parts:

- forward path for `A` data
- forward path for `B` data
- multiply-accumulate path for the local partial sum

## Demo Example

The Verilog testbench and the presentation use the same matrices:

```text
A = [1 2 3
     4 5 6
     7 8 9]

B = [9 8 7
     6 5 4
     3 2 1]
```

Expected result:

```text
C = A x B = [ 30  24  18
              84  69  54
             138 114  90]
```

## Input Schedule

To align the data correctly, the rows of `A` and the columns of `B` are skewed in time:

```text
Cycle 1: a_left={1,0,0}  b_top={9,0,0}
Cycle 2: a_left={2,4,0}  b_top={6,8,0}
Cycle 3: a_left={3,5,7}  b_top={3,5,7}
Cycle 4: a_left={0,6,8}  b_top={0,2,4}
Cycle 5: a_left={0,0,9}  b_top={0,0,1}
Cycle 6: a_left={0,0,0}  b_top={0,0,0}
Cycle 7: a_left={0,0,0}  b_top={0,0,0}
```

## Run The Verilog Demo

```bash
cd labs/systolic_array_3x3
make run
```

Optional waveform view:

```bash
cd labs/systolic_array_3x3
gtkwave systolic_array_3x3.vcd
```

## Open The Presentation

Open `presentation/systolic_vs_cpu.html` in a browser.
