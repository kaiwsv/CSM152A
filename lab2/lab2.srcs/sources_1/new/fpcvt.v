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


module fpcvt(D,S,E,F);
    input [11:0] D;
    output reg S;
    output reg [2:0] E;
    output reg [3:0] F;
    reg [11:0] A;
     always @(*) begin
     
        
        
     end
    
    
endmodule

module format_complement(D, S, A);
    input [11:0] D;
    output reg S;
    output reg [11:0] A;
    
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

module priority_encoder(A, B, F, O);
    input [11:0] A;
    output reg [2:0] B; //unoverflowed exponent
    output reg [3:0] F;
    output reg O;
    integer i;
    always @(*) begin
        for(i = 0; i < 8; i = i+1) begin
            if(A[11-i] == 1) begin
                B = 8-i;
                F = A[11-i +: 4];
                O = A[11-i-4];
                break;
            end
        end
    end
endmodule

module rounding_logic(F, R, O, B, E);
    input [3:0] F;
    input [2:0] B; //unoverflowed exponent
    input O; //overflow rounding bit
    output reg [3:0] R; //final rounded significand/mantissa
    output reg [2:0] E;  //final exponent
    
    always @(*) begin
        if (O == 1 && F == 4'b1111) begin
            E = B + 1;
            R = 4'b1000;
        end
        else if (O == 1)
            R = F + 1;
    end
endmodule

