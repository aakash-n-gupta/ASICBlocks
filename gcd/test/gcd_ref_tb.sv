`timescale 1ns / 1ps

module gcd_ref_tb;

    parameter XLEN = 16;
    parameter TEST_CYCLES = 100;
    int cycles = 0;

    logic clk, reset;
    logic [2*XLEN-1:0] req_msg;
    logic req_val;

    logic [XLEN-1:0] a_i;
    logic [XLEN-1:0] b_i;

    logic req_rdy;
    logic [XLEN-1:0] resp_msg;
    logic resp_rdy;
    logic resp_val;

    gcd_ref DUT(.*);

    always #5 clk = ~clk;
    always #10 cycles = cycles + 1;

    initial begin
        $dumpfile("./gcd_ref.vcd");
        $dumpvars(0, gcd_ref_tb);
    end

    task gcd_inputs(int a, int b);
        reset = 0;
        req_val = 1;
        req_msg = (a << 16) + b;
        #10;
        if(!resp_rdy) begin
            $display("req_rdy response not recieved from core for a_i");
        end
        req_msg = '0;
        req_val = 0;
    endtask

    initial begin
        // $monitor("Monitor backpressure signals | valid = %d || ready = %d", resp_val, req_rdy);
        // $monitor("GCD = %d, resp_valid = %d", resp_msg, resp_val);
        #1;
        clk = 0;
        reset = 1;
        req_msg = '0;
        req_val = 0;
        #30;


        // start the datapath operations
        $display("cycle count before GCD input: %d", cycles);

        gcd_inputs(48, 18);
        for (int i = 0; i < TEST_CYCLES; i++ )  begin
            #10;
            if(resp_val) begin
                $display("Cycle Count for GCD = %d", cycles);
                $display("GCD = %d", resp_msg);
                break;
            end
        end

        reset = 1;
        #20;
        gcd_inputs(1701, 199);
        for (int i = 0; i < TEST_CYCLES; i++ )  begin
            #10;
            if(resp_val) begin
                $display("Cycle Count for GCD = %d", cycles);
                $display("GCD = %d", resp_msg);
                break;
            end
        end

        reset = 1;
        #20;
        gcd_inputs(22000, 19900);
        for (int i = 0; i < TEST_CYCLES; i++ )  begin
            #10;
            if(resp_val) begin
                $display("Cycle Count for GCD = %d", cycles);
                $display("GCD = %d", resp_msg);
                break;
            end
        end

         reset = 1;
        #20;
        gcd_inputs(17, 289);
        $display("cycle count after GCD input : %d", cycles);

        for (int i = 0; i < TEST_CYCLES; i++ )  begin
            #10;
            if(resp_val) begin
                $display("Cycle Count for GCD = %d", cycles);
                $display("GCD = %d", resp_msg);
                break;
                end
        end


        #100;
        $finish;

    end


endmodule
