`timescale 1ns / 1ps

module CarrySaveAdder_tb;

    // Inputs
    reg X;
    reg Y;
    reg R;
    reg clk;
    reg en;
    
    // Output
    wire sum;
    
    // Expected outputs
    reg expected_sum;
    
    // Test case tracking
    integer test_case = 0;
    integer passed = 0;
    integer failed = 0;
    
    // Instantiate the Unit Under Test (UUT)
    CarrySaveAdder uut (
        .X(X),
        .Y(Y),
        .R(R),
        .clk(clk),
        .en(en),
        .sum(sum)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock period
    end
    
    // Test sequence
    initial begin
        // Initialize inputs
        X = 0;
        Y = 0;
        R = 0; // Active-low reset
        en = 0;
        
        // Wait for reset to take effect
        #20;
        
        // Release reset and enable
        R = 1;
        en = 1;
        
        // Test Case 1: X=0, Y=0 (first cycle)
        test_case = 1;
        X = 0;
        Y = 0;
        #10;
        expected_sum = 0;
        check_result();
        
        // Test Case 2: X=0, Y=1
        test_case = 2;
        X = 0;
        Y = 1;
        #10;
        expected_sum = 1;
        check_result();
        
        // Test Case 3: X=1, Y=0
        test_case = 3;
        X = 1;
        Y = 0;
        #10;
        expected_sum = 1;
        check_result();
        
        // Test Case 4: X=1, Y=1
        test_case = 4;
        X = 1;
        Y = 1;
        #10;
        expected_sum = 0; // With carry
        check_result();
        
        // Test Case 5: X=0, Y=0 (after carry)
        test_case = 5;
        X = 0;
        Y = 0;
        #10;
        expected_sum = 1; // Previous carry affects this result
        check_result();
        
        // Test Case 6: Reset during operation
        test_case = 6;
        X = 1;
        Y = 1;
        R = 0; // Apply reset
        #10;
        expected_sum = 0; // Reset should set sum to 0
        check_result();
        
        // Test Case 7: After reset
        test_case = 7;
        R = 1; // Release reset
        X = 1;
        Y = 1;
        #10;
        expected_sum = 0; // With carry
        check_result();
        
        // Test Case 8: Disable during operation
        test_case = 8;
        X = 0;
        Y = 0;
        en = 0; // Disable
        #10;
        expected_sum = 0; // Should not change when disabled
        check_result();
        
        // Test Case 9: Re-enable with X=1, Y=0, SC=1
        test_case = 9;
        en = 1;
        X = 1;
        Y = 0;
        #10;
        expected_sum = 0; // X ^ (Y ^ SC) = 1 ^ (0 ^ 1) = 1 ^ 1 = 0
        check_result();
        
        // Test Case 10: X=0, Y=1, SC=1
        test_case = 10;
        X = 0;
        Y = 1;
        #10;
        expected_sum = 0; // X ^ (Y ^ SC) = 0 ^ (1 ^ 1) = 0 ^ 0 = 0
        check_result();
        
        // Test Case 11: X=1, Y=0, SC=1
        test_case = 11;
        X = 1;
        Y = 0;
        #10;
        expected_sum = 0; // X ^ (Y ^ SC) = 1 ^ (0 ^ 1) = 1 ^ 1 = 0
        check_result();
        
        // Test Case 12: X=1, Y=1, SC=1
        test_case = 12;
        X = 1;
        Y = 1;
        #10;
        expected_sum = 1; // X ^ (Y ^ SC) = 1 ^ (1 ^ 1) = 1 ^ 0 = 1
        check_result();
        
        // Test Case 13: X=0, Y=0, SC=1->0
        test_case = 13;
        X = 0;
        Y = 0;
        #10;
        expected_sum = 1; // X ^ (Y ^ SC) = 0 ^ (0 ^ 0) = 0 ^ 0 = 0
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
            if (sum === expected_sum) begin
                $display("Test Case %0d: PASSED - X=%b, Y=%b, SC=%b, sum=%b (expected %b)", 
                         test_case, X, Y, uut.SC, sum, expected_sum);
                passed = passed + 1;
            end
            else begin
                $display("Test Case %0d: FAILED - X=%b, Y=%b, SC=%b, sum=%b (expected %b)", 
                         test_case, X, Y, uut.SC, sum, expected_sum);
                failed = failed + 1;
            end
        end
    endtask
    
    // Monitor for changes
    initial begin
        $monitor("Time=%0t: X=%b, Y=%b, R=%b, en=%b, SC=%b, sum=%b", 
                 $time, X, Y, R, en, uut.SC, sum);
    end

endmodule
