`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/19/2024 10:51:13 AM
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


module tb;

// Testbench signals
    reg clk;
//    reg adj;
//    reg seg;
    wire [6:0] seg;
    wire [3:0] an;
    reg digit_0;
    reg digit_1;
    reg digit_2;
    reg digit_3;
    
     clock_display display(
        .clk_2hz(clk_2hz), 
        .clk_500hz(clk_500hz), 
        .digit_0(digit_0), 
        .digit_1(digit_1), 
        .digit_2(digit_2), 
        .digit_3(digit_3),
        .display_seg(seg), 
        .display_sel(an),
        .blink(blink)
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
     
    // Generate 100 MHz clock
//    initial clk = 0;
//    always #5 clk = ~clk; // Toggle every 5 ns for a 100 MHz clock


    initial begin
        // Test Case 1:
        digit_0 = 0;
        digit_1 = 1;
        digit_2 = 2;
        digit_3 = 3;
        #50000
        
        // Test Case 2:
        digit_0 = 4;
        digit_1 = 5;
        digit_2 = 6;
        digit_3 = 7;
        #50000
        
        // Test Case 3:
        digit_0 = 8;
        digit_1 = 9;
        digit_2 = 10;
        digit_3 = 11;
        #50000
        
        // Test Case 4:
        digit_0 = 12;
        digit_1 = 13;
        digit_2 = 14;
        digit_3 = 15;
        #50000
        
        // Test Case 2:
        digit_0 = 16;
        digit_1 = 17;
        digit_2 = 18;
        digit_3 = 19;
        #50000
                                
        // End simulation
        #500000;
        $stop;
    end

endmodule
