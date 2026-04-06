`timescale 1ns/1ps

module tb_systolic_array_3x3;

localparam integer DATA_W = 8;
localparam integer ACC_W  = 24;

reg                         clk;
reg                         rst_n;
reg                         clear;
reg  signed [DATA_W-1:0]    a_left_0;
reg  signed [DATA_W-1:0]    a_left_1;
reg  signed [DATA_W-1:0]    a_left_2;
reg  signed [DATA_W-1:0]    b_top_0;
reg  signed [DATA_W-1:0]    b_top_1;
reg  signed [DATA_W-1:0]    b_top_2;
wire signed [ACC_W-1:0]     c00;
wire signed [ACC_W-1:0]     c01;
wire signed [ACC_W-1:0]     c10;
wire signed [ACC_W-1:0]     c11;
wire signed [ACC_W-1:0]     c02;
wire signed [ACC_W-1:0]     c12;
wire signed [ACC_W-1:0]     c20;
wire signed [ACC_W-1:0]     c21;
wire signed [ACC_W-1:0]     c22;

systolic_array_3x3 #(
    .DATA_W(DATA_W),
    .ACC_W(ACC_W)
) dut (
    .clk(clk),
    .rst_n(rst_n),
    .clear(clear),
    .a_left_0(a_left_0),
    .a_left_1(a_left_1),
    .a_left_2(a_left_2),
    .b_top_0(b_top_0),
    .b_top_1(b_top_1),
    .b_top_2(b_top_2),
    .c00(c00),
    .c01(c01),
    .c10(c10),
    .c11(c11),
    .c02(c02),
    .c12(c12),
    .c20(c20),
    .c21(c21),
    .c22(c22)
);

always #5 clk = ~clk;

task automatic push_cycle(
    input signed [DATA_W-1:0] next_a0,
    input signed [DATA_W-1:0] next_a1,
    input signed [DATA_W-1:0] next_a2,
    input signed [DATA_W-1:0] next_b0,
    input signed [DATA_W-1:0] next_b1,
    input signed [DATA_W-1:0] next_b2
);
begin
    @(negedge clk);
    a_left_0 = next_a0;
    a_left_1 = next_a1;
    a_left_2 = next_a2;
    b_top_0  = next_b0;
    b_top_1  = next_b1;
    b_top_2  = next_b2;

    @(posedge clk);
    #1;
    $display(
        "time=%0t a_left={%0d,%0d,%0d} b_top={%0d,%0d,%0d} -> C00..C22={%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d}",
        $time,
        a_left_0, a_left_1, a_left_2,
        b_top_0, b_top_1, b_top_2,
        c00, c01, c02, c10, c11, c12, c20, c21, c22
    );
end
endtask

initial begin
    $dumpfile("systolic_array_3x3.vcd");
    $dumpvars(0, tb_systolic_array_3x3);

    clk      = 1'b0;
    rst_n    = 1'b0;
    clear    = 1'b1;
    a_left_0 = '0;
    a_left_1 = '0;
    a_left_2 = '0;
    b_top_0  = '0;
    b_top_1  = '0;
    b_top_2  = '0;

    repeat (2) @(posedge clk);
    rst_n = 1'b1;

    @(posedge clk);
    #1;
    clear = 1'b0;

    // Presentation matrices taken from systolic_vs_cpu.html:
    // A = [1 2 3; 4 5 6; 7 8 9]
    // B = [9 8 7; 6 5 4; 3 2 1]
    //
    // Expected C = A x B =
    // [ 30  24  18
    //   84  69  54
    //  138 114  90 ]
    //
    // Inputs are injected with one-cycle skew per row and column.
    // Total systolic time for 3x3 is 3N-2 = 7 cycles.
    push_cycle(1, 0, 0, 9, 0, 0);
    push_cycle(2, 4, 0, 6, 8, 0);
    push_cycle(3, 5, 7, 3, 5, 7);
    push_cycle(0, 6, 8, 0, 2, 4);
    push_cycle(0, 0, 9, 0, 0, 1);
    push_cycle(0, 0, 0, 0, 0, 0);
    push_cycle(0, 0, 0, 0, 0, 0);

    if ((c00 === 30)  && (c01 === 24)  && (c02 === 18) &&
        (c10 === 84)  && (c11 === 69)  && (c12 === 54) &&
        (c20 === 138) && (c21 === 114) && (c22 === 90)) begin
        $display(
            "TEST PASSED: C = [%0d %0d %0d; %0d %0d %0d; %0d %0d %0d]",
            c00, c01, c02, c10, c11, c12, c20, c21, c22
        );
    end else begin
        $display(
            "TEST FAILED: C = [%0d %0d %0d; %0d %0d %0d; %0d %0d %0d]",
            c00, c01, c02, c10, c11, c12, c20, c21, c22
        );
    end

    @(negedge clk);
    $finish;
end

endmodule
