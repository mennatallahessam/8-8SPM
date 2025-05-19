`timescale 1ns / 1ps

module SPM_tb;

    reg clk, reset, control, en, Y;
    reg [7:0] X;
    wire serial_out;

    // Instantiate DUT
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
    
 /*
 initial begin 
     clk = 0;
     reset = 0; 
      en = 1'b0; 
     control = 1'b0;     
    repeat(3) @(negedge clk);    
       reset = 1; 
      @(negedge clk);  
        
     Y = 1'b1;
     X = 8'b0000_0001;
     en = 1'b1; 
     control = 1'b1; 
     
     repeat (20)       @(negedge clk); 
     $stop; 

     end
   */ 

    // Test task
    task run_serial_test(input [7:0] x_in, input [7:0] y_in);
        integer i;
        reg [15:0] collected_product;
        reg [15:0] expected_product;
        begin
            X = x_in;
            reset = 1; en = 0; control = 0;
            collected_product = 0;
            #10;
            reset = 0;

            expected_product = x_in * y_in;

            $display("=== TEST: X = %d, Y = %d ===", x_in, y_in);

            for (i = 0; i < 8; i = i + 1) begin
                Y = y_in[i];   // LSB first
                en = 1;
                #10;
                collected_product[i] = serial_out;
                en = 0;
                #10;
            end

            $display("Expected Product: %d (Binary: %016b)", expected_product, expected_product);
            $display("Actual   Product: %d (Binary: %016b)", collected_product, collected_product);
            
            if (collected_product == expected_product)
                $display("RESULT: ? PASS\n");
            else
                $display("RESULT: ? FAIL\n");
        end
    endtask

    // Test setup
    initial begin
        clk = 0;

        $display("=== Starting Serial Multiplier Tests ===");

        // Test cases
        run_serial_test(8'd1, 8'd1);     // 1 × 1
        run_serial_test(8'd2, 8'd2);     // 2 × 2
        run_serial_test(8'd3, 8'd5);     // 3 × 5
        run_serial_test(8'd7, 8'd15);    // 7 × 15
        run_serial_test(8'd255, 8'd1);   // 255 × 1
        run_serial_test(8'd255, 8'd255); // 255 × 255 = 65025

        $display("=== All Tests Complete ===");
        $finish;
    end

endmodule
