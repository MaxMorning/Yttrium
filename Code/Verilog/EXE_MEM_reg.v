`include "Exception.v"

module EXE_MEM_reg (
    input wire clk,
    input wire resetn,

    input wire i_ena,

    input wire[31:0] i_EXE_current_pc,
    input wire[31:0] i_EXE_current_instr,

    input wire i_EXE_get_result_in_MEM,
    input wire i_EXE_GPR_we,
    input wire[4:0] i_EXE_GPR_waddr,

    input wire[31:0] i_EXE_GPR_rdata1,
    input wire[31:0] i_EXE_ALU_result,

    input wire[31:0] i_EXE_Div_quotient,
    input wire[31:0] i_EXE_Div_remainder,

    input wire i_EXE_RegHi_we,
    input wire i_EXE_RegLo_we,

    input wire[1:0] i_EXE_LoHi_wdata_selection,
    input wire[31:0] i_EXE_opr2_value,

    input wire[2:0] i_EXE_GPR_wdata_selection,
    
    input wire i_EXE_CP0_we,

    input wire i_EXE_current_is_in_delay_slot,
    input wire i_EXE_is_eret,

    input wire i_EXE_is_trap,

    input wire i_EXE_LL_bit_value,

    input wire[31:0] i_EXE_proc_dmem_rdata,

    input wire[4:0] i_EXE_except_cause,
    input wire i_EXE_ALU_overflow,

    input wire[4 * 42 - 1 : 0] i_EXE_mult_stage_0_result,
    input wire i_EXE_mult_result_need_process,



    output wire[31:0] o_MEM_current_pc,
    output wire[31:0] o_MEM_current_instr,

    output wire o_MEM_get_result_in_MEM,
    output wire o_MEM_GPR_we,
    output wire[4:0] o_MEM_GPR_waddr,

    output wire[31:0] o_MEM_GPR_rdata1,
    output wire[31:0] o_MEM_ALU_result,

    output wire[31:0] o_MEM_Div_quotient,
    output wire[31:0] o_MEM_Div_remainder,

    output wire o_MEM_RegHi_we,
    output wire o_MEM_RegLo_we,

    output wire[1:0] o_MEM_LoHi_wdata_selection,
    output wire[31:0] o_MEM_opr2_value,

    output wire[2:0] o_MEM_GPR_wdata_selection,
    
    output wire o_MEM_CP0_we,

    output wire[4:0] o_MEM_CP0_except_cause,
    output wire o_MEM_current_is_in_delay_slot,
    output wire o_MEM_is_eret,

    output wire o_MEM_LL_bit_value,
    output wire[31:0] o_MEM_proc_dmem_rdata,

    output wire[4 * 42 - 1 : 0] o_MEM_mult_stage_0_result,
    output wire o_MEM_mult_result_need_process
);

    RegWithWE #(32) current_pc_reg(
        .clk(clk),
        .resetn(resetn),

        .i_we(i_ena),

        .i_data(i_EXE_current_pc),
        .o_data(o_MEM_current_pc)
    );

    RegWithWE #(32) current_instr_reg(
        .clk(clk),
        .resetn(resetn),

        .i_we(i_ena),

        .i_data(i_EXE_current_instr),
        .o_data(o_MEM_current_instr)
    );

    RegWithWE #(1, 1) get_result_in_mem_reg(
        .clk(clk),
        .resetn(resetn),

        .i_we(i_ena),

        .i_data(i_EXE_get_result_in_MEM),
        .o_data(o_MEM_get_result_in_MEM)
    );

    RegWithWE #(1, 1) gpr_we_reg(
        .clk(clk),
        .resetn(resetn),

        .i_we(i_ena),

        .i_data(i_EXE_GPR_we),
        .o_data(o_MEM_GPR_we)
    );

    RegWithWE #(5) gpr_waddr_reg(
        .clk(clk),
        .resetn(resetn),

        .i_we(i_ena),

        .i_data(i_EXE_GPR_waddr),
        .o_data(o_MEM_GPR_waddr)
    );

    RegWithWE #(32) gpr_rdata1_reg(
        .clk(clk),
        .resetn(resetn),

        .i_we(i_ena),

        .i_data(i_EXE_GPR_rdata1),
        .o_data(o_MEM_GPR_rdata1)
    );

    RegWithWE #(32) alu_result_reg(
        .clk(clk),
        .resetn(resetn),

        .i_we(i_ena),

        .i_data(i_EXE_ALU_result),
        .o_data(o_MEM_ALU_result)
    );

    RegWithWE #(32) div_q_reg(
        .clk(clk),
        .resetn(resetn),

        .i_we(i_ena),

        .i_data(i_EXE_Div_quotient),
        .o_data(o_MEM_Div_quotient)
    );

    RegWithWE #(32) div_r_reg(
        .clk(clk),
        .resetn(resetn),

        .i_we(i_ena),

        .i_data(i_EXE_Div_remainder),
        .o_data(o_MEM_Div_remainder)
    );

    RegWithWE #(1, 1) reg_hi_we_reg(
        .clk(clk),
        .resetn(resetn),

        .i_we(i_ena),

        .i_data(i_EXE_RegHi_we),
        .o_data(o_MEM_RegHi_we)
    );

    RegWithWE #(1, 1) reg_lo_we_reg(
        .clk(clk),
        .resetn(resetn),

        .i_we(i_ena),

        .i_data(i_EXE_RegLo_we),
        .o_data(o_MEM_RegLo_we)
    );

    RegWithWE #(2) lohi_wdata_sel_reg(
        .clk(clk),
        .resetn(resetn),

        .i_we(i_ena),

        .i_data(i_EXE_LoHi_wdata_selection),
        .o_data(o_MEM_LoHi_wdata_selection)
    );

    RegWithWE #(32) opr2_value_reg(
        .clk(clk),
        .resetn(resetn),

        .i_we(i_ena),

        .i_data(i_EXE_opr2_value),
        .o_data(o_MEM_opr2_value)
    );

    RegWithWE #(3) gpr_wdata_sel_reg(
        .clk(clk),
        .resetn(resetn),

        .i_we(i_ena),

        .i_data(i_EXE_GPR_wdata_selection),
        .o_data(o_MEM_GPR_wdata_selection)
    );

    RegWithWE #(1, 1) cp0_we_reg(
        .clk(clk),
        .resetn(resetn),

        .i_we(i_ena),

        .i_data(i_EXE_CP0_we),
        .o_data(o_MEM_CP0_we)
    );

    RegWithWE #(1, 1) current_is_in_delay_slot_reg(
        .clk(clk),
        .resetn(resetn),

        .i_we(i_ena),

        .i_data(i_EXE_current_is_in_delay_slot),
        .o_data(o_MEM_current_is_in_delay_slot)
    );

    RegWithWE #(1, 1) is_eret_reg(
        .clk(clk),
        .resetn(resetn),

        .i_we(i_ena),

        .i_data(i_EXE_is_eret),
        .o_data(o_MEM_is_eret)
    );

    RegWithWE #(1, 1) ll_bit_value_reg(
        .clk(clk),
        .resetn(resetn),

        .i_we(i_ena),

        .i_data(i_EXE_LL_bit_value),
        .o_data(o_MEM_LL_bit_value)
    );

    RegWithWE #(32) proc_dmem_rdata_reg(
        .clk(clk),
        .resetn(resetn),

        .i_we(i_ena),

        .i_data(i_EXE_proc_dmem_rdata),
        .o_data(o_MEM_proc_dmem_rdata)
    );

    RegWithWE #(5, 0, 5'h1f) except_cause_reg(
        .clk(clk),
        .resetn(resetn),

        .i_we(i_ena),

        .i_data((i_EXE_is_trap && (i_EXE_ALU_result != 0)) ? `EXC_CAUSE_TRAP : 
                                                            (i_EXE_ALU_overflow ? `EXC_CAUSE_OV : i_EXE_except_cause)),
        .o_data(o_MEM_CP0_except_cause)
    );
    
    RegWithWE #(4 * 42) mult_stage_0_reg(
        .clk(clk),
        .resetn(resetn),

        .i_we(i_ena),

        .i_data(i_EXE_mult_stage_0_result),
        .o_data(o_MEM_mult_stage_0_result)
    );

    RegWithWE #(1) mult_result_need_process_reg(
        .clk(clk),
        .resetn(resetn),

        .i_we(i_ena),

        .i_data(i_EXE_mult_result_need_process),
        .o_data(o_MEM_mult_result_need_process)
    );
endmodule