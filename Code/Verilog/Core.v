module Core (
    input wire          clk,
    input wire          resetn,

    input wire[5:0]     i_interuption,

    input wire[31:0]    i_IMEM_rdata,
    output wire[31:0]   o_IMEM_raddr,


    input wire[31:0]    i_DMEM_rdata,

    output wire[31:0]   o_DMEM_addr,
    output wire[31:0]   o_DMEM_wdata,
    output wire         o_DMEM_we,

    output wire[3:0]    o_DMEM_sel,

    output wire         o_timer_int
);

    wire IF_ID_ena;
    wire ID_EXE_ena;
    wire EXE_MEM_ena;
    wire MEM_WB_ena;

    // IF
    wire[31:0] IF_pc_out;

    // ID
    wire[31:0] ID_IF_next_pc;

    wire[31:0] ID_current_pc;
    wire[31:0] ID_current_instr;

    wire ID_get_result_in_EXE;
    wire ID_get_result_in_MEM;
    wire[4:0] ID_GPR_waddr;

    wire ID_is_trap;
    wire ID_is_branch;
    wire ID_is_jump_imm;

    wire ID_pred_is_branch;

    wire[31:0] ID_GPR_rdata1;
    wire[31:0] ID_GPR_rdata2;

    wire[31:0] ID_valid_rdata1;
    wire[31:0] ID_valid_rdata2;

    // EXE
    wire[31:0] EXE_current_instr;
    wire[31:0] EXE_current_pc;

    wire EXE_get_result_in_EXE;
    wire EXE_get_result_in_MEM;
    wire[4:0] EXE_GPR_waddr;

    wire[31:0] EXE_ALU_opr1;
    wire[31:0] EXE_ALU_opr2;
    wire[4:0] EXE_ALU_op;


    wire[31:0] EXE_ALU_result;
    wire EXE_ALU_overflow;
    wire EXE_ALU_no_write_override;


    wire EXE_MultDiv_is_unsigned;
    wire[31:0] EXE_Mult_hi_result;
    wire[31:0] EXE_Mult_lo_result;

    wire EXE_is_div;
    wire[31:0] EXE_Div_quotient;
    wire[31:0] EXE_Div_remainder;
    wire EXE_Div_busy;
    wire EXE_Div_done;

    wire[31:0] EXE_dmem_addr;
    wire[3:0] EXE_dmem_sel;
    wire EXE_bad_addr;

    // MEM
    wire[31:0] MEM_current_pc;
    wire[31:0] MEM_current_instr;

    wire MEM_get_result_in_EXE;
    wire MEM_get_result_in_MEM;
    wire[4:0] MEM_GPR_waddr;

    wire[31:0] MEM_GPR_raddr1;
    wire[31:0] MEM_GPR_raddr2;

    wire MEM_is_branch_instr;
    wire MEM_is_take_branch;
    wire MEM_pred_is_branch;

    wire[31:0] MEM_Mult_lo;
    wire[31:0] MEM_Mult_hi;

    wire[31:0] MEM_Div_quotient;
    wire[31:0] MEM_Div_remainder;

    wire[31:0] MEM_RegLo_rdata;
    wire[31:0] MEM_RegHi_rdata;

    wire[31:0] MEM_MCalc_lo;
    wire[31:0] MEM_MCalc_hi;

    wire MEM_RegHi_we;
    wire MEM_RegLo_we;

    reg[31:0] MEM_RegHi_wdata;
    reg[31:0] MEM_RegLo_wdata;

    wire[1:0] MEM_LoHi_wdata_selection;

    wire[31:0] MEM_dmem_addr;
    wire[31:0] MEM_opr2_value; // rt value
    wire[31:0] MEM_proc_dmem_rdata;

    // WB
    wire WB_GPR_we;
    wire[4:0] WB_GPR_waddr;
    wire[31:0] WB_GPR_wdata;

    assign o_DMEM_addr = IF_pc_out;

    PipelineController pipeline_controller(
        .clk(clk),
        .resetn(resetn),

        .i_div_busy(EXE_Div_busy),
        .i_div_done(EXE_Div_done),

        .i_branch_wrong_pred(MEM_is_take_branch ^ MEM_pred_is_branch),

        .o_IF_ID_ena(IF_ID_ena),
        .o_ID_EXE_ena(ID_EXE_ena),
        .o_EXE_MEM_ena(EXE_MEM_ena),
        .o_MEM_WB_ena(MEM_WB_ena)
    );

    // IF
    RegWithWE #(32) pc_inst(
        .clk(clk),
        .resetn(resetn),

        .i_we(IF_ID_ena),
        .i_data(ID_IF_next_pc),

        .o_data(IF_pc_out)
    );


    // ID
    BranchPred branch_pred_inst(
        .clk(clk),
        .resetn(resetn),

        .i_current_pc(ID_current_pc),
        .i_instr(ID_current_instr),

        .i_ID_is_branch(ID_is_branch),
        .i_ID_is_jump_imm(ID_is_jump_imm),

        .i_MEM_branch_pc(MEM_current_pc),
        .i_MEM_is_branch_instr(MEM_is_branch_instr),
        .i_MEM_is_take_branch(MEM_is_take_branch),

        .o_pred_is_branch(ID_pred_is_branch),
        .o_pred_next_pc(ID_IF_next_pc)
    );

    RegFile gpr_inst(
        .clk(clk),
        .resetn(resetn),

        .i_we(WB_GPR_we),
        .i_raddr1(ID_current_instr[25:21]),
        .i_raddr2(ID_current_instr[20:16]),
        .i_waddr(WB_GPR_waddr),
        .i_wdata(WB_GPR_wdata),

        .o_rdata1(ID_GPR_rdata1),
        .o_rdata2(ID_GPR_rdata2)
    );

    GPRByPass gpr_bypass_inst(
        .i_ID_raddr1(ID_current_instr[25:21]),
        .i_ID_raddr2(ID_current_instr[20:16]),
        .i_ID_rdata1(ID_GPR_rdata1),
        .i_ID_rdata2(ID_GPR_rdata2),

        .i_EXE_get_result_in_EXE(EXE_get_result_in_EXE),
        .i_EXE_waddr(EXE_GPR_waddr),
        .i_EXE_wdata(),

        .i_MEM_get_result_in_MEM(MEM_get_result_in_MEM),
        .i_MEM_waddr(MEM_GPR_waddr),
        .i_MEM_wdata(),

        .o_ID_valid_rdata1(ID_valid_rdata1),
        .o_ID_valid_rdata2(ID_valid_rdata2)
    );

    // EXE
    ALU alu_inst(
        .i_opr1(EXE_ALU_opr1),
        .i_opr2(EXE_ALU_opr2),
        .i_op(EXE_ALU_op),

        .o_result(EXE_ALU_result),
        .o_overflow(EXE_ALU_overflow),
        .o_no_write_override(EXE_ALU_no_write_override)
    );

    MultCalculator mult_inst(
        .i_opr1(EXE_ALU_opr1),
        .i_opr2(EXE_ALU_opr2),

        .is_unsigned(EXE_MultDiv_is_unsigned),

        .o_hi_result(EXE_Mult_hi_result),
        .o_lo_result(EXE_Mult_lo_result)
    );

    Divivder div_inst(
        .clk(clk),
        .resetn(resetn),

        .i_dividend(EXE_ALU_opr1),
        .i_divisor(EXE_ALU_opr2),
        .i_is_unsigned(EXE_MultDiv_is_unsigned),
        .i_div_start(EXE_is_div),

        .o_quotient(EXE_Div_quotient),
        .o_remainder(EXE_Div_remainder),
        .o_div_busy(EXE_Div_busy),
        .o_div_done(EXE_Div_done)
    );

    MemAddrProc mem_addr_proc_inst(
        .i_instr_op(EXE_current_instr[31:26]),
        .i_offset(EXE_current_instr[15:0]),
        .i_base_reg_value(EXE_ALU_opr1),

        .o_mem_addr(EXE_dmem_addr),
        .o_mem_sel(EXE_dmem_sel),
        .o_bad_addr(EXE_bad_addr)
    );

    // MEM
    MCalc m_calc_inst(
        .i_instr_func(MEM_current_instr[5:0]),

        .i_mult_lo(MEM_Mult_lo),
        .i_mult_hi(MEM_Mult_hi),

        .i_reg_lo(MEM_RegLo_rdata),
        .i_reg_hi(MEM_RegHi_rdata),

        .o_result_lo(MEM_MCalc_lo),
        .o_result_hi(MEM_MCalc_hi)
    );


    // Hi Reg
    RegWithWE #(32) Hi_reg_inst(
        .clk(clk),
        .resetn(resetn),

        .i_data(MEM_RegHi_wdata),
        .i_we(MEM_RegHi_we),

        .o_data(MEM_RegHi_rdata)
    );

    // Hi Reg wdata selection
    always @(*) begin
        case (MEM_LoHi_wdata_selection)
            LH_W_SEL_GPR:
                MEM_RegHi_wdata <= MEM_GPR_raddr1;

            LH_W_SEL_MCALC:
                MEM_RegHi_wdata <= MEM_MCalc_hi;

            LH_W_SEL_MUL:
                MEM_RegHi_wdata <= MEM_Mult_hi;

            default:  // LH_W_SEL_DIV:
                MEM_RegHi_wdata <= MEM_Div_remainder;
        endcase
    end

    // Lo Reg
    RegWithWE #(32) Lo_reg_inst(
        .clk(clk),
        .resetn(resetn),

        .i_data(MEM_RegLo_wdata),
        .i_we(MEM_RegLo_we),

        .o_data(MEM_RegLo_rdata)
    );

    // Lo Reg wdata selection
    always @(*) begin
        case (MEM_LoHi_wdata_selection)
            LH_W_SEL_GPR:
                MEM_RegLo_wdata <= MEM_GPR_raddr1;

            LH_W_SEL_MCALC:
                MEM_RegLo_wdata <= MEM_MCalc_lo;

            LH_W_SEL_MUL:
                MEM_RegLo_wdata <= MEM_Mult_lo;

            default:  // LH_W_SEL_DIV:
                MEM_RegLo_wdata <= MEM_Div_quotient;
        endcase
    end

    MemDataProc mem_data_proc_inst(
        .i_instr_op(MEM_current_instr[31:26]),

        .i_addr_last_two_bit(MEM_dmem_addr[1:0]),
        .i_mem_data(i_DMEM_rdata),
        .i_reg_data(MEM_opr2_value),

        .o_proc_data(MEM_proc_dmem_rdata)
    );

    // WB
    
endmodule