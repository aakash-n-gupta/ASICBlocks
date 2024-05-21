`timescale 1ns / 1ps

// Controller for GCD module

// import gcd_pkg::*;

module gcd_control (
    // inputs coming from top
    input clk,
    input resetn,
    input ld_i,

    // inputs coming from datapath
    input eq,
    input altb,


    // output to top
    output ready,
    output done,

    // outputs to datapath
    output gcd_pkg::state_t state

);

    state_t current_state, next_state;

    // Update to next state
    always_ff @(posedge clk)
    begin
        if (!resetn)
            current_state <= READY;
        else
        begin
            current_state <= next_state;
        end
    end

    // next state logic
    // does next state logic need to have explicit reset to READY??
    always_comb
    begin
        next_state = READY;
        begin
            case (current_state)
                READY: begin
                    if (!ld_i)     next_state = READY;
                    else           next_state = LOAD;
                end

                LOAD: next_state = ODD;
                ODD: next_state = CMP;
                CMP: begin
                    if (eq)             next_state = DONE;
                    else begin
                        if (altb)       next_state = DIVA;
                        else            next_state = DIVB;
                    end
                end
                DIVA: next_state = CMP;
                DIVB: next_state = CMP;
                DONE: next_state = READY;
            endcase
        end
    end

    // output logic
    assign state = current_state;

    assign ready =  (current_state == READY) ? 1 : 0 ;
    assign done =   (current_state == DONE) ? 1 : 0 ;

endmodule
