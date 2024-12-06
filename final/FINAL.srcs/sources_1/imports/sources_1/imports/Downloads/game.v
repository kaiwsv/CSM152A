`timescale 1ns / 1ps

//state machine + main game mode logic

module game(
    input wire clk_1hz,
    input wire clk_2hz,
    input wire clk_500hz,
    input [15:0] switches,
    input initialize,
    output reg [7:0] points,
    output reg [15:0] leds
);

    parameter MAX_MOLES = 4;

    //lfsr wires
    reg lfsr_reset;
    reg lfsr_enable;
    wire [3:0] random;

    //local variables
    reg [15:0] switches_last;
    reg [15:0] leds_last;
    reg [4:0] leds_on;
    wire [15:0] is_negative;
    wire [15:0] change_point;
    wire [15:0] leds_temp;

    //rng module
    lfsr rng(clk_500hz, lfsr_reset, lfsr_enable, random);

    //switch edge module
    switch_edge switch0(switches[0], switches_last[0], leds_last[0], leds_temp[0], is_negative[0], change_point[0]);
    switch_edge switch1(switches[1], switches_last[1], leds_last[1], leds_temp[1], is_negative[1], change_point[1]);
    switch_edge switch2(switches[2], switches_last[2], leds_last[2], leds_temp[2], is_negative[2], change_point[2]);
    switch_edge switch3(switches[3], switches_last[3], leds_last[3], leds_temp[3], is_negative[3], change_point[3]);
    switch_edge switch4(switches[4], switches_last[4], leds_last[4], leds_temp[4], is_negative[4], change_point[4]);
    switch_edge switch5(switches[5], switches_last[5], leds_last[5], leds_temp[5], is_negative[5], change_point[5]);
    switch_edge switch6(switches[6], switches_last[6], leds_last[6], leds_temp[6], is_negative[6], change_point[6]);
    switch_edge switch7(switches[7], switches_last[7], leds_last[7], leds_temp[7], is_negative[7], change_point[7]);
    switch_edge switch8(switches[8], switches_last[8], leds_last[8], leds_temp[8], is_negative[8], change_point[8]);
    switch_edge switch9(switches[9], switches_last[9], leds_last[9], leds_temp[9], is_negative[9], change_point[9]);
    switch_edge switch10(switches[10], switches_last[10], leds_last[10], leds_temp[10], is_negative[10], change_point[10]);
    switch_edge switch11(switches[11], switches_last[11], leds_last[11], leds_temp[11], is_negative[11], change_point[11]);
    switch_edge switch12(switches[12], switches_last[12], leds_last[12], leds_temp[12], is_negative[12], change_point[12]);
    switch_edge switch13(switches[13], switches_last[13], leds_last[13], leds_temp[13], is_negative[13], change_point[13]);
    switch_edge switch14(switches[14], switches_last[14], leds_last[14], leds_temp[14], is_negative[14], change_point[14]);
    switch_edge switch15(switches[15], switches_last[15], leds_last[15], leds_temp[15], is_negative[15], change_point[15]);

    initial begin
        switches_last <= 0;
        leds_on = 0;
        leds = 16'd0;
        leds_last =16'd0;
        points = 0;
        lfsr_enable <= 1;
        lfsr_reset <= 0;
    end

    always @(posedge clk_500hz) begin
    
        if (initialize) begin
            switches_last <= 0;
            leds_on = 0;
            leds = 16'd0;
            leds_last =16'd0;
            points = 0;


            lfsr_enable <= 1;
            lfsr_reset <= 0;
        end
        
        leds = leds_temp;
            
        //calculations for each switch - for loop doesn't work
        //add points as necessary
        points = points + (is_negative[0] == 0 ? change_point[0] : -change_point[0]);
        points = points + (is_negative[1] == 0 ? change_point[1] : -change_point[1]);
        points = points + (is_negative[2] == 0 ? change_point[2] : -change_point[2]);
        points = points + (is_negative[3] == 0 ? change_point[3] : -change_point[3]);
        points = points + (is_negative[4] == 0 ? change_point[4] : -change_point[4]);
        points = points + (is_negative[5] == 0 ? change_point[5] : -change_point[5]);
        points = points + (is_negative[6] == 0 ? change_point[6] : -change_point[6]);
        points = points + (is_negative[7] == 0 ? change_point[7] : -change_point[7]);
        points = points + (is_negative[8] == 0 ? change_point[8] : -change_point[8]);
        points = points + (is_negative[9] == 0 ? change_point[9] : -change_point[9]);
        points = points + (is_negative[10] == 0 ? change_point[10] : -change_point[10]);
        points = points + (is_negative[11] == 0 ? change_point[11] : -change_point[11]);
        points = points + (is_negative[12] == 0 ? change_point[12] : -change_point[12]);
        points = points + (is_negative[13] == 0 ? change_point[13] : -change_point[13]);
        points = points + (is_negative[14] == 0 ? change_point[14] : -change_point[14]);
        points = points + (is_negative[15] == 0 ? change_point[15] : -change_point[15]);

        if (points[7] || points < 0) //if negative
            points <= 0;

        //turn off LEDs that are hit
        leds = leds_temp;
        leds_on = leds_last[0] + leds_last[1] + leds_last[2] + leds_last[3] +
                        leds_last[4] + leds_last[5] + leds_last[6] + leds_last[7] +
                        leds_last[8] + leds_last[9] + leds_last[10] + leds_last[11] +
                        leds_last[12] + leds_last[13] + leds_last[14] + leds_last[15];

        //turn on new LED if necessary (place mole), use constantly generated random variable from lfsr
        //moles appear from lfsr deterministic pseudorandom random string- behaves like truly random since 
        //player inputs are vary wildly and effectively cause the output moles to be truly random 
        //tries index random, if it's valid check if there's room for another mole, if so add a mole there

        //only occurs if there's few moles (<MAX_MOLES) and led is not already on 
        if (leds_last[random] == 0 && leds_on < MAX_MOLES) begin
            leds_last[random] = 1;
            leds_on = leds_on + 1;
        end
        
        //update last state variables for next loop logic
        switches_last = switches;
        leds_last = leds;
    end
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
    output reg [1:0] state,
    output [15:0] leds,
    output [6:0] display_seg,
    output [3:0] display_sel
);

//4 states:
//00: status
//01: start game
//10: in game //only implementing this and finish for now
//11: finish game

//wires
wire [7:0] score;
wire [3:0] countdown_start;
wire countdown_game;
reg [30:0] countdown_finish;
reg initialize;

//score display after finish
reg [6:0] finish_digit_0, finish_digit_1, finish_digit_2, finish_digit_3;

//status display: hi and games played
reg [6:0] status_digit_0, status_digit_1, status_digit_2, status_digit_3;

//score display during game
wire [6:0] game_digit_0;
wire [6:0] game_digit_1;
wire [6:0] game_digit_2;
wire [6:0] game_digit_3;

//final output display - determined by state machine state
reg [6:0] digit_0, digit_1, digit_2, digit_3;

//local variables
reg [3:0] games_played;
reg [10:0] high_score; 
wire resets;
reg status;

//allow other code to simply check if any reset sohuld occur
assign resets = resetGame || resetAll;

//initialize values and states - begin game immediately
initial begin
    state <= 2'b10;
    games_played <= 0;
    high_score <= 0;
    initialize <= 1;
    status <= 0;
    countdown_finish <= 0;
end


//handle state transitions
always @(posedge clk) begin

     countdown_finish = countdown_finish - 1;
    
    if (initialize && ~clk_1hz)
        initialize = 1'b0; //reset initialize status
    //initialize should just be high for one clock cycle, enough for anything dependent to run

    //start to game
     //&& countdown_start == 0
    if (state == 2'b01 || resets) begin
        state <= 2'b10;
        initialize = 1'b1;
        if (resetAll) begin
            games_played <= 0;
            high_score <= 0;
        end
    end

    //game to end
    if (state == 2'b10 && countdown_game == 1) begin
        state <= 2'b11;
        initialize = 1'b1;

        //update global statistics
        games_played <= games_played + 1;
        if (score > high_score) begin
            high_score <= score;
        end
        
        //display game results
        //SC: [score]
        finish_digit_3 <= 5'b10001; // "S"
        finish_digit_2 <= 5'b11111; //show nothing next to S
        finish_digit_1 <= score / 10; //tens place
        finish_digit_0 <= score % 10; //ones place
        
        countdown_finish = 500000000; //5 seconds of counting down before status
    end

     //end to status
     if (state == 2'b11 && (countdown_finish == 0 || countdown_finish < 0)) begin
         state <= 2'b00;
         initialize = 1'b1;
         status_digit_0 = games_played / 10;
         status_digit_1 = games_played % 10;
         status_digit_2 <= high_score / 10;
         status_digit_3 <= high_score % 10;
     end
     
end

always @(posedge clk) begin
    //per state behavior - set output digits
    // game
    if (state == 2'b10) begin
        digit_0 <= game_digit_0;
        digit_1 <= game_digit_1;
        digit_2 <= game_digit_2;
        digit_3 <= game_digit_3;
    end
    // finish
    if (state == 2'b11) begin
        digit_0 <= finish_digit_0;
        digit_1 <= finish_digit_1;
        digit_2 <= finish_digit_2;
        digit_3 <= finish_digit_3;
    end
    //status - high score + games played
    if (state == 2'b00) begin
        digit_0 <= status_digit_0;
        digit_1 <= status_digit_1;
        digit_2 <= status_digit_2;
        digit_3 <= status_digit_3;
    end
end
    
    //modules
    //game state - only state with module due to complexity
    game play_game(
        .clk_1hz(clk_1hz),
        .clk_2hz(clk_2hz),
        .clk_500hz(clk_500hz),
        .switches(switches),
        .initialize(initialize),
        .points(score),
        .leds(leds)
    );
    
    //handles display output during game mode - indicates when state transition should occur
    countdown game_countdown(
        .clk_1hz(clk_1hz),
        .clk_500hz(clk_500hz),
        .rst_game(resets),
        .points(score),
        .countdown_game(countdown_game),
        .digit_0(game_digit_0),
        .digit_1(game_digit_1),
        .digit_2(game_digit_2),
        .digit_3(game_digit_3)
    );
    
    //take in desired output digits in binary and output multiplexed 7 segment display code
    clock_display display(
        .clk_2hz(clk_2hz), 
        .clk_500hz(clk_500hz), 
        .digit_0(digit_0), 
        .digit_1(digit_1), 
        .digit_2(digit_2), 
        .digit_3(digit_3), 
        .blink(), 
        .display_seg(display_seg), 
        .display_sel(display_sel)
    );
    
endmodule