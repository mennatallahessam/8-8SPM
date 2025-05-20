`timescale 1ns/1ps

module SPM_tb();

  reg clk, reset;
  reg [7:0] A, B;
  wire [15:0] out;
  wire finish;

  // Instantiate the multiplier
  SPM uut (
    .out(out),
    .finish(finish),
    .reset(reset),
    .clk(clk),
    .A(A),
    .B(B)
  );

  // Clock generation
  always #5 clk = ~clk;

integer i;
reg [7:0] testA[0:4];
    reg [7:0] testB[0:4];
    reg [15:0] expected;
    
  // Test procedure
  initial begin
    
    

    // Test vectors
    testA[0] = 8'd3;    testB[0] = 8'd5;
    testA[1] = 8'd15;   testB[1] = 8'd12;
    testA[2] = 8'd255;  testB[2] = 8'd2;
    testA[3] = 8'd100;  testB[3] = 8'd100;
    testA[4] = 8'd0;    testB[4] = 8'd200;

    clk = 0;
    reset = 1;
    A = 0;
    B = 0;

    #10 reset = 0;

    for (i = 0; i < 5; i = i + 1) begin
      A = testA[i];
      B = testB[i];
      reset = 1; #10;
      reset = 0;

      wait(finish); // wait for multiplier to finish

      expected = A * B;

      if (out == expected)
        $display("Test %0d: PASS -- A=%d, B=%d, Result=%d", i, A, B, out);
      else
        $display("Test %0d: FAIL -- A=%d, B=%d, Expected=%d, Got=%d", i, A, B, expected, out);

      #10; // small delay before next test
    end

    $finish;
  end

endmodule

//`timescale 1ns / 1ps

//module SPM_TB;

//    reg clk;
//    reg reset;
//    reg start;
//    reg serial_in;
//    reg [7:0] parallel_in;
//    wire [15:0] product_out;
//    wire finish;

//    // Instantiate the SPM
//    SPM uut (
//        .clk(clk),
//        .reset(reset),
//        .start(start),
//        .serial_in(serial_in),
//        .parallel_in(parallel_in),
//        .product_out(product_out),
//        .finish(finish)
//    );

//    // Clock generation: 10ns period
//    initial clk = 0;
//    always #5 clk = ~clk;

//    // Task to send serial operand bits LSB first
//    task send_serial_operand(input [7:0] operand);
//        integer i;
//        begin
//            for (i = 0; i < 8; i = i + 1) begin
//                serial_in = operand[i];  // Set bit BEFORE clock edge
//                @(posedge clk);          // Wait for clock edge where module reads serial_in
//            end
//        end
//    endtask

//    initial begin
//        // Initialize inputs
//        reset = 1;
//        start = 0;
//        serial_in = 0;
//        parallel_in = 0;

//        @(posedge clk);
//        reset = 0;

//        // Test vectors
//        // Multiply 13 * 7 = 91
//        parallel_in = 7;
//        @(posedge clk);
//        start = 1;
//        send_serial_operand(8'd13); // send serial bits for 13 LSB first
//        @(posedge clk);
//        start = 0;

//        // Wait for finish
//        wait(finish == 1);
//        $display("Test 1: 13 * 7 = %d (Expected: 91)", product_out);

//        @(posedge clk);

//        // Multiply 255 * 2 = 510
//        parallel_in = 8'd2;
//        @(posedge clk);
//        start = 1;
//        send_serial_operand(8'd255);
//        @(posedge clk);
//        start = 0;

//        wait(finish == 1);
//        $display("Test 2: 255 * 2 = %d (Expected: 510)", product_out);

//        @(posedge clk);

//        // Multiply 0 * 100 = 0
//        parallel_in = 8'd100;
//        @(posedge clk);
//        start = 1;
//        send_serial_operand(8'd0);
//        @(posedge clk);
//        start = 0;

//        wait(finish == 1);
//        $display("Test 3: 0 * 100 = %d (Expected: 0)", product_out);

//        @(posedge clk);

//        $finish;
//    end

//endmodule
