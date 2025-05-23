`timescale 1ns / 1ps

module pushButton_detector(
    input clk, rst, x,
    output z
    );

    wire clock_out;
    wire [1:0] outs;

//    clock_divider #(25000) clockdivider(.clk(clk), .rst(rst), .clk_out(clock_out));
//    debouncer db(.clk(clock_out), .rst(rst), .in(x), .out(outs[0]));
//    synchronizer sync(.clk(clock_out), .sig(outs[0]), .sig1(outs[1]));
//    rising_edge risinged(.clk(clock_out), .rst(rst), .x(outs[1]), .z(z));

    debouncer db(.clk(clk), .rst(rst), .in(x), .out(outs[0]));
    synchronizer sync(.clk(clk), .sig(outs[0]), .sig1(outs[1]));
    rising_edge risinged(.clk(clk), .rst(rst), .x(outs[1]), .z(z));
    
endmodule


//module pushbutton_detector(
//input clk, rst, x,
//output z
//);

//wire clock_out;
//wire [1:0] outs;

//clock_divider #(250000) clockdivider(.clk(clk), .rst(rst), .clk_out(clock_out));

//debouncer db(.clk(clock_out), .rst(rst), .in(x), .out(outs[0]));
//synchronizer sync(.clk(clock_out), .sig(outs[0]), .sig1(outs[1]));
//rising_edge risinged(.clk(clock_out), .rst(rst), .x(outs[1]), .z(z));
//endmodule
