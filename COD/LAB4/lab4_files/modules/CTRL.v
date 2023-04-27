module CTRL(
    input [31:0] inst,

    output jal, jalr,
    output [1:0] br_type,
    output wb_en,
    output [1:0] wb_sel,
    output alu_op1_sel, alu_op2_sel,
    output [3:0] alu_ctrl,
    //output [2:0] imm_type,
    output mem_we
);
    //inst type signals
    localparam R_type = 7'b0110011;
    localparam I_type = 7'b0010011;
    localparam S_type = 7'b0100011;
    localparam B_type = 7'b1100011;
    localparam class_load = 7'b0000011;
    localparam U_type_auipc = 7'b0010111;
    localparam U_type_lui = 7'b0110111;
    localparam J_type = 7'b1101111;

    //regfile write back signals
    localparam ALU_RES = 2'b00;
    localparam PC_ADD4 = 2'b01;
    localparam MEM_RD = 2'b10;
    localparam IMM = 2'b11;

    //ALU MUXs signals
    localparam RD0 = 1'b0;
    localparam PC_CUR = 1'b1;
    localparam RD1 = 1'b0;
    localparam IMMGEN = 1'b1;

    //branch signals
    localparam NONE_BR = 2'b00;
    localparam BEQ = 2'b01;
    localparam BLT = 2'b10;

    always@(*) begin
        case(inst[6:0])
            R_type: begin
                jal = 0;
                jalr = 0;
                br_type = NONE_BR;
                wb_en = 1;
                wb_sel = ALU_RES;
                alu_op1_sel = RD0;
                alu_op2_sel = RD1;
                alu_ctrl = 4'b0000;//TODO:
                mem_we = 0;
            end
            I_type: begin
                jal = 0;
                jalr = 0;
                br_type = NONE_BR;
                wb_en = 1;
                wb_sel = ALU_RES;
                alu_op1_sel = RD0;
                alu_op2_sel = IMMGEN;
                alu_ctrl = 4'b0000;
                mem_we = 0;
            end
            S_type: begin
                jal = 0;
                jalr = 0;
                br_type = NONE_BR;
                wb_en = 0;
                //wb_sel
                alu_op1_sel = RD0;
                alu_op2_sel = IMMGEN;
                alu_ctrl = 4'b0000;
                mem_we = 1;
            end
            B_type: begin
                jal = 0;
                jalr = 0;
                br_type = NONE_BR;//TODO:
                wb_en = 0;
                //wb_sel
                alu_op1_sel = RD0;
                alu_op2_sel = IMMGEN;
                alu_ctrl = 4'b0000;
                mem_we = 1;
            end
            class_load: begin
                jal = 0;
                jalr = 0;
                br_type = NONE_BR;
                wb_en = 1;
                wb_sel = MEM_RD;
                alu_op1_sel = RD0;
                alu_op2_sel = IMMGEN;
                alu_ctrl = 4'b0000;
                mem_we = 0;
            end
            U_type_auipc: begin
                jal = 0;
                jalr = 0;
                br_type = NONE_BR;
                wb_en = 1;
                wb_sel = ALU_RES;
                alu_op1_sel = PC_CUR;
                alu_op2_sel = IMMGEN;
                alu_ctrl = 4'b0000;
                mem_we = 0;
            end
            U_type_lui: begin
                jal = 0;
                jalr = 0;
                br_type = NONE_BR;
                wb_en = 1;
                wb_sel = ALU_RES;
                alu_op1_sel = RD0;//TODO:
                alu_op2_sel = IMMGEN;
                alu_ctrl = 4'b0000;
                mem_we = 0;
            end
            J_type: begin
                jal = 1;
                jalr = 0;
                br_type = NONE_BR;
                wb_en = 1;
                wb_sel = PC_ADD4;
                alu_op1_sel = PC_CUR;
                alu_op2_sel = IMMGEN;
                alu_ctrl = 4'b0000;
                mem_we = 0;
            end
        endcase
    end
endmodule