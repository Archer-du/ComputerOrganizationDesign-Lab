module Branch(
    input [31:0] op1, op2,
    input [1:0] br_type,

    output br
);
    localparam NONE_BR = 2'b00;
    localparam BEQ = 2'b01;
    localparam BLT = 2'b10;
    
    always@(*) begin
        case(br_type)
            NONE_BR: br = 0;
            BEQ: begin
                if(op1 == op2)
                    br = 1;
            end
            BLT: begin
                if(op1 < op2)//TODO:
                    br = 1;
            end
            default: br = 0;
        endcase
    end
endmodule
