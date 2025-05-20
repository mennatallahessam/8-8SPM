`timescale 1ns / 1ps

module topModule(
    input clk, rst, BTNL, BTNR, BTNC,
    input [7:0] X, Y,
    output [6:0] seg,
    output [3:0] an,
    output finish, start_multiplication
    );
   
//   wire finish;
   wire [15:0] spm_out;
   wire clk_button;
   wire reset_button;
   wire start;
   wire fin;
   
   clock_divider #(25000) button_divider(.clk(clk), .rst(rst), .clk_out(clk_button));
   pushButton_detector btnc(.clk(clk_button), .rst(rst), .x(BTNC), .z(start));
   pushButton_detector btn_reset(.clk(clk_button), .rst(rst), .x(rst), .z(reset_button));
   
   SPM spm(.out(spm_out), .finish(fin), .reset(reset_button), .clk(clk), .A(X), .B(Y), .en(start));
   ScrollController(.clk(clk), .leftBtn(BTNL), .rightBtn(BTNR), .rst(reset_button), .seg(seg), .an(an), .product(spm_out), .en(fin));
   
    assign start_multiplication = start;
    assign finish = fin;
    
endmodule