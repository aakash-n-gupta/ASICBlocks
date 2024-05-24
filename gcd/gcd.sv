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

    import gcd_pkg::*;

    logic eq_w;
    gcd_pkg::state_t state_w;

    gcd_control controller (
        .clk(clk_i),
        .resetn(resetn_i),
        .ld_i(ld_i),

        .eq(eq_w),
        .ready(ready_o),
        .done(valid_o),
        .state(state_w)
    );


    gcd_datapath #(.XLEN(XLEN)) datapath (
        .clk(clk_i),
        .resetn(resetn_i),

        .ld_i(ld_i),
        .a_i(a_i),
        .b_i(b_i),

        .state(state_w),
        .eq(eq_w),
        .gcd(gcd_o)
    );

endmodule
