// THIS SPM WORKS BUT IT IS NOT SERIAL-PARALLEL

`timescale 1ns / 1ps

module SPM (
    output reg [15:0] out,
    output reg finish,
    input reset,
    input clk,
    input [7:0] A,
    input [7:0] B
);

    reg [3:0] count;
    reg [15:0] multiplicand;
    reg [15:0] accumulator;
    reg [7:0] multiplier;

    reg busy;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 0;
            out <= 0;
            finish <= 0;
            busy <= 0;
            accumulator <= 0;
            multiplicand <= A;
            multiplier <= B;
        end
        else if (!busy) begin
            // Start multiplying
            busy <= 1;
            count <= 0;
            accumulator <= 0;
            multiplicand <= A;
            multiplier <= B;
            finish <= 0;
        end
        else if (count < 8) begin
            if (multiplier[0])
                accumulator <= accumulator + (multiplicand << count);
            multiplier <= multiplier >> 1;
            count <= count + 1;
        end
        else begin
            out <= accumulator;
            finish <= 1;
            busy <= 0;
        end
    end
endmodule


//`timescale 1ns/1ps

//module SPM (
//    input clk,
//    input reset,
//    input start,
//    input serial_in,          // Serial bit input (LSB first)
//    input [7:0] parallel_in,  // Parallel operand
//    output reg [15:0] product_out,
//    output reg finish
//);
//    // State machine states
//    localparam IDLE = 2'b00;
//    localparam RUNNING = 2'b01;
//    localparam COMPLETE = 2'b10;
    
//    reg [1:0] state;
//    reg [3:0] bit_count;
//    reg [15:0] product;
//    reg [7:0] multiplicand;
    
//    always @(posedge clk or posedge reset) begin
//        if (reset) begin
//            state <= IDLE;
//            bit_count <= 4'h0;
//            product <= 16'h0000;
//            multiplicand <= 8'h00;
//            product_out <= 16'h0000;
//            finish <= 1'b0;
//        end
//        else begin
//            case (state)
//                IDLE: begin
//                    finish <= 1'b0; // Reset finish signal
                    
//                    if (start) begin
//                        state <= RUNNING;
//                        bit_count <= 4'h0;
//                        product <= 16'h0000;
//                        multiplicand <= parallel_in;
//                    end
//                end
                
//                RUNNING: begin
//                    // Process the current serial bit
//                    if (serial_in) begin
//                        product <= product + (multiplicand << bit_count);
//                    end
                    
//                    // Check if we've processed all 8 bits
//                    if (bit_count == 4'h7) begin
//                        state <= COMPLETE;
//                    end
//                    else begin
//                        bit_count <= bit_count + 4'h1;
//                    end
//                end
                
//                COMPLETE: begin
//                    product_out <= product;
//                    finish <= 1'b1;
//                    state <= IDLE;
//                end
                
//                default: state <= IDLE;
//            endcase
//        end
//    end
//endmodule