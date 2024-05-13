`timescale 1ns / 1ps

// Find number of trailing zeros
// If the input is all zeros


module tzn32 #(WIDTH = 32) (
    input [WIDTH-1:0] a_i,
    output [$clog2(WIDTH):0] numz_o
);

    logic [$clog2(WIDTH):0] numz;

    always_comb begin
        numz = '0;
        if ((a_i & 32'h0000_0001) == 0)
            numz = 0;
        else if ((a_i & 32'h0000_0011) == 0)
            numz = 2;
        else if ((a_i & 32'h0000_0007) == 0)
            numz = 3;
        else if ((a_i & 32'h0000_000f) == 0)
            numz = 4;
        else if ((a_i & 32'h0000_001f) == 0)
            numz = 5;
        else if ((a_i & 32'h0000_003f) == 0)
            numz = 6;
        else if ((a_i & 32'h0000_007f) == 0)
            numz = 7;
        else if ((a_i & 32'h0000_00ff) == 0)
            numz = 8;


        else if ((a_i & 32'h0000_01ff) == 0)
            numz = 9;
        else if ((a_i & 32'h0000_03ff) == 0)
            numz = 10;
        else if ((a_i & 32'h0000_07ff) == 0)
            numz = 11;
        else if ((a_i & 32'h0000_0fff) == 0)
            numz = 12;
        else if ((a_i & 32'h0000_1fff) == 0)
            numz = 13;
        else if ((a_i & 32'h0000_3fff) == 0)
            numz = 14;
        else if ((a_i & 32'h0000_7fff) == 0)
            numz = 15;
        else if ((a_i & 32'h0000_ffff) == 0)
            numz = 16;

        else if ((a_i & 32'h0001_ffff) == 0)
            numz = 17;
        else if ((a_i & 32'h0003_ffff) == 0)
            numz = 18;
        else if ((a_i & 32'h0007_ffff) == 0)
            numz = 19;
        else if ((a_i & 32'h000f_ffff) == 0)
            numz = 20;
        else if ((a_i & 32'h001f_ffff) == 0)
            numz = 21;
        else if ((a_i & 32'h003f_ffff) == 0)
            numz = 22;
        else if ((a_i & 32'h007f_ffff) == 0)
            numz = 23;
        else if ((a_i & 32'h00ff_ffff) == 0)
            numz = 24;

        else if ((a_i & 32'h01ff_ffff) == 0)
            numz = 25;
        else if ((a_i & 32'h03ff_ffff) == 0)
            numz = 26;
        else if ((a_i & 32'h07ff_ffff) == 0)
            numz = 27;
        else if ((a_i & 32'h0fff_ffff) == 0)
            numz = 28;
        else if ((a_i & 32'h1fff_ffff) == 0)
            numz = 29;
        else if ((a_i & 32'h3fff_ffff) == 0)
            numz = 30;
        else if ((a_i & 32'h7fff_ffff) == 0)
            numz = 31;
        else if ((a_i & 32'hffff_ffff) == 0)
            numz = 32;
    end

    assign numz_o = numz;
endmodule

