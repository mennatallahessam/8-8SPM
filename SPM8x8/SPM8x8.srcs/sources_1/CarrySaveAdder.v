`timescale 1ns / 1ps

module CarrySaveAdder (
    input X, Y, R, clk, en,
    output sum
    );

    wire CAR1, CAR2, HSUM1, SC;

    //assign HSUM = Y ^ SC;
    //assign CAR1 = Y & SC;
    assign CAR2 = X & HSUM1;

    DFF dff1(.clk(clk), .d(X ^ HSUM1), .rst(R), .en(en), .q(sum));
    DFF dff2(.clk(clk), .d(CAR2 | CAR1), .rst(R), .en(en), .q(SC));

    HalfAdder HA(.A(Y), .B(SC), .sum(HSUM1), .cout(CAR1));

//    and and1(CAR2, X, HSUM1);
//    and and2(AND2, CAR2, CAR1);

endmodule