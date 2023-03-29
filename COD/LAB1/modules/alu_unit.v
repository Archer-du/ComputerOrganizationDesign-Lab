`timescale 1ns / 1ps
module alu_unit
    #(parameter WIDTH = 6)
    (
        input [WIDTH-1:0] a, b,
        input [3:0] func,
        output reg [WIDTH-1:0] y,
        output reg OF
    );
    always @(*) 
    begin
        case(func)
            4'b0000: begin
                y=a+b;
                OF=(~a[WIDTH-1]&~b[WIDTH-1]&y[WIDTH-1] | a[WIDTH-1]&b[WIDTH-1]&~y[WIDTH-1]);
            end
            4'b0001: begin
                y=a-b;
                OF=(~a[WIDTH-1]&b[WIDTH-1]&y[WIDTH-1] | a[WIDTH-1]&~b[WIDTH-1]&~y[WIDTH-1]);
            end
            4'b0010: begin
                y=(a==b);
                OF=0;
            end
            4'b0011: begin
                y=(a<b);
                OF=0;
            end
            4'b0100: begin
                y=($signed(a)<$signed(b));
                OF=0;
            end
            4'b0101: begin
                y=a&b;
                OF=0;
            end
            4'b0110: begin
                y=a|b;
                OF=0;
            end
            4'b0111: begin
                y=a^b;
                OF=0;
            end
            4'b1000: begin
                y=a>>b;
                OF=0;
            end
            4'b1001: begin
                y=a<<b;
                OF=0;
            end
            default: begin
                y=0;
                OF=0;
            end
        endcase
    end
endmodule

