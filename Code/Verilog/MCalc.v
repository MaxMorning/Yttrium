`include "OP.v"

module MCalc (
    input wire[5:0] i_instr_func,

    input wire[31:0] i_mult_lo,
    input wire[31:0] i_mult_hi,

    input wire[31:0] i_reg_lo,
    input wire[31:0] i_reg_hi,

    output wire[31:0] o_result_lo,
    output wire[31:0] o_result_hi
);

    wire[63:0] add_result = {i_reg_hi, i_reg_lo} + {i_mult_hi, i_mult_lo};
    wire[63:0] sub_result = {i_reg_hi, i_reg_lo} - {i_mult_hi, i_mult_lo};
    
    assign {o_result_hi, o_result_lo} = (i_instr_func == FUNC_MADD || i_instr_func == FUNC_MADDU) ? add_result : sub_result;
    
endmodule