`timescale 1ns / 1ps

module testingScroll (
    input clk,
    input rst,
    input button_l,
    input button_r,
    output [6:0] seg,
    output [3:0] an
);

    reg [1:0] start_from;

    wire clk_out;

    wire button_output_l;
    wire button_output_r;

    clock_divider #(25000) divider (
        .clk(clk),
        .rst(rst),
        .clk_out(clk_out)
    );


    pushButton_detector btn_l (
        .clk(clk_out),
        .rst(rst),
        .x(button_l),
        .z(button_output_l)
    );


    pushButton_detector btn_r (
        .clk(clk_out),
        .rst(rst),
        .x(button_r),
        .z(button_output_r)
    );


    always @(posedge clk_out or posedge rst) begin
        if (rst)
            start_from <= 2'd0;
        else if (button_output_l && start_from > 0)
            start_from <= start_from - 1;
        else if (button_output_r && start_from < 2)
            start_from <= start_from + 1;
    end

    wire [15:0] binary_in = 16'd113;

    SevenSegmentDisplayController display_controller (
        .clk(clk_out),
        .rst(rst),
        .windowStart(start_from),
        .binary_in(binary_in),
        .seg(seg),
        .an(an)
    );

endmodule
