`timescale 1ns / 1ps
module FIFO_testbench();
    reg clk,rst;
    reg enq,deq;
    reg [3:0] in;
    wire [3:0] out;
    wire full,emp;
    wire [2:0] an;
    wire [3:0] seg;
    FIFO FIFO(
        clk,rst,
        enq,deq,
        in,
        out,
        full,emp,
        an,
        seg
    );
    initial begin
        clk=0;
        in=1;
        enq=0;
        deq=0;
        rst=1;
        #200 rst=0;
    end
    always #1 clk=~clk;
    always #1000 in=in+2;
    always begin
        for(integer i=0;i<8;i=i+1)begin
            #300 enq=1;
            #600 enq=0;
            #100 ;
        end
        for(integer i=0;i<8;i=i+1)begin
            #300 deq=1;
            #600 deq=0;
            #100 ;
        end
    end
endmodule
