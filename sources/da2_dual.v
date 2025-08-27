
`timescale 1ns / 1ps

module da2_dual(
  input clk,
  input rst,
  //Serial data line
  input SCLK,
  output [1:0] SDATA,
  output reg SYNC,
  //Enable clock
  output reg working,
  //Output value and mode
  input [1:0] chmode0,
  input [1:0] chmode1,
  //Channel modes: 00 Enabled, Power off modes: 01 1kOhm, 10 100kOhm, 11 High-Z
  input [11:0] value0,
  input [11:0] value1,
  //Control signals
  input update
  /*output reg start*/);
  reg count;
  reg contCount;
  reg [3:0] counter; //Count edges
  wire [15:0] SDATAbuff_cont0, SDATAbuff_cont1;
  reg [15:0] SDATAbuff0, SDATAbuff1;

  //Handle SDATA buffer
  initial begin
  SDATAbuff0[15]<=1'b0;
  SDATAbuff1[15]<=1'b0;
  //start<=1'b0;
  end
  assign SDATAbuff_cont0 = {2'd0, chmode0, value0};
  assign SDATAbuff_cont1 = {2'd0, chmode1, value1};
  assign SDATA = {SDATAbuff1[15], SDATAbuff0[15]};
  always@(posedge SCLK or posedge SYNC) begin
    /*if(count==4'b0100)
    start<=1'b1;
    else
    start<=1'b0;*/
    if(SYNC) begin
      SDATAbuff0 <= SDATAbuff_cont0;
      SDATAbuff1 <= SDATAbuff_cont1;
    end else begin
      SDATAbuff0 <= (count) ? {SDATAbuff0[14:0], 1'b0} : SDATAbuff0;
      SDATAbuff1 <= (count) ? {SDATAbuff1[14:0], 1'b0} : SDATAbuff1;
    end
  end

  //count
  always@(posedge clk or posedge rst) begin
    if(rst) begin
        count <= 1'b0;
    end else case(count)
      1'b0: count <= SCLK & contCount;
      1'b1:  count <= (counter != 4'd0) | contCount;
    endcase
  end
 
  //contCount
  always@(posedge clk or posedge SYNC) begin
    if(SYNC) begin
      contCount <= 1'b1;
    end else begin
      contCount <= working & contCount & (counter != 4'd15);
    end
  end
 
 
  //working
  always@(posedge clk or posedge rst) begin
    if(rst) begin
        working <= 1'b0;
    end else case(working)
      1'b0: working <= SYNC;
      1'b1: working <= (counter != 4'd0) | contCount;
    endcase
  end
 
  //SYNC
  always@(posedge clk or posedge rst) begin
    if(rst) begin
        SYNC <= 1'b0;
    end else case(SYNC)
      1'b0: SYNC <= update & ~(contCount | count);
      1'b1: SYNC <= 1'b0;
    endcase
  end
 
  //Count SCLK
  always@(negedge SCLK or posedge SYNC) begin
    if(SYNC) begin
      counter <= 4'd0;
    end else begin
      counter <= counter + {3'd0, count};
    end
  end
endmodule//da2
