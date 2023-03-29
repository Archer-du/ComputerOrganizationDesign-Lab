`timescale 1ns / 1ps
module ALU_testbench();
reg clk,en;
reg [1:0] sel;
reg [5:0] x;
wire [5:0] y;
wire of;
reg [5:0] a,b,f;
ALU ALU(.clk(clk),.en(en),.sel(sel),.x(x),.y(y),.of(of));
integer k=0;
initial 
begin
    clk=0;
    en=1;
    sel=2'b10;
    x=6'b0;
    f=6'b0;
    a=6'b0;
    b=6'b111111;
end
always #5 clk=~clk;
always #270 f=f+1;
always #18 a=a+1;
always #18 b=b-3;
always
begin
    if(k<10)
    begin
        case(sel)
        2'b10:
        begin
            x=f;
            #90 sel=sel-2;
        end
        2'b00:
        begin
            x=a;
            #18 sel=sel+1;
            k=k+1;
        end
        2'b01:
        begin
            x=b;
            #18 sel=sel-1;
            k=k+1;
        end
        default:k=k+1;
        endcase
    end
    else 
    begin
        k=0;
        sel=2'b10;
    end
end
endmodule
