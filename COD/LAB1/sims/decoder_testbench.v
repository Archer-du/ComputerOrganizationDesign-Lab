`timescale 1ns / 1ps
module decoder_testbench();
reg [1:0] sel;
reg en;
wire ena,enb,enf;
decoder test(.sel(sel),.en(en),.ena(ena),.enb(enb),.enf(enf));
initial begin
    sel=2'b0;
    en=0;
    #200 en=~en;
end
always #20 sel=sel+1;
endmodule
