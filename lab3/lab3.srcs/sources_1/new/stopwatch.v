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
module stopwatch(clk, seg, an, btn_rst, btn_pause, sw_adj, sw_sel);
    input clk;
    input btn_rst;
    input btn_pause;
    input sw_adj;
    input sw_sel;
    output wire[6:0] seg;
    output wire[3:0] an;
    
    
    //temp until debouncing implemented
    wire rst_1 = 0;
    wire rst_2 = 0;
    wire rst_500 = 0;
    wire clk_rst = 0;
    wire pause = 0;
    wire sel = 0;
    wire adj = 0;
    
    //intermittent values
    wire clk_1hz;
    wire clk_2hz;
    wire clk_500hz;
    
    wire [6:0] sec_cnt;
    wire [7:0] min_cnt;
    
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
        .display_seg(seg), 
        .display_sel(an)
    );
    
    debouncing debounce_rst(
        .clk_500hz(clk_500hz), 
        .btn(btn_rst), 
        .signal(clk_rst)
    );
    
    debouncing debounce_pause(
        .clk_500hz(clk_500hz), 
        .btn(btn_pause), 
        .signal(pause)
    );
endmodule

//divide 100 Mhz clk into 1, 2, 500hz
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
//take in debounced button inputs for reset
//output min, sec values to display
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
module debouncing(clk_500hz, btn, signal);
    input clk_500hz;
    input btn;
    output reg signal;
    integer cnt = 0;
    integer btn_last = 0;
    
    
    always @(clk_500hz) begin
        if(btn == btn_last) begin
            cnt = cnt + 1;
        end else begin
            cnt = 0;
        end
        
        if(cnt > 5) begin // threshold of 5
            signal = btn_last;
        end
        btn_last = btn;
    end

endmodule

//display time onto clock
//take in clk_500hz, 2 digits for min_cnt (0-99), 2 digits for sec_cnt (0-59)
//output display_seg, display_sel values
module clock_display(clk_500hz, min_cnt, sec_cnt, display_seg, display_sel, adj);
    input clk_500hz;
    input [6:0] sec_cnt;
    input [7:0] min_cnt;
    input adj;
    output reg [6:0] display_seg;
    output reg[3:0] display_sel;
    reg [1:0] digit = 2'b00;
    reg [3:0] digit_to_display = 4'b0000;
    
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
        
        if (adj && ~clk_500hz) begin
            display_sel = 4'b1111;
        end
    end
    
endmodule

