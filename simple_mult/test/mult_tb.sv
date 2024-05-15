`timescale 1ns / 1ps

module mult_tb;

    parameter XLEN = 16;

    logic clk_i, resetn_i, ld_input_i;
    logic [XLEN-1:0] a_i;
    logic [XLEN-1:0] b_i;

    logic ready_o, valid_o;
    logic [2*XLEN-1:0] product_o;


    mult #(.XLEN(XLEN)) DUT(.*);


    always #5 clk_i = ~clk_i;
    initial begin
        $dumpfile("./mult.vcd");
        $dumpvars(0, mult_tb);
    end

    task multiplier_input(int a, int b);
        resetn_i = 1;
        ld_input_i = '1;
        a_i = 17;
        b_i = 5;
        #10;
        a_i = 0;
        b_i = 0;
        ld_input_i = 0;
    endtask

    initial begin
        $monitor("Monitor backpressure signals | valid = %b || ready = %b\n", valid_o, ready_o);
        $monitor("Product = %d", product_o);
        #1;
        clk_i = 0;
        resetn_i = 0;
        ld_input_i = 0;
        a_i = 0;
        b_i = 0;
        #20;
        // start the datapath operations
        resetn_i = 1;
        ld_input_i = '1;
        a_i = 17;
        b_i = 5;
        #10;
        a_i = 0;
        b_i = 0;
        ld_input_i = 0;
        #40;
        // $display("Product = %d", product_o);

        // Do some things in meanwhile
        for (int i = 0; i < 16; i++)
        begin
            // $display("Product = %d", product_o);
            #10;
        end


        #100;
        $finish;

    end



endmodule
