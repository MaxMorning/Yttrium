module MotherBoard (
    input wire clk,
    input wire reset, // positive active reset signal
    
    input wire[4:0] i_interruption

);
    
    wire clk_interruption;

    wire[31:0] IMEM_core_rdata;
    wire[31:0] core_IMEM_raddr;

    wire[31:0] DMEM_core_rdata;
    wire[31:0] core_DMEM_addr;
    wire[31:0] core_DMEM_wdata;
    wire core_DMEM_we;
    wire[3:0] core_DMEM_sel;
    
    Core core_0(
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

        .we(core_DMEM_we),

        .raddr(core_DMEM_addr),
        .wdata_sel(core_DMEM_sel),
        .wdata(core_DMEM_wdata),

        .rdata(DMEM_core_rdata)
    );
endmodule