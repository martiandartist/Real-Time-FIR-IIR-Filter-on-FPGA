
`timescale 1ns / 1ps
module spi_receiver (
    input clk,             // 100 MHz system clock
    input rst,
    input miso,
    output reg sclk,
    output reg ss,
    output reg [11:0] data_out,
    output reg data_valid
);

    reg [4:0] bit_cnt;
    reg [15:0] shift_reg;
    reg [7:0] clk_div;
    parameter CLK_DIVIDER = 50;  // 100 MHz / (2*50) = 1 MHz SPI clock

    reg sclk_en;

    always @(posedge clk) begin
        if (rst) begin
            clk_div <= 0;
            sclk <= 1;
            sclk_en <= 0;
        end else begin
            if (clk_div == CLK_DIVIDER) begin
                clk_div <= 0;
                sclk <= ~sclk;
                sclk_en <= 1;
            end else begin
                clk_div <= clk_div + 1;
                sclk_en <= 0;
            end
        end
    end

    always @(negedge sclk) begin
        if (rst) begin
            bit_cnt <= 0;
            shift_reg <= 0;
            ss <= 1;
            data_out <= 0;
            data_valid <= 0;
        end else if (sclk_en) begin
            ss <= 0;
            shift_reg <= {shift_reg[14:0], miso};
            bit_cnt <= bit_cnt + 1;

            if (bit_cnt == 15) begin
                data_out <= shift_reg[11:0]; // Capture lower 12 bits
                data_valid <= 1;
                bit_cnt <= 0;
                ss <= 1;  // Deselect after transfer
            end else begin
                data_valid <= 0;
            end
        end
    end
endmodule
