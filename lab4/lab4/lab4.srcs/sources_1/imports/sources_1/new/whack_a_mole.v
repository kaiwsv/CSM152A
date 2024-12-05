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
    input wire btnRst_game,
    input wire btnRst_all,
    input wire btnGo,
    input wire[15:0] switches,
    output wire[15:0] leds,
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

//reg rst_all = 0;
    
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

    );
    
    clock_display display (
        .clk_500hz(clk_500hz), 
        .sec_cnt(sec_cnt), 
        .display_seg(seg), 
        .display_sel(an)
    );
    
    debouncer db_reset_game(
        .clk(clk), 
        .button(btnRstGame), 
        .stable(rst_game)
    );
    
    debouncer db_reset_all(
        .clk(clk), 
        .button(btnRstAll), 
        .stable(rst_all)
    );
    
    debouncer db_go(
        .clk(clk), 
        .button(btnGo), 
        .stable(go)
    );
endmodule