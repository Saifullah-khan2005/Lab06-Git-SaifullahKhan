`timescale 1ns / 1ps

module module_ALU (ALUctl, A, B, ALUOut, Zero);
    input [3:0] ALUctl;
    input [31:0] A, B;
    output reg [31:0] ALUOut;
    output Zero;

    assign Zero = (ALUOut == 0); 
    always @(ALUctl, A, B) begin 
        case (ALUctl)
            4'd0:  ALUOut = A & B;
            4'd1:  ALUOut = A | B;
            4'd2:  ALUOut = A + B;
            4'd6:  ALUOut = A - B;
            4'd7:  ALUOut = A ^ B;       
            4'd8:  ALUOut = A << B;     
            4'd9:  ALUOut = A >> B;      
            4'd12: ALUOut = ~(A | B);    
            default: ALUOut = 0;
        endcase
    end
endmodule