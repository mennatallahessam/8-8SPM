`timescale 1ns / 1ps

module ComaparativeAdder(
    input [3:0] in,
    output [3:0] out
    );
    
    wire [3:0] Adder_out;
    wire comparator_out;
    
    Adder4Bit adder(.in(in), .out(Adder_out));
    
    

endmodule
