`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/19/2024 10:31:04 AM
// Design Name: 
// Module Name: whack_a_mole
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


module whack_a_mole(
    input wire clk,
//    input btnRst_game,
//    input btnRst_all,
//    input wire[15:0] switches,
//    output wire[15:0] leds,
    output wire[6:0] seg,
    output wire[3:0] an

);

wire clk_1hz;
wire clk_500hz;

wire[6:0] sec_cnt;
wire[7:0] min_cnt;

wire rst_game;
wire rst_all;
wire go;
    
    clock_divider divider(
        .clk(clk),
        .rst_all(rst_all),
        .clk_1hz(clk_1hz),
        .clk_500hz(clk_500hz)
    );
    
    clock_counter counter(
        .clk_1hz(clk_1hz),
        .sec_cnt(sec_cnt), 
        .rst(rst_all)
//        .clk_2hz(clk_2hz),
//        .min_cnt(min_cnt), 
//        .pause(pause), 
//        .sel(sel), 
//        .adj(adj)
    );
    
    debouncer db_reset_game(
        .clk(clk_500hz), 
        .button(btnRstGame), 
        .stable(rst_game)
    );
    
    debouncer db_reset_all(
        .clk(clk_500hz), 
        .button(btnRstAll), 
        .stable(rst_all)
    );
    
    debouncer db_go(
        .clk(clk_500hz), 
        .button(btnGo), 
        .stable(go)
    );
endmodule

//divide 100 Mhz clk
module clock_divider(clk, rst_all, clk_1hz, clk_500hz);
    reg[26:0] ticks_1;
    reg[27:0] ticks_2;
    reg[20:0] ticks_500;
    input clk, rst_all;
    output reg clk_1hz, clk_500hz;
    always @ (posedge clk)
    begin
        ticks_1 <= ticks_1 + 1;
//        ticks_2 <= ticks_2 + 1;
        ticks_500 <= ticks_500 + 1;
        //reset clk if necessary
        if (ticks_1 >= (100000000 - 1) || rst_all) begin
            ticks_1 <= 0;
        end
        
//        if (ticks_2 >= (50000000 - 1) || rst_2) begin
//            ticks_2 <= 0;
//        end
                
        if (ticks_500 >= (200000 - 1) || rst_all) begin
            ticks_500 <= 0;
         end
     //set output clks
     clk_1hz <= (ticks_1 > (100000000 / 2))? 1:0;

//     clk_2hz <= (ticks_2 > (50000000 / 2))? 1:0;
          
     clk_500hz <= (ticks_500 > (200000/ 2))? 1:0;
     end
endmodule

//debounce button and switch inputs
module debouncer(
    input wire clk,        // High-speed clock for sampling (clk_500hz)
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

//handle all clock display logic
module clock_counter(
    input clk_1hz,
//    input clk_500hz,
    input rst,
//    input pause,
//    input sel,
//    input adj,
    output reg [6:0] sec_cnt  // Seconds counter (0-59)
	);

//    reg pause_state; //store togglable state of pause
//    reg pause_last;
    reg reset_all_state;
    reg reset_all_last;
    
    initial begin
//        pause_state <= 0;
        reset_all_state <= 0;
    end
    
    always @ (posedge clk_1hz) begin
        if (reset_all_state) begin
            sec_cnt <= 59;
        end else begin
            sec_cnt <= sec_cnt - 1;
            if (sec_cnt == 0) begin
                sec_cnt <= 0;
            end
        end
    end

endmodule

//display time onto clock
module clock_display(clk_500hz, sec_cnt, display_seg, display_sel);
//    input clk_2hz;
    input clk_500hz;
    input [6:0] sec_cnt;
//    input [7:0] min_cnt;
//    input adj;
//    input sel;
    output reg [6:0] display_seg;
    output reg[3:0] display_sel;
    reg [1:0] digit;
    reg [3:0] digit_to_display;
    
    always @(posedge clk_500hz) begin
        //counter for select
        digit <= digit + 1;
        if (digit >= 4) begin
            digit <= 0;
        end
            
        //output selects
        case (digit)
            2'b10: begin
                display_sel <= 4'b1011; //seconds tens place
                digit_to_display <= (sec_cnt) / 10;
            end
            2'b11: begin
                display_sel <= 4'b1101; //seconds ones place
                digit_to_display <= (sec_cnt) % 10;
            end
        endcase
        
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
