`timescale 1ns / 1ps

module tzn32_tb;

parameter WIDTH = 32;
localparam CYCLES = 100;

logic clock;

logic [WIDTH-1:0] data_in;
logic [$clog2(WIDTH):0] trailing_zeros;


tzn32 #(.WIDTH(WIDTH)) dut (.a_i(data_in), .numz_o(trailing_zeros));


always #5ns clock = ~clock;

initial begin
    clock = 0;
    data_in = '0;
end

initial begin
    $dumpfile("tzn.vcd");
    $dumpvars(0, tzn32_tb);
end

initial begin
    #5;
    for (int i = 0; i < CYCLES; i++ )  begin
        data_in = i;
        #10;
        $display("i = %0d data_in %0b | trailing Zeros = %d", i, data_in, trailing_zeros);
    end

    $finish;
end




endmodule
