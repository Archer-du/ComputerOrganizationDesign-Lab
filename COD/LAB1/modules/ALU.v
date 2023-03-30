`timescale 1ns / 1ps
module ALU
    (
        input clk,en,
        input [1:0] sel,
        input [5:0] x,
        output [5:0] y,
        output of
    );
    wire [5:0] a,b,FUNC,Y;
    wire enf,ena,enb;
    wire OF;
    decoder dec(.sel(sel),.en(en),.enf(enf),.ena(ena),.enb(enb));
    FF Freg(.clk(clk),.en(enf),.x(x),.o(FUNC));
    FF Areg(.clk(clk),.en(ena),.x(x),.o(a));
    FF Breg(.clk(clk),.en(enb),.x(x),.o(b));
    alu_unit alu(.a(a),.b(b),.func(FUNC[3:0]),.y(Y),.OF(OF));
    FF Yreg(.clk(clk),.en(1),.x(Y),.o(y));
    FF Oreg(.clk(clk),.en(1),.x(OF),.o(of));
endmodule