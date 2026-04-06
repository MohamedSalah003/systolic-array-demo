SIM=sim
TOP=tb_systolic_array_3x3
SRCS=pe.v systolic_array_3x3.v tb_systolic_array_3x3.v

.PHONY: all run wave clean

all: run

$(SIM): $(SRCS)
	iverilog -g2012 -s $(TOP) -o $(SIM) $(SRCS)

run: $(SIM)
	vvp $(SIM)

wave: run
	gtkwave systolic_array_3x3.vcd

clean:
	rm -f $(SIM) systolic_array_3x3.vcd
