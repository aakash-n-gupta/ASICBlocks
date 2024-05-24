`timescale 1ns / 1ps

module gcd_datapath #( parameter XLEN = 16)
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

    // outputs to top
    output [XLEN-1:0] gcd
);
    import gcd_pkg::*;

    logic sink_a;
    logic sink_b;

    // Wires to save a and b
    logic [XLEN-1:0] a_mux;
    logic [XLEN-1:0] b_mux;
    logic [XLEN-1:0] a_sub;
    logic [XLEN-1:0] b_sub;

    // registers for a and b
    logic [XLEN-1:0] a_r;
    logic [XLEN-1:0] b_r;

    // wires for comparators
    logic eq_w;
    logic [XLEN-1:0] gcd_w;

    logic [$clog2(XLEN)-1:0] shamt_a;
    logic [$clog2(XLEN)-1:0] shamt_b;

    // 2^d = |shamt_b - shamt_a|
    // this stores the common factor 2^d, final gcd needs to be shifted by this amount
    logic [$clog2(XLEN)-1:0] final_shamt;
    logic [$clog2(XLEN)-1:0] gcd_shamt;

    // muxA and muxB to select value to store
    always_comb begin
        a_mux = a_r;
        if(ld_i)
            a_mux = a_i;
        case (state)
            // LOAD: a_mux = a_i;
            ODD: a_mux = (a_r >> shamt_a);
            COMPUTE: a_mux = a_sub;
        endcase
    end

    always_ff @(posedge clk) begin
        if (!resetn)
            a_r <= '0;
        else
            a_r <= a_mux;
    end

    always_comb begin
        b_mux = b_r;
        if(ld_i)
            b_mux = b_i;
        case (state)
            // LOAD: b_mux = b_i;
            ODD: b_mux = (b_r >> shamt_b);
            COMPUTE: b_mux = b_sub;
        endcase
    end

    always_ff @(posedge clk) begin
        if (!resetn)
            b_r <= '0;
        else
            b_r <= b_mux;
    end

    // Subtractor for X - Y, where X is always greater than Y
    // inputs: a_r, b_r
    // Outputs: a_sub, b_sub,
    // where a_sub <- (a-b) or (b-a) and b_sub <- b or a , conditionally on a > b
    subtractor #(.XLEN(XLEN)) sub (.a_i(a_r), .b_i(b_r), .a_sub(a_sub), .b_sub(b_sub));

    // reduce a and b to odd values
    tzn16 #(.WIDTH(XLEN)) reduceA(.a_i(a_r), .numz_o(shamt_a), .all_zeros_o(sink_a));
    tzn16 #(.WIDTH(XLEN)) reduceB(.a_i(b_r), .numz_o(shamt_b), .all_zeros_o(sink_b));

    // Comparator
    assign eq_w   = (b_r == 0) ? 1'b1 : 1'b0;

    // Keep track of previous state
    logic [2:0] priv_state;

    always_ff @(posedge clk) begin
        priv_state <= state;
    end

    always_ff @(posedge clk) begin
        if (!resetn)
            gcd_shamt <= 0;
        else begin
            gcd_shamt <= gcd_shamt;
            if (priv_state == LOAD) begin
                gcd_shamt <= final_shamt;
            end
        end
    end

    assign final_shamt = (shamt_a >= shamt_b) ? shamt_b : shamt_b;

    assign gcd_w =  (a_r << gcd_shamt);
    assign gcd = (state == DONE) ? gcd_w : 'Z;

    assign eq = eq_w;

    // save shift value for final gcd calculation
    // use this as a final shift left to calculate gcd

    // compare a_r and b_r
    // if equal, gcd DONE
    // output values to control
    // compute b-a div 2 and a-b div 2

endmodule
