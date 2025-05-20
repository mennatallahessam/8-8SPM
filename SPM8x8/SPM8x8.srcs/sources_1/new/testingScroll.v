`timescale 1ns / 1ps

module testingScroll(
    input clk, input button_l, button_r, rst,
    output reg [6:0] seg,
    output reg [3:0] an
    );
    
    wire button_output_l, button_output_r;
    wire [3:0] bcd_ones, bcd_tens, bcd_hundreds, bcd_thousands, bcd_ten_thousands;
    wire clk_out;
    
    reg [1:0] start_from;
        
   always @(posedge clk_out or negedge rst) begin
        if (!rst)
            start_from <= 0;
        else begin
            if (button_output_l && start_from > 0)
                start_from <= start_from - 1;
            else if (button_output_r && start_from < 2)
                start_from <= start_from + 1;
        end
    end
    
    
    clock_divider #(25000) divider(.clk(clk), .rst(rst), .clk_out(clk_out));
    pushButton_detector btnl(.clk(clk_out), .rst(rst), .x(button_l), .z(button_output_l));
    pushButton_detector btnr(.clk(clk_out), .rst(rst), .x(button_r), .z(button_output_r));
    
    
//    DoubleDabble db(.binary_in(16'b0010100010111001), .bcd_ones(bcd_ones), .bcd_tens(bcd_tens), .bcd_hundreds(bcd_hundreds), .bcd_thousands(bcd_thousands), .bcd_ten_thousands(bcd_ten_thousands));
    
    wire [6:0] seg_wire;
    wire [3:0] an_wire;
    
    SevenSegmentDisplayController sevenseg(.clk(clk), .start_from(start_from), .binary_in(16'd369), .seg(seg_wire), .an(an_wire));
    always @ (*) begin
     seg = seg_wire;
     an = an_wire;
    end
    
    
endmodule