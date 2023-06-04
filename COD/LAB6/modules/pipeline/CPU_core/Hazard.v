module Hazard(
    input [4:0] rf_ra0_ex,
    input [4:0] rf_ra1_ex,
    input rf_re0_ex,
    input rf_re1_ex,
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

    output rf_rd0_fe,
    output rf_rd1_fe,
    output reg [31:0] rf_rd0_fd,
    output reg [31:0] rf_rd1_fd,

    output stall_if,
    output stall_id,
    output stall_ex,

    output flush_id,
    output flush_ex,
    output flush_mem //
);

    localparam ALU_RES = 2'b00;
    localparam PC_ADD4 = 2'b01;
    localparam MEM_RD = 2'b10;
    localparam IMM = 2'b11;
    
    wire data_hzd_mem;

    always@(*) begin
        //Data Hazard
        //forwarding
        if(rf_we_mem || rf_we_wb) begin
            if(rf_wa_wb != 0) begin
                rf_rd0_fd = (rf_re0_ex && rf_wa_wb == rf_ra0_ex)? rf_wd_wb: 0;
                rf_rd1_fd = (rf_re1_ex && rf_wa_wb == rf_ra1_ex)? rf_wd_wb: 0;
                end
            //override
            if(rf_wa_mem != 0) begin
                case(rf_wd_sel_mem)
                    ALU_RES: begin
                        rf_rd0_fd = (rf_re0_ex && rf_wa_mem == rf_ra0_ex)? alu_ans_mem: rf_wd_wb;
                        rf_rd1_fd = (rf_re1_ex && rf_wa_mem == rf_ra1_ex)? alu_ans_mem: rf_wd_wb;
                    end
                    PC_ADD4: begin
                        rf_rd0_fd = (rf_re0_ex && rf_wa_mem == rf_ra0_ex)? pc_add4_mem: rf_wd_wb;
                        rf_rd1_fd = (rf_re1_ex && rf_wa_mem == rf_ra1_ex)? pc_add4_mem: rf_wd_wb;
                    end
                    IMM: begin
                        rf_rd0_fd = (rf_re0_ex && rf_wa_mem == rf_ra0_ex)? imm_mem: rf_wd_wb;
                        rf_rd1_fd = (rf_re1_ex && rf_wa_mem == rf_ra1_ex)? imm_mem: rf_wd_wb;
                    end
                endcase
            end
        end
        else begin
            rf_rd0_fd = 0;
            rf_rd1_fd = 0;
        end
        //note that RF has a write first feature
    end
    
    //forwarding enable
    assign rf_rd0_fe = rf_re0_ex && ((rf_we_mem && rf_wa_mem != 0 && rf_wa_mem == rf_ra0_ex) || (rf_we_wb && rf_wa_wb != 0 && rf_wa_wb == rf_ra0_ex));
    assign rf_rd1_fe = rf_re1_ex && ((rf_we_mem && rf_wa_mem != 0 && rf_wa_mem == rf_ra1_ex) || (rf_we_wb && rf_wa_wb != 0 && rf_wa_wb == rf_ra1_ex));
    
    //Data Hazard: bubbling
    assign data_hzd_mem = rf_we_mem && rf_wa_mem != 0 && ((rf_re0_ex && rf_wa_mem == rf_ra0_ex) || (rf_re1_ex && rf_wa_mem == rf_ra1_ex));
    assign stall_if = (data_hzd_mem && rf_wd_sel_mem == MEM_RD);
    assign stall_id = (data_hzd_mem && rf_wd_sel_mem == MEM_RD);
    assign stall_ex = (data_hzd_mem && rf_wd_sel_mem == MEM_RD);
    assign flush_mem = (data_hzd_mem && rf_wd_sel_mem == MEM_RD);

    //Control Hazard
    assign flush_id = (jal_ex || br_ex || jalr_ex);
    assign flush_ex = (jal_ex || br_ex || jalr_ex);
endmodule