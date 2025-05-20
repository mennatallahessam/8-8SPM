`timescale 1ns / 1ps

//module rising_edge(
//    input clk, rst, x,
//    output z
//    );

//    reg [1:0] state, next_state;
//    parameter [1:0] A = 2'b00, B = 2'b01, C = 2'b10;

//    always @ (*) begin
//        case (state)
//            A: if (x == 0) next_state = A; else next_state = B;
//            B: if (x == 0) next_state = A; else next_state = C;
//            C: if (x == 0) next_state = A; else next_state = C;
//        endcase
//    end

//    always @ (posedge clk) begin
//        if (rst == 1'b0) state <= A; else state <= next_state;
//    end

//    assign z = (rst == 1'b1 && state == B);
//endmodule

module rising_edge(
input clk, rst, x,
output z
);
reg [1:0] state, next_state;
parameter [1:0] A = 2'b00, B = 2'b01, C = 2'b10;
always @ (*) begin
case (state)
A: if (x == 0) next_state = A; else next_state = B;
B: if (x == 0) next_state = A; else next_state = C;
C: if (x == 0) next_state = A; else next_state = C;
endcase
end
always @ (posedge clk) begin
if (rst) state <= A; else state <= next_state;
end
assign z = (!rst && state == B);
endmodule
