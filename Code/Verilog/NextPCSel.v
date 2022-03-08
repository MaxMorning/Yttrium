`include "Exception.v"

module NextPCSel (
    input wire[31:0] i_IF_current_pc,
    input wire i_ID_is_branch_jump_instr,
    input wire[31:0] i_ID_branch_jump_dst_pc,

    input wire  i_MEM_is_eret,
    input wire[31:0] i_MEM_epc_value,

    input wire i_answer_exc,
    input wire[4:0] i_MEM_exception_cause,

    output reg[31:0] o_IF_next_pc
);
    wire[31:0] normal_next_pc = i_IF_current_pc + 4;

    always @(*) begin
        if (i_answer_exc) begin
            case (i_MEM_exception_cause)
                `EXC_CAUSE_INT:
                    o_IF_next_pc <= `INT_PROC_ENTRY;

                `EXC_CAUSE_ADEL,
                `EXC_CAUSE_ADES,
                `EXC_CAUSE_SYS,
                `EXC_CAUSE_BP,
                `EXC_CAUSE_RI,
                `EXC_CAUSE_OV,
                `EXC_CAUSE_TRAP:
                    o_IF_next_pc <= `EXC_PROC_ENTRY;

                default:
                    o_IF_next_pc <= 32'hffffffff; // this should not be executed
            endcase
        end
        else if (i_MEM_is_eret) begin
            o_IF_next_pc <= i_MEM_epc_value;
        end
        else if (i_ID_is_branch_jump_instr) begin
            o_IF_next_pc <= i_ID_branch_jump_dst_pc;
        end
        else begin
            o_IF_next_pc <= normal_next_pc;
        end
    end
endmodule