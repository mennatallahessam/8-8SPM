`timescale 1ns / 1ps

module DoubleDabble_TB();

    // Inputs
    reg [15:0] binary_in;

    // Outputs (BCD digits)
    wire [3:0] bcd_ones;
    wire [3:0] bcd_tens;
    wire [3:0] bcd_hundreds;
    wire [3:0] bcd_thousands;
    wire [3:0] bcd_ten_thousands;

    // Expected values
    reg [3:0] exp_ones;
    reg [3:0] exp_tens;
    reg [3:0] exp_hundreds;
    reg [3:0] exp_thousands;
    reg [3:0] exp_ten_thousands;

    integer pass_count = 0;
    integer fail_count = 0;

    // Instantiate the binary_to_bcd module
    DoubleDabble uut (
        .binary_in(binary_in),
        .bcd_ones(bcd_ones),
        .bcd_tens(bcd_tens),
        .bcd_hundreds(bcd_hundreds),
        .bcd_thousands(bcd_thousands),
        .bcd_ten_thousands(bcd_ten_thousands)
    );

    // Test procedure
    initial begin
        $display("Starting binary to BCD self-checking testbench...");
        $display("===================================================");

        run_test(16'd0,      0, 0, 0, 0, 0);
        run_test(16'd9,      0, 0, 0, 0, 9);
        run_test(16'd45,     0, 0, 0, 4, 5);
        run_test(16'd12345,  1, 2, 3, 4, 5);
        run_test(16'd65535,  6, 5, 5, 3, 5);

        $display("===================================================");
        $display("Test Summary: %0d Passed, %0d Failed", pass_count, fail_count);
        $display("Testbench completed.");
        $finish;
    end

    // Task to run a test case
    task run_test(
        input [15:0] bin_val,
        input [3:0] ten_thousands, thousands, hundreds, tens, ones
    );
        begin
            binary_in = bin_val;
            exp_ten_thousands = ten_thousands;
            exp_thousands     = thousands;
            exp_hundreds      = hundreds;
            exp_tens          = tens;
            exp_ones          = ones;
            #10;
            check_result();
        end
    endtask

    // Task to check the output against expected values
    task check_result;
        begin
            $display("Binary Input   = %016b (%0d)", binary_in, binary_in);
            $display("BCD Output     = %0d%0d%0d%0d%0d (Expected: %0d%0d%0d%0d%0d)",
                     bcd_ten_thousands, bcd_thousands, bcd_hundreds, bcd_tens, bcd_ones,
                     exp_ten_thousands, exp_thousands, exp_hundreds, exp_tens, exp_ones);
            if ({bcd_ten_thousands, bcd_thousands, bcd_hundreds, bcd_tens, bcd_ones} ===
                {exp_ten_thousands, exp_thousands, exp_hundreds, exp_tens, exp_ones}) begin
                $display("Result: PASS");
                pass_count = pass_count + 1;
            end else begin
                $display("Result: FAIL");
                fail_count = fail_count + 1;
            end
            $display("---------------------------------------");
        end
    endtask

endmodule
