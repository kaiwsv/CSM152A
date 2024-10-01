`timescale 1ns / 1ps

module tb_four_bit_counters;

    // Parameters
    reg clk;
    reg rst;
    wire [3:0] q;

    // Instantiate the four_bit_counters module
    four_bit_counters uut (
        .clk(clk),
        .rst(rst),
        .q(q)
    );

    // Clock Generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock period
    end

    // Test Sequence
    initial begin
        // Initialize Inputs
        rst = 1; // Assert reset
        #10;     // Wait for a few clock cycles
        rst = 0; // Deassert reset
        
//        // Wait and observe
//        #100;    // Run simulation for 100ns

//        // Add more test scenarios as needed
//        // Example: Assert reset again
//        rst = 1;
//        #10; // Hold reset
//        rst = 0;

        
        #500;
        $finish;
    end

    // Monitor output
    initial begin
        $monitor("Time: %0dns, Reset: %b, Q: %b", $time, rst, q);
    end

endmodule
