`include "SelectSignal.v"
`include "OP.v"
`include "Exception.v"

module Core (
    input wire          clk,
    input wire          resetn,

    input wire[5:0]     i_interruption,

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
    wire[31:0] IF_next_pc;

    wire[31:0] IF_current_instr;

    // ID
    wire[31:0] ID_branch_jump_dst_pc;

    wire[31:0] ID_current_pc;
    wire[31:0] ID_current_instr;

    wire ID_get_result_in_EXE;
    wire ID_get_result_in_MEM;
    wire[4:0] ID_GPR_waddr;
    wire ID_GPR_we;

    wire[2:0] ID_GPR_wdata_selection;

    wire[31:0] ID_ALU_opr1;
    wire[31:0] ID_ALU_opr2;
    wire[4:0] ID_ALU_op;

    wire ID_is_trap;
    wire ID_is_branch;

    wire[31:0] ID_GPR_rdata1;
    wire[31:0] ID_GPR_rdata2;

    wire[31:0] ID_valid_rdata1;
    wire[31:0] ID_valid_rdata2;

    wire[31:0] ID_dmem_wdata;
    wire[31:0] ID_dmem_addr;
    wire[3:0] ID_dmem_sel;
    wire ID_bad_addr;
    wire ID_dmem_we;
    wire ID_Decoder_dmem_we;

    wire ID_current_instr_is_LL;
    wire ID_current_instr_is_SC;

    wire ID_LL_bit_value;

    wire ID_data_related_confict;

    wire ID_MultDiv_is_unsigned;

    wire ID_is_div;

    wire ID_RegHi_we;
    wire ID_RegLo_we;

    wire[1:0] ID_LoHi_wdata_selection;

    wire ID_CP0_we;

    wire ID_is_eret;

    wire[4:0] ID_except_cause;

    // EXE
    wire[31:0] EXE_current_instr;
    wire[31:0] EXE_current_pc;

    wire EXE_get_result_in_EXE;
    wire EXE_get_result_in_MEM;
    wire[4:0] EXE_GPR_waddr;
    wire EXE_GPR_we;

    wire[31:0] EXE_ALU_opr1;
    wire[31:0] EXE_ALU_opr2;
    wire[4:0] EXE_ALU_op;


    wire[31:0] EXE_ALU_result;
    wire EXE_ALU_overflow;
    wire EXE_ALU_no_write_override;


    wire EXE_MultDiv_is_unsigned;
    wire EXE_mult_result_need_process;

    wire [42 * 4 - 1 : 0] EXE_mult_stage_0_result;

    wire EXE_is_div;
    wire[31:0] EXE_Div_quotient;
    wire[31:0] EXE_Div_remainder;
    wire EXE_Div_busy;

    wire[2:0] EXE_GPR_wdata_selection;
    wire[31:0] EXE_GPR_wdata;

    wire[31:0] EXE_dmem_addr;
    wire[31:0] EXE_proc_dmem_rdata;

    wire EXE_LL_bit_value;

    wire[31:0] EXE_GPR_rdata1;
    wire EXE_RegHi_we;
    wire EXE_RegLo_we;

    wire[1:0] EXE_LoHi_wdata_selection;
    wire[31:0] EXE_opr2_value;

    wire EXE_CP0_we;
    wire EXE_current_is_in_delay_slot;
    wire EXE_is_eret;

    wire EXE_is_trap;

    wire[4:0] EXE_except_cause;

    wire EXE_is_branch;

    // MEM
    wire[31:0] MEM_current_pc;
    wire[31:0] MEM_current_instr;

    // wire MEM_get_result_in_EXE;
    wire MEM_get_result_in_MEM;
    wire MEM_GPR_we;
    wire[4:0] MEM_GPR_waddr;

    wire[31:0] MEM_GPR_rdata1;
    // wire[31:0] MEM_GPR_rdata2;

    wire[31:0] MEM_ALU_result;

    wire MEM_mult_result_need_process;
    wire[42 * 4 - 1 : 0] MEM_mult_stage_0_result;
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

    wire[31:0] MEM_opr2_value; // rt value

    wire[2:0] MEM_GPR_wdata_selection;
    wire[31:0] MEM_GPR_wdata;

    wire MEM_CP0_we;
    wire[31:0] MEM_CP0_rdata;
    wire[31:0] MEM_CP0_epc;
    wire MEM_CP0_timer_int;

    wire[4:0] MEM_CP0_except_cause;
    wire MEM_current_is_in_delay_slot;
    wire MEM_is_eret;

    wire MEM_LL_bit_value;

    wire[31:0] MEM_proc_dmem_rdata;

    wire MEM_CP0_answer_exc;


    // WB
    wire WB_GPR_we;
    wire[4:0] WB_GPR_waddr;
    wire[31:0] WB_GPR_wdata;


    assign ID_dmem_we = ID_Decoder_dmem_we & (~ID_current_instr_is_SC | ID_LL_bit_value);

    assign o_IMEM_raddr = IF_pc_out;
    assign IF_current_instr = i_IMEM_rdata;
    assign o_DMEM_addr = {ID_dmem_addr[31:2], 2'b00};
    assign o_DMEM_we = ID_dmem_we;
    assign o_DMEM_wdata = ID_dmem_wdata;
    assign o_DMEM_sel = ID_dmem_sel;
    

    assign o_timer_int = MEM_CP0_timer_int;

    PipelineController pipeline_controller(
        .clk(clk),
        .resetn(resetn),

        .i_div_busy(EXE_Div_busy),

        .i_ID_data_related_confict(ID_data_related_confict),
        .i_MEM_answer_exc(MEM_CP0_answer_exc | MEM_is_eret),

        .o_IF_ID_ena(IF_ID_ena),
        .o_ID_EXE_ena(ID_EXE_ena),
        .o_EXE_MEM_ena(EXE_MEM_ena),
        .o_MEM_WB_ena(MEM_WB_ena)
    );

    // IF
    RegWithWE #(32, 0, 32'h00400000) pc_inst( // initial value == 0040 0000 is to fit mars result
        .clk(clk),
        .resetn(resetn),

        .i_we(IF_ID_ena & ~ID_data_related_confict),
        .i_data(IF_next_pc),

        .o_data(IF_pc_out)
    );

    NextPCSel next_pc_sel_inst(
        .i_IF_current_pc(IF_pc_out),
        .i_ID_is_branch_jump_instr(ID_is_branch),
        .i_ID_branch_jump_dst_pc(ID_branch_jump_dst_pc),

        .i_MEM_is_eret(MEM_is_eret),
        .i_MEM_epc_value(MEM_CP0_epc),

        .i_answer_exc(MEM_CP0_answer_exc),
        .i_MEM_exception_cause(MEM_CP0_except_cause),

        .o_IF_next_pc(IF_next_pc)
    );

    // ID

    IF_ID_reg if_id_reg_inst(
        .clk(clk),
        .resetn(resetn),

        .i_ena(IF_ID_ena & ~ID_data_related_confict),

        .i_IF_current_pc(IF_pc_out),
        .i_IF_current_instr(IF_current_instr),

        .o_ID_current_pc(ID_current_pc),
        .o_ID_current_instr(ID_current_instr)
    );

    Decoder decoder_inst(
        .i_instr(ID_current_instr),
        .i_rs_rdata(ID_valid_rdata1),
        .i_rt_rdata(ID_valid_rdata2),

        .i_pc(ID_current_pc),

        .o_get_result_in_EXE(ID_get_result_in_EXE),
        .o_get_result_in_MEM(ID_get_result_in_MEM),

        .o_ALU_opr1(ID_ALU_opr1),
        .o_ALU_opr2(ID_ALU_opr2),
        .o_ALU_op(ID_ALU_op),

        .o_GPR_waddr(ID_GPR_waddr),
        .o_gpr_we(ID_GPR_we),
        .o_GPR_wdata_selection(ID_GPR_wdata_selection),
        
        .o_hi_we(ID_RegHi_we),
        .o_lo_we(ID_RegLo_we),

        .o_LoHi_wdata_selection(ID_LoHi_wdata_selection),

        .o_CP0_we(ID_CP0_we),

        .o_mem_we(ID_Decoder_dmem_we),

        .o_is_eret(ID_is_eret),
        .o_is_div(ID_is_div),

        .o_is_trap(ID_is_trap),

        .o_except_cause(ID_except_cause),

        .o_is_LL(ID_current_instr_is_LL),
        .o_is_SC(ID_current_instr_is_SC),

        .o_MultDiv_is_unsigned(ID_MultDiv_is_unsigned)
    );

    BranchProc branch_proc_inst(
        .i_current_pc(ID_current_pc),
        .i_instr(ID_current_instr),

        .i_GPR_rdata1(ID_valid_rdata1),
        .i_GPR_rdata2(ID_valid_rdata2),

        .o_is_branch(ID_is_branch),
        .o_next_pc(ID_branch_jump_dst_pc)
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
        .i_EXE_get_result_in_MEM(EXE_get_result_in_MEM),
        .i_EXE_we(EXE_GPR_we & EXE_ALU_no_write_override),
        .i_EXE_waddr(EXE_GPR_waddr),
        .i_EXE_wdata(EXE_GPR_wdata),

        .i_MEM_get_result_in_MEM(MEM_get_result_in_MEM),
        .i_MEM_we(MEM_GPR_we),
        .i_MEM_waddr(MEM_GPR_waddr),
        .i_MEM_wdata(MEM_GPR_wdata),

        .o_ID_valid_rdata1(ID_valid_rdata1),
        .o_ID_valid_rdata2(ID_valid_rdata2),
        .o_ID_data_related_confict(ID_data_related_confict)
    );

    MemAddrProc mem_addr_proc_inst(
        .i_instr_op(ID_current_instr[31:26]),
        .i_offset(ID_current_instr[15:0]),
        .i_base_reg_value(ID_valid_rdata1),
        .i_reg_wdata(ID_valid_rdata2),

        .o_mem_addr(ID_dmem_addr),
        .o_mem_wdata(ID_dmem_wdata),
        .o_mem_sel(ID_dmem_sel),
        .o_bad_addr(ID_bad_addr)
    );

    RegWithWE #(1) LL_bit_inst(
        .clk(clk),
        .resetn(resetn & ~(MEM_CP0_answer_exc)),

        .i_data(ID_current_instr_is_LL),
        .i_we(ID_current_instr_is_LL | ID_current_instr_is_SC),

        .o_data(ID_LL_bit_value)
    );

    // EXE
    ID_EXE_reg id_exe_reg_inst(
        .clk(clk),
        .resetn(resetn),

        .i_ena(ID_EXE_ena),

        .i_ID_current_instr(ID_data_related_confict ? 32'h0 :ID_current_instr),
        .i_ID_current_pc(ID_current_pc),

        .i_ID_get_result_in_EXE(ID_data_related_confict ? 1'b0 : ID_get_result_in_EXE),
        .i_ID_get_result_in_MEM(ID_data_related_confict ? 1'b0 : ID_get_result_in_MEM),
        .i_ID_GPR_waddr(ID_GPR_waddr),
        .i_ID_GPR_we(ID_data_related_confict ? 1'b0 : ID_GPR_we),

        .i_ID_ALU_opr1(ID_ALU_opr1),
        .i_ID_ALU_opr2(ID_ALU_opr2),
        .i_ID_ALU_op(ID_data_related_confict ? `ALU_NOP : ID_ALU_op),

        .i_ID_MultDiv_is_unsigned(ID_MultDiv_is_unsigned),

        .i_ID_is_div(ID_data_related_confict ? 1'b0 : ID_is_div),
        .i_ID_GPR_wdata_selection(ID_GPR_wdata_selection),
        .i_ID_dmem_addr(ID_dmem_addr),
        .i_ID_LL_bit_value(ID_LL_bit_value),

        .i_ID_GPR_rdata1(ID_valid_rdata1),
        .i_ID_RegHi_we(ID_data_related_confict ? 1'b0 : ID_RegHi_we),
        .i_ID_RegLo_we(ID_data_related_confict ? 1'b0 : ID_RegLo_we),

        .i_ID_LoHi_wdata_selection(ID_LoHi_wdata_selection),

        .i_ID_opr2_value(ID_valid_rdata2),

        .i_ID_CP0_we(ID_data_related_confict ? 1'b0 : ID_CP0_we),
        .i_ID_is_branch(ID_data_related_confict ? 1'b0 : ID_is_branch),
        .i_EXE_is_branch(ID_data_related_confict ? 1'b0 : EXE_is_branch),
        .i_ID_is_eret(ID_data_related_confict ? 1'b0 : ID_is_eret),

        .i_ID_is_trap(ID_data_related_confict ? 1'b0 : ID_is_trap),

        .i_ID_bad_addr(ID_data_related_confict ? 1'b0 : ID_bad_addr),
        .i_ID_dmem_we(ID_data_related_confict ? 1'b0 : ID_dmem_we),
        .i_ID_except_cause(ID_except_cause),

        .o_EXE_current_instr(EXE_current_instr),
        .o_EXE_current_pc(EXE_current_pc),

        .o_EXE_get_result_in_EXE(EXE_get_result_in_EXE),
        .o_EXE_get_result_in_MEM(EXE_get_result_in_MEM),
        .o_EXE_GPR_waddr(EXE_GPR_waddr),
        .o_EXE_GPR_we(EXE_GPR_we),

        .o_EXE_ALU_opr1(EXE_ALU_opr1),
        .o_EXE_ALU_opr2(EXE_ALU_opr2),
        .o_EXE_ALU_op(EXE_ALU_op),

        .o_EXE_MultDiv_is_unsigned(EXE_MultDiv_is_unsigned),

        .o_EXE_is_div(EXE_is_div),

        .o_EXE_GPR_wdata_selection(EXE_GPR_wdata_selection),

        .o_EXE_dmem_addr(EXE_dmem_addr),
        .o_EXE_LL_bit_value(EXE_LL_bit_value),

        .o_EXE_GPR_rdata1(EXE_GPR_rdata1),
        .o_EXE_RegHi_we(EXE_RegHi_we),
        .o_EXE_RegLo_we(EXE_RegLo_we),

        .o_EXE_LoHi_wdata_selection(EXE_LoHi_wdata_selection),

        .o_EXE_opr2_value(EXE_opr2_value),

        .o_EXE_CP0_we(EXE_CP0_we),
        .o_EXE_current_is_in_delay_slot(EXE_current_is_in_delay_slot),
        .o_EXE_is_branch(EXE_is_branch),
        .o_EXE_is_eret(EXE_is_eret),

        .o_EXE_is_trap(EXE_is_trap),

        .o_EXE_except_cause(EXE_except_cause)
    );

    ALU alu_inst(
        .i_opr1(EXE_ALU_opr1),
        .i_opr2(EXE_ALU_opr2),
        .i_op(EXE_ALU_op),

        .o_result(EXE_ALU_result),
        .o_overflow(EXE_ALU_overflow),
        .o_no_write_override(EXE_ALU_no_write_override)
    );

    Mult_Stage_0 mult_stage_0_inst(
        .i_opr1(EXE_ALU_opr1),
        .i_opr2(EXE_ALU_opr2),

        .is_unsigned(EXE_MultDiv_is_unsigned),

        .result_need_process(EXE_mult_result_need_process),
        .stage_0_result(EXE_mult_stage_0_result)
    );

    Divider div_inst(
        .clk(clk),
        .resetn(resetn),

        .i_dividend(ID_ALU_opr1),
        .i_divisor(ID_ALU_opr2),
        .i_is_unsigned(ID_MultDiv_is_unsigned),
        .i_div_start(ID_is_div),

        .o_quotient(EXE_Div_quotient),
        .o_remainder(EXE_Div_remainder),
        .o_div_busy(EXE_Div_busy)
    );

    GPRwdataSelect EXE_gpr_wdata_select_inst(
        .i_GPR_wdata_sel(EXE_GPR_wdata_selection),

        .i_alu_result(EXE_ALU_result),
        .i_mul_result(32'hZ),
        .i_llbit_result({31'h0, EXE_LL_bit_value}),
        .i_cp0_result(32'hZ),
        .i_lo_reg_result(32'hZ),
        .i_hi_reg_result(32'hZ),
        .i_mem_result(EXE_proc_dmem_rdata),
        .i_pc_result(EXE_current_pc + 8),

        .o_wdata_result(EXE_GPR_wdata)
    );

    MemDataProc mem_data_proc_inst(
        .i_instr_op(EXE_current_instr[31:26]),

        .i_addr_last_two_bit(EXE_dmem_addr[1:0]),
        .i_mem_data(i_DMEM_rdata),
        .i_reg_data(EXE_ALU_opr2),

        .o_proc_data(EXE_proc_dmem_rdata)
    );

    // MEM

    EXE_MEM_reg exe_mem_reg(
        .clk(clk),
        .resetn(resetn),

        .i_ena(EXE_MEM_ena & ~MEM_CP0_answer_exc),

        .i_EXE_current_pc(EXE_current_pc),
        .i_EXE_current_instr(EXE_current_instr),

        .i_EXE_get_result_in_MEM(EXE_get_result_in_MEM),
        .i_EXE_GPR_we(EXE_GPR_we & EXE_ALU_no_write_override),
        .i_EXE_GPR_waddr(EXE_GPR_waddr),

        .i_EXE_GPR_rdata1(EXE_GPR_rdata1),
        .i_EXE_ALU_result(EXE_ALU_result),

        .i_EXE_Div_quotient(EXE_Div_quotient),
        .i_EXE_Div_remainder(EXE_Div_remainder),

        .i_EXE_RegHi_we(EXE_RegHi_we),
        .i_EXE_RegLo_we(EXE_RegLo_we),

        .i_EXE_LoHi_wdata_selection(EXE_LoHi_wdata_selection),
        .i_EXE_opr2_value(EXE_opr2_value),

        .i_EXE_GPR_wdata_selection(EXE_GPR_wdata_selection),

        .i_EXE_CP0_we(EXE_CP0_we),
        .i_EXE_current_is_in_delay_slot(EXE_current_is_in_delay_slot),
        .i_EXE_is_eret(EXE_is_eret),

        .i_EXE_is_trap(EXE_is_trap),

        .i_EXE_LL_bit_value(EXE_LL_bit_value),

        .i_EXE_proc_dmem_rdata(EXE_proc_dmem_rdata),

        .i_EXE_except_cause(EXE_except_cause),
        .i_EXE_ALU_overflow(EXE_ALU_overflow),

        .i_EXE_mult_stage_0_result(EXE_mult_stage_0_result),
        .i_EXE_mult_result_need_process(EXE_mult_result_need_process),

        .o_MEM_current_pc(MEM_current_pc),
        .o_MEM_current_instr(MEM_current_instr),

        .o_MEM_get_result_in_MEM(MEM_get_result_in_MEM),
        .o_MEM_GPR_we(MEM_GPR_we),
        .o_MEM_GPR_waddr(MEM_GPR_waddr),

        .o_MEM_GPR_rdata1(MEM_GPR_rdata1),
        .o_MEM_ALU_result(MEM_ALU_result),

        .o_MEM_Div_quotient(MEM_Div_quotient),
        .o_MEM_Div_remainder(MEM_Div_remainder),

        .o_MEM_RegHi_we(MEM_RegHi_we),
        .o_MEM_RegLo_we(MEM_RegLo_we),

        .o_MEM_LoHi_wdata_selection(MEM_LoHi_wdata_selection),
        .o_MEM_opr2_value(MEM_opr2_value),

        .o_MEM_GPR_wdata_selection(MEM_GPR_wdata_selection),

        .o_MEM_CP0_we(MEM_CP0_we),

        .o_MEM_CP0_except_cause(MEM_CP0_except_cause),
        .o_MEM_current_is_in_delay_slot(MEM_current_is_in_delay_slot),
        .o_MEM_is_eret(MEM_is_eret),

        .o_MEM_LL_bit_value(MEM_LL_bit_value),
        .o_MEM_proc_dmem_rdata(MEM_proc_dmem_rdata),
        
        .o_MEM_mult_stage_0_result(MEM_mult_stage_0_result),
        .o_MEM_mult_result_need_process(MEM_mult_result_need_process)
    );

    Mult_Stage_1 mult_stage_1_inst(
        .stage_0_result(MEM_mult_stage_0_result),
        .result_need_process(MEM_mult_result_need_process),

        .o_hi_result(MEM_Mult_hi),
        .o_lo_result(MEM_Mult_lo)
    );

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
            `LH_W_SEL_GPR:
                MEM_RegHi_wdata <= MEM_GPR_rdata1;

            `LH_W_SEL_MCALC:
                MEM_RegHi_wdata <= MEM_MCalc_hi;

            `LH_W_SEL_MUL:
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
            `LH_W_SEL_GPR:
                MEM_RegLo_wdata <= MEM_GPR_rdata1;

            `LH_W_SEL_MCALC:
                MEM_RegLo_wdata <= MEM_MCalc_lo;

            `LH_W_SEL_MUL:
                MEM_RegLo_wdata <= MEM_Mult_lo;

            default:  // LH_W_SEL_DIV:
                MEM_RegLo_wdata <= MEM_Div_quotient;
        endcase
    end

    CP0 cp0_inst(
        .clk(clk),
        .resetn(resetn),

        .i_we(MEM_CP0_we),
        .i_waddr(MEM_current_instr[15:11]),
        .i_wdata(MEM_opr2_value),
        .i_raddr(MEM_current_instr[15:11]),

        .i_except_cause(EXE_MEM_ena ? MEM_CP0_except_cause : `EXC_CAUSE_NOP),
        .i_int(i_interruption),
        .i_current_pc(MEM_current_pc),
        .i_is_in_delay_slot(MEM_current_is_in_delay_slot),
        .i_is_eret(MEM_is_eret),

        .o_rdata(MEM_CP0_rdata),
        .o_epc_reg(MEM_CP0_epc),

        .o_timer_int(MEM_CP0_timer_int),
        .o_answer_exc(MEM_CP0_answer_exc)
    );

    GPRwdataSelect MEM_gpr_wdata_select_inst(
        .i_GPR_wdata_sel(MEM_GPR_wdata_selection),

        .i_alu_result(MEM_ALU_result),
        .i_mul_result(MEM_Mult_lo),
        .i_llbit_result({31'h0, MEM_LL_bit_value}),
        .i_cp0_result(MEM_CP0_rdata),
        .i_lo_reg_result(MEM_RegLo_rdata),
        .i_hi_reg_result(MEM_RegHi_rdata),
        .i_mem_result(MEM_proc_dmem_rdata),
        .i_pc_result(MEM_current_pc + 8),

        .o_wdata_result(MEM_GPR_wdata)
    );

    // WB
    MEM_WB_reg mem_wb_reg_inst(
        .clk(clk),
        .resetn(resetn),

        .i_ena(MEM_WB_ena),

        .i_MEM_GPR_we(MEM_GPR_we),
        .i_MEM_GPR_waddr(MEM_GPR_waddr),
        .i_MEM_GPR_wdata(MEM_GPR_wdata),

        .o_WB_GPR_we(WB_GPR_we),
        .o_WB_GPR_waddr(WB_GPR_waddr),
        .o_WB_GPR_wdata(WB_GPR_wdata)
    );
    
endmodule