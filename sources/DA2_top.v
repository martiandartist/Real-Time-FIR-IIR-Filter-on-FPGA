`timescale 1ns / 1ps

module DA2_Top (
    input clk,
    input rst,
  input update,
   input [11:0] value0,
  input [11:0] value1,
    output [1:0] SDATA,
    output SYNC,
    output SCLK
);
//wire rst;

//wire SCLK;
wire SCLK_en;

da2_dual uut1(
  clk,
  rst,
  //Serial data line
  SCLK,
  SDATA,
  SYNC,
  //Enable clock
  SCLK_en,
  //Output value and mode
  2'b00,
  2'b00,
  //Channel modes: 00 Enabled, Power off modes: 01 1kOhm, 10 100kOhm, 11 High-Z
  value0,
  value1,
  //Control signals
  update);
 
 clkDiv25en uut2(
  clk,
  rst,
  SCLK_en,
  SCLK);
 
 
 
endmodule
