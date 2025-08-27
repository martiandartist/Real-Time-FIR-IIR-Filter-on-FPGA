`timescale 1ns / 1ps
module top(input clk,
    input rst,
    output [1:0] SDATA,
    output SCLK,
    output SYNC,
   
    input miso,
    output  sclk_m,
    output  ss,
    output  data_valid
    );
   


wire [11:0] value0,value1;
wire[11:0] data_out;
wire update;

   DA2_Top da2 (.clk(clk),.rst(rst),.update(1'b1),.value0(value0),.value1(value1),.SDATA(SDATA),.SCLK(SCLK),.SYNC(SYNC));
   
   spi_receiver spi(.clk(clk),.rst(rst),.miso(miso),.sclk(sclk_m),.ss(ss),.data_out(data_out),.data_valid(data_valid));
   
   fir f (.input_data(data_out),.clk(clk),.rst(rst),.output_data(value0));
   
   iir r (.clk(clk),.din(data_out),.dout(value1));
endmodule
