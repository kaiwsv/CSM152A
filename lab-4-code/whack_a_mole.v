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
    input wire[15:0] switches,
    output wire[15:0] leds,
    output wire[6:0] seg,
    output wire[3:0] an

);
    clock_divider divider(
    .clk(clk),
    .rst_1(rst_game),
    .rst_2(rst_all),
    .rst_500(rst_500),
    .clk_1hz(clk_1hz),
    .clk_2hz(clk_2hz),
    .clk_500hz(clk_500hz)
);
    debouncer db_reset_game(
        .clk(clk_500hz), 
        .button(btnRstGame), 
        .stable(resetGame)
    );
    
    debouncer db_reset_all(
        .clk(clk_500hz), 
        .button(btnRstAll), 
        .stable(resetAll)
    );
    
    debouncer db_go(
        .clk(clk_500hz), 
        .button(btnGo), 
        .stable(go)
    );
    
    state_manager states(
        .clk(clk),
        .clk_1hz(clk_1hz),
        .clk_2hz(clk_2hz),
        .clk_500hz(clk_500hz),
        .resetGame(resetGame),
        .resetAll(resetAll),
        .go(go)
        .switches(switches),
        .leds(leds),
        .seg(seg),
        .an(an)
    );
endmodule
