`timescale 1ns / 1ps

// Greatest common divisor

// This module will serve as a complete system simulation and synthesis flow that I follow
// Simple testbench in SV to check resets, IO and X and Z conditions
// System level simulation in Verilator with more focus on calculating total cycles for a given workload
// Synthesis using OpenROAD to calculate cycletime and thus determine total execution time


module gcd #(parameter XLEN = 32)
(
    input clk_i,
    input resetn_i,
    input [XLEN-1:0] a_i,
    input [XLEN-1:0] b_i,
    output [XLEN-1:0] gcd_o,
    output [XLEN-1:0] valid_o
);
    // compare and set variables for subscequent calculation
    logic [XLEN-1:0] greater_value;
    logic [XLEN-1:0] smaller_value;

    logic [XLEN-1:0] gcd_val;

    always_comb 
    begin
        if(a_i > b_i) begin
            greater_value = a_i;
            smaller_value = b_i;
        end
        else if (a_i == b_i)
            gcd_val = a_i;

        else begin
        greater_value = b_i;
        smaller_value = a_i;
        end
    end

    // if a and b both even, divide by 2, d times, till one becomes odd
    
endmodule
