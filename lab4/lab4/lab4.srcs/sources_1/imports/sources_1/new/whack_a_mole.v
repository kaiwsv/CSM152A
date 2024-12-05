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
    input wire btnRstGame,
    input wire btnRstAll,
    input wire btnGo,
    input wire[15:0] sw,
    output reg dp,
    output wire[15:0] led,
    output wire[6:0] seg,
    output wire[3:0] an
);

//internal wires
    wire clk_1hz;
    wire clk_2hz;
    wire clk_500hz;

    wire[6:0] sec_cnt;
    wire[7:0] min_cnt;

    wire rst_game;
    wire rst_all;
    wire go;

    initial begin
        dp <= 0;
    end
    
    state_manager manager(
        .clk(clk),
        .clk_1hz(clk_1hz),
        .clk_2hz(clk_2hz),
        .clk_500hz(clk_500hz),
        .resetGame(rst_game),
        .resetAll(rst_all),
        .go(go),
        .switches(),
        .state(),
        .leds(leds),
        .display_seg(seg),
        .display_sel(an)
    );
    
    clock_divider divider(
        .clk(clk),
        .rst_1(),
        .rst_2(),
        .rst_500(),
        .clk_1hz(clk_1hz),
        .clk_2hz(clk_2hz),
        .clk_500hz(clk_500hz)
    );
    
//    clock_counter counter(
//        .clk_1hz(clk_1hz),
//        .sec_cnt(sec_cnt), 
//        .rst(rst_all)
//    );
    
//    clock_display display (
//        .clk_500hz(clk_500hz), 
//        .sec_cnt(sec_cnt), 
//        .display_seg(seg), 
//        .display_sel(an)
//    );
    
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