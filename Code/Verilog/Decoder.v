`timescale 1ns/1ps
`include "OP.v"
`include "SelectSignal.v"
`include "Exception.v"

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
    output reg[2:0] o_GPR_wdata_selection,
    
    output reg o_hi_we,
    output reg o_lo_we,

    output reg[1:0] o_LoHi_wdata_selection,

    output wire o_CP0_we,

    output reg o_mem_we,
    
    output wire o_is_eret,
    output wire o_is_div,

    output reg o_is_trap,

    output reg[4:0] o_except_cause,

    output wire o_is_LL,
    output wire o_is_SC,

    output wire o_MultDiv_is_unsigned
);

    assign o_is_eret = i_instr[31:26] == `OP_COP0 && i_instr[25:21] == `RS_ERET;
    assign o_is_div = i_instr[31:26] == `OP_SPECIAL && i_instr[5:1] == 5'b01101; // `FUNC_DIV[5:1]
    assign o_CP0_we = i_instr[31:26] == `OP_COP0 && i_instr[25:21] == `RS_MT;
    assign o_is_LL = i_instr[31:26] == `OP_LL;
    assign o_is_SC = i_instr[31:26] == `OP_SC;

    wire mult_div_is_unsigned = i_instr[31:26] == `OP_SPECIAL && (i_instr[5:0] == `FUNC_MULTU || i_instr[5:0] == `FUNC_DIVU);
    wire madd_msub_is_unsigned = i_instr[31:26] == `OP_SPECIAL2 && (i_instr[5:0] == `FUNC_MADDU || i_instr[5:0] == `FUNC_MSUBU);
    assign o_MultDiv_is_unsigned = mult_div_is_unsigned | madd_msub_is_unsigned;

    wire[31:0] type_i_zero_ext = {16'h0, i_instr[15:0]};
    wire[31:0] type_i_sign_ext = {{17{i_instr[15]}}, i_instr[14:0]};

    wire[4:0] rt_addr = i_instr[20:16];
    wire[4:0] rd_addr = i_instr[15:11];

    always @(*) begin
        case (i_instr[31:26])
            `OP_SPECIAL:
            begin
                case (i_instr[5:0]) 
                    `FUNC_AND:
                    begin
                        o_get_result_in_EXE <= 1;
                        o_get_result_in_MEM <= 0;

                        o_ALU_opr1 <= i_rs_rdata;
                        o_ALU_opr2 <= i_rt_rdata;
                        o_ALU_op <= `ALU_AND;

                        o_GPR_waddr <= rd_addr;
                        o_gpr_we <= 1;
                        o_GPR_wdata_selection <= `GPR_W_SEL_ALU;

                        o_hi_we <= 0;
                        o_lo_we <= 0;

                        o_LoHi_wdata_selection <= 2'bxx;

                        o_mem_we <= 0;

                        o_is_trap <= 0;
                        o_except_cause <= `EXC_CAUSE_NOP;
                    end

                    `FUNC_OR:
                    begin
                        o_get_result_in_EXE <= 1;
                        o_get_result_in_MEM <= 0;

                        o_ALU_opr1 <= i_rs_rdata;
                        o_ALU_opr2 <= i_rt_rdata;
                        o_ALU_op <= `ALU_OR;

                        o_GPR_waddr <= rd_addr;
                        o_gpr_we <= 1;
                        o_GPR_wdata_selection <= `GPR_W_SEL_ALU;

                        o_hi_we <= 0;
                        o_lo_we <= 0;

                        o_LoHi_wdata_selection <= 2'bxx;

                        o_mem_we <= 0;

                        o_is_trap <= 0;
                        o_except_cause <= `EXC_CAUSE_NOP;
                    end

                    `FUNC_XOR:
                    begin
                        o_get_result_in_EXE <= 1;
                        o_get_result_in_MEM <= 0;

                        o_ALU_opr1 <= i_rs_rdata;
                        o_ALU_opr2 <= i_rt_rdata;
                        o_ALU_op <= `ALU_XOR;

                        o_GPR_waddr <= rd_addr;
                        o_gpr_we <= 1;
                        o_GPR_wdata_selection <= `GPR_W_SEL_ALU;

                        o_hi_we <= 0;
                        o_lo_we <= 0;

                        o_LoHi_wdata_selection <= 2'bxx;

                        o_mem_we <= 0;

                        o_is_trap <= 0;
                        o_except_cause <= `EXC_CAUSE_NOP;
                    end

                    `FUNC_NOR:
                    begin
                        o_get_result_in_EXE <= 1;
                        o_get_result_in_MEM <= 0;

                        o_ALU_opr1 <= i_rs_rdata;
                        o_ALU_opr2 <= i_rt_rdata;
                        o_ALU_op <= `ALU_NOR;

                        o_GPR_waddr <= rd_addr;
                        o_gpr_we <= 1;
                        o_GPR_wdata_selection <= `GPR_W_SEL_ALU;

                        o_hi_we <= 0;
                        o_lo_we <= 0;

                        o_LoHi_wdata_selection <= 2'bxx;

                        o_mem_we <= 0;

                        o_is_trap <= 0;
                        o_except_cause <= `EXC_CAUSE_NOP;
                    end

                    `FUNC_SLL:
                    begin
                        o_get_result_in_EXE <= 1;
                        o_get_result_in_MEM <= 0;

                        o_ALU_opr1 <= {27'h0, i_instr[10:6]};
                        o_ALU_opr2 <= i_rt_rdata;
                        o_ALU_op <= `ALU_SLL;

                        o_GPR_waddr <= rd_addr;
                        o_gpr_we <= 1;
                        o_GPR_wdata_selection <= `GPR_W_SEL_ALU;

                        o_hi_we <= 0;
                        o_lo_we <= 0;

                        o_LoHi_wdata_selection <= 2'bxx;

                        o_mem_we <= 0;

                        o_is_trap <= 0;
                        o_except_cause <= `EXC_CAUSE_NOP;
                    end

                    `FUNC_SLLV:
                    begin
                        o_get_result_in_EXE <= 1;
                        o_get_result_in_MEM <= 0;

                        o_ALU_opr1 <= i_rs_rdata;
                        o_ALU_opr2 <= i_rt_rdata;
                        o_ALU_op <= `ALU_SLL;

                        o_GPR_waddr <= rd_addr;
                        o_gpr_we <= 1;
                        o_GPR_wdata_selection <= `GPR_W_SEL_ALU;

                        o_hi_we <= 0;
                        o_lo_we <= 0;

                        o_LoHi_wdata_selection <= 2'bxx;

                        o_mem_we <= 0;

                        o_is_trap <= 0;
                        o_except_cause <= `EXC_CAUSE_NOP;
                    end

                    `FUNC_SRA:
                    begin
                        o_get_result_in_EXE <= 1;
                        o_get_result_in_MEM <= 0;

                        o_ALU_opr1 <= {27'h0, i_instr[10:6]};
                        o_ALU_opr2 <= i_rt_rdata;
                        o_ALU_op <= `ALU_SRA;

                        o_GPR_waddr <= rd_addr;
                        o_gpr_we <= 1;
                        o_GPR_wdata_selection <= `GPR_W_SEL_ALU;

                        o_hi_we <= 0;
                        o_lo_we <= 0;

                        o_LoHi_wdata_selection <= 2'bxx;

                        o_mem_we <= 0;

                        o_is_trap <= 0;
                        o_except_cause <= `EXC_CAUSE_NOP;
                    end

                    `FUNC_SRAV:
                    begin
                        o_get_result_in_EXE <= 1;
                        o_get_result_in_MEM <= 0;

                        o_ALU_opr1 <= i_rs_rdata;
                        o_ALU_opr2 <= i_rt_rdata;
                        o_ALU_op <= `ALU_SRA;

                        o_GPR_waddr <= rd_addr;
                        o_gpr_we <= 1;
                        o_GPR_wdata_selection <= `GPR_W_SEL_ALU;

                        o_hi_we <= 0;
                        o_lo_we <= 0;

                        o_LoHi_wdata_selection <= 2'bxx;

                        o_mem_we <= 0;

                        o_is_trap <= 0;
                        o_except_cause <= `EXC_CAUSE_NOP;
                    end

                    `FUNC_SRL:
                    begin
                        o_get_result_in_EXE <= 1;
                        o_get_result_in_MEM <= 0;

                        o_ALU_opr1 <= {27'h0, i_instr[10:6]};
                        o_ALU_opr2 <= i_rt_rdata;
                        o_ALU_op <= `ALU_SRL;

                        o_GPR_waddr <= rd_addr;
                        o_gpr_we <= 1;
                        o_GPR_wdata_selection <= `GPR_W_SEL_ALU;

                        o_hi_we <= 0;
                        o_lo_we <= 0;

                        o_LoHi_wdata_selection <= 2'bxx;

                        o_mem_we <= 0;

                        o_is_trap <= 0;
                        o_except_cause <= `EXC_CAUSE_NOP;
                    end

                    `FUNC_SRLV:
                    begin
                        o_get_result_in_EXE <= 1;
                        o_get_result_in_MEM <= 0;

                        o_ALU_opr1 <= i_rs_rdata;
                        o_ALU_opr2 <= i_rt_rdata;
                        o_ALU_op <= `ALU_SRL;

                        o_GPR_waddr <= rd_addr;
                        o_gpr_we <= 1;
                        o_GPR_wdata_selection <= `GPR_W_SEL_ALU;

                        o_hi_we <= 0;
                        o_lo_we <= 0;

                        o_LoHi_wdata_selection <= 2'bxx;

                        o_mem_we <= 0;

                        o_is_trap <= 0;
                        o_except_cause <= `EXC_CAUSE_NOP;
                    end

                    `FUNC_MOVN:
                    begin
                        o_get_result_in_EXE <= 1;
                        o_get_result_in_MEM <= 0;

                        o_ALU_opr1 <= i_rs_rdata;
                        o_ALU_opr2 <= i_rt_rdata;
                        o_ALU_op <= `ALU_MOVN;

                        o_GPR_waddr <= rd_addr;
                        o_gpr_we <= 1;
                        o_GPR_wdata_selection <= `GPR_W_SEL_ALU;

                        o_hi_we <= 0;
                        o_lo_we <= 0;

                        o_LoHi_wdata_selection <= 2'bxx;

                        o_mem_we <= 0;

                        o_is_trap <= 0;
                        o_except_cause <= `EXC_CAUSE_NOP;
                    end

                    `FUNC_MOVZ:
                    begin
                        o_get_result_in_EXE <= 1;
                        o_get_result_in_MEM <= 0;

                        o_ALU_opr1 <= i_rs_rdata;
                        o_ALU_opr2 <= i_rt_rdata;
                        o_ALU_op <= `ALU_MOVZ;

                        o_GPR_waddr <= rd_addr;
                        o_gpr_we <= 1;
                        o_GPR_wdata_selection <= `GPR_W_SEL_ALU;

                        o_hi_we <= 0;
                        o_lo_we <= 0;

                        o_LoHi_wdata_selection <= 2'bxx;

                        o_mem_we <= 0;

                        o_is_trap <= 0;
                        o_except_cause <= `EXC_CAUSE_NOP;
                    end

                    `FUNC_MFHI:
                    begin
                        o_get_result_in_EXE <= 0;
                        o_get_result_in_MEM <= 1;

                        o_ALU_opr1 <= 32'hX;
                        o_ALU_opr2 <= 32'hX;
                        o_ALU_op <= `ALU_NOP;

                        o_GPR_waddr <= rd_addr;
                        o_gpr_we <= 1;
                        o_GPR_wdata_selection <= `GPR_W_SEL_HI;

                        o_hi_we <= 0;
                        o_lo_we <= 0;

                        o_LoHi_wdata_selection <= 2'bxx;

                        o_mem_we <= 0;

                        o_is_trap <= 0;
                        o_except_cause <= `EXC_CAUSE_NOP;
                    end

                    `FUNC_MFLO:
                    begin
                        o_get_result_in_EXE <= 0;
                        o_get_result_in_MEM <= 1;

                        o_ALU_opr1 <= 32'hX;
                        o_ALU_opr2 <= 32'hX;
                        o_ALU_op <= `ALU_NOP;

                        o_GPR_waddr <= rd_addr;
                        o_gpr_we <= 1;
                        o_GPR_wdata_selection <= `GPR_W_SEL_LO;

                        o_hi_we <= 0;
                        o_lo_we <= 0;

                        o_LoHi_wdata_selection <= 2'bxx;

                        o_mem_we <= 0;

                        o_is_trap <= 0;
                        o_except_cause <= `EXC_CAUSE_NOP;
                    end

                    `FUNC_MTHI:
                    begin
                        o_get_result_in_EXE <= 0;
                        o_get_result_in_MEM <= 0;

                        o_ALU_opr1 <= 32'hX;
                        o_ALU_opr2 <= 32'hX;
                        o_ALU_op <= `ALU_NOP;

                        o_GPR_waddr <= 5'hX;
                        o_gpr_we <= 0;
                        o_GPR_wdata_selection <= 3'hX;

                        o_hi_we <= 1;
                        o_lo_we <= 0;

                        o_LoHi_wdata_selection <= `LH_W_SEL_GPR;

                        o_mem_we <= 0;

                        o_is_trap <= 0;
                        o_except_cause <= `EXC_CAUSE_NOP;
                    end

                    `FUNC_MTLO:
                    begin
                        o_get_result_in_EXE <= 0;
                        o_get_result_in_MEM <= 0;

                        o_ALU_opr1 <= 32'hX;
                        o_ALU_opr2 <= 32'hX;
                        o_ALU_op <= `ALU_NOP;

                        o_GPR_waddr <= 5'hX;
                        o_gpr_we <= 0;
                        o_GPR_wdata_selection <= 3'hX;

                        o_hi_we <= 0;
                        o_lo_we <= 1;

                        o_LoHi_wdata_selection <= `LH_W_SEL_GPR;

                        o_mem_we <= 0;

                        o_is_trap <= 0;
                        o_except_cause <= `EXC_CAUSE_NOP;
                    end

                    `FUNC_ADD:
                    begin
                        o_get_result_in_EXE <= 1;
                        o_get_result_in_MEM <= 0;

                        o_ALU_opr1 <= i_rs_rdata;
                        o_ALU_opr2 <= i_rt_rdata;
                        o_ALU_op <= `ALU_ADD;

                        o_GPR_waddr <= rd_addr;
                        o_gpr_we <= 1;
                        o_GPR_wdata_selection <= `GPR_W_SEL_ALU;

                        o_hi_we <= 0;
                        o_lo_we <= 0;

                        o_LoHi_wdata_selection <= 2'bxx;

                        o_mem_we <= 0;

                        o_is_trap <= 0;
                        o_except_cause <= `EXC_CAUSE_NOP;
                    end

                    `FUNC_ADDU:
                    begin
                        o_get_result_in_EXE <= 1;
                        o_get_result_in_MEM <= 0;

                        o_ALU_opr1 <= i_rs_rdata;
                        o_ALU_opr2 <= i_rt_rdata;
                        o_ALU_op <= `ALU_ADDU;

                        o_GPR_waddr <= rd_addr;
                        o_gpr_we <= 1;
                        o_GPR_wdata_selection <= `GPR_W_SEL_ALU;

                        o_hi_we <= 0;
                        o_lo_we <= 0;

                        o_LoHi_wdata_selection <= 2'bxx;

                        o_mem_we <= 0;

                        o_is_trap <= 0;
                        o_except_cause <= `EXC_CAUSE_NOP;
                    end

                    `FUNC_SUB:
                    begin
                        o_get_result_in_EXE <= 1;
                        o_get_result_in_MEM <= 0;

                        o_ALU_opr1 <= i_rs_rdata;
                        o_ALU_opr2 <= i_rt_rdata;
                        o_ALU_op <= `ALU_SUB;

                        o_GPR_waddr <= rd_addr;
                        o_gpr_we <= 1;
                        o_GPR_wdata_selection <= `GPR_W_SEL_ALU;

                        o_hi_we <= 0;
                        o_lo_we <= 0;

                        o_LoHi_wdata_selection <= 2'bxx;

                        o_mem_we <= 0;

                        o_is_trap <= 0;
                        o_except_cause <= `EXC_CAUSE_NOP;
                    end

                    `FUNC_SUBU:
                    begin
                        o_get_result_in_EXE <= 1;
                        o_get_result_in_MEM <= 0;

                        o_ALU_opr1 <= i_rs_rdata;
                        o_ALU_opr2 <= i_rt_rdata;
                        o_ALU_op <= `ALU_SUBU;

                        o_GPR_waddr <= rd_addr;
                        o_gpr_we <= 1;
                        o_GPR_wdata_selection <= `GPR_W_SEL_ALU;

                        o_hi_we <= 0;
                        o_lo_we <= 0;

                        o_LoHi_wdata_selection <= 2'bxx;

                        o_mem_we <= 0;

                        o_is_trap <= 0;
                        o_except_cause <= `EXC_CAUSE_NOP;
                    end

                    `FUNC_SLT:
                    begin
                        o_get_result_in_EXE <= 1;
                        o_get_result_in_MEM <= 0;

                        o_ALU_opr1 <= i_rs_rdata;
                        o_ALU_opr2 <= i_rt_rdata;
                        o_ALU_op <= `ALU_SLT;

                        o_GPR_waddr <= rd_addr;
                        o_gpr_we <= 1;
                        o_GPR_wdata_selection <= `GPR_W_SEL_ALU;

                        o_hi_we <= 0;
                        o_lo_we <= 0;

                        o_LoHi_wdata_selection <= 2'bxx;

                        o_mem_we <= 0;

                        o_is_trap <= 0;
                        o_except_cause <= `EXC_CAUSE_NOP;
                    end

                    `FUNC_SLTU:
                    begin
                        o_get_result_in_EXE <= 1;
                        o_get_result_in_MEM <= 0;

                        o_ALU_opr1 <= i_rs_rdata;
                        o_ALU_opr2 <= i_rt_rdata;
                        o_ALU_op <= `ALU_SLTU;

                        o_GPR_waddr <= rd_addr;
                        o_gpr_we <= 1;
                        o_GPR_wdata_selection <= `GPR_W_SEL_ALU;

                        o_hi_we <= 0;
                        o_lo_we <= 0;

                        o_LoHi_wdata_selection <= 2'bxx;

                        o_mem_we <= 0;

                        o_is_trap <= 0;
                        o_except_cause <= `EXC_CAUSE_NOP;
                    end

                    `FUNC_MULT,
                    `FUNC_MULTU:
                    begin
                        o_get_result_in_EXE <= 0;
                        o_get_result_in_MEM <= 1;

                        o_ALU_opr1 <= i_rs_rdata;
                        o_ALU_opr2 <= i_rt_rdata;
                        o_ALU_op <= `ALU_NOP;

                        o_GPR_waddr <= 5'hX;
                        o_gpr_we <= 0;
                        o_GPR_wdata_selection <= 3'hX;

                        o_hi_we <= 1;
                        o_lo_we <= 1;

                        o_LoHi_wdata_selection <= `LH_W_SEL_MUL;

                        o_mem_we <= 0;

                        o_is_trap <= 0;
                        o_except_cause <= `EXC_CAUSE_NOP;
                        
                    end

                    `FUNC_DIV,
                    `FUNC_DIVU:
                    begin
                        o_get_result_in_EXE <= 1;
                        o_get_result_in_MEM <= 0;

                        o_ALU_opr1 <= i_rs_rdata;
                        o_ALU_opr2 <= i_rt_rdata;
                        o_ALU_op <= `ALU_NOP;

                        o_GPR_waddr <= 5'hX;
                        o_gpr_we <= 0;
                        o_GPR_wdata_selection <= 3'hX;

                        o_hi_we <= 1;
                        o_lo_we <= 1;

                        o_LoHi_wdata_selection <= `LH_W_SEL_DIV;

                        o_mem_we <= 0;

                        o_is_trap <= 0;
                        o_except_cause <= `EXC_CAUSE_NOP;
                    end

                    `FUNC_JR:
                    begin
                        o_get_result_in_EXE <= 0;
                        o_get_result_in_MEM <= 0;

                        o_ALU_opr1 <= 32'hX;
                        o_ALU_opr2 <= 32'hX;
                        o_ALU_op <= `ALU_NOP;

                        o_GPR_waddr <= 5'hX;
                        o_gpr_we <= 0;
                        o_GPR_wdata_selection <= 3'hX;

                        o_hi_we <= 0;
                        o_lo_we <= 0;

                        o_LoHi_wdata_selection <= 2'bxx;

                        o_mem_we <= 0;

                        o_is_trap <= 0;
                        o_except_cause <= `EXC_CAUSE_NOP;
                    end

                    `FUNC_JALR:
                    begin
                        o_get_result_in_EXE <= 1;
                        o_get_result_in_MEM <= 0;

                        o_ALU_opr1 <= 32'hX;
                        o_ALU_opr2 <= 32'hX;
                        o_ALU_op <= `ALU_NOP;

                        o_GPR_waddr <= rd_addr;
                        o_gpr_we <= 1;
                        o_GPR_wdata_selection <= `GPR_W_SEL_PC;

                        o_hi_we <= 0;
                        o_lo_we <= 0;

                        o_LoHi_wdata_selection <= 2'bxx;

                        o_mem_we <= 0;

                        o_is_trap <= 0;
                        o_except_cause <= `EXC_CAUSE_NOP;
                    end

                    `FUNC_TEQ:
                    begin
                        o_get_result_in_EXE <= 0;
                        o_get_result_in_MEM <= 0;

                        o_ALU_opr1 <= i_rs_rdata;
                        o_ALU_opr2 <= i_rt_rdata;
                        o_ALU_op <= `ALU_EQUAL;

                        o_GPR_waddr <= 5'hX;
                        o_gpr_we <= 0;
                        o_GPR_wdata_selection <= 3'hX;

                        o_hi_we <= 0;
                        o_lo_we <= 0;

                        o_LoHi_wdata_selection <= 2'bxx;

                        o_mem_we <= 0;

                        o_is_trap <= 1;
                        o_except_cause <= `EXC_CAUSE_NOP;
                    end

                    `FUNC_TGE:
                    begin
                        o_get_result_in_EXE <= 0;
                        o_get_result_in_MEM <= 0;

                        o_ALU_opr1 <= i_rs_rdata;
                        o_ALU_opr2 <= i_rt_rdata;
                        o_ALU_op <= `ALU_GE;

                        o_GPR_waddr <= 5'hX;
                        o_gpr_we <= 0;
                        o_GPR_wdata_selection <= 3'hX;

                        o_hi_we <= 0;
                        o_lo_we <= 0;

                        o_LoHi_wdata_selection <= 2'bxx;

                        o_mem_we <= 0;

                        o_is_trap <= 1;
                        o_except_cause <= `EXC_CAUSE_NOP;
                    end

                    `FUNC_TGEU:
                    begin
                        o_get_result_in_EXE <= 0;
                        o_get_result_in_MEM <= 0;

                        o_ALU_opr1 <= i_rs_rdata;
                        o_ALU_opr2 <= i_rt_rdata;
                        o_ALU_op <= `ALU_GEU;

                        o_GPR_waddr <= 5'hX;
                        o_gpr_we <= 0;
                        o_GPR_wdata_selection <= 3'hX;

                        o_hi_we <= 0;
                        o_lo_we <= 0;

                        o_LoHi_wdata_selection <= 2'bxx;

                        o_mem_we <= 0;

                        o_is_trap <= 1;
                        o_except_cause <= `EXC_CAUSE_NOP;
                    end

                    `FUNC_TLT:
                    begin
                        o_get_result_in_EXE <= 0;
                        o_get_result_in_MEM <= 0;

                        o_ALU_opr1 <= i_rs_rdata;
                        o_ALU_opr2 <= i_rt_rdata;
                        o_ALU_op <= `ALU_LT;

                        o_GPR_waddr <= 5'hX;
                        o_gpr_we <= 0;
                        o_GPR_wdata_selection <= 3'hX;

                        o_hi_we <= 0;
                        o_lo_we <= 0;

                        o_LoHi_wdata_selection <= 2'bxx;

                        o_mem_we <= 0;

                        o_is_trap <= 1;
                        o_except_cause <= `EXC_CAUSE_NOP;
                    end

                    `FUNC_TLTU:
                    begin
                        o_get_result_in_EXE <= 0;
                        o_get_result_in_MEM <= 0;

                        o_ALU_opr1 <= i_rs_rdata;
                        o_ALU_opr2 <= i_rt_rdata;
                        o_ALU_op <= `ALU_LTU;

                        o_GPR_waddr <= 5'hX;
                        o_gpr_we <= 0;
                        o_GPR_wdata_selection <= 3'hX;

                        o_hi_we <= 0;
                        o_lo_we <= 0;

                        o_LoHi_wdata_selection <= 2'bxx;

                        o_mem_we <= 0;

                        o_is_trap <= 1;
                        o_except_cause <= `EXC_CAUSE_NOP;
                    end

                    `FUNC_TNE:
                    begin
                        o_get_result_in_EXE <= 0;
                        o_get_result_in_MEM <= 0;

                        o_ALU_opr1 <= i_rs_rdata;
                        o_ALU_opr2 <= i_rt_rdata;
                        o_ALU_op <= `ALU_NE;

                        o_GPR_waddr <= 5'hX;
                        o_gpr_we <= 0;
                        o_GPR_wdata_selection <= 3'hX;

                        o_hi_we <= 0;
                        o_lo_we <= 0;

                        o_LoHi_wdata_selection <= 2'bxx;

                        o_mem_we <= 0;

                        o_is_trap <= 1;
                        o_except_cause <= `EXC_CAUSE_NOP;
                    end

                    `FUNC_SYSCALL:
                    begin
                        o_get_result_in_EXE <= 0;
                        o_get_result_in_MEM <= 0;

                        o_ALU_opr1 <= 32'hX;
                        o_ALU_opr2 <= 32'hX;
                        o_ALU_op <= `ALU_NOP;

                        o_GPR_waddr <= 5'hX;
                        o_gpr_we <= 0;
                        o_GPR_wdata_selection <= 3'hX;

                        o_hi_we <= 0;
                        o_lo_we <= 0;

                        o_LoHi_wdata_selection <= 2'bxx;

                        o_mem_we <= 0;

                        o_is_trap <= 0;
                        o_except_cause <= `EXC_CAUSE_SYS;
                    end

                    `FUNC_SYNC:
                    begin
                        o_get_result_in_EXE <= 0;
                        o_get_result_in_MEM <= 0;

                        o_ALU_opr1 <= 32'hX;
                        o_ALU_opr2 <= 32'hX;
                        o_ALU_op <= `ALU_NOP;

                        o_GPR_waddr <= 5'hX;
                        o_gpr_we <= 0;
                        o_GPR_wdata_selection <= 3'hX;

                        o_hi_we <= 0;
                        o_lo_we <= 0;

                        o_LoHi_wdata_selection <= 2'bxx;

                        o_mem_we <= 0;

                        o_is_trap <= 0;
                        o_except_cause <= `EXC_CAUSE_NOP;
                    end

                    default:
                    begin
                        o_get_result_in_EXE <= 0;
                        o_get_result_in_MEM <= 0;

                        o_ALU_opr1 <= 32'hX;
                        o_ALU_opr2 <= 32'hX;
                        o_ALU_op <= `ALU_NOP;

                        o_GPR_waddr <= 5'hX;
                        o_gpr_we <= 0;
                        o_GPR_wdata_selection <= 3'hX;

                        o_hi_we <= 0;
                        o_lo_we <= 0;

                        o_LoHi_wdata_selection <= 2'bxx;

                        o_mem_we <= 0;

                        o_is_trap <= 0;
                        o_except_cause <= `EXC_CAUSE_RI;
                    end
                endcase
            end

            `OP_SPECIAL2:
            begin
                case (i_instr[5:0]) 
                    `FUNC_CLO:
                    begin
                        o_get_result_in_EXE <= 1;
                        o_get_result_in_MEM <= 0;

                        o_ALU_opr1 <= i_rs_rdata;
                        o_ALU_opr2 <= 32'hX;
                        o_ALU_op <= `ALU_CLO;

                        o_GPR_waddr <= rd_addr;
                        o_gpr_we <= 1;
                        o_GPR_wdata_selection <= `GPR_W_SEL_ALU;

                        o_hi_we <= 0;
                        o_lo_we <= 0;

                        o_LoHi_wdata_selection <= 2'bxx;

                        o_mem_we <= 0;

                        o_is_trap <= 0;
                        o_except_cause <= `EXC_CAUSE_NOP;
                    end

                    `FUNC_CLZ:
                    begin
                        o_get_result_in_EXE <= 1;
                        o_get_result_in_MEM <= 0;

                        o_ALU_opr1 <= i_rs_rdata;
                        o_ALU_opr2 <= 32'hX;
                        o_ALU_op <= `ALU_CLZ;

                        o_GPR_waddr <= rd_addr;
                        o_gpr_we <= 1;
                        o_GPR_wdata_selection <= `GPR_W_SEL_ALU;

                        o_hi_we <= 0;
                        o_lo_we <= 0;

                        o_LoHi_wdata_selection <= 2'bxx;

                        o_mem_we <= 0;

                        o_is_trap <= 0;
                        o_except_cause <= `EXC_CAUSE_NOP;
                    end

                    `FUNC_MUL:
                    begin
                        o_get_result_in_EXE <= 0;
                        o_get_result_in_MEM <= 1;

                        o_ALU_opr1 <= i_rs_rdata;
                        o_ALU_opr2 <= i_rt_rdata;
                        o_ALU_op <= `ALU_NOP;

                        o_GPR_waddr <= rd_addr;
                        o_gpr_we <= 1;
                        o_GPR_wdata_selection <= `GPR_W_SEL_MUL;

                        o_hi_we <= 0;
                        o_lo_we <= 0;

                        o_LoHi_wdata_selection <= 2'bxx;

                        o_mem_we <= 0;

                        o_is_trap <= 0;
                        o_except_cause <= `EXC_CAUSE_NOP;
                    end

                    `FUNC_MADD,
                    `FUNC_MADDU,
                    `FUNC_MSUB,
                    `FUNC_MSUBU:
                    begin
                        o_get_result_in_EXE <= 0;
                        o_get_result_in_MEM <= 1;

                        o_ALU_opr1 <= i_rs_rdata;
                        o_ALU_opr2 <= i_rt_rdata;
                        o_ALU_op <= `ALU_NOP;

                        o_GPR_waddr <= 5'hX;
                        o_gpr_we <= 0;
                        o_GPR_wdata_selection <= 3'hX;

                        o_hi_we <= 1;
                        o_lo_we <= 1;

                        o_LoHi_wdata_selection <= `LH_W_SEL_MCALC;

                        o_mem_we <= 0;

                        o_is_trap <= 0;
                        o_except_cause <= `EXC_CAUSE_NOP;
                    end

                    default:
                    begin
                        o_get_result_in_EXE <= 0;
                        o_get_result_in_MEM <= 0;

                        o_ALU_opr1 <= 32'hX;
                        o_ALU_opr2 <= 32'hX;
                        o_ALU_op <= `ALU_NOP;

                        o_GPR_waddr <= 5'hX;
                        o_gpr_we <= 0;
                        o_GPR_wdata_selection <= 3'hX;

                        o_hi_we <= 0;
                        o_lo_we <= 0;

                        o_LoHi_wdata_selection <= 2'bxx;

                        o_mem_we <= 0;

                        o_is_trap <= 0;
                        o_except_cause <= `EXC_CAUSE_RI;
                    end
                endcase
            end

            `OP_REGIMM:
            begin
                case (i_instr[20:16]) 
                    `RT_BGEZAL, // BAL
                    `RT_BLTZAL:
                    begin
                        o_get_result_in_EXE <= 0;
                        o_get_result_in_MEM <= 1;

                        o_ALU_opr1 <= 32'hX;
                        o_ALU_opr2 <= 32'hX;
                        o_ALU_op <= `ALU_NOP;

                        o_GPR_waddr <= 5'h1f;
                        o_gpr_we <= 1;
                        o_GPR_wdata_selection <= `GPR_W_SEL_PC;

                        o_hi_we <= 0;
                        o_lo_we <= 0;

                        o_LoHi_wdata_selection <= 2'bxx;

                        o_mem_we <= 0;

                        o_is_trap <= 0;
                        o_except_cause <= `EXC_CAUSE_NOP;
                    end

                    `RT_BGEZ,
                    `RT_BLTZ:
                    begin
                        o_get_result_in_EXE <= 0;
                        o_get_result_in_MEM <= 0;

                        o_ALU_opr1 <= 32'hX;
                        o_ALU_opr2 <= 32'hX;
                        o_ALU_op <= `ALU_NOP;

                        o_GPR_waddr <= 5'hX;
                        o_gpr_we <= 0;
                        o_GPR_wdata_selection <= 3'hX;

                        o_hi_we <= 0;
                        o_lo_we <= 0;

                        o_LoHi_wdata_selection <= 2'bxx;

                        o_mem_we <= 0;

                        o_is_trap <= 0;
                        o_except_cause <= `EXC_CAUSE_NOP;
                    end

                    `RT_TEQI:
                    begin
                        o_get_result_in_EXE <= 0;
                        o_get_result_in_MEM <= 0;

                        o_ALU_opr1 <= i_rs_rdata;
                        o_ALU_opr2 <= type_i_sign_ext;
                        o_ALU_op <= `ALU_EQUAL;

                        o_GPR_waddr <= 5'hX;
                        o_gpr_we <= 0;
                        o_GPR_wdata_selection <= 3'hX;

                        o_hi_we <= 0;
                        o_lo_we <= 0;

                        o_LoHi_wdata_selection <= 2'bxx;

                        o_mem_we <= 0;

                        o_is_trap <= 1;
                        o_except_cause <= `EXC_CAUSE_NOP;
                    end

                    `RT_TGEI:
                    begin
                        o_get_result_in_EXE <= 0;
                        o_get_result_in_MEM <= 0;

                        o_ALU_opr1 <= i_rs_rdata;
                        o_ALU_opr2 <= type_i_sign_ext;
                        o_ALU_op <= `ALU_GE;

                        o_GPR_waddr <= 5'hX;
                        o_gpr_we <= 0;
                        o_GPR_wdata_selection <= 3'hX;

                        o_hi_we <= 0;
                        o_lo_we <= 0;

                        o_LoHi_wdata_selection <= 2'bxx;

                        o_mem_we <= 0;

                        o_is_trap <= 1;
                        o_except_cause <= `EXC_CAUSE_NOP;
                    end

                    `RT_TGEIU:
                    begin
                        o_get_result_in_EXE <= 0;
                        o_get_result_in_MEM <= 0;

                        o_ALU_opr1 <= i_rs_rdata;
                        o_ALU_opr2 <= type_i_sign_ext;
                        o_ALU_op <= `ALU_GEU;

                        o_GPR_waddr <= 5'hX;
                        o_gpr_we <= 0;
                        o_GPR_wdata_selection <= 3'hX;

                        o_hi_we <= 0;
                        o_lo_we <= 0;

                        o_LoHi_wdata_selection <= 2'bxx;

                        o_mem_we <= 0;

                        o_is_trap <= 1;
                        o_except_cause <= `EXC_CAUSE_NOP;
                    end

                    `RT_TLTI:
                    begin
                        o_get_result_in_EXE <= 0;
                        o_get_result_in_MEM <= 0;

                        o_ALU_opr1 <= i_rs_rdata;
                        o_ALU_opr2 <= type_i_sign_ext;
                        o_ALU_op <= `ALU_LT;

                        o_GPR_waddr <= 5'hX;
                        o_gpr_we <= 0;
                        o_GPR_wdata_selection <= 3'hX;

                        o_hi_we <= 0;
                        o_lo_we <= 0;

                        o_LoHi_wdata_selection <= 2'bxx;

                        o_mem_we <= 0;

                        o_is_trap <= 1;
                        o_except_cause <= `EXC_CAUSE_NOP;
                    end

                    `RT_TLTIU:
                    begin
                        o_get_result_in_EXE <= 0;
                        o_get_result_in_MEM <= 0;

                        o_ALU_opr1 <= i_rs_rdata;
                        o_ALU_opr2 <= type_i_sign_ext;
                        o_ALU_op <= `ALU_LTU;

                        o_GPR_waddr <= 5'hX;
                        o_gpr_we <= 0;
                        o_GPR_wdata_selection <= 3'hX;

                        o_hi_we <= 0;
                        o_lo_we <= 0;

                        o_LoHi_wdata_selection <= 2'bxx;

                        o_mem_we <= 0;

                        o_is_trap <= 1;
                        o_except_cause <= `EXC_CAUSE_NOP;
                    end

                    `RT_TNEI:
                    begin
                        o_get_result_in_EXE <= 0;
                        o_get_result_in_MEM <= 0;

                        o_ALU_opr1 <= i_rs_rdata;
                        o_ALU_opr2 <= type_i_sign_ext;
                        o_ALU_op <= `ALU_NE;

                        o_GPR_waddr <= 5'hX;
                        o_gpr_we <= 0;
                        o_GPR_wdata_selection <= 3'hX;

                        o_hi_we <= 0;
                        o_lo_we <= 0;

                        o_LoHi_wdata_selection <= 2'bxx;

                        o_mem_we <= 0;

                        o_is_trap <= 1;
                        o_except_cause <= `EXC_CAUSE_NOP;
                    end

                    default:
                    begin
                        o_get_result_in_EXE <= 0;
                        o_get_result_in_MEM <= 0;

                        o_ALU_opr1 <= 32'hX;
                        o_ALU_opr2 <= 32'hX;
                        o_ALU_op <= `ALU_NOP;

                        o_GPR_waddr <= 5'hX;
                        o_gpr_we <= 0;
                        o_GPR_wdata_selection <= 3'hX;

                        o_hi_we <= 0;
                        o_lo_we <= 0;

                        o_LoHi_wdata_selection <= 2'bxx;

                        o_mem_we <= 0;

                        o_is_trap <= 0;
                        o_except_cause <= `EXC_CAUSE_RI;
                    end
                endcase
            end


            // I-type instr
            `OP_ANDI:
            begin
                o_get_result_in_EXE <= 1;
                o_get_result_in_MEM <= 0;

                o_ALU_opr1 <= i_rs_rdata;
                o_ALU_opr2 <= type_i_zero_ext;
                o_ALU_op <= `ALU_AND;

                o_GPR_waddr <= rt_addr;
                o_gpr_we <= 1;
                o_GPR_wdata_selection <= `GPR_W_SEL_ALU;

                o_hi_we <= 0;
                o_lo_we <= 0;

                o_LoHi_wdata_selection <= 2'bxx;

                o_mem_we <= 0;

                o_is_trap <= 0;
                o_except_cause <= `EXC_CAUSE_NOP;
            end

            `OP_ORI:
            begin
                o_get_result_in_EXE <= 1;
                o_get_result_in_MEM <= 0;

                o_ALU_opr1 <= i_rs_rdata;
                o_ALU_opr2 <= type_i_zero_ext;
                o_ALU_op <= `ALU_OR;

                o_GPR_waddr <= rt_addr;
                o_gpr_we <= 1;
                o_GPR_wdata_selection <= `GPR_W_SEL_ALU;

                o_hi_we <= 0;
                o_lo_we <= 0;

                o_LoHi_wdata_selection <= 2'bxx;

                o_mem_we <= 0;

                o_is_trap <= 0;
                o_except_cause <= `EXC_CAUSE_NOP;
            end

            `OP_XORI:
            begin
                o_get_result_in_EXE <= 1;
                o_get_result_in_MEM <= 0;

                o_ALU_opr1 <= i_rs_rdata;
                o_ALU_opr2 <= type_i_zero_ext;
                o_ALU_op <= `ALU_XOR;

                o_GPR_waddr <= rt_addr;
                o_gpr_we <= 1;
                o_GPR_wdata_selection <= `GPR_W_SEL_ALU;

                o_hi_we <= 0;
                o_lo_we <= 0;

                o_LoHi_wdata_selection <= 2'bxx;

                o_mem_we <= 0;

                o_is_trap <= 0;
                o_except_cause <= `EXC_CAUSE_NOP;
            end

            `OP_LUI:
            begin
                o_get_result_in_EXE <= 1;
                o_get_result_in_MEM <= 0;

                o_ALU_opr1 <= 32'hX;
                o_ALU_opr2 <= type_i_zero_ext;
                o_ALU_op <= `ALU_LUI;

                o_GPR_waddr <= rt_addr;
                o_gpr_we <= 1;
                o_GPR_wdata_selection <= `GPR_W_SEL_ALU;

                o_hi_we <= 0;
                o_lo_we <= 0;

                o_LoHi_wdata_selection <= 2'bxx;

                o_mem_we <= 0;

                o_is_trap <= 0;
                o_except_cause <= `EXC_CAUSE_NOP;
            end

            `OP_ADDI:
            begin
                o_get_result_in_EXE <= 1;
                o_get_result_in_MEM <= 0;

                o_ALU_opr1 <= i_rs_rdata;
                o_ALU_opr2 <= type_i_sign_ext;
                o_ALU_op <= `ALU_ADD;

                o_GPR_waddr <= rt_addr;
                o_gpr_we <= 1;
                o_GPR_wdata_selection <= `GPR_W_SEL_ALU;

                o_hi_we <= 0;
                o_lo_we <= 0;

                o_LoHi_wdata_selection <= 2'bxx;

                o_mem_we <= 0;

                o_is_trap <= 0;
                o_except_cause <= `EXC_CAUSE_NOP;
            end

            `OP_ADDIU:
            begin
                o_get_result_in_EXE <= 1;
                o_get_result_in_MEM <= 0;

                o_ALU_opr1 <= i_rs_rdata;
                o_ALU_opr2 <= type_i_sign_ext;
                o_ALU_op <= `ALU_ADDU;

                o_GPR_waddr <= rt_addr;
                o_gpr_we <= 1;
                o_GPR_wdata_selection <= `GPR_W_SEL_ALU;

                o_hi_we <= 0;
                o_lo_we <= 0;

                o_LoHi_wdata_selection <= 2'bxx;

                o_mem_we <= 0;

                o_is_trap <= 0;
                o_except_cause <= `EXC_CAUSE_NOP;
            end

            `OP_SLTI:
            begin
                o_get_result_in_EXE <= 1;
                o_get_result_in_MEM <= 0;

                o_ALU_opr1 <= i_rs_rdata;
                o_ALU_opr2 <= type_i_sign_ext;
                o_ALU_op <= `ALU_SLT;

                o_GPR_waddr <= rt_addr;
                o_gpr_we <= 1;
                o_GPR_wdata_selection <= `GPR_W_SEL_ALU;

                o_hi_we <= 0;
                o_lo_we <= 0;

                o_LoHi_wdata_selection <= 2'bxx;

                o_mem_we <= 0;

                o_is_trap <= 0;
                o_except_cause <= `EXC_CAUSE_NOP;
            end

            `OP_SLTIU:
            begin
                o_get_result_in_EXE <= 1;
                o_get_result_in_MEM <= 0;

                o_ALU_opr1 <= i_rs_rdata;
                o_ALU_opr2 <= type_i_sign_ext;
                o_ALU_op <= `ALU_SLTU;

                o_GPR_waddr <= rt_addr;
                o_gpr_we <= 1;
                o_GPR_wdata_selection <= `GPR_W_SEL_ALU;

                o_hi_we <= 0;
                o_lo_we <= 0;

                o_LoHi_wdata_selection <= 2'bxx;

                o_mem_we <= 0;

                o_is_trap <= 0;
                o_except_cause <= `EXC_CAUSE_NOP;
            end

            `OP_J:
            begin
                o_get_result_in_EXE <= 0;
                o_get_result_in_MEM <= 0;

                o_ALU_opr1 <= 32'hX;
                o_ALU_opr2 <= 32'hX;
                o_ALU_op <= `ALU_NOP;

                o_GPR_waddr <= 5'hX;
                o_gpr_we <= 0;
                o_GPR_wdata_selection <= 3'hX;

                o_hi_we <= 0;
                o_lo_we <= 0;

                o_LoHi_wdata_selection <= 2'bxx;

                o_mem_we <= 0;

                o_is_trap <= 0;
                o_except_cause <= `EXC_CAUSE_NOP;
            end

            `OP_JAL:
            begin
                o_get_result_in_EXE <= 1;
                o_get_result_in_MEM <= 0;

                o_ALU_opr1 <= 32'hX;
                o_ALU_opr2 <= 32'hX;
                o_ALU_op <= `ALU_NOP;

                o_GPR_waddr <= 5'h1f;
                o_gpr_we <= 1;
                o_GPR_wdata_selection <= `GPR_W_SEL_PC;

                o_hi_we <= 0;
                o_lo_we <= 0;

                o_LoHi_wdata_selection <= 2'bxx;

                o_mem_we <= 0;

                o_is_trap <= 0;
                o_except_cause <= `EXC_CAUSE_NOP;
            end

            `OP_BEQ, // B
            `OP_BGTZ,
            `OP_BLEZ,
            `OP_BNE:
            begin
                o_get_result_in_EXE <= 0;
                o_get_result_in_MEM <= 0;

                o_ALU_opr1 <= 32'hX;
                o_ALU_opr2 <= 32'hX;
                o_ALU_op <= `ALU_NOP;

                o_GPR_waddr <= 5'hX;
                o_gpr_we <= 0;
                o_GPR_wdata_selection <= 3'hX;

                o_hi_we <= 0;
                o_lo_we <= 0;

                o_LoHi_wdata_selection <= 2'bxx;

                o_mem_we <= 0;

                o_is_trap <= 0;
                o_except_cause <= `EXC_CAUSE_NOP;
            end

            `OP_LB,
            `OP_LBU,
            `OP_LH,
            `OP_LHU,
            `OP_LL,
            `OP_LW,
            `OP_LWL,
            `OP_LWR:
            begin
                o_get_result_in_EXE <= 1;
                o_get_result_in_MEM <= 0;

                o_ALU_opr1 <= 32'hX;
                o_ALU_opr2 <= i_rt_rdata;
                o_ALU_op <= `ALU_NOP;

                o_GPR_waddr <= rt_addr;
                o_gpr_we <= 1;
                o_GPR_wdata_selection <= `GPR_W_SEL_MEM;

                o_hi_we <= 0;
                o_lo_we <= 0;

                o_LoHi_wdata_selection <= 2'bxx;

                o_mem_we <= 0;

                o_is_trap <= 0;
                o_except_cause <= `EXC_CAUSE_NOP;
            end

            `OP_SB,
            `OP_SH,
            `OP_SW,
            `OP_SWL,
            `OP_SWR:
            begin
                o_get_result_in_EXE <= 0;
                o_get_result_in_MEM <= 0;

                o_ALU_opr1 <= 32'hX;
                o_ALU_opr2 <= 32'hX;
                o_ALU_op <= `ALU_NOP;

                o_GPR_waddr <= 5'hX;
                o_gpr_we <= 0;
                o_GPR_wdata_selection <= 3'hX;

                o_hi_we <= 0;
                o_lo_we <= 0;

                o_LoHi_wdata_selection <= 2'bxx;

                o_mem_we <= 1;

                o_is_trap <= 0;
                o_except_cause <= `EXC_CAUSE_NOP;
            end

            `OP_SC:
            begin
                o_get_result_in_EXE <= 1;
                o_get_result_in_MEM <= 0;

                o_ALU_opr1 <= 32'hX;
                o_ALU_opr2 <= 32'hX;
                o_ALU_op <= `ALU_NOP;

                o_GPR_waddr <= rt_addr;
                o_gpr_we <= 1;
                o_GPR_wdata_selection <= `GPR_W_SEL_LLBIT;

                o_hi_we <= 0;
                o_lo_we <= 0;

                o_LoHi_wdata_selection <= 2'bxx;

                o_mem_we <= 1;

                o_is_trap <= 0;
                o_except_cause <= `EXC_CAUSE_NOP;
            end

            `OP_COP0:
            begin
                case (i_instr[25:21])
                    `RS_MF:
                    begin
                        o_get_result_in_EXE <= 0;
                        o_get_result_in_MEM <= 1;

                        o_ALU_opr1 <= 32'hX;
                        o_ALU_opr2 <= 32'hX;
                        o_ALU_op <= `ALU_NOP;

                        o_GPR_waddr <= rt_addr;
                        o_gpr_we <= 1;
                        o_GPR_wdata_selection <= `GPR_W_SEL_CP0;

                        o_hi_we <= 0;
                        o_lo_we <= 0;

                        o_LoHi_wdata_selection <= 2'bxx;

                        o_mem_we <= 0;

                        o_is_trap <= 0;
                        o_except_cause <= `EXC_CAUSE_NOP;
                    end

                    `RS_MT:
                    begin
                        o_get_result_in_EXE <= 0;
                        o_get_result_in_MEM <= 0;

                        o_ALU_opr1 <= 32'hX;
                        o_ALU_opr2 <= i_rt_rdata;
                        o_ALU_op <= `ALU_NOP;

                        o_GPR_waddr <= 5'hX;
                        o_gpr_we <= 0;
                        o_GPR_wdata_selection <= 3'hX;

                        o_hi_we <= 0;
                        o_lo_we <= 0;

                        o_LoHi_wdata_selection <= 2'bxx;

                        o_mem_we <= 0;

                        o_is_trap <= 0;
                        o_except_cause <= `EXC_CAUSE_NOP;
                    end

                    `RS_ERET:
                    begin
                        o_get_result_in_EXE <= 0;
                        o_get_result_in_MEM <= 0;

                        o_ALU_opr1 <= 32'hX;
                        o_ALU_opr2 <= 32'hX;
                        o_ALU_op <= `ALU_NOP;

                        o_GPR_waddr <= 5'hX;
                        o_gpr_we <= 0;
                        o_GPR_wdata_selection <= 3'hX;

                        o_hi_we <= 0;
                        o_lo_we <= 0;

                        o_LoHi_wdata_selection <= 2'bxx;

                        o_mem_we <= 0;

                        o_is_trap <= 0;
                        o_except_cause <= `EXC_CAUSE_NOP;
                    end

                    default:
                    begin
                        o_get_result_in_EXE <= 0;
                        o_get_result_in_MEM <= 0;

                        o_ALU_opr1 <= 32'hX;
                        o_ALU_opr2 <= 32'hX;
                        o_ALU_op <= `ALU_NOP;

                        o_GPR_waddr <= 5'hX;
                        o_gpr_we <= 0;
                        o_GPR_wdata_selection <= 3'hX;

                        o_hi_we <= 0;
                        o_lo_we <= 0;

                        o_LoHi_wdata_selection <= 2'bxx;

                        o_mem_we <= 0;

                        o_is_trap <= 0;
                        o_except_cause <= `EXC_CAUSE_RI;
                    end

                endcase
            end

            `OP_PREF:
            begin
                o_get_result_in_EXE <= 0;
                o_get_result_in_MEM <= 0;

                o_ALU_opr1 <= 32'hX;
                o_ALU_opr2 <= 32'hX;
                o_ALU_op <= `ALU_NOP;

                o_GPR_waddr <= 5'hX;
                o_gpr_we <= 0;
                o_GPR_wdata_selection <= 3'hX;

                o_hi_we <= 0;
                o_lo_we <= 0;

                o_LoHi_wdata_selection <= 2'bxx;

                o_mem_we <= 0;

                o_is_trap <= 0;
                o_except_cause <= `EXC_CAUSE_NOP;
            end

            default:
            begin
                o_get_result_in_EXE <= 0;
                o_get_result_in_MEM <= 0;

                o_ALU_opr1 <= 32'hX;
                o_ALU_opr2 <= 32'hX;
                o_ALU_op <= `ALU_NOP;

                o_GPR_waddr <= 5'hX;
                o_gpr_we <= 0;
                o_GPR_wdata_selection <= 3'hX;

                o_hi_we <= 0;
                o_lo_we <= 0;

                o_LoHi_wdata_selection <= 2'bxx;

                o_mem_we <= 0;

                o_is_trap <= 0;
                o_except_cause <= `EXC_CAUSE_RI;
            end 
        endcase
    end
    
endmodule