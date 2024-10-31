`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/17/2024 10:12:16 AM
// Design Name: 
// Module Name: fpcvt
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


//good
module format_complement(D, S, A);
    input [11:0] D; //input
    output reg S; //sign bit
    output reg [11:0] A; //absolute value of D
    
    always @(*) begin
            //extract sign bit and convert 2's complement
            S = D[11];
            
            if (S == 1) 
                A = ~D + 1;
            //if 2's complement = -2048, magnitude = +2047
            else if (D == 12'b100000000000) 
                A = 12'b011111111111;    
            else
                A = D;
     end
endmodule

module priority_encoder(A, B, R, O);
    input [11:0] A; //absolute value of input
    output reg [2:0] B; //unoverflowed exponent
    output reg [3:0] R; //unrounded significand
    output reg O; //overflow rounding bit
    integer i;
    integer break = 0;
    
    always @(*) begin

        casez (A) // casez allows us to use 'z' for don't care
            12'b1??????????? : begin B = 3'd7; R = 4'b1111; O = 1; end //-2048
            12'b01?????????? : begin B = 3'd7; R = A[10:7]; O = A[6]; end // 1 leading zero
            12'b001????????? : begin B = 3'd6; R = A[9:6]; O = A[5]; end // 2 leading zeroes
            12'b0001???????? : begin B = 3'd5; R = A[8:5]; O = A[4]; end // 3 leading zeroes
            12'b00001??????? : begin B = 3'd4; R = A[7:4]; O = A[3]; end // 4 leading zeroes
            12'b000001?????? : begin B = 3'd3; R = A[6:3]; O = A[2]; end // 5 leading zeroes
            12'b0000001????? : begin B = 3'd2; R = A[5:2]; O = A[1]; end // 6 leading zeroes
            12'b00000001???? : begin B = 3'd1; R = A[4:1]; O = A[0]; end // 7 leading zeroes
            12'b00000000???? : begin B = 0; R = A[3:0]; O = 0; end // 8 or more leading zeroes
            default: begin B = 0; R = 0; O = 0; end
        endcase
    end
        
       
endmodule

module rounding_logic(R, F, O, B, E);
    input [3:0] R; //unrounded significand
    input [2:0] B; //unoverflowed exponent
    input O; //overflow rounding bit
    output reg [3:0] F; //final rounded significand/mantissa
    output reg [2:0] E;  //final exponent
    
    reg [4:0] overflow_F;
    reg [3:0] overflow_E;
    
    always @(*) begin
        overflow_F = R + O;
        overflow_E = B + overflow_F[4]; //increase exponent by one if overflow
        
        //catch exponent overflow edge case
        if (overflow_E[3]) begin
            F = 4'b1111;
            E = 3'b111;
        end
        //check for F overflow
        else begin
            F = overflow_F >> overflow_F [4]; //shift if overflowed
            E = overflow_E[2:0];
        end
    end
endmodule


module fpcvt(D,S,E,F); 
    input [11:0] D; //input 12 bit
    output S; //final sign bit
    output [2:0] E; //final exponent
    output [3:0] F; //final 
    wire [3:0] R;
    wire [2:0] B;
    wire O;
    wire [11:0] A;
    
    format_complement complement(
        .D(D),
        .S(S),
        .A(A)
    );
    
    priority_encoder encoder (
        .A(A),
        .B(B),
        .R(R),
        .O(O)
    );
    
    rounding_logic rounder (
        .R(R),
        .F(F),
        .O(O),
        .B(B),
        .E(E)
    );
    
endmodule