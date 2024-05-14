`timescale 1ns / 1ps

// Initialize some program data into memory (instr.riscv) elf
// Cross verify contents through input file

module mult_datapath_tb;

    parameter XLEN = 16;

    logic clock, resetn;
    logic ld_input;

    logic [1:0] state;
    logic ready;
    logic done;

    logic [XLEN-1:0] a_in;
    logic [XLEN-1:0] b_in;

    logic eqz;
    logic [2*XLEN-1:0] product;

    mult_datapath #(.XLEN(XLEN)) DUT_Datapath (
                                .clk(clock),
                                .resetn(resetn),
                                .ld_input(ld_input),

                                .state(state),
                                .ready(ready),
                                .done(done),

                                .a(a_in),
                                .b(b_in),

                                .eqz(eqz),
                                .product(product)
);

    always #5 clock = ~clock;
    initial begin
        $dumpfile("datapath.vcd");
        $dumpvars(0, mult_datapath_tb);
    end

    initial begin
        #1;
        clock = 0;
        resetn = 0;
        ld_input = 0;
        state = 0;
        ready = 0;
        done = 0;
        a_in = 0;
        b_in = 0;
        #20;
        // start the datapath operations
        resetn = 1;
        ld_input = '1;
        a_in = 17;
        b_in = 5;
        #20;
        state = 1;
        #10
        a_in = 0;
        b_in = 0;
        ld_input = 0;
        #40;
        done = 1;
        state = 2;
        $display("Product = %d", product);

        // Do some things in meanwhile
        for (int i = 0; i < 16; i++)
        begin
            $display("Product = %d and eqz = %b", product, eqz);
            #10;
        end


        #100;
        $finish;

    end





endmodule
