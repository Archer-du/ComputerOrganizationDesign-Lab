module Hazard(
    input [4:0] rf_ra0_ex,
    input [4:0] rf_ra1_ex,
    //TODO:
    input rf_we_mem,
    input [4:0] rf_wa_mem,
    input [1:0] rf_wd_sel_mem,
    input [31:0] alu_ans_mem,
    input [31:0] pc_add4_mem,
    input [31:0] imm_mem,
    input rf_we_wb,
    input [4:0] rf_wa_wb,
    input [31:0] rf_wd_wb,
    input jal_ex, jalr_ex, br_ex,

    output reg rf_rd0_fe,
    output reg rf_rd1_fe,
    output reg [31:0] rf_rd0_fd,
    output reg [31:0] rf_rd1_fd,

    output reg stall_if,
    output reg stall_id,
    output reg stall_ex,

    output reg flush_id,
    output reg flush_ex,
    output reg flush_mem //
);

    localparam ALU_RES = 2'b00;
    localparam PC_ADD4 = 2'b01;
    localparam MEM_RD = 2'b10;
    localparam IMM = 2'b11;

    always@(*) begin
        if(rf_we_mem && rf_wa_mem != 0) begin
            //Data Harzard: forwarding
            if(rf_wa_mem == rf_ra0_ex) begin
                rf_rd0_fe = 1;
                case(rf_wd_sel_mem)
                    ALU_RES:    rf_rd0_fd = alu_ans_mem;
                    PC_ADD4:    rf_rd0_fd = pc_add4_mem;
                    IMM:        rf_rd0_fd = imm_mem;
                    //src: MEM -- bubbling
                    MEM_RD: begin
                        stall_if = 1;
                        stall_id = 1;
                        stall_ex = 1;
                        flush_mem = 1;
                    end
                endcase
            end
            //not harzard
            else rf_rd0_fe = 0;
            //Data Harzard: forwarding
            if(rf_wa_mem == rf_ra1_ex) begin
                rf_rd1_fe = 1;
                case(rf_wd_sel_mem)
                    ALU_RES:    rf_rd1_fd = alu_ans_mem;
                    PC_ADD4:    rf_rd1_fd = pc_add4_mem;
                    IMM:        rf_rd1_fd = imm_mem;
                    //src = MEM -- bubbling
                    MEM_RD: begin
                        stall_if = 1;
                        stall_id = 1;
                        stall_ex = 1;
                        flush_mem = 1;
                    end
                endcase
            end
            else rf_rd1_fe = 0;
        end
        //note that RF has a write first feature
        if(rf_we_wb && rf_wa_wb != 0) begin
            //Data Harzard: forwarding
            if(rf_wa_wb == rf_ra0_ex) begin
                rf_rd0_fe = 1;
                rf_rd0_fd = rf_wd_wb;
                stall_if = 0;
                stall_id = 0;
                stall_ex = 0;
                flush_mem = 0;
            end
            else rf_rd0_fe = 0;
            //Data Harzard: forwarding
            if(rf_wa_wb == rf_ra1_ex) begin
                rf_rd1_fe = 1;
                rf_rd1_fd = rf_wd_wb;
                stall_if = 0;
                stall_id = 0;
                stall_ex = 0;
                flush_mem = 0;
            end
            else rf_rd1_fe = 0;
        end
        
        //Control Hazard
        if(jal_ex || br_ex || jalr_ex) begin
            flush_id = 1;
            flush_ex = 1;
        end
        else begin
            flush_id = 0;
            flush_ex = 0;
        end
    end

endmodule