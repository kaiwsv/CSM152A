//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/17/2024 11:17:43 AM
// Design Name: 
// Module Name: module_testing
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
module module_testing;

reg [11:0] linear;
reg clk;

wire S;
wire [3:0] E;
wire [3:0] F;

module_testing uut (
    .linear(linear),
    .clk(clk),
    .S(S),
    .E(E),
    .F(F)
);

always #50 clk = ~clk;

initial begin 
   clk = 0;
   linear = 12'b0000000000000;
   
   #100
   
   // Test cases    
   linear = 12'b000000101100;
   linear = 12'b000000101101;
   linear = 12'b000000101110;
   linear = 12'b000000101111;
end
endmodule
