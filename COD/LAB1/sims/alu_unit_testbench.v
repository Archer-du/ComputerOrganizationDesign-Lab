`timescale 1ns / 1ps
module alu_unit_testbench();
    reg [5:0] a;
    reg [5:0] b;
    reg [3:0] func;
    wire [5:0] y;
    wire OF;
    alu_unit test(.a(a),.b(b),.func(func),.y(y),.OF(OF));
    initial
    begin
        a=6'b000000;
        b=6'b111111;
        forever
        begin
            #10 a=a+1;
            b=b-3;
        end
    end
    initial
    begin
        func=4'b0;
        while(func<4'b1010)
        begin
            #200
            func=func+1;
        end
    end
endmodule
