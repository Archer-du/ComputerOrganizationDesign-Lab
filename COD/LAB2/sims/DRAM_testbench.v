`timescale 1ns / 1ps
module DRAM_testbench();
    reg [3:0] a;
    reg [7:0] d;
    reg clk;
    reg we;
    wire [7:0] spo;
    DRAM DRAM (
    .a(a),      // input wire [3 : 0] a
    .d(d),      // input wire [7 : 0] d
    .clk(clk),  // input wire clk
    .we(we),    // input wire we
    .spo(spo)  // output wire [7 : 0] spo
    );
    initial begin
        clk=0;
        we=1;
        a=0;
        d=1;
        #800 we=0;
    end
    always #5 clk=~clk;
    always #50 a=a+1;
    always #50 d=d+2;
endmodule
