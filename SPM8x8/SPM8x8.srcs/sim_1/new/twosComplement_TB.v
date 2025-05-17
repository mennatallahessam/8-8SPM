`timescale 1ns / 1ps

module twosComplement_TB();
    reg A, R, clk;
    wire S; 
    
    TwosComplement TCMP(.A(A), .R(R), .clk(clk), .S(S));
    
    initial begin
        clk = 1;
        forever #25 clk=~clk;
    end
    
    
    initial begin
        R = 1;
        #25
        R= 0; 
        A = 0;
        #100
        A = 1;
        
    end
    
endmodule
