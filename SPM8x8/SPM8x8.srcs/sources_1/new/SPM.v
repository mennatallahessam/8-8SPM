`timescale 1ns / 1ps

module SPM(
    input Y,
    input [7:0] X,
    input reset, clk, control, en,
    output serial_out
    );

    wire [7:1] PP;

   
    TwosComplement TCMP(.A(Y & X[7]), .R(reset), .clk(clk), .en(en), .S(PP[7]));
    
    CarrySaveAdder CSA6(.X(Y & X[6]), .Y(PP[7]), .R(reset), .clk(clk), .en(en), .sum(PP[6]));
    
    CarrySaveAdder CSA5(.X(Y & X[5]), .Y(PP[6]), .R(reset), .clk(clk), .en(en), .sum(PP[5]));
    
    CarrySaveAdder CSA4(.X(Y & X[4]), .Y(PP[5]), .R(reset), .clk(clk), .en(en), .sum(PP[4]));
    
    CarrySaveAdder CSA3(.X(Y & X[3]), .Y(PP[4]), .R(reset), .clk(clk), .en(en), .sum(PP[3]));
    
    CarrySaveAdder CSA2(.X(Y & X[2]), .Y(PP[3]), .R(reset), .clk(clk), .en(en), .sum(PP[2]));
    
    CarrySaveAdder CSA1(.X(Y & X[1]), .Y(PP[2]), .R(reset), .clk(clk), .en(en), .sum(PP[1]));
    
    CarrySaveAdder CSA0(.X(Y & X[0]), .Y(PP[1]), .R(reset), .clk(clk), .en(en), .sum(serial_out));
    
endmodule
