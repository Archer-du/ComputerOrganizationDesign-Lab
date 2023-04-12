`timescale 1ns / 1ps

module Shift_reg(
    input rst,
    input clk,          // Work at 100MHz clock

    input [31:0] din,   // Data input  
    input [3:0] hex,    // Hexadecimal code for the switches
    input add,          // Add signal
    input del,          // Delete signal
    input set,          // Set signal
    
    output reg [31:0] dout  // Data output
);
    // TODO
    always@(posedge clk or posedge rst)begin
        if(rst)begin
            dout<=0;
        end
        else begin
            if(add)begin
                dout=dout<<4;
                dout<=dout+hex;
            end
            else if(del)begin
                dout=dout>>4;
            end
            else if(set)begin
                dout<=din;
            end
        end
    end
endmodule

