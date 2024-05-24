`timescale 1ns / 1ps


// Subtractor for X - Y, where X is always greater than Y
    // inputs: a_i, b_i
    // Outputs: a_sub, b_sub
    // where a_sub is (a-b) or (b-a) and b_sub <- b or a

module subtractor #(parameter XLEN = 16) (
    input [XLEN-1:0]    a_i,
    input [XLEN-1:0]    b_i,
    output [XLEN-1:0]   a_sub,
    output [XLEN-1:0]   b_sub
);

    logic [XLEN-1:0] X;
    logic [XLEN-1:0] Y;
    logic [XLEN:0]   Z;

    assign X = a_i;
    assign Y = b_i;
    assign Z = X - Y;

    assign a_sub = (Z[XLEN]) ? -Z : Z;
    assign b_sub = (Z[XLEN]) ? a_i : b_i;

    // This does not work in iverilog
    // always_comb begin
    //     if (Z[XLEN]) begin
    //         a = -Z;
    //         b = a_i;
    //     end
    //     else begin
    //         a = Z;
    //         b = b_i;
    //     end
    // end
    
endmodule
