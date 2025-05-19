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