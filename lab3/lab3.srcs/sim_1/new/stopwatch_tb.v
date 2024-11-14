`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/07/2024 10:21:43 AM
// Design Name: 
// Module Name: stopwatch_tb
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


`timescale 1ns / 1ps

module stopwatch_tb;

    // Testbench signals
    reg clk;
    reg btnRst;
    reg btnPause;
    reg adj;
    reg sel;
    wire [6:0] seg;
    wire [3:0] an;

    // Instantiate the stopwatch module
    stopwatch uut (
        .clk(clk),
        .btnRst(btnRst),
        .btnPause(btnPause),
        .adj(adj),
        .sel(sel),
        .seg(seg),
        .an(an)
    );

    // Generate 100 MHz clock
    initial clk = 0;
    always #5 clk = ~clk; // Toggle every 5 ns for a 100 MHz clock

    // Test procedure
    initial begin
        // Initialize inputs
        btnRst = 0;
        btnPause = 0;
        adj = 0;
        sel = 0;

        // Wait for global reset
        #100;

        // Test Case 1: Reset the stopwatch
        btnRst = 1;
        #10 btnRst = 0;
        #100000; // Wait to observe reset effect

        // Test Case 2: Start the stopwatch and let it run
        #100000; // Wait to observe counting

        // Test Case 3: Pause and resume
        btnPause = 1;
        #10 btnPause = 0;
        #50000; // Wait while paused
        btnPause = 1;
        #10 btnPause = 0;
        #100000; // Wait to observe resumed counting

        // Test Case 4: Enter adjustment mode and adjust minutes
        adj = 1;
        sel = 0; // Adjust minutes
        #50000;
        adj = 0;

        // Test Case 5: Enter adjustment mode and adjust seconds
        adj = 1;
        sel = 1; // Adjust seconds
        #50000;
        adj = 0;

        // Test Case 6: Pause and reset during running
        btnPause = 1;
        #10 btnPause = 0;
        #50000;
        btnRst = 1;
        #10 btnRst = 0;

        // End simulation
        #500000;
        $stop;
    end

endmodule
