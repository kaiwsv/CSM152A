`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/01/2024 11:33:35 AM
// Design Name: 
// Module Name: tb_led_flash
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


module tb_led_flash;
    reg clk;
    reg rst;
    wire clk_1hz;
    
    led_flash uut (
            .clk(clk),
            .rst(rst),
            .clk_1hz(clk_1hz)
        );
        
    initial begin
        rst = 1;
        #10
        rst = 0;
        #1000000000
        $finish;
    end
endmodule

