
`timescale 1ns / 1ps

module testingScroll_tb();
    // Inputs
    reg clk;
    reg button_l;
    reg button_r;
    reg rst;
    
    // Outputs
    wire [6:0] seg;
    wire [3:0] an;
    
    // Internal signals for tracking and debugging
    integer i;
    reg [3:0] displayed_digits [3:0]; // Array to store digits for all 4 displays
    reg [3:0] active_display;         // Which display is currently active
    
    // Instantiate the Unit Under Test (UUT)
    testingScroll uut (
        .clk(clk), 
        .button_l(button_l), 
        .button_r(button_r), 
        .rst(rst), 
        .seg(seg), 
        .an(an)
    );
    
    // Clock generation (100MHz clock = 10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 5ns high, 5ns low = 10ns period
    end
    
    // Initialize digit trackers
    initial begin
        for (i = 0; i < 4; i = i + 1) begin
            displayed_digits[i] = 0;
        end
        active_display = 0;
    end
    
    // Function to decode 7-segment pattern to decimal
    function [3:0] decode_7seg;
        input [6:0] segments;
        begin
            casez (segments)
                7'b1000000: decode_7seg = 4'd0; // 0
                7'b1111001: decode_7seg = 4'd1; // 1
                7'b0100100: decode_7seg = 4'd2; // 2
                7'b0110000: decode_7seg = 4'd3; // 3
                7'b0011001: decode_7seg = 4'd4; // 4
                7'b0010010: decode_7seg = 4'd5; // 5
                7'b0000010: decode_7seg = 4'd6; // 6
                7'b1111000: decode_7seg = 4'd7; // 7
                7'b0000000: decode_7seg = 4'd8; // 8
                7'b0010000: decode_7seg = 4'd9; // 9
                default:    decode_7seg = 4'hF; // Unknown pattern
            endcase
        end
    endfunction
    
    // Monitor the 7-segment display outputs
    always @(an or seg) begin
        case (an)
            4'b1110: active_display = 0; // Rightmost display
            4'b1101: active_display = 1;
            4'b1011: active_display = 2;
            4'b0111: active_display = 3; // Leftmost display
            default: active_display = 4'hF;
        endcase
        
        if (an != 4'b1111) begin // If any display is active
            displayed_digits[active_display] = decode_7seg(seg);
        end
    end
    
    // Track the value of start_from by watching button presses
    reg [1:0] current_start_from;
    
    initial begin
        current_start_from = 0;
    end
    
    always @(posedge button_output_l or posedge button_output_r or negedge rst) begin
        if (!rst)
            current_start_from = 0;
        else begin
            if (button_output_l && current_start_from > 0)
                current_start_from = current_start_from - 1;
            else if (button_output_r && current_start_from < 2)
                current_start_from = current_start_from + 1;
        end
    end
    
    // Access internal signals from the UUT for better debugging
    wire button_output_l;
    wire button_output_r;
    assign button_output_l = uut.button_output_l;
    assign button_output_r = uut.button_output_r;
    
    // Enhanced monitoring with digit display information
    always @(displayed_digits[0] or displayed_digits[1] or displayed_digits[2] or displayed_digits[3] or current_start_from) begin
        $display("Time=%t, start_from=%d, Display Values: [3]=%h [2]=%h [1]=%h [0]=%h, Current Active Display=%d", 
                $time, current_start_from, 
                displayed_digits[3], displayed_digits[2], displayed_digits[1], displayed_digits[0],
                active_display);
    end
    
    // Regular monitoring for button and control signals
    initial begin
        $monitor("Time=%t, rst=%b, button_l=%b, button_r=%b, button_output_l=%b, button_output_r=%b, seg=%b, an=%b", 
                 $time, rst, button_l, button_r, button_output_l, button_output_r, seg, an);
    end
    
    // Test scenario
    initial begin
        // Initialize inputs
        button_l = 0;
        button_r = 0;
        rst = 0;  // Active low reset
        
        // Apply reset
        #20;
        rst = 1;  // Release reset
        #100;
        
        // Test right button (should increment start_from)
        button_r = 1;
        #1000;    // Hold button for some time
        button_r = 0;
        #5000;    // Wait to see the effect
        
        // Press right button again (should increment start_from to 2)
        button_r = 1;
        #1000;
        button_r = 0;
        #5000;
        
        // Try pressing right button once more (start_from should remain at 2 since it's the max)
        button_r = 1;
        #1000;
        button_r = 0;
        #5000;
        
        // Now test left button (should decrement start_from)
        button_l = 1;
        #1000;
        button_l = 0;
        #5000;
        
        // Press left button again (should decrement start_from to 0)
        button_l = 1;
        #1000;
        button_l = 0;
        #5000;
        
        // Try pressing left button once more (start_from should remain at 0 since it's the min)
        button_l = 1;
        #1000;
        button_l = 0;
        #5000;
        
        // Test both buttons at once (should have no effect)
        button_l = 1;
        button_r = 1;
        #1000;
        button_l = 0;
        button_r = 0;
        #5000;
        
        // Apply reset again to verify reset functionality
        rst = 0;
        #20;
        rst = 1;
        #5000;
        
        $finish;
    end
    
endmodule