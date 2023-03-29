`timescale 1ns / 1ps
module FF
    (
        input clk,en,
        input [5:0] x,
        output reg [5:0] o
    );
    always @(posedge clk) 
    begin
        if(en)o<=x;
    end
endmodule
