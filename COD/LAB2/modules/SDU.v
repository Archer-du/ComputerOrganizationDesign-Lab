`timescale 1ns / 1ps
module SDU(
    input clk,
    input [7:0] valid,
    input [3:0] rd,
    input [2:0] p,
    output reg [2:0] ra,
    output reg [2:0] an,
    output [3:0] seg
    );
    integer f=0;
    reg [2:0] cnt=0;
    assign seg=valid[ra]?rd:0;
    always@(posedge clk)begin
        if(f==9)begin
            an=cnt;
            ra=p+cnt;
            if(!valid[ra])begin
                cnt=0;
                an=0;
                ra=p;
            end
            cnt=cnt+1;
            f=0;
        end
        else begin
            f=f+1;
        end
    end
endmodule
