`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/31/2024 11:17:03 AM
// Design Name: 
// Module Name: stopwatch
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
//top level module
module stopwatch(
    input wire clk,
    input wire btnRst,
    input wire btnPause,
    input wire adj,
    input wire sel,
    output wire[6:0] seg,
    output wire[3:0] an
    );
    
    //temp until debouncing implemented
    reg rst_1 = 0;
    reg rst_2 = 0;
    reg rst_500 = 0;
//    reg clk_rst = 0;
//    reg pause = 0;
//    reg sel = 0;
//    reg adj = 0;
    
    //pass values
    wire clk_1hz;
    wire clk_2hz;
    wire clk_500hz;
    
    wire[6:0] sec_cnt;
    wire[7:0] min_cnt;
    
    wire clk_rst;
    wire pause;
    
    clock_divider divider(
        .clk(clk),
        .rst_1(rst_1),
        .rst_2(rst_2),
        .rst_500(rst_500),
        .clk_1hz(clk_1hz),
        .clk_2hz(clk_2hz),
        .clk_500hz(clk_500hz)
    );
    
    clock_counter counter(
        .clk_1hz(clk_1hz),
        .clk_2hz(clk_2hz),
        .min_cnt(min_cnt), 
        .sec_cnt(sec_cnt), 
        .rst(clk_rst), 
        .pause(pause), 
        .sel(sel), 
        .adj(adj)
    );
    
    clock_display display (
        .clk_2hz(clk_2hz),
        .clk_500hz(clk_500hz), 
        .min_cnt(min_cnt), 
        .sec_cnt(sec_cnt), 
        .display_seg(seg), 
        .display_sel(an),
        .adj(adj),
        .sel(sel)
    );
    
    debouncer db_rst(
        .clk(clk_500hz), 
        .button(btnRst), 
        .stable(clk_rst)
    );
    
    debouncer db_pause(
        .clk(clk_500hz), 
        .button(btnPause), 
        .stable(pause)
    );
endmodule

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

//handle all clock display logic
module clock_counter(
    input clk_1hz,
    input clk_2hz,
    input clk_500hz,
    input rst,
    input pause,
    input sel,
    input adj,
    output reg [6:0] sec_cnt,  // Seconds counter (0-59)
    output reg [7:0] min_cnt   // Minutes counter (0-99)
//    output reg pause_state,
//    output reg reset_state
);

    reg pause_state; //store togglable state of pause
    reg pause_last;
    reg reset_state;
    reg reset_last;
    
    initial begin
        pause_state <= 0;
        reset_state <= 0;
    end
    
    //button flip flops
    always @ (posedge clk_2hz) begin
        if (rst != reset_last) begin
            reset_state <= ~reset_state;
        end
        if (pause == 1 && pause_last == 0) begin
            pause_state <= ~pause_state;  // Toggle the pause_state on 'pause' signal
        end
        pause_last <= pause;
        reset_last <= rst;
    end

    always @ (posedge clk_2hz) begin
        if (reset_state) begin
            sec_cnt <= 0;
            min_cnt <= 0;
        end else begin
            if (adj) begin
                // Adjustment mode (triggered by clk_2hz)
                if (sel == 0) begin
                    // Adjust minutes
                    if (clk_2hz) begin
                        min_cnt <= min_cnt + 1;
                        if (min_cnt >= 99) begin
                            min_cnt <= 0;
                        end
                    end
                end else if (sel == 1) begin
                    // Adjust seconds
                    if (clk_2hz) begin
                        sec_cnt <= sec_cnt + 1;
                        if (sec_cnt >= 59) begin
                            sec_cnt <= 0;
                            min_cnt <= min_cnt + 1;
                        end
                    end
                end
             end
            else if (~pause_state && ~adj) begin
                // Normal counting mode (triggered by clk_1hz)
                if (clk_1hz) begin
                    sec_cnt <= sec_cnt + 1;
                    if (sec_cnt >= 59) begin
                        sec_cnt <= 0;
                        min_cnt <= min_cnt + 1;
                    end

                    if (min_cnt >= 99) begin
                        min_cnt <= 0;
                    end
                end
            end
        end
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

//display time onto clock
module clock_display(clk_2hz, clk_500hz, min_cnt, sec_cnt, display_seg, display_sel, adj, sel);
    input clk_2hz;
    input clk_500hz;
    input [6:0] sec_cnt;
    input [7:0] min_cnt;
    input adj;
    input sel;
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
            2'b00: begin
                display_sel <= 4'b1110; //minutes tens place
                digit_to_display <= (min_cnt) / 10;
            end
            2'b01: begin
                display_sel <= 4'b0111; //minutes ones place
                digit_to_display <= (min_cnt) % 10;
            end
        endcase
        
        //if adjust is on and clk_2hz is low, turn off everything
        if (adj && ~clk_2hz) begin 
            if (sel == 0) begin //minutes
                display_sel <= 4'b1001;
            end
            else begin //seconds
                display_sel <= 4'b0110;
            end
        end
        
        //output display
        case(digit_to_display)
        4'b0000: display_seg <= 7'b1000000; // "0"  
        4'b0001: display_seg <= 7'b1111001; // "1" 
        4'b0010: display_seg <= 7'b0100100; // "2" 
        4'b0011: display_seg <= 7'b0110000; // "3" 
        4'b0100: display_seg <= 7'b0011001; // "4" 
        4'b0101: display_seg <= 7'b0010010; // "5" 
        4'b0110: display_seg <= 7'b0000010; // "6" 
        4'b0111: display_seg <= 7'b1111000; // "7" 
        4'b1000: display_seg <= 7'b0000000; // "8"  
        4'b1001: display_seg <= 7'b0010000; // "9" 
        default: display_seg <= 7'b1000000; // "0"
        endcase
    end
    
endmodule

