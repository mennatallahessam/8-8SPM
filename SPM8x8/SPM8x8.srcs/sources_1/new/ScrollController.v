`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.05.2025 14:30:52
// Design Name: 
// Module Name: ScrollController
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ScrollController(
    input clk,
input rst,
input left_btn,
input right_btn,
output reg [2:0] scroll_index  // 0 to 4
);
always @(posedge clk or posedge rst) begin
    if (rst)
        scroll_index <= 0;
    else begin
        if (left_btn && scroll_index > 0)
            scroll_index <= scroll_index - 1;
        else if (right_btn && scroll_index < 4)
            scroll_index <= scroll_index + 1;
    end
end

  
endmodule
