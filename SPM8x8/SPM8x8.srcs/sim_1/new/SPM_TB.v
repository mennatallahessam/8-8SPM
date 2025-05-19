`timescale 1ns / 1ps

module SPM_tb;

    reg clk, reset, control, en, Y;
    reg [7:0] X;
    wire serial_out;

    // Instantiate the DUT
    SPM uut (
        .Y(Y),
        .X(X),
        .reset(reset),
        .clk(clk),
        .control(control),
        .en(en),
        .serial_out(serial_out)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Task for single test
    task run_test(input [7:0] x_in, input y_bit, input expected_out);
        begin
            X = x_in;
            Y = y_bit;
            reset = 1;
            en = 0;
            #10;
            reset = 0;
            en = 1;
            #10;  // Let logic settle
            if (serial_out === expected_out)
                $display("PASS: X=%b, Y=%b -> serial_out=%b", x_in, y_bit, serial_out);
            else
                $display("FAIL: X=%b, Y=%b -> serial_out=%b (Expected %b)", x_in, y_bit, serial_out, expected_out);
            en = 0;
            #10;
        end
    endtask

    initial begin
        $display("Starting SPM Self-Checking Testbench");
        clk = 0; reset = 0; control = 0; en = 0;
        
        // --- Test Cases ---
        // Case: X = 8'b00000000, Y = 0 => Output should be 0
        run_test(8'b00000000, 0, 0);

        // Case: X = 8'b00000001, Y = 0 => Output should be 0
        run_test(8'b00000001, 0, 0);

        // Case: X = 8'b00000001, Y = 1 => LSB should be 1
        run_test(8'b00000001, 1, 1);

        // Case: X = 8'b11111111 (-1 in 2's complement), Y = 1 => LSB of -1 = 1
        run_test(8'b11111111, 1, 1);

        // Case: X = 8'b00001111 (15), Y = 1 => LSB = 1
        run_test(8'b00001111, 1, 1);

        // Case: X = 8'b00001110 (14), Y = 1 => LSB = 0
        run_test(8'b00001110, 1, 0);

        // Case: X = 8'b10000000 (-128), Y = 1 => LSB = 0
        run_test(8'b10000000, 1, 0);

        // Case: X = 8'b00000010 (2), Y = 1 => LSB = 0
        run_test(8'b00000010, 1, 0);

        $display("All tests completed.");
        $finish;
    end
endmodule


