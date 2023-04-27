module DM(
    input clk,
    input we,

    input [31:0] dm_addr,
    input [31:0] dm_din,
    output [31:0] dm_dout,
    
    input [31:0] mem_check_addr,
    output [31:0] mem_check_data
);
DATA_MEM DATA_MEM (
  .a(dm_addr[9:2]),        // input wire [7 : 0] a
  .d(dm_din),        // input wire [31 : 0] d
  .dpra(mem_check_addr[9:2]),  // input wire [7 : 0] dpra
  .clk(clk),    // input wire clk
  .we(we),      // input wire we
  .spo(dm_dout),    // output wire [31 : 0] spo
  .dpo(mem_check_data)    // output wire [31 : 0] dpo
);
endmodule