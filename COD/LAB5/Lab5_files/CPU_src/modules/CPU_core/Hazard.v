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

    //for simulation
    initial begin
        rf_rd0_fd <= 0;
        rf_rd1_fd <= 0;
        stall_if <= 0;
        stall_id <= 0;
        stall_ex <= 0;
        flush_id <= 0;
        flush_ex <= 0;
        flush_mem <= 0;
    end
    
    wire data_hzd_mem;
    wire data_hzd_wb;

    always@(*) begin
        //Data Hazard
        //forwarding
        if(data_hzd_wb) begin
            stall_if = 0;
            stall_id = 0;
            stall_ex = 0;
            flush_mem = 0;
            if(rf_wa_wb == rf_ra0_ex) begin
                rf_rd0_fd = rf_wd_wb;
            end
            if(rf_wa_wb == rf_ra1_ex) begin
                rf_rd1_fd = rf_wd_wb;
            end
        end
        if(data_hzd_mem) begin
            if(rf_wa_mem == rf_ra0_ex) begin
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
            if(rf_wa_mem == rf_ra1_ex) begin
                case(rf_wd_sel_mem)
                    ALU_RES:    rf_rd1_fd = alu_ans_mem;
                    PC_ADD4:    rf_rd1_fd = pc_add4_mem;
                    IMM:        rf_rd1_fd = imm_mem;
                    //src: MEM -- bubbling
                    MEM_RD: begin
                        stall_if = 1;
                        stall_id = 1;
                        stall_ex = 1;
                        flush_mem = 1;
                    end
                endcase
            end
        end
        //note that RF has a write first feature
        
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

    assign data_hzd_mem = rf_we_mem && rf_wa_mem != 0 && ((rf_re0_ex && rf_wa_mem == rf_ra0_ex) || (rf_re1_ex && rf_wa_mem == rf_ra1_ex));
    assign data_hzd_wb = rf_we_wb && rf_wa_wb != 0 && ((rf_re0_ex && rf_wa_wb == rf_ra0_ex) || (rf_re1_ex && rf_wa_wb == rf_ra1_ex));
    assign rf_rd0_fe = (rf_wa_mem != 0 || rf_wa_wb != 0) && rf_re0_ex && ((rf_we_mem && rf_wa_mem == rf_ra0_ex) || (rf_we_wb && rf_wa_wb == rf_ra0_ex));
    assign rf_rd1_fe = (rf_wa_mem != 0 || rf_wa_wb != 0) && rf_re1_ex && ((rf_we_mem && rf_wa_mem == rf_ra1_ex) || (rf_we_wb && rf_wa_wb == rf_ra1_ex));
    
endmodule