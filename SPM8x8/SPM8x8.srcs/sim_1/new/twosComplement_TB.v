`timescale 1ns / 1ps

module twosComplement_TB();

    // Inputs
    reg a;
    reg clk;
    reg rst;
    reg start;
    
    // Output
    wire s;
    
    // Expected outputs for verification
    reg expected_s;
    
    // Test case counter
    integer test_case = 0;
    integer passed = 0;
    integer failed = 0;
    
    // Instantiate the Unit Under Test (UUT)
    TwosComplement uut (
        .a(a),
        .s(s),
        .clk(clk),
        .rst(rst),
        .start(start)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock period
    end
    
    // Test sequence
    initial begin
        // Initialize inputs
        a = 0;
        rst = 0; // Active-low reset
        start = 0;
        
        // Wait for reset to take effect
        #20;
        
        // Release reset
        rst = 1;
        start = 1;
        
        // Test Case 1: a=0 (first cycle)
        test_case = 1;
        a = 0;
        #10; // Wait for one clock cycle
        expected_s = 0; // a XOR z = 0 XOR 0 = 0
        check_result();
        
        // Test Case 2: a=1 (second cycle)
        test_case = 2;
        a = 1;
        #10;
        expected_s = 1; // a XOR z = 1 XOR 0 = 1
        check_result();
        
        // Test Case 3: a=0 (third cycle)
        test_case = 3;
        a = 0;
        #10;
        expected_s = 1; // a XOR z = 0 XOR 1 = 1
        check_result();
        
        // Test Case 4: a=1 (fourth cycle)
        test_case = 4;
        a = 1;
        #10;
        expected_s = 0; // a XOR z = 1 XOR 1 = 0
        check_result();
        
        // Test Case 5: Reset during operation
        test_case = 5;
        a = 1;
        rst = 0; // Apply reset
        #10;
        expected_s = 0; // Reset should set s to 0
        check_result();
        
        // Test Case 6: After reset
        test_case = 6;
        rst = 1; // Release reset
        a = 1;
        #10;
        expected_s = 1; // a XOR z = 1 XOR 0 = 1
        check_result();
        
        // Test Case 7: Sequence of bits (0,1,0,1)
        test_case = 7;
        a = 0;
        #10;
        expected_s = 1; // a XOR z = 0 XOR 1 = 1
        check_result();
        
        test_case = 8;
        a = 1;
        #10;
        expected_s = 0; // a XOR z = 1 XOR 1 = 0
        check_result();
        
        test_case = 9;
        a = 0;
        #10;
        expected_s = 1; // a XOR z = 0 XOR 1 = 1
        check_result();
        
        test_case = 10;
        a = 1;
        #10;
        expected_s = 0; // a XOR z = 1 XOR 1 = 0
        check_result();
        
        // Display final results
        $display("\n----- Test Summary -----");
        $display("Total Tests: %0d", test_case);
        $display("Passed: %0d", passed);
        $display("Failed: %0d", failed);
        if (failed == 0)
            $display("All tests PASSED!");
        else
            $display("Some tests FAILED!");
        
        $finish;
    end
    
    // Task to check results
    task check_result;
        begin
            if (s === expected_s) begin
                $display("Test Case %0d: PASSED - a=%b, z=%b, s=%b (expected %b)", 
                         test_case, a, uut.z, s, expected_s);
                passed = passed + 1;
            end
            else begin
                $display("Test Case %0d: FAILED - a=%b, z=%b, s=%b (expected %b)", 
                         test_case, a, uut.z, s, expected_s);
                failed = failed + 1;
            end
        end
    endtask
    
    // Monitor for changes
    initial begin
        $monitor("Time=%0t: a=%b, rst=%b, start=%b, z=%b, s=%b", 
                 $time, a, rst, start, uut.z, s);
    end

endmodule
