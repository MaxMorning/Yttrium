module RegFile (
    input wire clk,
    input wire resetn,

    input wire i_we,
    input wire[4:0] i_raddr1,
    input wire[4:0] i_raddr2,
    input wire[4:0] i_waddr,
    input wire[31:0] i_wdata,

    output wire[31:0] o_rdata1,
    output wire[31:0] o_rdata2
);
    reg[31:0] array_reg[31:0];
    assign o_rdata1 = i_we && (i_waddr == i_raddr1) && (i_waddr != 0) ? i_wdata : array_reg[i_raddr1];
    assign o_rdata2 = i_we && (i_waddr == i_raddr2) && (i_waddr != 0) ? i_wdata : array_reg[i_raddr2];

    integer i;
    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            for (i = 0; i < 32; i = i + 1) begin
                array_reg[i] <= 32'h0;
            end
        end
        else if (i_we && i_waddr != 4'b0000) begin
            array_reg[i_waddr] <= i_wdata;
        end
    end
endmodule