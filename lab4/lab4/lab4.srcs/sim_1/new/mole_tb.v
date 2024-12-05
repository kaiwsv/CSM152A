`timescale 1ns / 1ps

module whack_a_mole_tb;

// Inputs
reg clk;
reg btnRstGame;
reg btnRstAll;
reg btnGo;
reg [15:0] sw;

// Outputs
wire dp;
wire [15:0] led;
wire [6:0] seg;
wire [3:0] an;

// Instantiate the Unit Under Test (UUT)
whack_a_mole uut (
    .clk(clk),
    .btnRstGame(btnRstGame),
    .btnRstAll(btnRstAll),
    .btnGo(btnGo),
    .sw(sw),
    .dp(dp),
    .led(led),
    .seg(seg),
    .an(an)
);

// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk; // 100MHz clock
end

// Initialize Inputs
initial begin
    // Initialize inputs to default values
    btnRstGame = 0;
    btnRstAll = 0;
    btnGo = 0;
    sw = 0;

    // Wait for global reset
    #100;

    // Test case 1: Reset game
    btnRstGame = 1; #20;
    btnRstGame = 0; #80;

    // Test case 2: Start game with Go button
    btnGo = 1; #20;
    btnGo = 0; #80;

    // Test case 3: Activate switches to simulate hitting moles
    sw = 16'h0001; #20; // Activate first switch
    sw = 16'h0002; #20; // Activate second switch
    sw = 0; #100;       // Release switches

    // Test case 4: Reset all
    btnRstAll = 1; #20;
    btnRstAll = 0; #80;

    // Test case 5: Random switch presses
    sw = 16'h00FF; #40; // Activate several switches
    sw = 0; #100;       // Release switches

    // Continue additional test cases as needed...
end

endmodule
