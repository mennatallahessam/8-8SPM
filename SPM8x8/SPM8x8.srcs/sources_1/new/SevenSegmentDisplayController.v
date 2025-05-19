'timescale 1ns / 1ps

module SevenSegmentDisplayController (
    input wire clk, 
    input wire [1:0] start_from,                 // 100 MHz clock
    input wire [15:0] binary_in,     // 16-bit input to convert and display
    output reg [6:0] seg,            // Seven segment outputs (A to G)
    output reg [3:0] an              // Active-low anode outputs
);

    wire [3:0] bcd_ones, bcd_tens, bcd_hundreds, bcd_thousands, bcd_ten_thousands;

    // Instantiate DoubleDabble to convert binary to BCD
    DoubleDabble bcd_inst (
        .binary_in(binary_in),
        .bcd_ones(bcd_ones),
        .bcd_tens(bcd_tens),
        .bcd_hundreds(bcd_hundreds),
        .bcd_thousands(bcd_thousands),
        .bcd_ten_thousands(bcd_ten_thousands)
    );

    reg [19:0] refresh_counter = 0;
    wire [2:0] digit_select;

    // Generate slower refresh clock (~1 kHz for 5 digits)
    always @(posedge clk) begin
        refresh_counter <= refresh_counter + 1;
    end

    assign digit_select = refresh_counter[19:17];  // cycle through 5 digits

    reg [3:0] current_digit;

    reg [3:0] first, second, third;
    
always @(*) begin
        if (start_from == 0) begin
            first = bcd_ten_thousands;
            second = bcd_thousands;
            third = bcd_hundreds;
        end 
        else if (start_from == 1) begin
            first = bcd_thousands;
            second = bcd_hundreds;
            third = bcd_tens;
        end 
        else if (start_from == 2) begin
            first = bcd_hundreds;
            second = bcd_tens;
            third = bcd_ones;
        end
        else begin
            first = 0;
            second = 0;
            third = 0;
        end
    end
     
        
        

always @(*) begin
    case (digit_select)
        3'd0: begin
            current_digit = third;
            an = 4'b1110;  // 4 bits
        end
        3'd1: begin
            current_digit = second;
            an = 4'b1101;  // 4 bits
        end
        3'd2: begin
            current_digit = first;
            an = 4'b1011;  // 4 bits
        end

        default: begin
            current_digit = 4'd0;
            an = 4'b1111;  // 4 bits
        end
    endcase
end

    // 7-segment encoding (common anode: 0 = ON, 1 = OFF)
    always @(*) begin
        case (current_digit)
            4'd0: seg = 7'b1000000;
            4'd1: seg = 7'b1111001;
            4'd2: seg = 7'b0100100;
            4'd3: seg = 7'b0110000;
            4'd4: seg = 7'b0011001;
            4'd5: seg = 7'b0010010;
            4'd6: seg = 7'b0000010;
            4'd7: seg = 7'b1111000;
            4'd8: seg = 7'b0000000;
            4'd9: seg = 7'b0010000;
            default: seg = 7'b1111111; // blank
        endcase
    end

endmodule