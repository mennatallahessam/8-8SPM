`timescale 1ns / 1ps


module DoubleDabble (
    input wire [15:0] binary_in,
    output reg [3:0] bcd_ones,
    output reg [3:0] bcd_tens,
    output reg [3:0] bcd_hundreds,
    output reg [3:0] bcd_thousands,
    output reg [3:0] bcd_ten_thousands,
    input en
    );
    
    integer i;
    reg [35:0] shift_reg;

    always @(*) begin
        if (en) begin
            shift_reg = 36'd0;
            shift_reg[15:0] = binary_in;
            
            
            for (i = 0; i < 16; i = i + 1) begin
                // Check and add 3 before shifting
                if (shift_reg[19:16] > 4)
                    shift_reg[19:16] = shift_reg[19:16] + 3;
                if (shift_reg[23:20] > 4)
                    shift_reg[23:20] = shift_reg[23:20] + 3;
                if (shift_reg[27:24] > 4)
                    shift_reg[27:24] = shift_reg[27:24] + 3;
                if (shift_reg[31:28] > 4)
                    shift_reg[31:28] = shift_reg[31:28] + 3;
                if (shift_reg[35:32] > 4)
                    shift_reg[35:32] = shift_reg[35:32] + 3;
            
                // Now shift
                shift_reg = {shift_reg[34:0], 1'b0};
                
                
                        // Assign BCD outputs
                bcd_ones = shift_reg[19:16];
                bcd_tens = shift_reg[23:20];
                bcd_hundreds = shift_reg[27:24];
                bcd_thousands = shift_reg[31:28];
                bcd_ten_thousands = shift_reg[35:32];
        end
    end
            end

endmodule