`timescale 1ns / 1ns

module imem2048 #(parameter XLEN = 64)(
    input               clk_i,
    input               aresetn_i,
    input               rw_en_i,
    input  [31:0]       pc_i,
    input  [31:0]       data_i,

    output [31:0]       instr_o
    // output              valid
);

    logic [8:0] inst_addr;
    // logic [1:0] imem_chip_en;

    logic [31:0] inst;
    assign inst_addr = pc_i[10:2];

    assign instr_o = inst;

    fakeram_512x8 imem0 (
                        .rd_out(inst[7:0]),
                        .addr_in(inst_addr),
                        .we_in(rw_en_i),
                        .wd_in(data_i[7:0]),
                        .clk(clk_i),
                        .ce_in(1'b1)
    );

    fakeram_512x8 imem1 (
                        .rd_out(inst[15:8]),
                        .addr_in(inst_addr),
                        .we_in(rw_en_i),
                        .wd_in(data_i[15:8]),
                        .clk(clk_i),
                        .ce_in(1'b1)
    );

    fakeram_512x8 imem2 (
                        .rd_out(inst[23:16]),
                        .addr_in(inst_addr),
                        .we_in(rw_en_i),
                        .wd_in(data_i[23:16]),
                        .clk(clk_i),
                        .ce_in(1'b1)
    );

    fakeram_512x8 imem3 (
                        .rd_out(inst[31:24]),
                        .addr_in(inst_addr),
                        .we_in(rw_en_i),
                        .wd_in(data_i[31:24]),
                        .clk(clk_i),
                        .ce_in(1'b1)
    );

    
endmodule

