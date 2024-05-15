`timescale 1ns / 1ps

module mult_tb;

    parameter XLEN = 32;
    parameter TEST_CYCLES = 10000;
    int cycles = 0;

    logic clk_i, resetn_i, ld_input_i;
    logic [XLEN-1:0] a_i;
    logic [XLEN-1:0] b_i;

    logic ready_o, valid_o;
    logic [2*XLEN-1:0] product_o;


    mult #(.XLEN(XLEN)) DUT(.*);


    always #5 clk_i = ~clk_i;
    always #10 cycles = cycles + 1;

    initial begin
        $dumpfile("./mult.vcd");
        $dumpvars(0, mult_tb);
    end

    task multiplier_input(int a, int b);
        resetn_i = 1;
        ld_input_i = '1;
        a_i = a;
        b_i = b;
        #10;
        a_i = 0;
        b_i = 0;
        ld_input_i = 0;
    endtask

    initial begin
        $monitor("Monitor backpressure signals | valid = %d || ready = %d", valid_o, ready_o);
        $monitor("Product = %d", product_o);
        #1;
        clk_i = 0;
        resetn_i = 0;
        ld_input_i = 0;
        a_i = 0;
        b_i = 0;
        #20;
        // start the datapath operations
        $display("cycle count before Mult input: %d", cycles);
        multiplier_input(17090, 1119);
        $display("cycle count after Mult input : %d", cycles);

        for (int i = 0; i < TEST_CYCLES; i++ )  begin
            #10;
            if(valid_o)
                $display("cycle count: %d when Multiplication Complete", cycles);
        end

        $display("cycle count before Mult input: %d", cycles);
        multiplier_input(1701, 199);
        $display("cycle count after Mult input : %d", cycles);

        for (int i = 0; i < TEST_CYCLES; i++ )  begin
            #10;
            if(valid_o)
                $display("cycle count: %d when Multiplication Complete", cycles);
        end

        $finish;

    end



endmodule
