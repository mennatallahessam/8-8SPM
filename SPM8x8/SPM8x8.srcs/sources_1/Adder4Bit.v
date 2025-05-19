module Adder4Bit(
    input [3:0] in,
    output [3:0] out
    );
    
    wire [5:1] ands;
    wire [8:1] xors;
    
    
    assign ands[1] = in[0] & 1;
    assign ands[2] = in[1] & 1;
    assign ands[3] = in[2] & 0;
    assign ands[4] = ands[1] & xors[1];
    assign ands[5] = xors[2] & xors[5];
    
    assign xors[1] = in[1] ^ 1;
    assign xors[2] = in[2] ^ 0;
    assign xors[3] = in[3] ^ 0;
    assign xors[4] = ands[1] ^ xors[1];
    assign xors[5] = ands[4] ^ ands[2]; 
    assign xors[6] = xors[5] ^ xors[2];
    assign xors[7] = ands[5] ^ ands[3];
    assign xors[8] = xors[7] ^ xors[3];
   
    assign out[0] = 1 ^ in[0];
    assign out[1] = xors[4];
    assign out[2] = xors[6];
    assign out[3] = xors[8];
    

//    input [3:0] A, B,
//    input cin,
//    output [3:0] sum, 
//    output cout
//    );

//    wire [3:0] carry;

//    FullAdder FA0 (.A(A[0]), .B(B[0]), .cin(cin), .sum(sum[0]), .cout(carry[0]));
//    FullAdder FA1 (.A(A[1]), .B(B[1]), .cin(carry[0]), .sum(sum[1]), .cout(carry[1]));
//    FullAdder FA2 (.A(A[2]), .B(B[2]), .cin(carry[1]), .sum(sum[2]), .cout(carry[2]));
//    FullAdder FA3 (.A(A[3]), .B(B[3]), .cin(carry[2]), .sum(sum[3]), .cout(cout));

endmodule