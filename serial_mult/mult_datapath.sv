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
    logic [XLEN-1:0] a_reg;
    logic cntz;

    always_ff @(posedge clk)
    begin
        if (!resetn)
            countB <= '0;
        else
        begin
            if (ld_input)
                countB <= b;
            else if(state == OPERATE)
                countB <= countB - 1;
            else
                countB <= countB;
        end
    end

    logic [2*XLEN-1:0] partial_product;

    always_ff @(posedge clk) begin
        if (!resetn)
            a_reg <= 0;
        else begin
            if (ld_input) begin
                a_reg <= a;
            end
            else
                a_reg <= a_reg;
        end
    end

    always_ff @(posedge clk)
    begin
        if (!resetn)
            partial_product <= '0;
        else begin
            partial_product <= '0;
            case (state)
                READY: partial_product <= 0;
                // OPERATE: partial_product <= partial_product + a_reg;
                OPERATE: begin
                        if (!cntz)
                            partial_product <= partial_product + {{ (XLEN-1){1'b0}} , a_reg};
                        else
                            partial_product <= partial_product;
                    end
                DONE: partial_product <= partial_product;
            endcase
        end
    end

    // Output assignments
    assign eqz = cntz;
    assign cntz = (countB == 0) ? 1 : 0;
    assign product = (state == DONE) ? partial_product : 'z;

endmodule
