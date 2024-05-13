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
        numz = '0;
        if(a_i == '0)
            numz = 32;
        casex (a_i)
            32'hxxxx_xxx1: numz = 0;
            32'hxxxx_xxx2: numz = 1;
            32'hxxxx_xxx4: numz = 2;
            32'hxxxx_xxx8: numz = 3;
            32'hxxxx_xx10: numz = 4;
            32'hxxxx_xx20: numz = 5;
            32'hxxxx_xx40: numz = 6;
            32'hxxxx_xx80: numz = 7;

            32'hxxxx_x100: numz = 8;
            32'hxxxx_x200: numz = 9;
            32'hxxxx_x400: numz = 10;
            32'hxxxx_x800: numz = 11;
            32'hxxxx_1000: numz = 12;
            32'hxxxx_2000: numz = 13;
            32'hxxxx_4000: numz = 14;
            32'hxxxx_8000: numz = 15;

            32'hxxx1_0000: numz = 16;
            32'hxxx2_0000: numz = 17;
            32'hxxx4_0000: numz = 18;
            32'hxxx8_0000: numz = 19;
            32'hxx10_0000: numz = 20;
            32'hxx20_0000: numz = 21;
            32'hxx40_0000: numz = 22;
            32'hxx80_0000: numz = 23;

            32'hx100_0000: numz = 24;
            32'hx200_0000: numz = 25;
            32'hx400_0000: numz = 26;
            32'hx800_0000: numz = 27;
            32'h1000_0000: numz = 28;
            32'h2000_0000: numz = 29;
            32'h4000_0000: numz = 30;
            32'h8000_0000: numz = 31;
        endcase
    end
    endmodule

