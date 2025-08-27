`timescale 1ns / 1ps

module clkDiv25en(
  input clk,
  input rst,
  input en,
  output reg SCLK);
  reg clk_m;

  //50 MHz
  always@(posedge clk) begin
    if(~en) begin
      clk_m <= 1'b0;
    end else begin
      clk_m <= ~clk_m;
    end
  end
  //25 MHz
  always@(posedge clk_m or negedge en) begin
    if(~en) begin
      SCLK <= 1'b0;
    end else begin
      SCLK <= ~SCLK;
    end
  end
   
endmodule//clkDiv25
