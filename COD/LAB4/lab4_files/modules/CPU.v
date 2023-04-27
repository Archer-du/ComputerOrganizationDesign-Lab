`timescale 1ns / 1ps


module CPU(
    input clk, 
    input rst,

    // MEM And MMIO Data BUS
    output [31:0] im_addr,
    input [31:0] im_dout,
    output [31:0] mem_addr,
    output  mem_we,		            
    output [31:0] mem_din,
    input [31:0] mem_dout,	        

    // Debug BUS with PDU
    output [31:0] current_pc, 	            // Current_pc
    output [31:0] next_pc,
    input [31:0] cpu_check_addr,	        // Check current datapath state (code)
    output reg [31:0] cpu_check_data      // Current datapath state data

);
    // Write your CPU here!
    wire [31:0] pc_next, pc_cur;
    wire [31:0] pc_add4;
    wire [31:0] pc_jalr;
    wire [1:0] br_type;
    wire br;
    wire jal, jalr;
    wire [31:0] inst;
    wire wb_en;
    wire [1:0] wb_sel;
    wire alu_op1_sel, alu_op2_sel;
    wire [3:0] alu_ctrl;
    wire mem_we;
    wire [31:0] alu_op1, alu_op2;
    wire [31:0] alu_res;
    wire [31:0] rd0, rd1, rd_dbg;
    wire [31:0] wb_data;
    wire [31:0] imm;

    CTRL signals_controller(
        .inst(inst),
        .jal(jal),
        .jalr(jalr),
        .br_type(br_type),
        .wb_en(wb_en),
        .wb_sel(wb_sel),
        .alu_op1_sel(alu_op1_sel),
        .alu_op2_sel(alu_op2_sel),
        .alu_ctrl(alu_ctrl),
        .mem_we(mem_we)
    );

    PC Program_Counter(
        .rst(rst),
        .clk(clk),
        .pc_next(pc_next),
        .pc_cur(pc_cur)
    );

    RF regfile(
        .clk(clk),
        .we(wb_en),

        .ra0(inst[19:15]),
        .ra1(inst[24:20]),
        .wa(inst[11:7]),
        .wd(wb_data),
        
        .rd0(rd0),
        .rd1(rd1),

        .ra_dbg(cpu_check_addr[4:0]),
        .rd_dbg(rd_dbg)
    );

    ALU ALU(
        .alu_op1(alu_op1),
        .alu_op2(alu_op2),
        .alu_ctrl(alu_ctrl),
        .alu_res(alu_res)
    );
    
    IMM IMM(
        .inst(inst),
        .imm(imm)
    );

    ADDER_PC PC_adder(
        .lhs(32'd4),
        .rhs(pc_cur),
        .res(pc_add4)
    );
    
    MUX_ALU ALU_MUX1(
        .sel(alu_op1_sel),
        .src0(rd0),
        .src1(pc_cur),
        .res(alu_op1)
    );

    MUX_ALU ALU_MUX2(
        .sel(alu_op2_sel),
        .src0(rd1),
        .src1(imm),
        .res(alu_op2)
    );

    MUX_RFwrite RF_writeback_MUX(
        .sel(wb_sel),
        .alu_res(alu_res),
        .pc_add4(pc_add4),
        .mem_rd(mem_rd),
        .imm(imm),
        .wb_data(wb_data)
    );

    Branch Branch_signals(
        .br_type(br_type),
        .op1(rd0),
        .op2(rd1),
        .br(br)
    );

    AND_jalr jalr_ANDgate(
        .lhs(32'hFFFFFFFE),
        .rhs(alu_res),
        .res(pc_jalr)
    );

    MUX_PC PC_MUX(
        .jal(jal),
        .jalr(jalr),
        .br(br),
        .pc_add4(pc_add4),
        .pc_jal_br(alu_res),
        .pc_jalr(pc_jalr),
        .pc_next(pc_next)
    );

    assign im_addr = pc_cur;
    assign inst = im_dout;

endmodule