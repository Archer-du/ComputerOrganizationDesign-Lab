module MEM(
    input clk,

    // MEM Data BUS with CPU
	//指令存储器端口
    input [31:0] im_addr,
    output [31:0] im_dout,
	
	//数据存储器端口
    input  [31:0] dm_addr,
    input dm_we,
    input  [31:0] dm_din,
    output [31:0] dm_dout,

    // MEM Debug BUS
    input [31:0] mem_check_addr,
    output [31:0] mem_check_data
);
   IM Inst_Mem(
    .im_addr(im_addr),
    .im_dout(im_dout)
   );

   DM Data_Mem(
    .dm_addr(dm_addr),
    .dm_we(dm_we),
    .dm_din(dm_din),
    .dm_dout(dm_dout),

    .mem_check_addr(mem_check_addr),
    .mem_check_data(mem_check_data)
   );

endmodule