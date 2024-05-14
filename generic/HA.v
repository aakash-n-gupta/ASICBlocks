`timescale 1ns / 1ns

module HA(
    input a_i,
    input b_i,

    output s_o,
    output c_o);

    assign {c_o, s_o} = a_i + b_i;

endmodule
