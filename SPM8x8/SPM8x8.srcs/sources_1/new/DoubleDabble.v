`timescale 1ns / 1ps


module DoubleDabble (
    input wire [15:0] binary_in,
    output reg [3:0] bcd_ones,
    output reg [3:0] bcd_tens,
    output reg [3:0] bcd_hundreds,
    output reg [3:0] bcd_thousands,
    output reg [3:0] bcd_ten_thousands
    );
    
    integer i;
    reg [35:0] shift_reg;

    always @(*) begin
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
            
            
//            // Double dabble algorithm
//        for (i = 0; i < 16; i = i + 1) begin
//            // Shift left first
//            shift_reg = {shift_reg[34:0], 1'b0};
            
//            // Then check and add
//            if (shift_reg[19:16] > 4)
//                shift_reg[19:16] = shift_reg[19:16] + 3;
                
//            if (shift_reg[23:20] > 4)
//                shift_reg[23:20] = shift_reg[23:20] + 3;
                
//            if (shift_reg[27:24] > 4)
//                shift_reg[27:24] = shift_reg[27:24] + 3;
                               
//            if (shift_reg[31:28] > 4)
//                shift_reg[31:28] = shift_reg[31:28] + 3;
                               
//            if (shift_reg[35:32] > 4)
//                shift_reg[35:32] = shift_reg[35:32] + 3;
//        end
    


//        for (i = 0; i < 16; i = i + 1) begin
//            if (shift_reg[34:31] > 4)
//                shift_reg[35:31] = shift_reg[35:31] + 3;
                
//            if (shift_reg[30:27] > 4)
//                shift_reg[35:27] = shift_reg[35:27] + 3;
                
//            if (shift_reg[26:23] > 4)
//                shift_reg[35:23] = shift_reg[35:23] + 3;
                               
//             if (shift_reg[22:19] > 4)
//                shift_reg[35:19] = shift_reg[35:19] + 3;
                               
//             if (shift_reg[18:15] > 4)
//                 shift_reg[35:15] = shift_reg[35:15] + 3;
                               
//             if ( i < 15)           // Shift left
//                shift_reg = {shift_reg[34:0], 1'b0};


    
    
end
     end

endmodule