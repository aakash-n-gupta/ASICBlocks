`timescale 1ns / 1ps

// Multiplication using repetitive addition
// Seperate control and datapath modules

module mult #(parameter XLEN = 16)
(
    input                   clk_i,
    input                   resetn_i,
    input                   ld_input_i,
    input [XLEN-1:0]        a_i,
    input [XLEN-1:0]        b_i,

    output                  ready_o,
    output                  valid_o,
    output [2*XLEN-1:0]     product_o

);

    // glue logic to connect control to datapath
    logic eqz_b;
    logic ready_w;
    logic done_w;
    logic [1:0] current_state;

    logic [2*XLEN-1:0] product_w;

    assign valid_o = done_w;
    assign ready_o = ready_w;
    assign product_o = product_w;

    mult_datapath #(.XLEN(XLEN)) datapath (
                                        .clk(clk_i),
                                        .resetn(resetn_i),
                                        .ld_input(ld_input_i),

                                        // inputs from control
                                        .state(current_state),
                                        .ready(ready_w),
                                        .done(done_w),

                                        .a(a_i),
                                        .b(b_i),

                                        .eqz(eqz_b),
                                        .product(product_w)
    );

    mult_control controller (
                            .clk(clk_i),
                            .resetn(resetn_i),
                            .eqz(eqz_b),
                            .ld_input(ld_input_i),

                            .ready(ready_w),
                            .done(done_w),
                            .state(current_state)
    );


endmodule

