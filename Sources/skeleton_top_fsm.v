`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/25/2026 10:11:06 AM
// Design Name: 
// Module Name: fsm
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module fsm (
    input wire clk,
    input wire pbin,
    input wire [15:0] physical_sw,
    output wire [15:0] physical_leds
);

    // DEBOUNCER (Cleans up the physical reset button signal)
    wire rst_clean;
    wire [31:0] switch_data; // hold the value read from the switches
    reg [31:0] led_write_data = 32'd0; // counter value here
    wire slow_clk;
  
    debouncer rst_db (
        .clk(clk),
        .pbin(pbin), 
        .pbout(rst_clean)   //generated a clean signal
    ); 

    leds switch_reader (
        .clk(clk), .rst(rst_clean),
        .btns(16'd0),               // Not used for this FSM
        .writeData(32'd0),          // We don't write to switches
        .writeEnable(1'b0),         // Disabled
        .readEnable(1'b1),          // Always ON so we can monitor switches
        .memAddress(30'd0),       
        .switches(physical_sw),     // Plug in the physical switches
        .readData(switch_data)      // output data 
    );
    
    switches led_writer (
        .clk(clk), .rst(rst_clean),
        .writeData(led_write_data),
        .writeEnable(1'b1),         // Always ON so LEDs update instantly
        .readEnable(1'b0), .memAddress(30'd0),
        .readData(),                // Ignored
        .leds(physical_leds)      
    );
    
    clock_divider ticker (
        .clk_in(clk),               // Feed it the 100MHz fast clock
        .rst(rst_clean),            // Feed it the clean reset signal
        .clk_out(slow_clk)          // It spits out the 1Hz slow clock!
    );

    
    wire [31:0] A = 32'h10101010;
    wire [31:0] B = 32'h01010101;
    
    wire [31:0] alu_result;
    wire alu_zero;
    reg [3:0] alu_ctrl_reg;
    
    ALU my_alu (
        .ALUctl(alu_ctrl_reg),
        .A(operand_A),
        .B(operand_B),
        .ALUOut(alu_result),
        .Zero(alu_zero)
    );

    localparam IDLE = 2'b00;
    localparam READ_SWITCHES = 2'b01;
    localparam EXEC_ALU = 2'b10;
    localparam WRITE_LED = 2'b11;
    
    reg [1:0] current_state, next_state;

    always @(posedge clk or posedge rst_clean) begin
        if (rst_clean) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    always @(*) begin
        case (current_state)
            IDLE: next_state = READ_SWITCHES;
            READ_SWITCHES:   next_state = EXEC_ALU;
            EXEC_ALU: next_state = WRITE_LED;
            WRITE_LED: next_state = IDLE;
            default:  next_state = IDLE;
        endcase
    end

    // Output and Control Logic
    always @(posedge clk or posedge rst_clean) begin
        if (rst_clean) begin
            alu_ctrl_reg <= 4'b0000;
            led_write_data <= 32'd0;
        end else begin
            case (current_state)
                READ_SWITCHES: begin
                    alu_ctrl_reg <= switch_data[3:0];
                end
                WRITE_LED: begin
                    led_write_data[31:16] <= 16'd0; 
                    led_write_data[15]    <= alu_zero;        
                    led_write_data[14:0]  <= alu_result[14:0];
                end
            endcase
        end
    end
