# Systolic Array Demo

This repository contains a Verilog demo for a `3x3` systolic array used for matrix multiplication, plus the presentation file used to explain the idea visually.

## Contents

- `labs/systolic_array_3x3/`: Verilog source, testbench, waveform output notes, and architecture documentation
- `presentation/systolic_vs_cpu.html`: interactive presentation comparing CPU-style matrix multiplication and a systolic array

## Demo Matrices

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
C = [ 30  24  18
      84  69  54
     138 114  90]
```

## Run The Verilog Demo

```bash
cd labs/systolic_array_3x3
make run
```

## Open The Presentation

Open `presentation/systolic_vs_cpu.html` in a browser.
