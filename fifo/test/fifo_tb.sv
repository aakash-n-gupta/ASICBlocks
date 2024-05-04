`timescale 1ns / 1ns

module fifo_tb;

  parameter DATA_WIDTH = 32;
  parameter MAX = 256;

  logic clock, resetn;
  logic wr_en, rd_en;
  logic [DATA_WIDTH-1:0] data_in;
  logic [DATA_WIDTH-1:0] data_out;
  logic full, empty;

  // Queue to push data_in
  logic [DATA_WIDTH-1:0] wdata_q[$], wdata;

  fifo #(.DEPTH(MAX)) s_fifo
                (clock,
                resetn,
                wr_en,
                rd_en,
                data_in,

                full,
                empty,
                data_out);

    always #5ns clock = ~clock;

    initial begin
      clock = 1'b0;
      resetn = 1'b0;
      wr_en = 1'b0;
      rd_en = '0;
      data_in = '0;
      wdata = '0;
  end

  initial begin
    $dumpfile("fifo.vcd");
    $dumpvars(0, fifo_tb);
  end

  task push(int MAX);
    if(!full) begin
      for (int i = 0; i < MAX; ++i) begin
        wr_en = 1;
        rd_en = 0;
        data_in = $urandom;
        wdata_q.push_back(data_in);
        #10;
        $display("Push In: wr_en = %d, rd_en = %d, data_in = %d", wr_en, rd_en, data_in);
      end
    end
    else if(full)
      $display("FIFO Full!! Can not push data_in = %d ", data_in);
  endtask


  task pop(int MAX);
    if(!empty) begin
      for (int i = 0; i < MAX; ++i) begin
        rd_en = 1;
        wr_en = 0;
        #10;
        if (data_out != wdata_q.pop_front()) begin
          $display("Test Failed, wdata = %d data_out = %d", wdata_q.pop_front(), data_out);
        end
        $display("Pop Out: wr_en = %d, rd_en = %d, data_out = %d", wr_en, rd_en, data_out);
      end
    end
    else if (empty)
      $display("FIFO Empty!! Can not pop data_out");
  endtask

  initial begin
    #10;
    resetn = '1;
    #10;

  //   push(1);
  //   wr_en = 0;
  //   rd_en = 1;
  //   #50;
  // for (int i = 0; i < 10; i++ )  begin
  //   push(1);
  //   wr_en = 0;
  //   rd_en = 1;
  // end
  // wr_en = 1;


    $display("Push 24 data in");
    push(24);
    $display("Pop 20 data out");
    pop(20);
    $display("Pop 4 data out");
    pop(4);
    rd_en = '1;
    wr_en  = '0;
    data_in = '0;
    #100;
    $display("--------------------------------");
    $display("TEST1: Fill fifo to %d", MAX);
    push(100);
    $display("Pushed %d words into FIFO", MAX);
    $display("Starting to read data from fifo");
    pop(100);
    $display("--------------------------------");
    $display("TEST1: Fill fifo to %d Complete", MAX);

    // Test reset\
    $display("TEST2: TEST RESET");
    resetn = '0;
    rd_en = '0;
    #50;
    resetn = '1;
    #100;
    $display("FIFO State|| Full = %d  Empty = %d", full, empty);
    $display("");
    $display("--------------------------------");
    $display("TEST3: FIFO Overflow");
    $display("Push %d words into FIFO", (MAX+5));
    push(MAX+5);
    $display("Starting to read data from fifo, after overflow");
    pop(MAX+5);
    $display("--------------------------------");
    $display("TEST3: fifo Overflow completed");

    #100;
    $finish;
  end

endmodule
