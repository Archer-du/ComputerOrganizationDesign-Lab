`timescale 1ns / 1ps
module reg_testbench();
    reg clk,en;
    reg [5:0] x;
    wire [5:0] o;
    FF FF(.clk(clk),.en(en),.x(x),.o(o));
    initial
    begin
        clk=0;
        en=0;
        x=6'b0;
        #50 en=~en;
    end
    always #5 clk=~clk;
    always #20 x=x+1;
endmodule
