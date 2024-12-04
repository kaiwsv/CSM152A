`timescale 1ns / 1ps

module tb_lfsr_rng;

  // Inputs
  reg clk;            // Clock signal
  reg rst;            // Reset signal
  reg enable;         // Enable signal for the LFSR

  // Outputs
  wire [7:0] rand_out; // 8-bit random number output

  // Instantiate the LFSR module
  lfsr_rng uut (
    .clk(clk),
    .rst(rst),
    .enable(enable),
    .rand_out(rand_out)
  );

  // Clock generation (50 MHz clock)
  always begin
    #5 clk = ~clk; // Toggle clock every 5ns -> 100 MHz clock (10ns period)
  end

  // Test procedure
  initial begin
    // Initialize signals
    clk = 0;
    rst = 0;
    enable = 0;

    // Apply reset and check the output
    $display("Applying reset...");
    rst = 1;
    #10; // Wait for some time
    rst = 0;
    #10; // Wait for some more time

    // Enable the LFSR and check the random number sequence
    $display("Enabling LFSR...");
    enable = 1;
    #100; // Run for 100ns to observe the output

    // Disable the LFSR and observe that the output stops changing
    $display("Disabling LFSR...");
    enable = 0;
    #50;  // Run for 50ns and see if the output freezes

    // Finish simulation
    $display("Simulation complete.");
    $finish;
  end

  // Display random numbers on the output (for debugging)
  always @(posedge clk) begin
    if (enable) begin
      $display("Random Output: %b (decimal: %d)", rand_out, rand_out);
    end
  end

endmodule
