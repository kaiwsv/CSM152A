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

// Helper function to convert LED state to textual representation
task display_leds(input [15:0] led_state);
    integer i;
    begin
        $write("LEDs state: ");
        for (i = 15; i >= 0; i = i - 1) begin
            $write("%d", led_state[i]);
        end
        $display("");
    end
endtask

// Test stimulus
initial begin
    // Initialize Inputs
    btnRstGame = 0;
    btnRstAll = 0;
    btnGo = 0;
    sw = 0;

    // Wait for global reset to finish
    #100;
    
    // Test sequence
    // Test Case 1: Reset Game
    $display("Resetting Game...");
    btnRstGame = 1; #20;
    btnRstGame = 0; #80;
    display_leds(led);

    // Test Case 2: Start Game with Go button
    $display("Starting Game...");
    btnGo = 1; #20;
    btnGo = 0; #80;
    display_leds(led);

    // Test Case 3: Simulate switch activity
    $display("Activating switches...");
    sw = 16'h0001; #50; // Activate first switch
    display_leds(led);
    sw = 16'h0002; #50; // Activate second switch
    display_leds(led);
    sw = 0; #100;       // Release switches

    // Test Case 4: Reset All
    $display("Resetting All...");
    btnRstAll = 1; #20;
    btnRstAll = 0; #80;
    display_leds(led);

    // Test Case 5: Random switches
    $display("Random switch activity...");
    sw = 16'hAAAA; #50; // Alternate switches
    display_leds(led);
    sw = 16'h5555; #50; // Opposite alternate switches
    display_leds(led);
    sw = 0; #100;       // Release switches

    // Finish simulation
    #200;
    $stop;
end

// Monitor score and countdown
always @(posedge clk) begin
    // Assuming seg and led capture score and countdown status
    // Decode segments and displays; logic depends on actual segment usage
    // For demonstration, a simplified conceptual display
    $display("Score / Countdown Display: seg=%b, an=%b", seg, an);
end

endmodule
