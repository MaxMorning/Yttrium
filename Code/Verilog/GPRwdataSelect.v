`include "SelectSignal.v"

module GPRwdataSelect (
    input wire[2:0] i_GPR_wdata_sel,

    input wire[31:0] i_alu_result,
    input wire[31:0] i_mul_result,
    input wire[31:0] i_llbit_result,
    input wire[31:0] i_cp0_result,
    input wire[31:0] i_lo_reg_result,
    input wire[31:0] i_hi_reg_result,
    input wire[31:0] i_mem_result,
    input wire[31:0] i_pc_result,

    output reg[31:0] o_wdata_result
);
    always @(*) begin
        case (i_GPR_wdata_sel)
            `GPR_W_SEL_ALU:
                o_wdata_result <= i_alu_result;

            `GPR_W_SEL_MUL:
                o_wdata_result <= i_mul_result;

            `GPR_W_SEL_CP0:
                o_wdata_result <= i_cp0_result;

            `GPR_W_SEL_LO:
                o_wdata_result <= i_lo_reg_result;

            `GPR_W_SEL_HI:
                o_wdata_result <= i_hi_reg_result;

            `GPR_W_SEL_MEM:
                o_wdata_result <= i_mem_result;

            `GPR_W_SEL_PC:
                o_wdata_result <= i_pc_result;

            default: // GPR_W_SEL_LLBIT
                o_wdata_result <= i_llbit_result;

        endcase
    end
endmodule