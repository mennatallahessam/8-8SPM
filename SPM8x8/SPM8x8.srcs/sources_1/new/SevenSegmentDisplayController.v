`timescale 1ns / 1ps

module SevenSegmentDisplayController (
    input wire clk,
    input wire rst,
    input wire [1:0] windowStart,        // Controls 3-digit scroll window
    input wire [15:0] binary_in,         // Binary number to display
    output wire [6:0] seg,               // Segment output
    output reg [3:0] an                  // Active-low anode
);


    wire [3:0] bcd_ones, bcd_tens, bcd_hundreds, bcd_thousands, bcd_ten_thousands;


    DoubleDabble bcd_converter (
        .binary_in(binary_in),
        .bcd_ones(bcd_ones),
        .bcd_tens(bcd_tens),
        .bcd_hundreds(bcd_hundreds),
        .bcd_thousands(bcd_thousands),
        .bcd_ten_thousands(bcd_ten_thousands)
    );


    reg [19:0] refresh_counter = 0;
    wire [1:0] digit_selector = refresh_counter[19:18];

    always @(posedge clk or posedge rst) begin
        if (rst)
            refresh_counter <= 0;
        else
            refresh_counter <= refresh_counter + 1;
    end


    reg [3:0] digit_data;
    
    always @(*) begin
        case (digit_selector)
            2'd0: begin
                an = 4'b1110;
                case (windowStart)
                    2'd0: digit_data = bcd_ten_thousands;
                    2'd1: digit_data = bcd_thousands;
                    2'd2: digit_data = bcd_hundreds;
                    default: digit_data = 4'd0;
                endcase
            end
            2'd1: begin
                an = 4'b1101;
                case (windowStart)
                    2'd0: digit_data = bcd_thousands;
                    2'd1: digit_data = bcd_hundreds;
                    2'd2: digit_data = bcd_tens;
                    default: digit_data = 4'd0;
                endcase
            end
            2'd2: begin
                an = 4'b1011;
                case (windowStart)
                    2'd0: digit_data = bcd_hundreds;
                    2'd1: digit_data = bcd_tens;
                    2'd2: digit_data = bcd_ones;
                    default: digit_data = 4'd0;
                endcase
            end
            2'd3: begin
                an = 4'b0111;     
                digit_data = 4'd0;
            end
        endcase
    end

    SevenSegDriver one_digit_display (
        .BCD(digit_data),
        .seg(seg)
    );

endmodule
