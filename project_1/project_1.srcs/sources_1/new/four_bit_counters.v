`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/01/2024 10:26:33 AM
// Design Name: 
// Module Name: four_bit_counters
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


module four_bit_counters(clk, rst, q);
    reg [3:0] a;
    input clk, rst;
    output reg [3:0] q;
    
    always @ (posedge clk)
    begin
        if (rst) begin
            a <= 4'b0000;
        end else begin
            a <= a + 1'b1; 
            q = a;
        end
    end
endmodule
