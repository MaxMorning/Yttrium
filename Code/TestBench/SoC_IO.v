module SoC (
    input wire base_clk,
    input wire reset, // positive active reset signal

    output wire[7:0] o_seg,
    output wire[7:0] o_sel
);
    
    wire clk;

    wire clk_interruption;

    wire[31:0] IMEM_core_rdata;
    wire[31:0] core_IMEM_raddr;

    wire[31:0] DMEM_core_rdata;
    wire[31:0] core_DMEM_addr;
    wire[31:0] core_DMEM_wdata;
    wire core_DMEM_we;
    wire[3:0] core_DMEM_sel;

    wire[31:0] ANSCODE;
    
    Core core0(
        .clk(clk),
        .resetn(~reset),

        .i_interruption({clk_interruption, i_interruption}),

        .i_IMEM_rdata(IMEM_core_rdata),
        .o_IMEM_raddr(core_IMEM_raddr),

        .i_DMEM_rdata(DMEM_core_rdata),

        .o_DMEM_addr(core_DMEM_addr),
        .o_DMEM_wdata(core_DMEM_wdata),
        .o_DMEM_we(core_DMEM_we),

        .o_DMEM_sel(core_DMEM_sel),

        .o_timer_int(clk_interruption)
    );

    IMEM imem_inst(
        .a(core_IMEM_raddr[31:2]),

        .spo(IMEM_core_rdata)
    );

    DMEM dmem_inst(
        .clk(clk),
        .resetn(~reset),
        .we(core_DMEM_we),

        .addr(core_DMEM_addr),
        .wdata_sel(core_DMEM_sel),
        .wdata(core_DMEM_wdata),

        .ANSCODE_reg(ANSCODE),
        .rdata(DMEM_core_rdata)
    );


    // assign clk = base_clk;
    clock_div clock_div_inst(
        .clk_in1(base_clk),
        .clk_out1(clk),
        .resetn(~reset)
    );

    seg7x16 seg7_inst(
        .clk(base_clk),
        .reset(reset),
        .cs(1'b1),
        .i_data(ANSCODE),
        .o_seg(o_seg),
        .o_sel(o_sel)
    );
endmodule