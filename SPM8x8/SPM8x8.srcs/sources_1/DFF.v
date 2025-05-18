`timescale 1ns / 1ps

module DFF(
    input clk, d, rst, en,
    output reg q
    );

    always @ (posedge clk) begin
        if (!rst)
            q <= 0;
        else if (en)
            q <= d;
    end

endmodule