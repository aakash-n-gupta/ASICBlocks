`timescale 1ns / 1ps

// Find number of trailing zeros
// If the input is all zeros
// this module can also be called find_first_one


module tzn16 #(WIDTH = 16) (
    input [WIDTH-1:0] a_i,
    output [$clog2(WIDTH)-1:0] numz_o,
    output all_zeros_o
);

    logic [$clog2(WIDTH):0] numz;

    assign numz_o = numz;
    assign all_zeros_o = numz[$clog2(WIDTH)];

    always_comb begin
        numz = 'z;
        if(a_i == '0)
            numz = 32;
        casex (a_i)
            16'bxxxx_xxxx_xxxx_xxx1: numz = 0;
            16'bxxxx_xxxx_xxxx_xx10: numz = 1;
            16'bxxxx_xxxx_xxxx_x100: numz = 2;
            16'bxxxx_xxxx_xxxx_1000: numz = 3;
            16'bxxxx_xxxx_xxx1_0000: numz = 4;
            16'bxxxx_xxxx_xx10_0000: numz = 5;
            16'bxxxx_xxxx_x100_0000: numz = 6;
            16'bxxxx_xxxx_1000_0000: numz = 7;
            16'bxxxx_xxx1_0000_0000: numz = 8;
            16'bxxxx_xx10_0000_0000: numz = 9;
            16'bxxxx_x100_0000_0000: numz = 10;
            16'bxxxx_1000_0000_0000: numz = 11;
            16'bxxx1_0000_0000_0000: numz = 12;
            16'bxx10_0000_0000_0000: numz = 13;
            16'bx100_0000_0000_0000: numz = 14;
            16'b1000_0000_0000_0000: numz = 15;
        endcase
    end
    endmodule

