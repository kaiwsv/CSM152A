`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/03/2024 10:15:19 AM
// Design Name: 
// Module Name: tb
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

module tb;

    // Testbench signals
    reg clk;
    reg btnRst;
    reg btnPause;
    reg adj;
    reg sel;
    wire [6:0] seg;
    wire [3:0] an;

    // Instantiate the whack a mole module
    whack_a_mole uut (
        .clk(clk),
//        .btnRst(btnRst),
        .seg(seg),
        .an(an)
    );

    // Generate 100 MHz clock
    initial clk = 0;
    always #5 clk = ~clk; // Toggle every 5 ns for a 100 MHz clock

    // Test procedure
    initial begin
        // Initialize inputs

        // Wait for global reset
        #100;

        // Test Case 1: Reset the stopwatch
//        btnRst = 1;
//        #10 btnRst = 0;
        #100000; // Wait to observe reset effect

        // End simulation
        #500000;
        $stop;
    end

endmodule

