`timescale 1ns / 1ps

// Find number of trailing zeros
// If the input is all zeros


module tzn32 #(WIDTH = 32) (
    input [WIDTH-1:0] a_i,
    output [$clog2(WIDTH):0] numz_o
);

    logic [$clog2(WIDTH):0] numz;

    assign numz_o = numz;

    always_comb begin
        numz = 'z;
        if(a_i == '0)
            numz = 32;
        casex (a_i)
            32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxx1: numz = 0;
            32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xx10: numz = 1;
            32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_x100: numz = 2;
            32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_1000: numz = 3;
            32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxx1_0000: numz = 4;
            32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xx10_0000: numz = 5;
            32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_x100_0000: numz = 6;
            32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_1000_0000: numz = 7;
            32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxx1_0000_0000: numz = 8;
            32'bxxxx_xxxx_xxxx_xxxx_xxxx_xx10_0000_0000: numz = 9;
            32'bxxxx_xxxx_xxxx_xxxx_xxxx_x100_0000_0000: numz = 10;
            32'bxxxx_xxxx_xxxx_xxxx_xxxx_1000_0000_0000: numz = 11;
            32'bxxxx_xxxx_xxxx_xxxx_xxx1_0000_0000_0000: numz = 12;
            32'bxxxx_xxxx_xxxx_xxxx_xx10_0000_0000_0000: numz = 13;
            32'bxxxx_xxxx_xxxx_xxxx_x100_0000_0000_0000: numz = 14;
            32'bxxxx_xxxx_xxxx_xxxx_1000_0000_0000_0000: numz = 15;
            32'bxxxx_xxxx_xxxx_xxx1_0000_0000_0000_0000: numz = 16;
            32'bxxxx_xxxx_xxxx_xx10_0000_0000_0000_0000: numz = 17;
            32'bxxxx_xxxx_xxxx_x100_0000_0000_0000_0000: numz = 18;
            32'bxxxx_xxxx_xxxx_1000_0000_0000_0000_0000: numz = 19;
            32'bxxxx_xxxx_xxx1_0000_0000_0000_0000_0000: numz = 20;
            32'bxxxx_xxxx_xx10_0000_0000_0000_0000_0000: numz = 21;
            32'bxxxx_xxxx_x100_0000_0000_0000_0000_0000: numz = 22;
            32'bxxxx_xxxx_1000_0000_0000_0000_0000_0000: numz = 23;
            32'bxxxx_xxx1_0000_0000_0000_0000_0000_0000: numz = 24;
            32'bxxxx_xx10_0000_0000_0000_0000_0000_0000: numz = 25;
            32'bxxxx_x100_0000_0000_0000_0000_0000_0000: numz = 26;
            32'bxxxx_1000_0000_0000_0000_0000_0000_0000: numz = 27;
            32'bxxx1_0000_0000_0000_0000_0000_0000_0000: numz = 28;
            32'bxx10_0000_0000_0000_0000_0000_0000_0000: numz = 29;
            32'bx100_0000_0000_0000_0000_0000_0000_0000: numz = 30;
            32'b1000_0000_0000_0000_0000_0000_0000_0000: numz = 31;
        endcase
    end
    endmodule

