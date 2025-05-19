`timescale 1ns / 1ps

/*
module TwosComplement(a,s,clk,rst,start);

input a;
input clk;
input rst;
input start;
output reg s;
reg z;

//wire T=a|z;
always @ ( posedge clk or negedge rst )begin
if  (!rst)begin 
    s <= 1'b0;
    z <= 1'b0;
end else begin
    s <= a^z;
    //z <= T;
    z <= a|z;
end 
end
endmodule
*/
module TwosComplement(
    input A, R, clk, en,
   // input wire X,   
   output wire S
   );
    
    
    wire Z; 
  // assign S = ~ X +1'b1;
  
  wire in0, in1; 
    
    assign in0 = A^Z; 
    assign in1 = A|Z; 
    DFF dff1(.clk(clk), .d(in0), .rst(R), .en(en), .q(S));
    DFF dff2(.clk(clk), .d(in1), .rst(R), .en(en), .q(Z));
    
    endmodule 
    
   
    
