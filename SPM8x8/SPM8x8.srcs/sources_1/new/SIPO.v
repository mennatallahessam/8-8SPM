`timescale 1ns / 1ps

module SIPO #(parameter N = 16) (
    input clk, rst, en,
    input serial_in,
    output reg [N-1:0] out
    );
    
    always @ (posedge clk) begin
            if (!rst)
                out <= 0;
            else if (en)
                out <= {serial_in, out[N-1:1]};
        end
    
    
endmodule

    