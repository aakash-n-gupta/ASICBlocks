`timescale 1ns / 1ps

// Initialize some program data into memory (instr.riscv) elf
// Cross verify contents through input file

module mult_control_tb;

    logic clock, resetn;
    logic eqz;
    logic ld_input;

    logic ready;
    logic done;
    logic [1:0] state;

    logic [3:0] dummy;

    mult_control DUT_Control (  .clk(clock),
                                .resetn(resetn),
                                .eqz(eqz),
                                .ld_input(ld_input),

                                .ready(ready),
                                .done(done),
                                .state(state)
);

    always #5 clock = ~clock;
    initial begin
        $dumpfile("controller.vcd");
        $dumpvars(0, mult_control_tb);
    end

    initial begin
        #1;
        clock = 0;
        resetn = 0;
        eqz = 0;
        ld_input = 0;
        #4;
        // start the state machine
        resetn = 1;
        eqz = 0;
        ld_input = '1;
        dummy = 15;
        #10;
        $display("Expected State : Operate");
        $display("Current State  : %d", state);

        // Do some things in meanwhile
        for (int i = 0; i < 16; i++)
        begin
            dummy = dummy - 1;
            #10;
            if(dummy == 0)
                eqz = 1;
        end


        #100;
        $finish;

    end





endmodule
