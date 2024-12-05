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
    wire [15:0] switches;

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
        .switches(switches),
        .state(),
        .leds(led),
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
    
    debouncer db_sw_0(
        .clk(clk), 
        .button(sw[0]), 
        .stable(switches[0])
    );
    
    debouncer db_sw_1(
        .clk(clk), 
        .button(sw[1]), 
        .stable(switches[1])
    );
    
    debouncer db_sw_2(
        .clk(clk), 
        .button(sw[2]), 
        .stable(switches[2])
    );
    
    debouncer db_sw_3(
        .clk(clk), 
        .button(sw[3]), 
        .stable(switches[3])
    );
    
    debouncer db_sw_4(
        .clk(clk), 
        .button(sw[4]), 
        .stable(switches[4])
    );
    
    debouncer db_sw_5(
        .clk(clk), 
        .button(sw[5]), 
        .stable(switches[5])
    );
    
    debouncer db_sw_6(
        .clk(clk), 
        .button(sw[6]), 
        .stable(switches[6])
    );
    
    debouncer db_sw_7(
        .clk(clk), 
        .button(sw[7]), 
        .stable(switches[7])
    );
    
    debouncer db_sw_8(
        .clk(clk), 
        .button(sw[8]), 
        .stable(switches[8])
    );
    
    debouncer db_sw_9(
        .clk(clk), 
        .button(sw[9]), 
        .stable(switches[9])
    );
    
    debouncer db_sw_10(
        .clk(clk), 
        .button(sw[10]), 
        .stable(switches[10])
    );
    
    debouncer db_sw_11(
        .clk(clk), 
        .button(sw[11]), 
        .stable(switches[11])
    );
    
    debouncer db_sw_12(
        .clk(clk), 
        .button(sw[12]), 
        .stable(switches[12])
    );
    
    debouncer db_sw_13(
        .clk(clk), 
        .button(sw[13]), 
        .stable(switches[13])
    );
    
    debouncer db_sw_14(
        .clk(clk), 
        .button(sw[14]), 
        .stable(switches[14])
    );
    
    debouncer db_sw_15(
        .clk(clk), 
        .button(sw[15]), 
        .stable(switches[15])
    );

endmodule