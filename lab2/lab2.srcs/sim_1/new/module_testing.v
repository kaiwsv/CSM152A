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

reg [11:0] A; // Input to the priority encoder
wire [2:0] B; // Unoverflowed exponent
wire [3:0] R; // Unrounded significand
wire O;       // Overflow rounding bit

// Instantiate the priority_encoder
priority_encoder uut (
    .A(A),
    .B(B),
    .R(R),
    .O(O)
);

initial begin 
    // Monitor the outputs
    $monitor("Time: %0d, A = %b, B = %b, R = %b, O = %b", $time, A, B, R, O);
    
    // Test cases
    A = 12'b000000000000; #100; // All zeros
    A = 12'b000000000001; #100; // Smallest positive value
    A = 12'b000011111111; #100; // Mid-range value
    A = 12'b000000000010; #100; // Small positive value (2)
    A = 12'b000000000011; #100; // Small positive value (3)
    A = 12'b111111111111; #100; // All ones (maximum positive value)

    // Testing specific cases for priority encoding
    A = 12'b000011000000; #100; // Case with significant bits
    A = 12'b000000110000; #100; // Another case with significant bits
    A = 12'b000000000100; #100; // Single significant bit in lower positions

    #500 $finish; // End simulation
end

endmodule

/*
reg [11:0] D;
reg clk;

wire S; //final sign bit
wire [2:0] E; //final exponent
wire [3:0] F; //final significand

//wire S;
//wire [11:0] A;

fpcvt uut (
    .D(D),
    .S(S),
    .E(E),
    .F(F)
);

always #50 clk = ~clk;

initial begin 
   clk = 0;
   D = 12'b0000000000000;
   
   #100
   
   // Test cases    
   D = 12'b000000101100; #100; // Test Case 1
   D = 12'b000000101101; #100; // Test Case 2
   D = 12'b100000101110; #100; // Test Case 3
   D = 12'b100000101111; #100; // Test Case 4
   
   #500 $finish;
end

initial begin
    $monitor("Time: %0d, D = %b, S = %b, E = %b, F = %b", $time, D, S, E, F);
end
endmodule
*/
