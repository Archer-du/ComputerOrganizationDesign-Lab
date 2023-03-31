`timescale 1ns / 1ps
module decoder
    (
        input [1:0] sel,
        input en,
        output reg ena,enb,enf
    );
    always @(*) 
    begin
        if(en)
        begin
            case(sel)
                2'b00:{ena,enb,enf}=3'b100;
                2'b01:{ena,enb,enf}=3'b010;
                2'b10:{ena,enb,enf}=3'b001;
                2'b11:{ena,enb,enf}=3'b000;
            endcase
        end
        else begin
            {ena,enb,enf}=3'b000;
        end
    end
endmodule
