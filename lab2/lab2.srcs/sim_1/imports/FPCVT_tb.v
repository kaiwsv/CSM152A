`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   02:25:04 10/21/2021
// Design Name:   FPCVT
// Module Name:   C:/Users/wrand/Desktop/CSM152A/lab2/lab2/FPCVT_tb.v
// Project Name:  lab2
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: FPCVT
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module FPCVT_tb;

	// Inputs
	reg [11:0] D;

	// Outputs
	wire S;
	wire [2:0] E;
	wire [3:0] F;

	// Instantiate the Unit Under Test (UUT)
	fpcvt uut (
		.D(D), 
		.S(S), 
		.E(E), 
		.F(F)
	);
    
    reg correct_S;
    reg [2:0] correct_E;
    reg [3:0] correct_F;

	initial 
    begin
        // zero test
        #10 $display("ZERO CHECK");
        #10 D = 12'b0000_0000_0000; correct_S = 0; correct_E = 0; correct_F = 4'b0000;
        
        // positive sanity check
        #10 $display("POSITIVE SANITY CHECKS");
        #10 D = 12'b0000_0000_0001; correct_S = 0; correct_E = 0; correct_F = 4'b0001;
        #10 D = 12'b0000_0000_0010; correct_S = 0; correct_E = 0; correct_F = 4'b0010;
        #10 D = 12'b0000_0000_0100; correct_S = 0; correct_E = 0; correct_F = 4'b0100;
        #10 D = 12'b0000_0000_1000; correct_S = 0; correct_E = 0; correct_F = 4'b1000;
        #10 D = 12'b0000_0001_0000; correct_S = 0; correct_E = 1; correct_F = 4'b1000;
        #10 D = 12'b0000_0010_0000; correct_S = 0; correct_E = 2; correct_F = 4'b1000;
        #10 D = 12'b0000_0100_0000; correct_S = 0; correct_E = 3; correct_F = 4'b1000;
        #10 D = 12'b0000_1000_0000; correct_S = 0; correct_E = 4; correct_F = 4'b1000;
        #10 D = 12'b0001_0000_0000; correct_S = 0; correct_E = 5; correct_F = 4'b1000;
        #10 D = 12'b0010_0000_0000; correct_S = 0; correct_E = 6; correct_F = 4'b1000;
        #10 D = 12'b0100_0000_0000; correct_S = 0; correct_E = 7; correct_F = 4'b1000;
        
        // negative sanity check
        #10 $display("NEGATIVE SANITY CHECKS");
        #10 D = 12'b1111_1111_1111; correct_S = 1; correct_E = 0; correct_F = 4'b0001;
        #10 D = 12'b1111_1111_1110; correct_S = 1; correct_E = 0; correct_F = 4'b0010;
        #10 D = 12'b1111_1111_1100; correct_S = 1; correct_E = 0; correct_F = 4'b0100;
        #10 D = 12'b1111_1111_1000; correct_S = 1; correct_E = 0; correct_F = 4'b1000;
        #10 D = 12'b1111_1111_0000; correct_S = 1; correct_E = 1; correct_F = 4'b1000;
        #10 D = 12'b1111_1110_0000; correct_S = 1; correct_E = 2; correct_F = 4'b1000;
        #10 D = 12'b1111_1100_0000; correct_S = 1; correct_E = 3; correct_F = 4'b1000;
        #10 D = 12'b1111_1000_0000; correct_S = 1; correct_E = 4; correct_F = 4'b1000;
        #10 D = 12'b1111_0000_0000; correct_S = 1; correct_E = 5; correct_F = 4'b1000;
        #10 D = 12'b1110_0000_0000; correct_S = 1; correct_E = 6; correct_F = 4'b1000;
        #10 D = 12'b1100_0000_0000; correct_S = 1; correct_E = 7; correct_F = 4'b1000;
        
        // positive tests
        #10 $display("POSITIVE TESTS");
        #10 D = 56; correct_S = 0; correct_E = 2; correct_F = 4'b1110;
        #10 D = 41; correct_S = 0; correct_E = 2; correct_F = 4'b1010;
        #10 D = 51; correct_S = 0; correct_E = 2; correct_F = 4'b1101;
        #10 D = 51; correct_S = 0; correct_E = 2; correct_F = 4'b1101;
        #10 D = 31; correct_S = 0; correct_E = 2; correct_F = 4'b1000;
        // negative tests
        #10 $display("NEGATIVE TESTS");
        #10 D = -40; correct_S = 1; correct_E = 2; correct_F = 4'b1010;
        #10 D = -56; correct_S = 1; correct_E = 2; correct_F = 4'b1110;
        #10 D = -41; correct_S = 1; correct_E = 2; correct_F = 4'b1010;
        #10 D = -51; correct_S = 1; correct_E = 2; correct_F = 4'b1101;
        #10 D = -51; correct_S = 1; correct_E = 2; correct_F = 4'b1101;
        #10 D = -31; correct_S = 1; correct_E = 2; correct_F = 4'b1000;
        
        // rounding
        #10 $display("ROUNDING DOWN TESTS");
        #10 D = 12'b0000_0010_1100; correct_S = 0; correct_E = 2; correct_F = 4'b1011;
        #10 D = 12'b0000_0010_1101; correct_S = 0; correct_E = 2; correct_F = 4'b1011;
        #10 D = 12'b1100_0110_1101; correct_S = 1; correct_E = 6; correct_F = 4'b1110;
        #10 D = 12'b0111_1000_0000; correct_S = 0; correct_E = 7; correct_F = 4'b1111;
        #10 $display("ROUNDING UP TESTS");
        #10 D = 12'b0000_0010_1110; correct_S = 0; correct_E = 2; correct_F = 4'b1100;
        #10 D = 12'b0000_0010_1111; correct_S = 0; correct_E = 2; correct_F = 4'b1100;
        #10 D = 12'b0000_0011_1110; correct_S = 0; correct_E = 3; correct_F = 4'b1000;
        #10 D = 12'b1000_0011_1110; correct_S = 1; correct_E = 7; correct_F = 4'b1111;
        #10 D = 12'b0111_1100_0000; correct_S = 0; correct_E = 7; correct_F = 4'b1111;
        // edge cases
        #10 $display("EDGE CASES");
        #10 D = 12'b0111_1111_1111; correct_S = 0; correct_E = 7; correct_F = 4'b1111;
        #10 D = 12'b1000_0000_0000; correct_S = 1; correct_E = 7; correct_F = 4'b1111;
        
        #100 $finish;
	end
    
    initial
    begin
        $monitor(
        "%d:\tD: %b | S: %b == %b | E: %b == %b | F: %b == %b | \t %d, %d, %d",
        $time,
        D, 
        S, correct_S,
        E, correct_E,
        F, correct_F,
        D, (-1)**S * F * 2 ** E, (-1)**correct_S * correct_F * 2 ** correct_E
        );
    end
      
endmodule

