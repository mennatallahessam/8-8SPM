`timescale 1ns / 1ps

module PISO_TB();
    reg clk, rst, load, en;
    reg [7:0] parallel_in;
    wire out;

    PISO DUT (.clk(clk), .rst(rst), .load(load), .en(en), .parallel_in(parallel_in), .out(out));

    always #5 clk = ~clk;

    initial begin
        $monitor("Time=%0t | rst=%b load=%b en=%b parallel_in=%b out=%b", 
                 $time, rst, load, en, parallel_in, out);

        clk = 0;
        rst = 0;
        load = 0;
        en = 0;
//        parallel_in = 8'b10101010;
        parallel_in = 8'b11100101;

        #10 rst = 1;

        #10 load = 1;  // Load data
        #10 load = 0;

        en = 1;
        repeat (8) #10;

        en = 0;
        #20 $finish;
    end

endmodule
