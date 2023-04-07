`timescale 1ns / 1ps
module LCU(
    input clk, rst,         //基本信号
    input enq,deq,          //外部接口------------
    input [3:0] in,
    output reg full,emp,
    output [2:0] p,
    output [3:0] out,
    output reg [7:0] valid, //SDU接口
    output reg [2:0] ra,
    input [3:0] rd,
    output reg [2:0] wa,
    output reg [3:0] wd
    );
    wire pulse_en,pulse_de;
    reg r1_en=0,r2_en=0;
    always@(posedge clk)
    r1_en<=enq;
    always@(posedge clk)
    r2_en<=r1_en;
    assign pulse_en=r1_en&(~r2_en);
    reg r1_de=0,r2_de=0;
    always@(posedge clk)
    r1_de<=deq;
    always@(posedge clk)
    r2_de<=r1_de;
    assign pulse_de=r1_de&(~r2_de);
    //构造单周期脉冲
    reg [2:0] RP=0,WP=0;
    assign p=RP;
    assign out=rd;
    always@(posedge clk)begin
        if(rst)begin
            valid[7:0]=8'b0;    //reg0硬连线const0
            RP=0;
            WP=0;
            full=0;
            emp=1;
        end
        else begin
            if(pulse_en)begin
                if(!full)begin
                    wa<=WP;
                    wd<=in;
                    valid[WP]<=1;
                    WP=WP+1;
                    full<=(WP==RP);
                    emp<=0;
                end
            end
            if(pulse_de)begin
                if(!emp)begin
                    ra=RP;
                    valid[RP]<=0;
                    RP=RP+1;
                    emp<=(RP==WP);
                    full<=0;
                end
            end
        end
    end
endmodule
