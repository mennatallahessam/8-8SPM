`timescale 1ns / 1ps

module ScrollController (
    input clk, leftBtn, rightBtn, rst,
    output [6:0] seg,
    output [3:0] an,
    output btn_led_left, btn_led_right, clk_display,
    output [1:0] seg_sel_debug
    );
    
    //ADD 16 BIT PRODUCT TO PARAMETERS!!! AND THEN CHECK FOR SIGN IN SWITCH CASE 

    wire leftBtn_out, rightBtn_out;
    wire [3:0] bcd_ones, bcd_tens, bcd_hundreds, bcd_thousands, bcd_ten_thousands;
//    wire clk_out;
    wire clk_buttons;
    reg [3:0] first, second, third;
    wire [1:0] segmentSelector;
    reg [3:0] current_num;
    wire clk_display_internal;
    
    assign clk_display = clk_display_internal;
    
    reg [1:0] start_from; 
    // 0 -> ten_thousands, thousands, hundreds
    // 1 -> thousands, hundreds, tens
    // 2 -> hundreds, tens, ones
    
    assign btn_led_left = leftBtn_out;
    assign btn_led_right = rightBtn_out;
    
    assign first_led = first, second_led = second, third_led = third;
    
//    clock_divider #(25000) divider(.clk(clk), .rst(rst), .clk_out(clk_out));
    clock_divider #(25000) divider_buttons (.clk(clk), .rst(rst), .clk_out(clk_buttons));
//    clock_divider #(20000) divider_display (.clk(clk), .rst(rst), .clk_out(clk_display));
    clock_divider #(20000) divider_display (.clk(clk), .rst(rst), .clk_out(clk_display_internal));


    pushButton_detector btnl(.clk(clk_buttons), .rst(rst), .x(leftBtn), .z(leftBtn_out));
    pushButton_detector btnr(.clk(clk_buttons), .rst(rst), .x(rightBtn), .z(rightBtn_out));
    
    DoubleDabble BCD (.binary_in(16'd23456), .bcd_ones(bcd_ones), .bcd_tens(bcd_tens),.bcd_hundreds(bcd_hundreds), .bcd_thousands(bcd_thousands), .bcd_ten_thousands(bcd_ten_thousands));
    
    
    always @ (posedge clk or negedge rst) begin
        if (rst)
            start_from <= 0;
        else begin
            if (leftBtn_out && start_from > 0)
                start_from <= start_from - 1;
            else if (rightBtn_out && start_from < 2)
                start_from <= start_from + 1;
        end
    end
    

   always @(*) begin
    case (start_from)
        0: begin
            first = bcd_ten_thousands;
            second = bcd_thousands;
            third = bcd_hundreds;
        end
        1: begin
            first = bcd_thousands;
            second = bcd_hundreds;
            third = bcd_tens;
        end
        2: begin
            first = bcd_hundreds;
            second = bcd_tens;
            third = bcd_ones;
        end
        default: begin
            first = 4'd0;
            second = 4'd0;
            third = 4'd0;
        end
    endcase
    end
   
   SevenSegmentDisplayController sevenseg(.clk(clk_display_internal), .first(first), .second(second), .third(third), .digit(segmentSelector), .seg(seg), .an(an));

   counter_x_bit #(2,4) counter(.clk(clk_display_internal), .reset(rst), .en(1'b1), .count(segmentSelector));

   assign seg_sel_debug = segmentSelector;

endmodule


