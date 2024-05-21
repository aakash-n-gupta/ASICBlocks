`timescale 1ns / 1ps

module gcd_datapath #( parameter XLEN = 32)
(
    // clock and reset from top
    input clk,
    input resetn,

    // load and data from top
    input ld_i,
    input [XLEN-1] a_i,
    input [XLEN-1] b_i,

    // inputs from control
    input gcd_pkg::state_t state,

    // outputs to top
    output [XLEN-1:0] gcd
);

    // registers for a and b
    logic [XLEN-1] a_r;
    logic [XLEN-1] b_r;

    // muxA and muxB to select value to store
    always_ff @(posedge clk) begin
        if (!resetn)
            a_r <= '0;
        else begin
            if (ld_i)
                a_r <= a_i;
            else if () begin
                
            end
        end
    end

    // reduce a and b to odd values
    // save shift value for final gcd calculation
    // use this as a final shift left to calculate gcd

    // compare a_r and b_r
    // if equal, gcd DONE
    // output values to control
    // compute b-a div 2 and a-b div 2

endmodule
