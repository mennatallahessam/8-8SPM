`timescale 1ns / 1ps


module TwosComplement(
    input A, R, clk, en,
    output S
    );
    
    wire Z; 
    
    DFF dff1(.clk(clk), .d(A^Z), .rst(R), .en(en), .q(S));
    DFF dff2(.clk(clk), .d(A|Z), .rst(R), .en(en), .q(Z));
    
    
endmodule
