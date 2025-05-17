`timescale 1ns / 1ps


module TwosComplement(
    input A, R, clk,
    output S
    );
    
    wire Z; 
    
    DFF dff1(.clk(clk), .d(A^Z), .rst(R), .q(S));
    DFF dff2(.clk(clk), .d(A|Z), .rst(R), .q(Z));
    
    
endmodule
