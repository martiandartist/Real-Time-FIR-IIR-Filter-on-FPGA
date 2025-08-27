`timescale 1ns / 1ps
module fir(
    input signed [11:0] input_data,       // Q5.6 input
    input clk,
    input rst,
    output signed [11:0] output_data      // Q5.6 output
);

    parameter n1 = 8;    // Coefficient width (Q1.6)
    parameter n2 = 12;   // Input width (Q5.6)
    parameter n3 = 24;   // Accumulator width (Q6.12 max sum width)

    // Fixed-point Q1.6 coefficients (scaled by 64)
    wire signed [n1-1:0] coeff [0:7];

assign coeff[0] = 8'b00000000; //  0
assign coeff[1] = 8'b11111111; // -1
assign coeff[2] = 8'b00000110; //  6
assign coeff[3] = 8'b00011100; // 28
assign coeff[4] = 8'b00011100; // 28
assign coeff[5] = 8'b00000110; //  6
assign coeff[6] = 8'b11111111; // -1
assign coeff[7] = 8'b00000000; //  0


    // Sample delay line: Q5.6
    reg signed [n2-1:0] samples [0:7];

    // MAC result: Q6.12 (intermediate fixed-point result)
    reg signed [n3-1:0] mac_result;

    always @(posedge clk) begin
        if (rst) begin
            samples[0] <= 0; samples[1] <= 0; samples[2] <= 0; samples[3] <= 0;
            samples[4] <= 0; samples[5] <= 0; samples[6] <= 0; samples[7] <= 0;
            mac_result <= 0;
        end else begin
            // Multiply and accumulate (fixed-point Q6.12)
            mac_result <=  coeff[0] * input_data +
                           coeff[1] * samples[0] +
                           coeff[2] * samples[1] +
                           coeff[3] * samples[2] +
                           coeff[4] * samples[3] +
                           coeff[5] * samples[4] +
                           coeff[6] * samples[5] +
                           coeff[7] * samples[6];

            // Shift register update
            samples[0] <= input_data;
            samples[1] <= samples[0];
            samples[2] <= samples[1];
            samples[3] <= samples[2];
            samples[4] <= samples[3];
            samples[5] <= samples[4];
            samples[6] <= samples[5];
        end
    end

    // Scale result back from Q6.12 ? Q5.6 by right-shifting 6 bits
    assign output_data = mac_result[17:6];

endmodule
