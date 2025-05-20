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
   wire sign; //1 if negative 0 if positive
   
   clock_divider #(25000) button_divider(.clk(clk), .rst(rst), .clk_out(clk_button));
   pushButton_detector btnc(.clk(clk_button), .rst(rst), .x(BTNC), .z(start));
   pushButton_detector btn_reset(.clk(clk_button), .rst(rst), .x(rst), .z(reset_button));
   
   // if x is negative -> 2s complement..
   reg [7:0] actual_x, actual_y;
   
   assign sign = X[7] ^ Y[7];
   
   always @(posedge clk or posedge reset_button) begin
       if (reset_button) begin
            actual_x <= 0;
            actual_y <= 0;
       end else begin
       if (start) begin
           if (X[7] == 1)
               actual_x <= ~X + 1;
           else
               actual_x <= X;
           
           if (Y[7] == 1)
               actual_y <= ~Y + 1;
           else
               actual_y <= Y;
       end
       end
   end
   
   SPM spm(.out(spm_out), .finish(fin), .reset(reset_button), .clk(clk), .A(actual_x), .B(actual_y), .en(start));
   ScrollController scroll(.clk(clk), .leftBtn(BTNL), .rightBtn(BTNR), .rst(reset_button), .seg(seg), .an(an), .product(spm_out), .en(fin), .sign(sign));
   
    assign start_multiplication = start;
    assign finish = fin;
    
endmodule