`timescale 1ns / 1ps

module topModule_tb;

    // Inputs
    reg clk = 0;
    reg rst;
    reg PISO_load;
    reg control;
    reg left = 0;
    reg right = 0;
    reg [7:0] X;
    reg [7:0] Y;

    // Outputs
    wire [6:0] segments;
    wire [15:0] product_out;

    // Instantiate DUT
    topModule top (
        .clk(clk),
        .rst(rst),
        .PISO_load(PISO_load),
        .control(control),
        .left(left),
        .right(right),
        .X(X),
        .Y(Y),
        .segments(segments),
        .product_out(product_out)
    );

    // Clock
    always #5 clk = ~clk;

    // Simulation logic
    initial begin
     $monitor("Time=%0t, rst=%b, en_count=%b, multiplying=%b, counter=%d, serial_Y=%b, SPM_out=%b", 
                $time, rst, top.en_count, top.multiplying, top.counter, top.serial_Y, top.SPM_serial_out);
        $display("Starting simulation...");
        rst = 0;
        control = 0;
        PISO_load = 0;
        #10;

        rst = 1;
        X = 8'd5;   // 5
        Y = 8'd3;   // 3

        // Load PISO
        PISO_load = 1;
        #10;
        PISO_load = 0;

        // Start multiplication
        control = 1;
        #10;
        control = 0;

        // Wait for result
        #300;

        $display("Expected: %0d, Got: %0d", X * Y, product_out);
        if (product_out == X * Y)
            $display("? Test Passed!");
        else
            $display("? Test Failed!");

        $finish;
    end

    // Live product display
    always @(product_out) begin
        $display("Time: %0t | Product = %0d (0x%0h)", $time, product_out, product_out);
    end

endmodule
