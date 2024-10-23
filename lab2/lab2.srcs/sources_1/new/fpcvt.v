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
        for(i = 0; i < 12 && break == 0; i = i+1) begin
            if(A[11-i] == 1) begin
                if(i < 8) begin
                    B = 8-i;
                    R = A[11-i +: 4];
                    O = A[11-i-4];
                    break = 1;
                end else begin
                    B = 0;
                    O = 0;
                    if (i == 7) begin
                        R = A[11-i +: 3];
                    end else if (i == 8) begin
                        R = A[11-i +: 2];
                    end else if (i == 9) begin
                        R = A[11-i +: 1];
                    end else if (i == 10) begin
                        R = A[0];
                    end
                end    
            end
            else if (i == 11) begin
                B = 0;
                O = 0;
                R = 0;
            end
        end
    end
endmodule

module rounding_logic(R, F, O, B, E);
    input [3:0] R; //unrounded significand
    input [2:0] B; //unoverflowed exponent
    input O; //overflow rounding bit
    output reg [3:0] F; //final rounded significand/mantissa
    output reg [2:0] E;  //final exponent
    
    always @(*) begin
        if (O == 1 && R == 4'b1111) begin
            E = B + 1;
            F = 4'b1000;
        end
        else if (O == 1) begin
            F = R + 1;
            E = B;  
        end
        else
            E = B;
            F = R;
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
    
//    complement(D, S, A);
//    encoder(A, B, R, O);
//    rounder(R, F, O, B, E);
endmodule