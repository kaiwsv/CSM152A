`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/19/2024 10:08:55 AM
// Design Name: 
// Module Name: game
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


module game(
    input wire clk_1hz,
    input wire clk_500hz,
    input [15:0] switches,
    output [15:0] leds,
    output [3:0][6:0] digits
);
endmodule

module start(

);
endmodule

module finish(

);
endmodule

module status(

);
endmodule

module state_manager(
    input clk,
    input clk_1hz,
    input clk_2hz,
    input clk_500hz,
    input resetGame,
    input resetAll,
    input go,
    input [15:0] switches,
    output [15:0] leds
    output [6:0] display_seg;
    output [3:0] display_sel;
);

//wires
wire [10:0] score;
wire [3:0] countdown_start;
wire [5:0] countdown_game;
wire [3:0] countdown_finish;
wire [6:0] display_seg,
wire [3:0] display_sel,
wire initialize

//0-3 correspond to states, 4 is output
wire [4:0][3:0][6:0] digits;
wire [4:0][15:0] leds;

//local variables
//4 states:
//00: status
//01: start game
//10: in game
//11: finish game
reg [1:0] state;
reg [3:0] games_played;
reg [10:0] high_score; //can be negative

initial begin
    state = 2'b00;
    games_played = 0;
    high_score = 0;
    initialize = 0
end

//handle state transitions
always @(posedge clk) begin
    if (initialize)
        initialize = 1'b0;
    //resets
    if (resetGame || resetAll) begin
        state <= 2'b00;
        initialize = 1'b1;
        if (resetAll) begin
            games_played = 0;
            high_score = 0;
        end
    end

    //status to start
    if (state == 2'b00 && go) begin
        state <= 2'b01;
        initialize = 1'b1;
    end

    //start to game
    if (state == 2'b01 && countdown_start == 0) begin
        state <= 2'b10;
        initialize = 1'b1;
    end

    //game to end
    if (state = 2'b10 && countdown_game == 0) begin
        state <= 2'b11;
        initialize = 1'b1;

        //update global statistics
        games_played <= games_played + 1;
        if (score > high_score)
            high_score <= score;
    end

    //end to status
    if (state == 2'b11 && countdown_finish == 0) begin
        state <= 2'b00;
        initialize = 1'b1;
    end
end

always @(posedge clk) begin
    //per state behavior
    // status
    if (state == 2'b00) begin
        digits[4] = digits[0];
        leds[4] = leds[0];
    end
    // start
    if (state == 2'b01) begin
        digits[4] = digits[1];
        leds[4] = leds[1];
    end
    // game
    if (state == 2'b10) begin
        digits[4] = digits[2];
        leds[4] = leds[2];
    end
    // finish
    if (state == 2'b11) begin
        digits[4] = digits[3];
        leds[4] = leds[3];
    end

end

status status_display(

);

start start_game(

);

game in_game(

);

finish finish_game(

);

clock_display display(
    .clk_2hz(clk_2hz),
    .clk_500hz(clk_500hz),
    .digit_0(digits[4][0]),
    .digit_1(digits[4][1]),
    .digit_2(digits[4][2]),
    .digit_3(digits[4][3]),
    .blink(),
    .display_seg(display_seg),
    .display_sel(display_sel)
);

endmodule