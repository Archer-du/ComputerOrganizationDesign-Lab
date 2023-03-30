module FLS
    (
        input clk,rst,
        input en,
        input [6:0] d,
        output [6:0] f
    );
    //reg en_0=1'b1,en_1=1'b1;
    reg [1:0] cs=2'b00,ns;//  state=={en_0,en_1}
    reg [6:0] f_0,f_1,F;
    //初始化
    reg r1=0,r2=0;
    wire pulse;
    always@(posedge clk)
    r1<=en;
    always@(posedge clk)
    r2<=r1;
    assign pulse=r1&(~r2);
    //双寄存器构造单周期脉冲
    // --------------------------------------------
    always@(posedge clk)
    begin
        if(rst)
        begin
            f_0=0;
            f_1=0;
            cs=2'b00;
        end
        else if(pulse)
        begin
            cs<=ns;
            case(ns)
            2'b10:f_0<=d;
            2'b01:f_1<=d;
            2'b11:
            begin
                F=f_0+f_1;
                f_0<=f_1;
                f_1<=F;
            end
            endcase
        end
    end
    // --------------------------------------------
    always@(*)
    begin
        case(cs)
        2'b00:ns=2'b10;
        2'b10:ns=2'b01;
        2'b01:ns=2'b11;
        2'b11:ns=2'b11;
        endcase
    end
    // --------------------------------------------
    assign f=(cs==2'b11)?F:((cs==2'b10)?f_0:((cs==2'b01)?f_1:7'b0));
endmodule
