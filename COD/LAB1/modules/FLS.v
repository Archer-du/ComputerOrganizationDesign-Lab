module FLS
    (
        input clk,rst,
        input en,
        input [6:0] d,
        output [6:0] f
    );
    //初始化
    reg [1:0] cs=2'b00,ns;
    reg [6:0] f_0,f_1;
    wire [6:0] F;
    alu_unit #(7) alu(.a(f_0),.b(f_1),.func(4'b0000),.y(F));
    //双寄存器构造单周期脉冲
    reg r1=0,r2=0;
    wire pulse;
    always@(posedge clk)
    r1<=en;
    always@(posedge clk)
    r2<=r1;
    assign pulse=r1&(~r2);
    // --------------------------------------------
    //状态转换模块
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
            case(cs)
            2'b00:f_0<=d;
            2'b10:f_1<=d;
            2'b11:
            begin
                f_0<=f_1;
                f_1<=F;
            end
            endcase
        end
    end
    // --------------------------------------------
    //状态激励模块
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
    //组合输出模块
    assign f=(cs==2'b11)?F:((cs==2'b10)?f_0:((cs==2'b01)?f_1:7'b0));
    // --------------------------------------------
endmodule
