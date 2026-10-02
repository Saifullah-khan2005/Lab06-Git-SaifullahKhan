`timescale 1ns / 1ps

module ALU_top(
    input [15:0] sw,   // 16 switches on Basys 3
    output [15:0] led  // 16 LEDs on Basys 3
);
    
    // Map switches to inputs. Pad the upper 26 bits with zeros.
    wire [3:0]  alu_ctl = sw[15:12]; // Leftmost 4 switches
    wire [31:0] A_ext   = {26'd0, sw[11:6]};  // Middle 6 switches
    wire [31:0] B_ext   = {26'd0, sw[5:0]};   // Rightmost 6 switches
    
    wire [31:0] alu_out;
    wire zero;
    
    // Instantiate your existing ALU
    module_ALU uut (
        .ALUctl(alu_ctl),
        .A(A_ext),
        .B(B_ext),
        .ALUOut(alu_out),
        .Zero(zero)
    );
    
    // Map outputs to LEDs
    assign led[14:0] = alu_out[14:0]; // Lower 15 bits of result to first 15 LEDs
    assign led[15]   = zero;          // Leftmost LED shows the Zero flag

endmodule