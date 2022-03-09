module PipelineController (
    input wire clk,
    input wire resetn,

    input wire i_div_busy,

    input wire i_ID_data_related_confict,
    input wire i_MEM_answer_exc,


    output wire o_IF_ID_ena,
    output wire o_ID_EXE_ena,
    output wire o_EXE_MEM_ena,
    output wire o_MEM_WB_ena
);

    reg[3:0] control_regs;

    // reg div_busy;

    assign o_IF_ID_ena = ~i_MEM_answer_exc & ~i_div_busy & control_regs[3];
    assign o_ID_EXE_ena = ~i_MEM_answer_exc & ~i_div_busy & control_regs[2];
    assign o_EXE_MEM_ena = ~i_MEM_answer_exc & ~i_div_busy & control_regs[1];
    assign o_MEM_WB_ena = ~i_div_busy & control_regs[0];

    // always @(posedge clk or negedge resetn) begin
    //     if (!resetn) begin
    //         div_busy <= 0;
    //     end
    //     else if (div_busy && ~i_div_busy) begin
    //         div_busy <= 0;
    //     end
    //     else if (~div_busy && i_div_busy) begin
    //         div_busy <= 1;
    //     end
    // end

    always @(posedge clk) begin
        if (!resetn) begin
            control_regs <= 4'b1000;
        end
        else if (~i_div_busy) begin
            control_regs[3] <= 1;
            control_regs[2] <= control_regs[3];
            control_regs[1] <= control_regs[2];
            control_regs[0] <= control_regs[1];
        end
    end
endmodule