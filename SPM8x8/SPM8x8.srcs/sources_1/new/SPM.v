// THIS SPM WORKS BUT IT IS NOT SERIAL-PARALLEL

`timescale 1ns / 1ps

module SPM (
    output reg [15:0] out,
    output reg finish,
    input reset,
    input clk,
    input [7:0] A,
    input [7:0] B,
    input en
);

    reg [3:0] count;
    reg [15:0] multiplicand;
    reg [15:0] accumulator;
    reg [7:0] multiplier;

    reg busy;

    always @(posedge clk or posedge reset) begin
    if (en) begin
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
    end
endmodule


