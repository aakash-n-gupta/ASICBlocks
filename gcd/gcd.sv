`timescale 1ns / 1ps

// Greatest common divisor

// This module will serve as a complete system simulation and synthesis flow that I follow
// Simple testbench in SV to check resets, IO and X and Z conditions
// System level simulation in Verilator with more focus on calculating total cycles for a given workload
// Synthesis using OpenROAD to calculate cycletime and thus determine total execution time


module gcd #(parameter XLEN = 32)
(
    input               clk_i,
    input               resetn_i,
    input               ld_i,

    input [XLEN-1:0]    a_i,
    input [XLEN-1:0]    b_i,

    output[XLEN-1:0]    gcd_o,
    output              ready_o,
    output              valid_o
);
    
endmodule
