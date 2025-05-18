`timescale 1ns / 1ps

module topModule(
    input clk, rst, PISO_load, control, left, right,
    input [7:0] X, Y,
    output reg [6:0] segments,
    output [15:0] product_out
    );
   
    assign product_out = SIPO_out;
    
    wire clk_out;
    wire serial_Y;
    wire controlBtn, leftBtn, rightBtn;
    wire SPM_serial_out;
    wire [15:0] SIPO_out;
    reg en_count, counter, multiplying;
    
    clock_divider divider(.clk(clk), .rst(rst), .clk_out(clk_out));
    
    PISO piso(.clk(clk), .rst(rst), .load(PISO_load), .parallel_in(Y), .out(serial_Y));
    
    pushButton_detector BTNC(.clk(clk_out), .rst(rst), .x(control), .z(controlBtn));
    
    pushButton_detector BTNL(.clk(clk_out), .rst(rst), .x(left), .z(leftBtn));
    
    pushButton_detector BTNR(.clk(clk_out), .rst(rst), .x(right), .z(rightBtn));
    
    SPM spm(.Y(serial_Y), .X(X), .reset(rst), .clk(clk), .control(controlBtn), .en(en_count), .serial_out(SPM_serial_out));
    
    SIPO sipo(.clk(clk), .rst(rst), .serial_in(SPM_serial_out), .out(SIPO_out));
    
    always @ (posedge clk) begin
        if (!rst)
            if (!control)
                en_count <= 0;
                
        else if (control || (!control && counter < 16)) begin
            multiplying = 1;
            counter = counter + 1;
        end 
        
        else if (counter == 16) begin
            multiplying = 0;
            en_count = 0;
        end
            
    end
    
endmodule
