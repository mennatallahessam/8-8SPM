`timescale 1ns / 1ps

module SIPO_TB();

    reg clk, rst, en;
    reg serial_in;
    wire [15:0] out;

    SIPO DUT (.clk(clk),.rst(rst),.en(en), .serial_in(serial_in), .out(out));

    always #5 clk = ~clk;

    reg [15:0] input_bits = 16'b1100101011110001;
    integer i;

    initial begin
        $monitor("Time=%0t | rst=%b en=%b serial_in=%b out=%b", 
                 $time, rst, en, serial_in, out);

        clk = 0;
        rst = 0;
        en = 0;
        serial_in = 0;

        #10 rst = 1;
        en = 1;

        for (i = 0; i < 16; i = i + 1) begin
            serial_in = input_bits[i];
            #10;
        end

        en = 0;
        #20 $finish;
    end

endmodule
