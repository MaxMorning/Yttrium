module IF_ID_reg (
    input wire clk,
    input wire resetn,
    
    input wire i_ena,

    input wire[31:0] i_IF_current_pc,
    input wire[31:0] i_IF_current_instr,

    output wire[31:0] o_ID_current_pc,
    output wire[31:0] o_ID_current_instr
);
    RegWithWE #(32) current_instr_reg(
        .clk(clk),
        .resetn(resetn),
        
        .i_ena(i_ena),

        .i_data(i_IF_current_instr),
        .o_data(o_ID_current_instr)
    );

    RegWithWE #(32) current_instr_reg(
        .clk(clk),
        .resetn(resetn),
        
        .i_ena(i_ena),

        .i_data(i_IF_current_pc),
        .o_data(o_ID_current_pc)
    );

endmodule