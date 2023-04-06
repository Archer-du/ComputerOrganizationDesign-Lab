`timescale 1ns / 1ps
module register_file
    #(parameter WIDTH=32,
      parameter REGNUM=32)
    (
        input clk,
        input [4:0] ra0,
        output [WIDTH-1:0] rd0,
        input [4:0] ra1,
        output [WIDTH-1:0] rd1,
        input [4:0] wa,
        input we,
        input [WIDTH-1:0] wd
    );
    reg [WIDTH-1:0] regfile[0:REGNUM-1];
    assign rd0=regfile[ra0],rd1=regfile[ra1];
    always@(posedge clk)begin
        regfile[0]<=0;
        if(we)begin
            if(wa!=5'b0)
            regfile[wa]<=wd;
        end
    end
endmodule
