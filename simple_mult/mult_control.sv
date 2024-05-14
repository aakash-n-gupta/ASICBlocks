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
    always_comb
    begin
        {ready, done} = {1, 0};
        case (current_state)
            READY   : {ready, done} = {1, 0};
            OPERATE : {ready, done} = {0, 0};
            DONE    : {ready, done} = {0, 1};
        endcase
    end

endmodule
