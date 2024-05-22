`timescale 1ns / 1ps

module gcd_datapath #( parameter XLEN = 32)
(
    // clock and reset from top
    input clk,
    input resetn,

    // load and data from top
    input ld_i,
    input [XLEN-1:0] a_i,
    input [XLEN-1:0] b_i,

    // inputs from control
    input gcd_pkg::state_t state,

    // outputs to control
    output eq,
    output altb,

    // outputs to top
    output [XLEN-1:0] gcd
);

    import gcd_pkg::*;

    // registers for a and b
    logic [XLEN-1:0] a_r;
    logic [XLEN-1:0] b_r;
    logic [XLEN-1:0] gcd_w;

    // wires for comparators
    logic eq_w;
    logic altb_w;

    logic [$clog2(XLEN)-1:0] shamt_a;
    logic [$clog2(XLEN)-1:0] shamt_b;

    // 2^d = |shamt_b - shamt_a|
    // this stores the common factor 2^d, final gcd needs to be shifted by this amount
    logic [$clog2(XLEN)-1:0] final_shamt;
    logic [$clog2(XLEN)-1:0] gcd_shamt;


    logic sink_a;
    logic sink_b;

    // muxA and muxB to select value to store
    always_ff @(posedge clk) begin
        if (!resetn)
            a_r <= '0;
        else begin
            if (ld_i)
                a_r <= a_i;
            else if (state == ODD)
                a_r <= a_r >> shamt_a;
            else if (state == DIVA)
                a_r <= (a_r - b_r);
        end
    end

    tzn16 #(.WIDTH(XLEN)) reduceA(.a_i(a_r), .numz_o(shamt_a), .all_zeros_o(sink_a));

    always_ff @(posedge clk) begin
        if (!resetn)
            b_r <= '0;
        else begin
            if (ld_i)
                b_r <= b_i;
            else if (state == ODD)
                b_r <= b_r >> shamt_b;
            else if (state == DIVB)
                b_r <= (b_r - a_r);
            else
                b_r <= b_r;
        end
    end

    // reduce a and b to odd values
    tzn16 #(.WIDTH(XLEN)) reduceB(.a_i(b_r), .numz_o(shamt_b), .all_zeros_o(sink_b));

    // Comparator
    assign eq_w   = (a_r == b_r) ? 1'b1 : 1'b0;
    assign altb_w = (a_r < b_r) ? 1'b1 : 1'b0;

    assign gcd_w =  (a_r << gcd_shamt);
    assign gcd = (state == DONE) ? gcd_w : 'Z;

    assign final_shamt = (shamt_a >= shamt_b) ? shamt_b : shamt_b;

    always_ff @(posedge clk)
    begin
        if (!resetn)
            gcd_shamt <= '0;
        else
            if(state == ODD)
                gcd_shamt <= final_shamt;
            else
                gcd_shamt <= gcd_shamt;
    end

    assign eq = eq_w;
    assign altb = altb_w;

    // save shift value for final gcd calculation
    // use this as a final shift left to calculate gcd

    // compare a_r and b_r
    // if equal, gcd DONE
    // output values to control
    // compute b-a div 2 and a-b div 2

endmodule
