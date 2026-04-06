module pe #(
    parameter integer DATA_W = 8,
    parameter integer ACC_W  = 24
) (
    input  wire                         clk,
    input  wire                         rst_n,
    input  wire                         clear,
    input  wire signed [DATA_W-1:0]     a_in,
    input  wire signed [DATA_W-1:0]     b_in,
    output reg  signed [DATA_W-1:0]     a_out,
    output reg  signed [DATA_W-1:0]     b_out,
    output reg  signed [ACC_W-1:0]      acc_out
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        a_out   <= '0;
        b_out   <= '0;
        acc_out <= '0;
    end else begin
        a_out <= a_in;
        b_out <= b_in;

        if (clear) begin
            acc_out <= '0;
        end else begin
            acc_out <= acc_out + (a_in * b_in);
        end
    end
end

endmodule
