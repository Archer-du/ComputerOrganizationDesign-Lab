`timescale 1ns / 1ps
module LCU(
    input enq,deq,          //外部接口------------
    input [3:0] in,
    output full,emp,
    output reg [3:0] out,
    output reg [7:0] valid, //SDU接口
    input clk, rst,         //基本信号
    output reg [2:0] ra,
    input [3:0] rd,
    output reg [2:0] wa,
    output reg [3:0] wd
    );
    // reg [2:0] ra;
    // wire [3:0] wd;
    // reg [2:0] wa;
    // wire [3:0] rd;
    // register_file #(.WIDTH(4),.REGNUM(8)) 
    // RF(
    //     .clk(clk),
    //     .ra0(ra),
    //     .rd0(rd),
    //     .wa(wa),
    //     .we(1),
    //     .wd(wd)
    // );
    wire pulse_en,pulse_de;
    reg r1_en=0,r2_en=0;
    always@(posedge clk)
    r1<=enq;
    always@(posedge clk)
    r2<=r1;
    assign pulse_en=r1&(~r2);
    reg r1_de=0,r2_de=0;
    always@(posedge clk)
    r1<=deq;
    always@(posedge clk)
    r2<=r1;
    assign pulse_de=r1&(~r2);
    //构造单周期脉冲
    reg [2:0] RP=0,WP=0;
    assign full=((WP+1)==RP);
    assign emp=(WP==RP);
    always@(posedge clk)begin
        if(rst)begin
            valid[7:0]=8'b1;    //reg0硬连线const0
            RP=0;
            WP=0;
        end
        else begin
            if(pulse_en)begin
                if(!full)begin
                    wa<=WP;
                    wd<=in;
                    valid[WP]<=1;
                    WP<=WP+1;
                end
            end
            if(pulse_de)begin
                if(!emp)begin
                    ra=RP;
                    out<=rd;//test
                    valid[RP]<=0;
                    RP<=RP+1;
                end
            end
        end
    end
endmodule
