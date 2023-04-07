`timescale 1ns / 1ps
module BRAM_testbench();
    reg clka;
    reg wea;
    reg [3:0] addra;
    reg [7:0] dina;
    wire [7:0] douta;
    wire [7:0] douta_R;
    wire [7:0] douta_N;
    BRAM BRAM (
    .clka(clka),    // input wire clka
    .wea(wea),      // input wire [0 : 0] wea
    .addra(addra),  // input wire [3 : 0] addra
    .dina(dina),    // input wire [7 : 0] dina
    .douta(douta)  // output wire [7 : 0] douta
    );
    BRAM_R BRAM_R (
    .clka(clka),    // input wire clka
    .wea(wea),      // input wire [0 : 0] wea
    .addra(addra),  // input wire [3 : 0] addra
    .dina(dina),    // input wire [7 : 0] dina
    .douta(douta_R)  // output wire [7 : 0] douta
    );
    BRAM_N BRAM_N (
    .clka(clka),    // input wire clka
    .wea(wea),      // input wire [0 : 0] wea
    .addra(addra),  // input wire [3 : 0] addra
    .dina(dina),    // input wire [7 : 0] dina
    .douta(douta_N)  // output wire [7 : 0] douta
    );
    initial begin
        clka=0;
        addra=0;
        dina=0;
        wea=0;
        #67 wea=1;
        #867 wea=0;
    end
    always #5 clka=~clka;
    always #50 addra=addra+1;
    always #50 dina=dina+2;
endmodule
