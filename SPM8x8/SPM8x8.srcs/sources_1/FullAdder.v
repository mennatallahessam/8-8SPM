module FullAdder(
    input A,B,cin,
    output sum, cout
    );

    assign sum = A ^ B ^ cin;
    assign cout = A & B | B & cin | A & cin;
endmodule