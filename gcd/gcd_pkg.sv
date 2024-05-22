`timescale 1ns / 1ps

// GCD Package

package gcd_pkg;

    typedef enum logic[2:0] {
        READY   = 3'b111, //7
        LOAD    = 3'b001, //1
        ODD     = 3'b010, //2
        CMP     = 3'b100, //4
        DIVA    = 3'b011, //3
        DIVB    = 3'b000, //0
        DONE    = 3'b101  //5

    } state_t;

endpackage : gcd_pkg
