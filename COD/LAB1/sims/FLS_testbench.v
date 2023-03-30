`timescale 1ns / 1ps
module FLS_testbench();
reg clk=0,rst=0;
reg en;
reg [6:0] d=7'b0000001;
wire [6:0] f;
FLS FLS(.clk(clk),.rst(rst),.en(en),.d(d),.f(f));
always #5 clk=~clk;
always
begin
    #2 en=1;
    #40 en=0;
    #38;
end
initial
begin
    #3000 rst=1;
end
endmodule
