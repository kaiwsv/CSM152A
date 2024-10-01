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
    
    
    module led_flash(clk, rst, clk_1hz);
        reg [26:0] a;
        input clk, rst;
        output reg clk_1hz;
        
        always @ (posedge clk)
        begin
            if (rst) begin
                a <= 27'd4999999999;
                clk_1hz = ~clk_1hz;
                rst <= 0;
            end
            else begin
                a <= a + 1'b1; 
                if (a == 100000000)
                rst <= 1;
            end
        end
    endmodule
