`timescale 1ns / 1ns

// Initialize some program data into memory (instr.riscv) elf
// Cross verify contents through input file

module top_imem;

    logic clock, aresetn;
    logic rw_en;
    logic [31:0] address_in;
    logic [31:0] data_in;

    logic [31:0] inst_out;

    logic [31:0] mem [512];


    imem2048 #(.XLEN(64)) IMem (.clk_i(clock),
                                .aresetn_i(aresetn),
                                .rw_en_i(rw_en),
                                .pc_i(address_in),
                                .data_i(data_in),

                                // .valid_o(out_valid),
                                .instr_o(inst_out) );

    always #5 clock = ~clock;

    // task load_program ();
    //     aresetn = '0;
    //     rw_en = '1;
    //     #10;
    //     for (int i = 0; i < ; ++i )  begin
    //     end
    // endtask

    initial begin
        clock = 0;
        #9;
        aresetn = 0;
        rw_en = 0;
        address_in = '0;
        data_in = '0;
        #10;
        aresetn = '0;
        rw_en = '1;
        $readmemh("rv64ui-p-simple32.hex", mem);

        for (int i = 0; i < 512; i++ )  begin
            address_in = i;
            data_in = mem[i];
            #10;
            $display("Load Address = %d | instruction loaded == %h", i, data_in);
        end

        #100;
        $finish;

    end





endmodule
