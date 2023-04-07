`timescale 1ns / 1ps
module register_file_testbench();
reg clk;
reg [4:0] ra0;
wire [31:0] rd0;
reg [4:0] ra1;
wire [31:0] rd1;
reg [4:0] wa;
reg we;
reg [31:0] wd;
register_file register_file(clk,ra0,rd0,ra1,rd1,wa,we,wd);
initial begin
    clk=0;
    wa=0;
    we=1;
    wd=1;
    ra0=0;
    ra1=0;
    # 1600 we=0;
end
always #5 clk=~clk;
always #50 wa=wa+1;
always #50 wd=wd+2;
initial begin
    #1600 ra1=5'd15;
    #100 ra0=5'd31;
    ra1=5'd7;
end
endmodule
