module PipelineController (
    input wire clk,
    input wire resetn,

    input wire i_div_busy,
    input wire i_div_done,

    input wire i_branch_wrong_pred,


    output wire o_IF_ID_ena,
    output wire o_ID_EXE_ena,
    output wire o_EXE_MEM_ena,
    output wire o_MEM_WB_ena
);

    reg[3:0] control_regs;

    reg div_busy;

    assign o_IF_ID_ena = control_regs[3];
    assign o_ID_EXE_ena = control_regs[2];
    assign o_EXE_MEM_ena = control_regs[1];
    assign o_MEM_WB_ena = control_regs[0];

    always @(posedge clk) begin
        if (!resetn || i_branch_wrong_pred) begin
            div_busy <= 0;
        end
        else if (div_busy && i_div_done) begin
            div_busy <= 0;
        end
        else if (~div_busy && i_div_busy) begin
            div_busy <= 1;
        end
    end

    always @(posedge clk) begin
        if (!resetn) begin
            control_regs <= 4'h1000;
        end
        else if (i_branch_wrong_pred) begin
            control_regs[3:1] <= 3'b000;
            control_regs[0] <= control_regs[1];
        end
        else if (~div_busy) begin
            control_regs[3] <= 1;
            control_regs[2] <= control_regs[3];
            control_regs[1] <= control_regs[2];
            control_regs[0] <= control_regs[1];
        end
    end
endmodule