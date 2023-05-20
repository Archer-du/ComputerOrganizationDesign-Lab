`timescale 1ns / 1ps
/* 
 *   Author: wintermelon
 *   Last update: 2023.05.03
 */

// This is a simple 4-1 Mux.
/* Ports
    Mux4 #(32) my_mux (
        .sr1(),
        .sr2(),
        .sr3(),
        .sr4(),
        .ctrl(),

        .out()
    );
*/

module MUX4 #(WIDTH = 32) (
    input [WIDTH-1: 0]          sr1,
    input [WIDTH-1: 0]          sr2,
    input [WIDTH-1: 0]          sr3,
    input [WIDTH-1: 0]          sr4,
    input [1:0]                 ctrl,

    output reg [WIDTH-1: 0]     out
);  

    always @(*) begin
        case (ctrl)
            2'b00: out = sr1;
            2'b01: out = sr2;
            2'b10: out = sr3;
            2'b11: out = sr4;
        endcase // We don't need default here
    end

endmodule