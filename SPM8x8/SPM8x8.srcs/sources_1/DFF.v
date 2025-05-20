`timescale 1ns / 1ps

//module DFF(
//    input clk, d, rst, en,
//    output reg q
//    );

//    always @ (posedge clk or posedge rst) begin
//        if (rst == 1'b0)
//            q <= 0;
//        else if (en)
//            q <= d;
//    end

////    always @ (posedge clk)
////    q <= d;
////    assign qb =~q;
    
//endmodule

module DFF(
input clk, d,
output reg q
);
//reg q;
always @ (posedge clk)
q <= d;
assign qb =~q;
endmodule
