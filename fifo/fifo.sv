`timescale 1ns / 1ns

module fifo #(parameter int DEPTH = 256) (
    input clock,
    input resetn,
    input wr_en,
    input rd_en,
    input [31:0] data_in,

    output full,
    output empty,
    output logic [31:0] data);

    logic [31:0] data_read;
    logic [31:0] data_write;

    // Keep track of fifo
    logic [($clog2(DEPTH) - 1):0] rd_ptr;
    logic [($clog2(DEPTH) - 1):0] wr_ptr;
    logic [($clog2(DEPTH) - 1):0] addr_ptr;

    // Single address port, need to be carefull about .addr_in port.
    // Also interesting is that the fakeram does not have a reset.

    fakeram7_256x32 fifo(   .rd_out(data_read),             // read data out
                            .addr_in(addr_ptr),             // read/write data address in
                            .we_in(wr_en),                  // write enable in
                            .wd_in(data_write),             // write data in
                            .clk(clock),                    // clock
                            .ce_in('1)                      // chip enable
    );

    // Presidence will be given to writes,
    assign addr_ptr = wr_en ? wr_ptr : rd_ptr;

     always_ff @(posedge clock)
    begin
        if (!resetn) begin
            // FIFO will be reset, data will not be available
            wr_ptr <= '0;
        end
        else begin
            case ({rd_en, wr_en})
            2'b00:            wr_ptr <= wr_ptr;
            2'b01: if (!full) wr_ptr <= wr_ptr + 1;
            2'b10: if(!empty) wr_ptr <= wr_ptr - 1;
            2'b11:            wr_ptr <= wr_ptr;
            endcase
        end
    end

    //  Push data into FIFO @wr_ptr
    always_ff @(posedge clock)
    begin
        if (!full && wr_en) begin
            data_write <= data_in;
        end
    end

    // read data from FIFO head
    always_ff @(posedge clock)
    begin
        if (!resetn) begin
            rd_ptr <= '0;
        end
        if (!empty && rd_en) begin
            data <= data_read;
            rd_ptr <= rd_ptr + 1;
        end
    end

    // if wr_ptr = MAX, fifo full, if 0, fifo empty
    assign full     = (wr_ptr == '1);
    assign empty    = (wr_ptr == '0);

endmodule
