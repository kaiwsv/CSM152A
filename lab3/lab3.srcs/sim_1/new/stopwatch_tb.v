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


module stopwatch_tb;
    reg clk;
    reg rst_1;
    reg rst_2;
    reg rst_500;
    wire clk_1hz;
    wire clk_2hz;
    wire clk_500hz;
    
    clock_divider uut (
        .clk(clk),
        .rst_1(rst_1),
        .rst_2(rst_2),
        .rst_500(rst_500),
        .clk_1hz(clk_1hz),
        .clk_2hz(clk_2hz),
        .clk_500hz(clk_500hz)
    );

    //clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    initial begin
        rst_1 = 1;
        rst_2 = 1;
        rst_500 = 1;
        
        #10

                rst_1 = 0;
                rst_2 = 0;
                rst_500 = 0;
        #10000000000
        $finish;
        end
endmodule
