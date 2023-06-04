module AND_jalr(
    input [31:0] lhs, rhs,
    output [31:0] res
);
    assign res = lhs & rhs;
endmodule