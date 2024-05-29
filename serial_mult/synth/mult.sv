`timescale 1ns / 1ps

// Control Path for simple multiplier

// 3 state machine - READY, OPERATE, DONE


module mult_control
(
    input clk,
    input resetn,
    input eqz,
    input ld_input,

    output ready,
    output done,
    output [1:0] state
);
    localparam READY        = 0;
    localparam OPERATE      = 1;
    localparam DONE         = 2;

    logic [1:0] current_state, next_state;

    assign state = current_state;

// Set current state to next state
    always_ff @(posedge clk)
    begin
        if (!resetn)
            current_state <= READY;
        else
            current_state <= next_state;
    end

// Next state logic
    always_comb begin
        if (!resetn)
            next_state = READY;
        else
        begin
            next_state = READY;
            case (current_state)
                READY: begin
                    if (ld_input)   next_state = OPERATE;
                    else            next_state = READY;
                end

                OPERATE: begin
                    if(eqz)     next_state = DONE;
                    else        next_state = OPERATE;
                end

                DONE:           next_state = READY;
            endcase
        end
    end

    // Output logic

    assign ready    = (current_state == READY) ? 1 : 0;
    assign done     = (current_state == DONE)  ? 1 : 0;

endmodule

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

