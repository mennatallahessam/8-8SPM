module Adder4Bit(
    input [3:0] A, B,
    input cin,
    output [3:0] sum, 
    output cout
    );

    wire [3:0] carry;

    FullAdder FA0 (.A(A[0]), .B(B[0]), .cin(cin), .sum(sum[0]), .cout(carry[0]));
    FullAdder FA1 (.A(A[1]), .B(B[1]), .cin(carry[0]), .sum(sum[1]), .cout(carry[1]));
    FullAdder FA2 (.A(A[2]), .B(B[2]), .cin(carry[1]), .sum(sum[2]), .cout(carry[2]));
    FullAdder FA3 (.A(A[3]), .B(B[3]), .cin(carry[2]), .sum(sum[3]), .cout(cout));

endmodule