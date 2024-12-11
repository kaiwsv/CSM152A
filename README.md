# CSM152A
Kai Wang and Emanuel Zavalza

Code and documents for Fall 2024 [COM SCI M152A: Introductory Digital Design Laboratory](https://catalog.registrar.ucla.edu/course/2022/COMSCIM152A?siteYear=2022), a 2 unit course at UCLA. 

Structure:
| folder | contents |
| -------- | ------- |
| meaningful | These folders contain our final submitted work or otherwise useful information. |
| course-documents/ | Holds all the provided labs specs and other reference documents for this course. |
| reports/ | Reports for each lab. |
| final/ | Final project as demoed and submitted in lab, implementation files and report only. |
| project_1 | Lab 0 - simulation and Basys 3 implementation of conbinational gates, 2 bit counter, and clock divider to flash LED at 1Hz |
| lab_1 | Implement ALU sequencer that takes assembly-like instructions |
| lab_2 | Simulate floating point conversion, converts 12-bit linear encoding of analog signals into 8-bit floating point representation. The spec specifies this lab will be graded by a TA testbench of all possible inputs, so we wrote a python script to generate a similar testbench for our own testing. |
| lab_3 | Implement stopwatch for Basys 3 with basic counting up functionality. Includes pause, reset buttons to control stopwatch ticking, as well as adjustment functionality with several switches to blink the stopwatch display and change values faster. |
| less meaningful | These folders contain work in progress intermediate states, incompatible versions of code due to Xilinx Vivado software limitations, and other partially complete snippets. |
| final-broken/ | Bugged implementation of status state where it should flash "HIGH", high score, "PLAY", number of games played. Written in a rush before group demos began, has a bug where the states jump past game end score display directly to status. We ran out of time to debug this so we decided to go with a different status implementation before our project demo. Compatible with Vivado 2018. |
| lab-4-code | Early final project code written without access to Vivado design software, has basic skeleton. |
| NewLab4 | In progress code, using lab 3 as a template, tested on the FPGA parallel to lab-4-code, that first implements lfsr and adds non-numerical characters to our display multiplexer driver. |
| lab4 | Main development of final project, done outside of the lab, mostly on the day of 12/4 and early morning of 12/5. This is where the full game logic is implemented, unfortunately due to computer limitations this module was developed on my personal desktop with Vivado 2024. This code does not implement the status display but is otherwise complete. Additionally, all of our testbenches are include in the sims section of this folder. All modules were tested as they were developed and testbench files are named after intended tests. Compatible with Vivado 2024. |
| lab_1_submission | Contains copy of lab 1 synthesis and simulation Verilog code only for submission to Canvas. |


Final Project:
Implementation of a single player Whack-A-Mole game contained on the Basys 3 board. Player will try to hit as many moles as possible in 30 seconds by flipping the 16 switches on the board when moles are present as indicated by LEDs. The player will earn points for each mole succesfully hit, but if an incorrect switch is flipped, they will lose points (down to 0 points). After the game ends, the score is displayed for 5 seconds, after which the high score and number of games played is display indefinitely. The player can start a new game at any time by pressing the reset game button on the left or start a new game and wipe out global game statistics (high score and games played) by pressing the reset all button on the right. Successfully demoed in class, pending final grade.
