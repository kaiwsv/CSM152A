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
//    reg clk;
    reg clk_500hz;
    reg [7:0] min_cnt;
    reg [6:0] sec_cnt;
    wire [6:0] display_seg;
    wire [3:0] display_sel;
    integer i;
    
    clock_display uut(
        .clk_500hz(clk_500hz), 
        .min_cnt(min_cnt), 
        .sec_cnt(sec_cnt), 
        .display_seg(display_seg), 
        .display_sel(display_sel)
    );

    //clock generation
    initial begin
        clk_500hz = 0;
        forever #(500000) clk_500hz = ~clk_500hz;
    end
    
    initial begin
    #10
        min_cnt = 7'b0000000;
        sec_cnt = 6'b000000;
        
//        #100000000
//                min_cnt = 7'b0000001;
//                sec_cnt = 6'b000001;
//                        #100000000
                
//        #1000000
//        min_cnt = 7'b0000010;
//        sec_cnt = 6'b000010;
        
        i = 0;
        while (i < 1000) begin
            min_cnt = i / 60;
            sec_cnt = i % 60;
            #1000000 i = i + 1;
        end
        
        #100000000
        $finish;
        end
endmodule
