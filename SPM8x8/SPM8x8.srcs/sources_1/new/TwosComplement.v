`timescale 1ns / 1ps


module TwosComplement(a,s,clk,rst,start);

input a;
input clk;
input rst;
input start;
output reg s;
reg z;

wire T=a|z;
always @ ( posedge clk or negedge rst )begin
if  (!rst)begin 
s <= 1'b0;
z <=1'b0;
end
else begin
s<=a ^z;
z<=T;
end 
end
endmodule

    //input X, R, clk, en,
//    input wire X,
    
//    output wire S
//    );
    
//   // wire Z; 
//   assign S = ~ X +1'b1;
   
    
//   // DFF dff1(.clk(clk), .d(A^Z), .rst(R), .en(en), .q(S));
//    //DFF dff2(.clk(clk), .d(A|Z), .rst(R), .en(en), .q(Z));
    
   
    

