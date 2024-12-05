`timescale 1ns / 1ps

module game_tb;

    // Inputs
    reg clk_1hz;
    reg clk_500hz;
    reg [15:0] switches;
    reg [1:0] state;

    // Outputs
    wire [15:0] leds;
//    wire [3:0][6:0] digits;

    // Instantiate the Unit Under Test (UUT)
    game uut (
        .clk_1hz(clk_1hz),
        .clk_500hz(clk_500hz),
        .switches(switches),
        .state(state),
        .leds(leds)
//        .digits(digits)
    );

    // Clock generation
//    always begin
//        #10 clk_1hz = ~clk_1hz;    // Generate 1Hz clock
//    end

    always begin
        #2 clk_500hz = ~clk_500hz;  // Generate 500Hz clock
    end

    // Stimulus process
    initial begin
        // Initialize signals
        clk_1hz = 0;
        clk_500hz = 0;
        switches = 16'b0;
        state = 2'b00;  // Set initial state (status)
//    end        
        // Wait for a few clock cycles
        #100;

        // Test case 1: Flip a switch and check mole placement
        switches = 16'b1111111111111111;  // Flip all switches
        #50; // Wait for processing

        // Test case 2: Flip another switch and check if points change
        switches = 16'b0000000000000100;  // Flip switch 2
        #50; // Wait for processing

        // Test case 3: Simulate a hit on an existing mole (flip switch 1)
        switches = 16'b0000000000000010;  // Flip switch 1 (hit mole)
        #50;

        // Test case 4: Flip a non-mole switch (should deduct points)
        switches = 16'b0000000000001000;  // Flip switch 3 (missed mole)
        #50;

        // Test case 5: Reset the game
        switches = 16'b0;  // No switches flipped
        #50;

        // Add more test cases as needed to simulate different game conditions

        // End the simulation
        $stop;
    end

endmodule
