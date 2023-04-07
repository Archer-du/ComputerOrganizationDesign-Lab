`timescale 1ns / 1ps
module FIFO(
    input clk,rst,
    input enq,deq,
    input [3:0] in,
    output [3:0] out,
    output full,emp,
    output [2:0] an,
    output [3:0] seg
    );
    wire [7:0] VALID;
    wire [2:0] RA0,RA1,WA;
    wire [3:0] RD0,RD1,WD;
    wire [2:0] P;
    register_file #(.WIDTH(4),.ADDRNUM(3),.REGNUM(8))
    RF(
        .clk(clk),
        .ra0(RA0),
        .rd0(RD0),
        .ra1(RA1),
        .rd1(RD1),
        .wa(WA),
        .we(1),
        .wd(WD)
    );
    LCU LCU(
        .clk(clk),.rst(rst),
        .enq(enq),.deq(deq),
        .in(in),
        .full(full),.emp(emp),
        .p(P),
        .out(out),
        .valid(VALID),
        .ra(RA0),
        .rd(RD0),
        .wa(WA),
        .wd(WD)
    );
    SDU SDU(
        .clk(clk),
        .valid(VALID),
        .rd(RD1),
        .p(P),
        .ra(RA1),
        .an(an),
        .seg(seg)
    );
endmodule
