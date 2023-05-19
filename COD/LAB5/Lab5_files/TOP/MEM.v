module MEM(
    input clk,

    // MEM Data BUS with CPU
	// IM port
    input [31:0] im_addr,
    output [31:0] im_dout,
	
	// DM port
    input  [31:0] dm_addr,
    input dm_we,
    input  [31:0] dm_din,
    output [31:0] dm_dout,

    // MEM Debug BUS
    input [31:0] mem_check_addr,
    output [31:0] mem_check_data
);
   
   Inst_MEM IM(
    .im_addr(im_addr),
    .im_dout(im_dout)
   );

   Data_MEM DM(
    .clk(clk),
    .we(dm_we),
    
    .dm_addr(dm_addr),
    .dm_din(dm_din),
    .dm_dout(dm_dout),

    .mem_check_addr(mem_check_addr),
    .mem_check_data(mem_check_data)
   );

endmodule