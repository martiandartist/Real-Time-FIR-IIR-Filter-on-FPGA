
`timescale 1ns / 1ps
module iir(
    input clk,
    input signed [11:0] din,
    output reg signed [11:0] dout
    );

    // Fixed-point Q1.6 Coefficients (8-bit)
    reg signed [7:0] a1 = -8'sd71;
    reg signed [7:0] a2 =  8'sd25;
    reg signed [7:0] b0 =  8'sd5;
    reg signed [7:0] b1 =  8'sd9;
    reg signed [7:0] b2 =  8'sd5;

    // Internal delayed signals
    reg signed [15:0] rx = 0;
    reg signed [15:0] rx_1 = 0;
    reg signed [15:0] rx_2 = 0;
    reg signed [15:0] ry_1 = 0;
    reg signed [15:0] ry_2 = 0;

    wire signed [31:0] sum;
    wire signed [11:0] scaled;

    always @(posedge clk) begin
        rx <= din;
        rx_1 <= rx;
        rx_2 <= rx_1;
        ry_1 <= sum >>> 6;  // Scale back from Q1.6
        ry_2 <= ry_1;

        // Saturation logic
        if (scaled > 12'sd2047)
            dout <= 12'sd2047;
        else if (scaled < -12'sd2048)
            dout <= -12'sd2048;
        else
            dout <= scaled;
    end

    assign sum = (rx * b0) + (rx_1 * b1) + (rx_2 * b2)
               + (ry_1 * -a1) + (ry_2 * -a2);

    assign scaled = sum[17:6];  // Extract 12-bit scaled result
endmodule

