`timescale 1ns / 1ps

// output eqz when B == 0
// output final product prod_o when eqz is set and state is DONE
// input ready, a_i, b_i, clk_i, resetn_i


module mult_datapath #(parameter XLEN = 16)
(
    input clk,
    input resetn,
    input ld_input,

    // Inputs from control
    input [1:0]state,
    input ready,
    input done,

    // Data inputs
    input [XLEN-1:0] a,
    input [XLEN-1:0] b,

    output eqz,
    output [2*XLEN-1: 0] product
);
    localparam READY        = 0;
    localparam OPERATE      = 1;
    localparam DONE         = 2;

    // downcounter for B
    logic [XLEN-1:0] countB;

    always_ff @(posedge clk)
    begin
        if (!resetn)
            countB <= '0;
        else
        begin
            if (ld_input)
                countB <= b;
            else
                countB <= countB - 1;
        end
    end

    logic [2*XLEN-1:0] presult;
    logic [2*XLEN-1:0] presult_reg;

    always_ff @(posedge clk)
    begin
        if (!resetn)
            presult_reg <= '0;
        else
            presult_reg <= presult;
    end

    // Output assignments
    assign eqz = (countB == 0) ? 1 : 0;
    assign presult = (state == OPERATE) ? (presult_reg + a) : presult_reg;
    assign product = (done) ? (presult_reg) : 'Z;

endmodule
