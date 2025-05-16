module HalfAdder(
    input A, B,
    output sum, cout 
    );

    assign sum = A ^ B;  
    assign cout = A & B;  
endmodule