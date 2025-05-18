`timescale 1ns / 1ps

module PISO #(parameter N = 8) (
    input clk, rst, load,
    input [N-1:0] parallel_in,
    output out
    );
    
    reg [N-1:0] data;
    assign out = data[0];
    
    always @ (posedge clk) begin
        if (!rst)
            data <= 0;
        else if (load)
            data = parallel_in;
        else
            data <= {1'b0, data[N-1:1]};
    end
    
endmodule
