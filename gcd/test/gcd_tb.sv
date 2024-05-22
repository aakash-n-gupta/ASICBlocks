`timescale 1ns / 1ps

module gcd_tb;

    parameter XLEN = 16;
    parameter TEST_CYCLES = 100;
    int cycles = 0;

    logic clk_i, resetn_i, ld_i;
    logic [XLEN-1:0] a_i;
    logic [XLEN-1:0] b_i;

    logic ready_o, valid_o;
    logic [XLEN-1:0] gcd_o;


    gcd #(.XLEN(XLEN)) DUT(.*);

    always #5 clk_i = ~clk_i;
    always #10 cycles = cycles + 1;

    initial begin
        $dumpfile("./gcd.vcd");
        $dumpvars(0, gcd_tb);
    end

    task gcd_inputs(int a, int b);
        resetn_i = 1;
        ld_i = '1;
        a_i = a;
        b_i = b;
        #10;
        a_i = 0;
        b_i = 0;
        ld_i = 0;
    endtask

    initial begin
        $monitor("Monitor backpressure signals | valid = %d || ready = %d", valid_o, ready_o);
        $monitor("GCD = %d", gcd_o);
        #1;
        clk_i = 0;
        resetn_i = 0;
        ld_i = 0;
        a_i = 0;
        b_i = 0;
        #20;
        // start the datapath operations
        $display("cycle count before GCD input: %d", cycles);

        gcd_inputs(48, 18);
        for (int i = 0; i < TEST_CYCLES; i++ )  begin
            #10;
            if(valid_o) begin
                $display("Cycle Count for GCD = %d", cycles);
                break;
                end
        end

        resetn_i = 0;
        #20;
        gcd_inputs(1701, 199);

        for (int i = 0; i < TEST_CYCLES; i++ )  begin
            #10;
            if(valid_o) begin
                $display("Cycle Count for GCD = %d", cycles);
                break;
                end
        end

        resetn_i = 0;
        #20;
        gcd_inputs(22000, 19900);

        for (int i = 0; i < TEST_CYCLES; i++ )  begin
            #10;
            if(valid_o) begin
                $display("Cycle Count for GCD = %d", cycles);
                break;
                end
        end

        resetn_i = 0;
        #20;
        gcd_inputs(17, 289);

        for (int i = 0; i < TEST_CYCLES; i++ )  begin
            #10;
            if(valid_o) begin
                $display("Cycle Count for GCD = %d", cycles);
                break;
                end
        end


        $finish;

    end


endmodule
