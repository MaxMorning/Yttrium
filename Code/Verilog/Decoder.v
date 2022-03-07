`timescale 1ns/1ps
`include "Include/OP.v"
`include "Include/SelectSignal.v"

module Decoder (
    input wire[31:0] i_instr,
    input wire[31:0] i_rs_rdata,
    input wire[31:0] i_rt_rdata,

    input wire[31:0] i_pc,

    output reg o_get_result_in_EXE,
    output reg o_get_result_in_MEM,

    output reg[31:0] o_ALU_opr1,
    output reg[31:0] o_ALU_opr2,
    output reg[4:0] o_ALU_op,

    output reg[4:0] o_GPR_waddr,
    output reg o_gpr_we,
    output reg o_hi_we,
    output reg o_lo_we,

    output reg o_CP0_we,

    output reg o_mem_we,

    output reg o_is_trap,
    // output reg o_is_branch,
    // output reg o_is_jump,
    output wire o_is_syscall,
    output wire o_is_eret,
    output wire o_is_div,
    output wire o_is_mult_first, // MADD / MADDU / MSUB / MSUBU
    output reg[4:0] o_except_cause,

    output reg[2:0] o_GPR_w_sel,
    output reg[1:0] o_LoHi_w_sel,

    output wire o_CP0_we,

    output wire o_is_LL,
    output wire o_is_SC
);

    assign o_is_syscall = i_instr[31:26] == OP_SPECIAL && i_instr[5:0] == FUNC_SYSCALL;
    assign o_is_eret = i_instr[31:26] == OP_COP0 && i_instr[25:21] == RS_ERET;
    assign o_is_div = i_instr[31:26] == OP_SPECIAL && i_instr[5:1] == FUNC_DIV[5:1];
    assign o_is_mult_first = i_instr[31:26] == OP_SPECIAL2 && i_instr[5:3] == 3'b000 && i_instr[1] == 1'b1;

    wire[31:0] type_i_zero_ext = {16'h0, i_instr[15:0]};
    wire[31:0] type_i_sign_ext = {{17{i_instr[15]}}, i_instr[14:0]};

    wire[4:0] rt_addr = i_instr[20:16];
    wire[4:0] rd_addr = i_instr[15:11];

    always @(*) begin
        case (i_instr[31:26])
            OP_SPECIAL:
            begin
                case (i_instr[5:0]) 
                    FUNC_AND:
                    begin
                        o_ALU_opr1 <= i_rs_rdata;
                        o_ALU_opr2 <= i_rt_rdata;
                        o_ALU_op <= ALU_AND;

                        o_GPR_waddr <= rd_addr;

                        o_gpr_we <= 1;
                        o_hi_we <= 0;
                        o_lo_we <= 0;

                        o_CP0_we <= 0;

                        o_is_trap <= 0;
                        o_is_branch <= 0;
                        o_is_jump <= 0;
                        o_except_cause <= 5'hX;

                        o_GPR_w_sel <= GPR_W_SEL_ALU;
                        o_LoHi_w_sel <= 2'hX;
                    end

                    FUNC_OR:
                    begin
                        o_ALU_opr1 <= i_rs_rdata;
                        o_ALU_opr2 <= i_rt_rdata;
                        o_ALU_op <= ALU_OR;

                        o_GPR_waddr <= rd_addr;
                        
                        o_gpr_we <= 1;
                        o_hi_we <= 0;
                        o_lo_we <= 0;

                        o_CP0_we <= 0;

                        o_is_trap <= 0;
                        o_is_branch <= 0;
                        o_is_jump <= 0;
                        o_except_cause <= 5'hX;

                        o_GPR_w_sel <= GPR_W_SEL_ALU;
                        o_LoHi_w_sel <= 2'hX;
                    end

                    FUNC_XOR:
                    begin
                        o_ALU_opr1 <= i_rs_rdata;
                        o_ALU_opr2 <= i_rt_rdata;
                        o_ALU_op <= ALU_XOR;

                        o_GPR_waddr <= rd_addr;
                        
                        o_gpr_we <= 1;
                        o_hi_we <= 0;
                        o_lo_we <= 0;

                        o_CP0_we <= 0;

                        o_is_trap <= 0;
                        o_is_branch <= 0;
                        o_is_jump <= 0;
                        o_except_cause <= 5'hX;

                        o_GPR_w_sel <= GPR_W_SEL_ALU;
                        o_LoHi_w_sel <= 2'hX;
                    end

                    FUNC_NOR:
                    begin
                        o_ALU_opr1 <= i_rs_rdata;
                        o_ALU_opr2 <= i_rt_rdata;
                        o_ALU_op <= ALU_NOR;

                        o_GPR_waddr <= rd_addr;
                        
                        o_gpr_we <= 1;
                        o_hi_we <= 0;
                        o_lo_we <= 0;

                        o_CP0_we <= 0;

                        o_is_trap <= 0;
                        o_is_branch <= 0;
                        o_is_jump <= 0;
                        o_except_cause <= 5'hX;

                        o_GPR_w_sel <= GPR_W_SEL_ALU;
                        o_LoHi_w_sel <= 2'hX;
                    end

                    FUNC_SLL:
                    begin
                        o_ALU_opr1 <= i_rt_rdata;
                        o_ALU_opr2 <= {27'h0, i_instr[10:6]};
                        o_ALU_op <= ALU_SLL;

                        o_GPR_waddr <= rd_addr;
                        
                        o_gpr_we <= 1;
                        o_hi_we <= 0;
                        o_lo_we <= 0;

                        o_CP0_we <= 0;

                        o_is_trap <= 0;
                        o_is_branch <= 0;
                        o_is_jump <= 0;
                        o_except_cause <= 5'hX;

                        o_GPR_w_sel <= GPR_W_SEL_ALU;
                        o_LoHi_w_sel <= 2'hX;
                    end

                    FUNC_SLLV:
                    begin
                        o_ALU_opr1 <= i_rs_rdata;
                        o_ALU_opr2 <= i_rt_rdata;
                        o_ALU_op <= ALU_SLL;

                        o_GPR_waddr <= rd_addr;
                        
                        o_gpr_we <= 1;
                        o_hi_we <= 0;
                        o_lo_we <= 0;

                        o_CP0_we <= 0;

                        o_is_trap <= 0;
                        o_is_branch <= 0;
                        o_is_jump <= 0;
                        o_except_cause <= 5'hX;

                        o_GPR_w_sel <= GPR_W_SEL_ALU;
                        o_LoHi_w_sel <= 2'hX;
                    end

                    FUNC_SRA:
                    begin
                        o_ALU_opr1 <= i_rt_rdata;
                        o_ALU_opr2 <= {27'h0, i_instr[10:6]};
                        o_ALU_op <= ALU_SRA;

                        o_GPR_waddr <= rd_addr;
                        
                        o_gpr_we <= 1;
                        o_hi_we <= 0;
                        o_lo_we <= 0;

                        o_CP0_we <= 0;

                        o_is_trap <= 0;
                        o_is_branch <= 0;
                        o_is_jump <= 0;
                        o_except_cause <= 5'hX;

                        o_GPR_w_sel <= GPR_W_SEL_ALU;
                        o_LoHi_w_sel <= 2'hX;
                    end

                    FUNC_SRAV:
                    begin
                        o_ALU_opr1 <= i_rs_rdata;
                        o_ALU_opr2 <= i_rt_rdata;
                        o_ALU_op <= ALU_SRA;

                        o_GPR_waddr <= rd_addr;
                        
                        o_gpr_we <= 1;
                        o_hi_we <= 0;
                        o_lo_we <= 0;

                        o_CP0_we <= 0;

                        o_is_trap <= 0;
                        o_is_branch <= 0;
                        o_is_jump <= 0;
                        o_except_cause <= 5'hX;

                        o_GPR_w_sel <= GPR_W_SEL_ALU;
                        o_LoHi_w_sel <= 2'hX;
                    end

                    FUNC_SRL:
                    begin
                        o_ALU_opr1 <= i_rt_rdata;
                        o_ALU_opr2 <= {27'h0, i_instr[10:6]};
                        o_ALU_op <= ALU_SRL;

                        o_GPR_waddr <= rd_addr;
                        
                        o_gpr_we <= 1;
                        o_hi_we <= 0;
                        o_lo_we <= 0;

                        o_CP0_we <= 0;

                        o_is_trap <= 0;
                        o_is_branch <= 0;
                        o_is_jump <= 0;
                        o_except_cause <= 5'hX;

                        o_GPR_w_sel <= GPR_W_SEL_ALU;
                        o_LoHi_w_sel <= 2'hX;
                    end

                    FUNC_SRLV:
                    begin
                        o_ALU_opr1 <= i_rs_rdata;
                        o_ALU_opr2 <= i_rt_rdata;
                        o_ALU_op <= ALU_SRL;

                        o_GPR_waddr <= rd_addr;
                        
                        o_gpr_we <= 1;
                        o_hi_we <= 0;
                        o_lo_we <= 0;

                        o_CP0_we <= 0;

                        o_is_trap <= 0;
                        o_is_branch <= 0;
                        o_is_jump <= 0;
                        o_except_cause <= 5'hX;

                        o_GPR_w_sel <= GPR_W_SEL_ALU;
                        o_LoHi_w_sel <= 2'hX;
                    end

                    FUNC_MOVN:
                    begin
                        o_ALU_opr1 <= i_rs_rdata;
                        o_ALU_opr2 <= i_rt_rdata;
                        o_ALU_op <= ALU_MOVN;

                        o_GPR_waddr <= rd_addr;
                        
                        o_gpr_we <= 1;
                        o_hi_we <= 0;
                        o_lo_we <= 0;

                        o_CP0_we <= 0;

                        o_is_trap <= 0;
                        o_is_branch <= 0;
                        o_is_jump <= 0;
                        o_except_cause <= 5'hX;

                        o_GPR_w_sel <= GPR_W_SEL_ALU;
                        o_LoHi_w_sel <= 2'hX;
                    end

                    FUNC_MOVZ:
                    begin
                        o_ALU_opr1 <= i_rs_rdata;
                        o_ALU_opr2 <= i_rt_rdata;
                        o_ALU_op <= ALU_MOVZ;

                        o_GPR_waddr <= rd_addr;
                        
                        o_gpr_we <= 1;
                        o_hi_we <= 0;
                        o_lo_we <= 0;

                        o_CP0_we <= 0;

                        o_is_trap <= 0;
                        o_is_branch <= 0;
                        o_is_jump <= 0;
                        o_except_cause <= 5'hX;

                        o_GPR_w_sel <= GPR_W_SEL_ALU;
                        o_LoHi_w_sel <= 2'hX;
                    end

                    FUNC_MFHI:
                    begin
                        o_ALU_opr1 <= 32'hX;
                        o_ALU_opr2 <= 32'hX;
                        o_ALU_op <= ALU_NOP;

                        o_GPR_waddr <= rd_addr;
                        
                        o_gpr_we <= 1;
                        o_hi_we <= 0;
                        o_lo_we <= 0;

                        o_CP0_we <= 0;

                        o_is_trap <= 0;
                        o_is_branch <= 0;
                        o_is_jump <= 0;
                        o_except_cause <= 5'hX;

                        o_GPR_w_sel <= GPR_W_SEL_HI;
                        o_LoHi_w_sel <= 2'hX;
                    end

                    FUNC_MFLO:
                    begin
                        o_ALU_opr1 <= 32'hX;
                        o_ALU_opr2 <= 32'hX;
                        o_ALU_op <= ALU_NOP;

                        o_GPR_waddr <= rd_addr;
                        
                        o_gpr_we <= 1;
                        o_hi_we <= 0;
                        o_lo_we <= 0;

                        o_CP0_we <= 0;

                        o_is_trap <= 0;
                        o_is_branch <= 0;
                        o_is_jump <= 0;
                        o_except_cause <= 5'hX;

                        o_GPR_w_sel <= GPR_W_SEL_LO;
                        o_LoHi_w_sel <= 2'hX;
                    end

                    FUNC_MTHI:
                    begin
                        o_ALU_opr1 <= 32'hX;
                        o_ALU_opr2 <= 32'hX;
                        o_ALU_op <= ALU_NOP;

                        o_GPR_waddr <= 5'hX;
                        
                        o_gpr_we <= 0;
                        o_hi_we <= 1;
                        o_lo_we <= 0;

                        o_CP0_we <= 0;

                        o_is_trap <= 0;
                        o_is_branch <= 0;
                        o_is_jump <= 0;
                        o_except_cause <= 5'hX;

                        o_GPR_w_sel <= 3'hX;
                        o_LoHi_w_sel <= LH_W_SEL_GPR;
                    end

                    FUNC_MTLO:
                    begin
                        o_ALU_opr1 <= 32'hX;
                        o_ALU_opr2 <= 32'hX;
                        o_ALU_op <= ALU_NOP;

                        o_GPR_waddr <= 5'hX;
                        
                        o_gpr_we <= 0;
                        o_hi_we <= 0;
                        o_lo_we <= 1;

                        o_CP0_we <= 0;

                        o_is_trap <= 0;
                        o_is_branch <= 0;
                        o_is_jump <= 0;
                        o_except_cause <= 5'hX;

                        o_GPR_w_sel <= 3'hX;
                        o_LoHi_w_sel <= LH_W_SEL_GPR;
                    end

                    FUNC_ADD:
                    begin
                        o_ALU_opr1 <= i_rs_rdata;
                        o_ALU_opr2 <= i_rt_rdata;
                        o_ALU_op <= ALU_ADD;

                        o_GPR_waddr <= rd_addr;
                        
                        o_gpr_we <= 1;
                        o_hi_we <= 0;
                        o_lo_we <= 0;

                        o_CP0_we <= 0;

                        o_is_trap <= 0;
                        o_is_branch <= 0;
                        o_is_jump <= 0;
                        o_except_cause <= 5'hX;

                        o_GPR_w_sel <= GPR_W_SEL_ALU;
                        o_LoHi_w_sel <= 2'hX;
                    end

                    FUNC_ADDU:
                    begin
                        o_ALU_opr1 <= i_rs_rdata;
                        o_ALU_opr2 <= i_rt_rdata;
                        o_ALU_op <= ALU_ADDU;

                        o_GPR_waddr <= rd_addr;
                        
                        o_gpr_we <= 1;
                        o_hi_we <= 0;
                        o_lo_we <= 0;

                        o_CP0_we <= 0;

                        o_is_trap <= 0;
                        o_is_branch <= 0;
                        o_is_jump <= 0;
                        o_except_cause <= 5'hX;

                        o_GPR_w_sel <= GPR_W_SEL_ALU;
                        o_LoHi_w_sel <= 2'hX;
                    end

                    FUNC_SUB:
                    begin
                        o_ALU_opr1 <= i_rs_rdata;
                        o_ALU_opr2 <= i_rt_rdata;
                        o_ALU_op <= ALU_SUB;

                        o_GPR_waddr <= rd_addr;
                        
                        o_gpr_we <= 1;
                        o_hi_we <= 0;
                        o_lo_we <= 0;

                        o_CP0_we <= 0;

                        o_is_trap <= 0;
                        o_is_branch <= 0;
                        o_is_jump <= 0;
                        o_except_cause <= 5'hX;

                        o_GPR_w_sel <= GPR_W_SEL_ALU;
                        o_LoHi_w_sel <= 2'hX;
                    end

                    FUNC_SUBU:
                    begin
                        o_ALU_opr1 <= i_rs_rdata;
                        o_ALU_opr2 <= i_rt_rdata;
                        o_ALU_op <= ALU_SUBU;

                        o_GPR_waddr <= rd_addr;
                        
                        o_gpr_we <= 1;
                        o_hi_we <= 0;
                        o_lo_we <= 0;

                        o_CP0_we <= 0;

                        o_is_trap <= 0;
                        o_is_branch <= 0;
                        o_is_jump <= 0;
                        o_except_cause <= 5'hX;

                        o_GPR_w_sel <= GPR_W_SEL_ALU;
                        o_LoHi_w_sel <= 2'hX;
                    end

                    FUNC_SLT:
                    begin
                        o_ALU_opr1 <= i_rs_rdata;
                        o_ALU_opr2 <= i_rt_rdata;
                        o_ALU_op <= ALU_SLT;

                        o_GPR_waddr <= rd_addr;
                        
                        o_gpr_we <= 1;
                        o_hi_we <= 0;
                        o_lo_we <= 0;

                        o_CP0_we <= 0;

                        o_is_trap <= 0;
                        o_is_branch <= 0;
                        o_is_jump <= 0;
                        o_except_cause <= 5'hX;

                        o_GPR_w_sel <= GPR_W_SEL_ALU;
                        o_LoHi_w_sel <= 2'hX;
                    end

                    FUNC_SLTU:
                    begin
                        o_ALU_opr1 <= i_rs_rdata;
                        o_ALU_opr2 <= i_rt_rdata;
                        o_ALU_op <= ALU_SLTU;

                        o_GPR_waddr <= rd_addr;
                        
                        o_gpr_we <= 1;
                        o_hi_we <= 0;
                        o_lo_we <= 0;

                        o_CP0_we <= 0;

                        o_is_trap <= 0;
                        o_is_branch <= 0;
                        o_is_jump <= 0;
                        o_except_cause <= 5'hX;

                        o_GPR_w_sel <= GPR_W_SEL_ALU;
                        o_LoHi_w_sel <= 2'hX;
                    end

                    FUNC_MULT:
                    begin
                        o_ALU_opr1 <= 32'hX;
                        o_ALU_opr2 <= 32'hX;
                        o_ALU_op <= ALU_NOP;

                        o_GPR_waddr <= 5'hX;
                        
                        o_gpr_we <= 0;
                        o_hi_we <= 1;
                        o_lo_we <= 1;

                        o_CP0_we <= 0;

                        o_is_trap <= 0;
                        o_is_branch <= 0;
                        o_is_jump <= 0;
                        o_except_cause <= 5'hX;

                        o_GPR_w_sel <= 3'hX;
                        o_LoHi_w_sel <= LH_W_SEL_MUL;
                    end

                    FUNC_MULTU:
                    begin
                        o_ALU_opr1 <= 32'hX;
                        o_ALU_opr2 <= 32'hX;
                        o_ALU_op <= ALU_NOP;

                        o_GPR_waddr <= 5'hX;
                        
                        o_gpr_we <= 0;
                        o_hi_we <= 1;
                        o_lo_we <= 1;

                        o_CP0_we <= 0;

                        o_is_trap <= 0;
                        o_is_branch <= 0;
                        o_is_jump <= 0;
                        o_except_cause <= 5'hX;

                        o_GPR_w_sel <= 3'hX;
                        o_LoHi_w_sel <= LH_W_SEL_MUL;
                    end

                    FUNC_DIV:
                    begin
                        o_ALU_opr1 <= 32'hX;
                        o_ALU_opr2 <= 32'hX;
                        o_ALU_op <= ALU_NOP;

                        o_GPR_waddr <= 5'hX;
                        
                        o_gpr_we <= 0;
                        o_hi_we <= 1;
                        o_lo_we <= 1;

                        o_CP0_we <= 0;

                        o_is_trap <= 0;
                        o_is_branch <= 0;
                        o_is_jump <= 0;
                        o_except_cause <= 5'hX;

                        o_GPR_w_sel <= 3'hX;
                        o_LoHi_w_sel <= LH_W_SEL_DIV;
                    end

                    FUNC_DIVU:
                    begin
                        o_ALU_opr1 <= 32'hX;
                        o_ALU_opr2 <= 32'hX;
                        o_ALU_op <= ALU_NOP;

                        o_GPR_waddr <= 5'hX;
                        
                        o_gpr_we <= 0;
                        o_hi_we <= 1;
                        o_lo_we <= 1;

                        o_CP0_we <= 0;

                        o_is_trap <= 0;
                        o_is_branch <= 0;
                        o_is_jump <= 0;
                        o_except_cause <= 5'hX;

                        o_GPR_w_sel <= 3'hX;
                        o_LoHi_w_sel <= LH_W_SEL_DIV;
                    end

                    FUNC_JR:
                    begin
                        o_ALU_opr1 <= 32'hX;
                        o_ALU_opr2 <= 32'hX;
                        o_ALU_op <= ALU_NOP;

                        o_GPR_waddr <= 5'hX;
                        
                        o_gpr_we <= 0;
                        o_hi_we <= 0;
                        o_lo_we <= 0;

                        o_CP0_we <= 0;

                        o_is_trap <= 0;
                        o_is_branch <= 0;
                        o_is_jump <= 1;
                        o_except_cause <= 5'hX;

                        o_GPR_w_sel <= 3'hX;
                        o_LoHi_w_sel <= 2'hX;
                    end

                    FUNC_JALR:
                    begin
                    end

                    FUNC_TEQ:
                    begin
                    end

                    FUNC_TGE:
                    begin
                    end

                    FUNC_TGEU:
                    begin
                    end

                    FUNC_TLT:
                    begin
                    end

                    FUNC_TLTU:
                    begin
                    end

                    FUNC_TNE:
                    begin
                    end

                    FUNC_SYSCALL:
                    begin
                    end

                    FUNC_SYNC:
                    begin
                    end

                    default:
                    begin
                    end
                endcase
            end

            OP_SPECIAL2:
            begin
                case (i_instr[5:0]) 
                    FUNC_CLO:
                    begin
                    end

                    FUNC_CLZ:
                    begin
                    end

                    FUNC_MUL:
                    begin
                    end

                    FUNC_MADD:
                    begin
                    end

                    FUNC_MADDU:
                    begin
                    end

                    FUNC_MSUB:
                    begin
                    end

                    FUNC_MSUBU:
                    begin
                    end
                endcase
            end

            OP_REGIMM:
            begin
                case (i_instr[20:16]) 
                    RT_BGEZAL: // BAL
                    begin
                    end

                    RT_BGEZ:
                    begin
                    end

                    RT_BLTZ:
                    begin
                    end

                    RT_BLTZAL:
                    begin
                    end    

                    RT_TEQI:
                    begin
                    end

                    RT_TGEI:
                    begin
                    end

                    RT_TGEIU:
                    begin
                    end

                    RT_TLTI:
                    begin
                    end

                    RT_TLTIU:
                    begin
                    end

                    RT_TNEI:
                    begin
                    end

                endcase
            end


            // I-type instr
            OP_ANDI:
            begin
            end

            OP_ORI:
            begin
            end

            OP_XORI:
            begin
            end

            OP_LUI:
            begin
            end

            OP_ADDI:
            begin
            end

            OP_ADDIU:
            begin
            end

            OP_SLTI:
            begin
            end

            OP_SLTIU:
            begin
            end

            OP_J:
            begin
            end

            OP_JAL:
            begin
            end

            OP_BEQ: // B
            begin
            end

            OP_BGTZ:
            begin
            end

            OP_BLEZ:
            begin
            end

            OP_BNE:
            begin
            end

            OP_LB:
            begin
            end

            OP_LBU:
            begin
            end

            OP_LH:
            begin
            end

            OP_LHU:
            begin
            end

            OP_LL:
            begin
            end

            OP_LW:
            begin
            end

            OP_LWL:
            begin
            end

            OP_LWR:
            begin
            end

            OP_SB:
            begin
            end

            OP_SC:
            begin
            end

            OP_SH:
            begin
            end

            OP_SW:
            begin
            end

            OP_SWL:
            begin
            end

            OP_SWR:
            begin
            end

            OP_COP0:
            begin
                case (i_instr[25:21])
                    RS_MF:
                    begin
                        
                    end

                    RS_MT:
                    begin
                        
                    end

                    RS_ERET:
                    begin

                    end

                endcase
            end

            OP_PREF:
            begin
            end

            default:
            begin
            end 
        endcase
    end
    
endmodule