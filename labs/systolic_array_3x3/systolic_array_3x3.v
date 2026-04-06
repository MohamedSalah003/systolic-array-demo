module systolic_array_3x3 #(
    parameter integer DATA_W = 8,
    parameter integer ACC_W  = 24
) (
    input  wire                         clk,
    input  wire                         rst_n,
    input  wire                         clear,
    input  wire signed [DATA_W-1:0]     a_left_0,
    input  wire signed [DATA_W-1:0]     a_left_1,
    input  wire signed [DATA_W-1:0]     a_left_2,
    input  wire signed [DATA_W-1:0]     b_top_0,
    input  wire signed [DATA_W-1:0]     b_top_1,
    input  wire signed [DATA_W-1:0]     b_top_2,
    output wire signed [ACC_W-1:0]      c00,
    output wire signed [ACC_W-1:0]      c01,
    output wire signed [ACC_W-1:0]      c10,
    output wire signed [ACC_W-1:0]      c11,
    output wire signed [ACC_W-1:0]      c02,
    output wire signed [ACC_W-1:0]      c12,
    output wire signed [ACC_W-1:0]      c20,
    output wire signed [ACC_W-1:0]      c21,
    output wire signed [ACC_W-1:0]      c22
);

wire signed [DATA_W-1:0] a_00_to_01;
wire signed [DATA_W-1:0] a_01_to_02;
wire signed [DATA_W-1:0] a_10_to_11;
wire signed [DATA_W-1:0] a_11_to_12;
wire signed [DATA_W-1:0] a_20_to_21;
wire signed [DATA_W-1:0] a_21_to_22;
wire signed [DATA_W-1:0] b_00_to_10;
wire signed [DATA_W-1:0] b_01_to_11;
wire signed [DATA_W-1:0] b_02_to_12;
wire signed [DATA_W-1:0] b_10_to_20;
wire signed [DATA_W-1:0] b_11_to_21;
wire signed [DATA_W-1:0] b_12_to_22;

pe #(
    .DATA_W(DATA_W),
    .ACC_W(ACC_W)
) pe_00 (
    .clk(clk),
    .rst_n(rst_n),
    .clear(clear),
    .a_in(a_left_0),
    .b_in(b_top_0),
    .a_out(a_00_to_01),
    .b_out(b_00_to_10),
    .acc_out(c00)
);

pe #(
    .DATA_W(DATA_W),
    .ACC_W(ACC_W)
) pe_01 (
    .clk(clk),
    .rst_n(rst_n),
    .clear(clear),
    .a_in(a_00_to_01),
    .b_in(b_top_1),
    .a_out(a_01_to_02),
    .b_out(b_01_to_11),
    .acc_out(c01)
);

pe #(
    .DATA_W(DATA_W),
    .ACC_W(ACC_W)
) pe_02 (
    .clk(clk),
    .rst_n(rst_n),
    .clear(clear),
    .a_in(a_01_to_02),
    .b_in(b_top_2),
    .a_out(),
    .b_out(b_02_to_12),
    .acc_out(c02)
);

pe #(
    .DATA_W(DATA_W),
    .ACC_W(ACC_W)
) pe_10 (
    .clk(clk),
    .rst_n(rst_n),
    .clear(clear),
    .a_in(a_left_1),
    .b_in(b_00_to_10),
    .a_out(a_10_to_11),
    .b_out(b_10_to_20),
    .acc_out(c10)
);

pe #(
    .DATA_W(DATA_W),
    .ACC_W(ACC_W)
) pe_11 (
    .clk(clk),
    .rst_n(rst_n),
    .clear(clear),
    .a_in(a_10_to_11),
    .b_in(b_01_to_11),
    .a_out(a_11_to_12),
    .b_out(b_11_to_21),
    .acc_out(c11)
);

pe #(
    .DATA_W(DATA_W),
    .ACC_W(ACC_W)
) pe_12 (
    .clk(clk),
    .rst_n(rst_n),
    .clear(clear),
    .a_in(a_11_to_12),
    .b_in(b_02_to_12),
    .a_out(),
    .b_out(b_12_to_22),
    .acc_out(c12)
);

pe #(
    .DATA_W(DATA_W),
    .ACC_W(ACC_W)
) pe_20 (
    .clk(clk),
    .rst_n(rst_n),
    .clear(clear),
    .a_in(a_left_2),
    .b_in(b_10_to_20),
    .a_out(a_20_to_21),
    .b_out(),
    .acc_out(c20)
);

pe #(
    .DATA_W(DATA_W),
    .ACC_W(ACC_W)
) pe_21 (
    .clk(clk),
    .rst_n(rst_n),
    .clear(clear),
    .a_in(a_20_to_21),
    .b_in(b_11_to_21),
    .a_out(a_21_to_22),
    .b_out(),
    .acc_out(c21)
);

pe #(
    .DATA_W(DATA_W),
    .ACC_W(ACC_W)
) pe_22 (
    .clk(clk),
    .rst_n(rst_n),
    .clear(clear),
    .a_in(a_21_to_22),
    .b_in(b_12_to_22),
    .a_out(),
    .b_out(),
    .acc_out(c22)
);

endmodule
