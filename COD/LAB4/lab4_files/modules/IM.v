module IM(
    input [31:0] im_addr,
    output [31:0] im_dout
);
INST_MEM your_instance_name (
  .a(im_addr[9:2]),      // input wire [7 : 0] a
  .spo(im_dout)  // output wire [31 : 0] spo
);
endmodule