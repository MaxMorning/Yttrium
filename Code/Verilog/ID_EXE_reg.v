`include "Include/Exception.v"

module ID_EXE_reg (
    input wire clk,
    input wire resetn,
    
    input wire i_ena,

    input wire[31:0] i_ID_current_instr,
    input wire[31:0] i_ID_current_pc,

    input wire i_ID_get_result_in_EXE,
    input wire i_ID_get_result_in_MEM,
    input wire[4:0] i_ID_GPR_waddr,
    input wire i_ID_GPR_we,

    input wire[31:0] i_ID_ALU_opr1,
    input wire[31:0] i_ID_ALU_opr2,
    input wire[4:0] i_ID_ALU_op,

    input wire i_ID_MultDiv_is_unsigned,

    input wire i_ID_is_div,

    input wire[2:0] i_ID_GPR_wdata_selection,

    input wire[31:0] i_ID_dmem_addr,
    input wire i_ID_LL_bit_value,

    input wire[31:0] i_ID_GPR_rdata1,
    input wire i_ID_RegHi_we,
    input wire i_ID_RegLo_we,

    input wire[1:0] i_ID_LoHi_wdata_selection,

    input wire[31:0] i_ID_opr2_value,

    input wire i_ID_CP0_we,
    input wire i_ID_is_branch,
    input wire i_EXE_is_branch,
    input wire i_ID_is_eret,

    input wire i_ID_bad_addr,
    input wire i_ID_dmem_we,
    input wire[4:0] i_ID_except_cause




    output wire[31:0] o_EXE_current_instr,
    output wire[31:0] o_EXE_current_pc,

    output wire o_EXE_get_result_in_EXE,
    output wire o_EXE_get_result_in_MEM,
    output wire[4:0] o_EXE_GPR_waddr,
    output wire o_EXE_GPR_we,

    output wire[31:0] o_EXE_ALU_opr1,
    output wire[31:0] o_EXE_ALU_opr2,
    output wire[4:0] o_EXE_ALU_op,

    output wire o_EXE_MultDiv_is_unsigned,

    output wire o_EXE_is_div,

    output wire[2:0] o_EXE_GPR_wdata_selection,

    output wire[31:0] o_EXE_dmem_addr,
    output wire o_EXE_LL_bit_value,

    output wire[31:0] o_EXE_GPR_rdata1,
    output wire o_EXE_RegHi_we,
    output wire o_EXE_RegLo_we,

    output wire[1:0] o_EXE_LoHi_wdata_selection,

    output wire[31:0] o_EXE_opr2_value,

    output wire o_EXE_CP0_we,
    output wire o_EXE_current_is_in_delay_slot,
    output wire o_EXE_is_branch,
    output wire o_EXE_is_eret,

    output wire[4:0] o_EXE_except_cause
);

    RegWithWE #(32) current_instr_reg(
        .clk(clk),
        .resetn(resetn),
        
        .i_ena(i_ena),

        .i_data(i_ID_current_instr),
        .o_data(o_EXE_current_instr)
    );

    RegWithWE #(32) current_pc_reg(
        .clk(clk),
        .resetn(resetn),
        
        .i_ena(i_ena),

        .i_data(i_ID_current_pc),
        .o_data(o_EXE_current_pc)
    );

    RegWithWE #(1, 1) get_result_in_exe_reg(
        .clk(clk),
        .resetn(resetn),
        
        .i_ena(i_ena),

        .i_data(i_ID_get_result_in_EXE),
        .o_data(o_EXE_get_result_in_EXE)
    );

    RegWithWE #(1, 1) get_result_in_mem_reg(
        .clk(clk),
        .resetn(resetn),
        
        .i_ena(i_ena),

        .i_data(i_ID_get_result_in_MEM),
        .o_data(o_EXE_get_result_in_MEM)
    );

    RegWithWE #(5) gpr_waddr_reg(
        .clk(clk),
        .resetn(resetn),
        
        .i_ena(i_ena),

        .i_data(i_ID_GPR_waddr),
        .o_data(o_EXE_GPR_waddr)
    );

    RegWithWE #(1, 1) gpr_we_reg(
        .clk(clk),
        .resetn(resetn),
        
        .i_ena(i_ena),

        .i_data(i_ID_GPR_we),
        .o_data(o_EXE_GPR_we)
    );

    RegWithWE #(32) alu_opr1_reg(
        .clk(clk),
        .resetn(resetn),
        
        .i_ena(i_ena),

        .i_data(i_ID_ALU_opr1),
        .o_data(o_EXE_ALU_opr1)
    );

    RegWithWE #(32) alu_opr2_reg(
        .clk(clk),
        .resetn(resetn),
        
        .i_ena(i_ena),

        .i_data(i_ID_ALU_opr2),
        .o_data(o_EXE_ALU_opr2)
    );

    RegWithWE #(5) alu_op_reg(
        .clk(clk),
        .resetn(resetn),
        
        .i_ena(i_ena),

        .i_data(i_ID_ALU_op),
        .o_data(o_EXE_ALU_op)
    );

    RegWithWE #(1) mult_div_is_unsigned_reg(
        .clk(clk),
        .resetn(resetn),
        
        .i_ena(i_ena),

        .i_data(i_ID_MultDiv_is_unsigned),
        .o_data(o_EXE_MultDiv_is_unsigned)
    );

    RegWithWE #(32) dmem_addr_reg(
        .clk(clk),
        .resetn(resetn),
        
        .i_ena(i_ena),

        .i_data(i_ID_dmem_addr),
        .o_data(o_EXE_dmem_addr)
    );

    RegWithWE #(1, 1) ll_bit_reg(
        .clk(clk),
        .resetn(resetn),
        
        .i_ena(i_ena),

        .i_data(i_ID_LL_bit_value),
        .o_data(o_EXE_LL_bit_value)
    );

    RegWithWE #(32) gpr_rdata1_reg(
        .clk(clk),
        .resetn(resetn),
        
        .i_ena(i_ena),

        .i_data(i_ID_GPR_rdata1),
        .o_data(o_EXE_GPR_rdata1)
    );

    RegWithWE #(1, 1) reg_hi_we_reg(
        .clk(clk),
        .resetn(resetn),
        
        .i_ena(i_ena),

        .i_data(i_ID_RegHi_we),
        .o_data(o_EXE_RegHi_we)
    );

    RegWithWE #(1, 1) reg_lo_we_reg(
        .clk(clk),
        .resetn(resetn),
        
        .i_ena(i_ena),

        .i_data(i_ID_RegLo_we),
        .o_data(o_EXE_RegLo_we)
    );

    RegWithWE #(2) lohi_wdata_sel_reg(
        .clk(clk),
        .resetn(resetn),
        
        .i_ena(i_ena),

        .i_data(i_ID_LoHi_wdata_selection),
        .o_data(o_EXE_LoHi_wdata_selection)
    );

    RegWithWE #(32) opr2_value_reg(
        .clk(clk),
        .resetn(resetn),
        
        .i_ena(i_ena),

        .i_data(i_ID_opr2_value),
        .o_data(o_EXE_opr2_value)
    );

    RegWithWE #(1, 1) cp0_we_reg(
        .clk(clk),
        .resetn(resetn),
        
        .i_ena(i_ena),

        .i_data(i_ID_CP0_we),
        .o_data(o_EXE_CP0_we)
    );

    RegWithWE #(1, 1) is_branch_reg(
        .clk(clk),
        .resetn(resetn),
        
        .i_ena(i_ena),

        .i_data(i_ID_is_branch),
        .o_data(o_EXE_is_branch)
    );

    RegWithWE #(1, 1) in_delay_slot_reg(
        .clk(clk),
        .resetn(resetn),
        
        .i_ena(i_ena),

        .i_data(i_EXE_is_branch),
        .o_data(o_EXE_current_is_in_delay_slot)
    );

    RegWithWE #(1, 1) is_eret_reg(
        .clk(clk),
        .resetn(resetn),
        
        .i_ena(i_ena),

        .i_data(i_ID_is_eret),
        .o_data(o_EXE_is_eret)
    );

    RegWithWE #(5) except_cause_reg(
        .clk(clk),
        .resetn(resetn),
        
        .i_ena(i_ena),

        .i_data(i_ID_bad_addr ? (i_ID_dmem_we ? EXC_CAUSE_ADES : EXC_CAUSE_ADEL) : i_ID_except_cause),
        .o_data(o_EXE_except_cause)
    );
    
endmodule