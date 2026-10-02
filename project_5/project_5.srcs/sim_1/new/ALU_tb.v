`timescale 1ns / 1ps

module ALU_tb;

    reg [3:0] ALUctl;
    reg [31:0] A;
    reg [31:0] B;

    wire [31:0] ALUOut;
    wire Zero;

    module_ALU uut (
        .ALUctl(ALUctl), 
        .A(A), 
        .B(B), 
        .ALUOut(ALUOut), 
        .Zero(Zero)
    );

    initial begin
        ALUctl = 4'b0000;
        A = 32'b00000000_00000000_00000000_00000000;
        B = 32'b00000000_00000000_00000000_00000000;
        #10;
        #10;
        
        // AND 
        ALUctl = 4'b0000; 
        A = 32'b00000000_00000000_11111111_11111111; 
        B = 32'b11111111_11111111_00000000_00000000; 
        #10;
        
        // OR 
        ALUctl = 4'b0001; 
        A = 32'b00000000_00000000_11111111_11111111; 
        B = 32'b11111111_11111111_00000000_00000000; 
        #10;
        
        // ADD
        ALUctl = 4'd2; A = 32'd15; B = 32'd10; #10;
        
        // SUB
        ALUctl = 4'd6; A = 32'd25; B = 32'd10; #10;
        
        // XOR
        ALUctl = 4'b0111; // 7 in decimal
        A = 32'b10101010_10101010_10101010_10101010; 
        B = 32'b01010101_01010101_01010101_01010101; 
        #10;
        
        // SSL 
        ALUctl = 4'b1000; // 8 in decimal
        A = 32'b00000000_00000000_00000000_00000001; 
        B = 32'd4;
        #10;
        
        // SRL 
        ALUctl = 4'b1001; // 9 in decimal
        A = 32'b00000000_00000000_00000000_00010000; 
        B = 32'd2;
        #10;
        
        // Zero flag
        ALUctl = 4'd6; A = 32'd50; B = 32'd50; #10;

        $finish;
    end
      
endmodule