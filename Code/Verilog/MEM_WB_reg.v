module MEM_WB_reg (
    input wire clk,
    input wire resetn,

    input wire i_ena,

    input wire i_MEM_GPR_we,
    input wire[4:0] i_MEM_GPR_waddr,
    input wire[31:0] i_MEM_GPR_wdata,

    output wire o_WB_GPR_we,
    output wire[4:0] o_WB_GPR_waddr,
    output wire[31:0] o_WB_GPR_wdata
);
    
    wire WB_GPR_we;

    assign o_WB_GPR_we = WB_GPR_we & i_ena;
    
    RegWithWE #(1) gpr_we_reg(
        .clk(clk),
        .resetn(resetn),

        .i_data(i_MEM_GPR_we),
        .i_we(i_ena),

        .o_data(WB_GPR_we)
    );

    RegWithWE #(5) gpr_waddr_reg(
        .clk(clk),
        .resetn(resetn),

        .i_data(i_MEM_GPR_waddr),
        .i_we(i_ena),

        .o_data(o_WB_GPR_waddr)
    );

    RegWithWE #(32) gpr_wdata_reg(
        .clk(clk),
        .resetn(resetn),

        .i_data(i_MEM_GPR_wdata),
        .i_we(i_ena),

        .o_data(o_WB_GPR_wdata)
    );
endmodule