`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/19/2024 10:11:24 AM
// Design Name: 
// Module Name: helpers
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
//divide 100 Mhz clk
module clock_divider(clk, rst_1, rst_2, rst_500, clk_1hz, clk_2hz, clk_500hz);
    reg[26:0] ticks_1;
    reg[27:0] ticks_2;
    reg[20:0] ticks_500;
    input clk, rst_1, rst_2, rst_500;
    output reg clk_1hz, clk_2hz, clk_500hz;
    always @ (posedge clk)
    begin
        ticks_1 <= ticks_1 + 1;
        ticks_2 <= ticks_2 + 1;
        ticks_500 <= ticks_500 + 1;
        //reset clk if necessary
        if (ticks_1 >= (100000000 - 1) || rst_1) begin
            ticks_1 <= 0;
        end
        
        if (ticks_2 >= (50000000 - 1) || rst_2) begin
            ticks_2 <= 0;
        end
                
        if (ticks_500 >= (200000 - 1) || rst_500) begin
            ticks_500 <= 0;
         end
     //set output clks
     clk_1hz <= (ticks_1 > (100000000 / 2))? 1:0;

     clk_2hz <= (ticks_2 > (50000000 / 2))? 1:0;
          
     clk_500hz <= (ticks_500 > (200000/ 2))? 1:0;
     end
endmodule

//debounce button and switch inputs
module debouncer(
    input wire clk,        // High-speed clock for sampling (clk: 100MHz)
    input wire button,     // Noisy button input
    output reg stable      // Debounced stable output
);

    parameter stable_threshold = 2; //arbitrary threshold
    
    reg [8:0] counter;
    reg button_last;
    
    initial begin
        stable = 0;
        counter = 0;
        button_last = 0;
    end
    
    always @(posedge clk) begin
        if (button != button_last) begin
            counter <= 0;
        end else begin
            counter <= counter + 1;
            
            if (counter >= stable_threshold) begin  
                stable <= button_last;
            end
         end
         button_last <= button;
    end
endmodule

//display time onto clock
module clock_display(clk_2hz, clk_500hz, digit_0, digit_1, digit_2, digit_3, blink, display_seg, display_sel);
    input clk_2hz;
    input clk_500hz;
    input [6:0] digit_0;
    input [6:0] digit_1;
    input [6:0] digit_2;
    input [6:0] digit_3;
    input blink;
    output reg [6:0] display_seg;
    output reg[3:0] display_sel;
    reg [1:0] digit;
    reg [6:0] digit_to_display;
    
    always @(posedge clk_500hz) begin
        //counter for select
        digit <= digit + 1;
        if (digit >= 4) begin
            digit <= 0;
        end
            
        //output selects
        case (digit)
            2'b10: begin
                display_sel <= 4'b1011; //LSB
                digit_to_display <= digit_0;
            end
            2'b11: begin
                display_sel <= 4'b1101;
                digit_to_display <= digit_1;
            end
            2'b00: begin
                display_sel <= 4'b1110;
                digit_to_display <= digit_2;
            end
            2'b01: begin
                display_sel <= 4'b0111; //MSB
                digit_to_display <= digit_3;
            end
        endcase
        
        //if blink is on and clk_2hz is low, turn off everything
        if (blink && ~clk_2hz) begin 
            display_sel <= 4'b1111;
        end
        
        //output display
        case(digit_to_display)
        // Numbers 0-9
        5'b00000: display_seg <= 7'b1000000; // "0"
        5'b00001: display_seg <= 7'b1111001; // "1"
        5'b00010: display_seg <= 7'b0100100; // "2"
        5'b00011: display_seg <= 7'b0110000; // "3"
        5'b00100: display_seg <= 7'b0011001; // "4"
        5'b00101: display_seg <= 7'b0010010; // "5"
        5'b00110: display_seg <= 7'b0000010; // "6"
        5'b00111: display_seg <= 7'b1111000; // "7"
        5'b01000: display_seg <= 7'b0000000; // "8"
        5'b01001: display_seg <= 7'b0010000; // "9"

        // ASCII Characters
        5'b01010: display_seg <= 7'b0000011; // "B"
        5'b01011: display_seg <= 7'b0000110; // "E"
        5'b01100: display_seg <= 7'b0100001; // "G"
        5'b01101: display_seg <= 7'b0001001; // "H"
        5'b01110: display_seg <= 7'b1111001; // "I" (same as "1")
        5'b01111: display_seg <= 7'b1000000; // "O" (same as "0")
        
        // Additional Characters
        5'b10000: display_seg <= 7'b0001100; // "P"
        5'b10001: display_seg <= 7'b0010010; // "S" (same as "5")
        5'b10010: display_seg <= 7'b0000111; // "T"
        5'b10011: display_seg <= 7'b0111111; // "!" (only segment G lit)

        default: display_seg <= 7'b1111111;   // Blank or error state
    endcase
    end
    
endmodule

