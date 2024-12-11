//`timescale 1ns / 1ps
module clock_display_top(
    input wire clk,        // 100 MHz system clock
    input wire btnRstGame,     // Hardware reset button
    output wire [6:0] seg,
    output wire [3:0] an
);

    // Internal signals
    wire clk_1hz, clk_2hz, clk_500hz;
    reg [6:0] digit_0, digit_1, digit_2, digit_3;
    reg blink;
    wire rst_debounced;

    // Instantiate clock divider
    clock_divider clk_div (
        .clk(clk),
        .rst_1(rst_debounced),
        .rst_2(rst_debounced),
        .rst_500(rst_debounced),
        .clk_1hz(clk_1hz),
        .clk_2hz(clk_2hz),
        .clk_500hz(clk_500hz)
    );

    // Instantiate the clock_display module
    clock_display display (
        .clk_2hz(clk_2hz),
        .clk_500hz(clk_500hz),
        .digit_0(digit_0),
        .digit_1(digit_1),
        .digit_2(digit_2),
        .digit_3(digit_3),
        .blink(blink),
        .display_seg(seg),
        .display_sel(an)
    );

    // Instantiate the debouncer for the reset button
    debouncer db_reset (
        .clk(clk), 
        .button(btnRstGame), 
        .stable(rst_debounced)
    );

    // Logic to set digits and blink signal
    reg [3:0] counter; // Counter to cycle through digit patterns

    always @(posedge clk or posedge rst_debounced) begin
        if (rst_debounced) begin
            digit_0 <= 7'b1000000; // "0"
            digit_1 <= 7'b1111001; // "1"
            digit_2 <= 7'b0100100; // "2"
            digit_3 <= 7'b0110000; // "3"
            blink <= 0;
            counter <= 0;
        end else begin                                                                                                          
            // Cycle through different digits every second
            if (clk_1hz) begin
                counter <= counter + 1;
                case (counter)
                    4'b0000: begin
                        digit_0 <= 0; // "0"
                        digit_1 <= 1; // "1"
                        digit_2 <= 2; // "2"
                        digit_3 <= 3; // "3"
                    end
                    4'b0001: begin
                        digit_0 <= 4; // "4"
                        digit_1 <= 5; // "5"
                        digit_2 <= 6; // "6"
                        digit_3 <= 7; // "7"
                    end
                    4'b0010: begin
                        digit_0 <= 8; // "8"
                        digit_1 <= 9; // "9"
                        digit_2 <= 10; // "b"
                        digit_3 <= 11; // "E"
                    end
                    4'b0011: begin
                        digit_0 <= 12; // "G"
                        digit_1 <= 13; // "H"
                        digit_2 <= 14; // "I" (same as "1")
                        digit_3 <= 15; // "O" (same as "0")
                    end
                    4'b0100: begin
                        digit_0 <= 16; // "P"
                        digit_1 <= 17; // "S"
                        digit_2 <= 18; // "T"
                        digit_3 <= 19; // "!"
                    end
                    default: begin
                        counter <= 0;
                    end
                endcase
            end

            // Toggle blink every second using clk_2hz for a slower blink rate
            if (clk_2hz) begin
                blink <= ~blink;
            end
        end
    end

endmodule



