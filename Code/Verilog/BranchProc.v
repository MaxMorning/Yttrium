`include "Include/OP.v"

module BranchProc (
    input wire[31:0] i_current_pc,
    input wire[31:0] i_instr,

    input wire[31:0] i_GPR_rdata1,
    input wire[31:0] i_GPR_rdata2,

    output reg o_is_branch,
    output reg[31:0] o_next_pc
);
    wire[31:0] branch_dst_pc = i_current_pc + {{15{i_instr[15]}}, i_instr[14:0], 2'b00};
    wire[31:0] imm_jump_dst_pc = {i_current_pc[31:28], i_instr[25:0], 2'b00};

    wire[31:0] pc_plus_8 = i_current_pc + 8;

    always @(*) begin
        case (i_current_pc[31:26])
            `OP_BEQ:
            begin
                if (i_GPR_rdata1 == i_GPR_rdata2) begin
                    o_next_pc <= branch_dst_pc;
                end
                else begin
                    o_next_pc <= pc_plus_8;
                end
            end

            `OP_BNE:
            begin
                if (i_GPR_rdata1 != i_GPR_rdata2) begin
                    o_next_pc <= branch_dst_pc;
                end
                else begin
                    o_next_pc <= pc_plus_8;
                end
            end

            `OP_BGTZ:
            begin
                if ($signed(i_GPR_rdata1) > $signed(i_GPR_rdata2)) begin
                    o_next_pc <= branch_dst_pc;
                end
                else begin
                    o_next_pc <= pc_plus_8;
                end
            end

            `OP_BLEZ:
            begin
                if ($signed(i_GPR_rdata1) <= $signed(i_GPR_rdata2)) begin
                    o_next_pc <= branch_dst_pc;
                end
                else begin
                    o_next_pc <= pc_plus_8;
                end
            end

            `OP_REGIMM:
            begin
                case (i_current_pc[20:16])
                    `RT_BGEZ:
                    `RT_BGEZAL:
                    begin
                        if (i_GPR_rdata1[31]) begin
                            // negative , not branch
                            o_next_pc <= pc_plus_8;
                        end
                        else begin
                            o_next_pc <= branch_dst_pc;
                        end
                    end

                    `RT_BLTZ:
                    `RT_BLTZAL:
                    begin
                        if (i_GPR_rdata1[31]) begin
                            // negative , branch
                            o_next_pc <= branch_dst_pc;
                        end
                        else begin
                            o_next_pc <= pc_plus_8;
                        end
                    end
                    default:
                    begin
                        o_next_pc <= pc_plus_8;
                    end
                endcase
            end

            `OP_J:
            `OP_JAL:
            begin
                o_next_pc <= imm_jump_dst_pc;
            end

            `OP_SPECIAL:
            begin
                case (i_instr[5:0])
                    `FUNC_JALR:
                    `FUNC_JR:
                    begin
                        o_next_pc <= i_GPR_rdata1;
                    end

                    default:
                    begin
                        o_next_pc <= pc_plus_8;
                    end
                endcase
            end

            default: 
            begin
                o_next_pc <= pc_plus_8;
            end
        endcase
    end

    always @(*) begin
        case (i_current_pc[31:26])
            `OP_BEQ:
            `OP_BNE:
            `OP_BGTZ:
            `OP_BLEZ:
            `OP_J:
            `OP_JAL:
            begin
                o_is_branch <= 1;
            end

            `OP_REGIMM:
            begin
                case (i_current_pc[20:16])
                    `RT_BGEZ:
                    `RT_BGEZAL:
                    `RT_BLTZ:
                    `RT_BLTZAL:
                    begin
                        o_is_branch <= 1;
                    end

                    default:
                    begin
                        o_is_branch <= 0;
                    end
                endcase
            end

            `OP_SPECIAL:
            begin
                case (i_instr[5:0])
                    `FUNC_JALR:
                    `FUNC_JR:
                    begin
                        o_is_branch <= 1;
                    end

                    default:
                    begin
                        o_is_branch <= 0;
                    end
                endcase
            end

            default:
            begin
                o_is_branch <= 0;
            end
        endcase
    end
endmodule