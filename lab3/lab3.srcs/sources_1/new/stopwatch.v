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
module stopwatch(clk, seg, an);
    input clk;
    output reg[6:0] seg;
    output reg[3:0] an;
    
    //temp until debouncing implemented
    reg rst_1 = 0;
    reg rst_2 = 0;
    reg rst_500 = 0;
    reg clk_rst = 0;
    reg pause = 0;
    reg sel = 0;
    reg adj = 0;
    
    //intermittent values
    reg clk_1hz;
    reg clk_2hz;
    reg clk_500hz;
    
    reg[6:0] sec_cnt;
    reg[7:0] min_cnt;
    
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
        .clk_500hz(clk_500hz), 
        .min_cnt(min_cnt), 
        .sec_cnt(sec_cnt), 
        .seg(display_seg), 
        .an(display_sel)
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
     clk_1hz = (ticks_1 > (100000000 / 2))? 1:0;

          clk_2hz = (ticks_2 > (50000000 / 2))? 1:0;
          
               clk_500hz = (ticks_500 > (200000/ 2))? 1:0;
    

     end
endmodule

//handle all clock display logic
module clock_counter(clk_1hz,clk_2hz, min_cnt, sec_cnt, rst, pause, sel, adj);
    input clk_1hz;
    input clk_2hz;
    input rst;
    input pause;
    input sel;
    input adj;
    output reg[6:0] sec_cnt;
    output reg[7:0] min_cnt;
    
    always @ (posedge clk_1hz) 
    begin
        if(rst) begin
            sec_cnt = 0;
            min_cnt = 0;
        end else if(~pause) begin
            sec_cnt = sec_cnt + 1;
        
            if(sec_cnt >= 60) begin
                sec_cnt = 0;
                min_cnt = min_cnt + 1;
            end
            
            if(min_cnt >= 100) begin
                min_cnt = 0;
            end
        end else begin
            
        end
    end
    
    always @ (posedge clk_2hz) 
    begin
        if (adj && ~pause) begin
            if (sel == 0) begin
                min_cnt = min_cnt + 1;
            end
            else if (sel == 1) begin
                sec_cnt = sec_cnt + 1;
            end
        end
    end
endmodule

//debounce button and switch inputs
module debouncing();
endmodule

//display time onto clock
module clock_display(clk_500hz, min_cnt, sec_cnt, display_seg, display_sel);
    input clk_500hz;
    input [6:0] sec_cnt;
    input [7:0] min_cnt;
    output reg [6:0] display_seg;
    output reg[3:0] display_sel;
    reg [1:0] digit;
    reg [3:0] digit_to_display;
    
    always @(clk_500hz) begin
        //counter for select
        digit <= digit + 1;
        if (digit >= 4) begin
            digit <= 0;
        end
            
        //output selects
        case(digit)
        2'b00: begin
            display_sel = 4'b0111;
            digit_to_display = (min_cnt) / 10;
            end
            2'b01: begin
                        display_sel = 4'b1011;
                        digit_to_display = (min_cnt) % 10;
                        end
                        2'b10: begin
                                    display_sel = 4'b1101;
                                    digit_to_display = (sec_cnt) / 10;
                                    end
                                    2'b11: begin
                                                display_sel = 4'b1110;
                                                digit_to_display = (sec_cnt) % 10;
                                                end
        endcase
        //output display
        case(digit_to_display)
        4'b0000: display_seg = 7'b0000001; // "0"  
        4'b0001: display_seg = 7'b1001111; // "1" 
        4'b0010: display_seg = 7'b0010010; // "2" 
        4'b0011: display_seg = 7'b0000110; // "3" 
        4'b0100: display_seg = 7'b1001100; // "4" 
        4'b0101: display_seg = 7'b0100100; // "5" 
        4'b0110: display_seg = 7'b0100000; // "6" 
        4'b0111: display_seg = 7'b0001111; // "7" 
        4'b1000: display_seg = 7'b0000000; // "8"  
        4'b1001: display_seg = 7'b0000100; // "9" 
        default: display_seg = 7'b0000001; // "0"
        endcase
    end
    
endmodule

