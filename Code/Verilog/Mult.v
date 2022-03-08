module Mult (
    input wire[31:0] i_opr1,
    input wire[31:0] i_opr2,

    input wire is_unsigned,

    output wire[31:0] o_hi_result,
    output wire[31:0] o_lo_result
);

    wire[31:0] always_positive_opr1 = i_opr1[31] ? (~i_opr1 + 1) : i_opr1;
    wire[31:0] always_positive_opr2 = i_opr2[31] ? (~i_opr2 + 1) : i_opr2;

    wire[63:0] positive_result = always_positive_opr1 * always_positive_opr2;

    wire[63:0] result = is_unsigned ? (i_opr1 * i_opr2) : ($signed(i_opr1) * $signed(i_opr2));

    assign o_hi_result = result[63:32];
    assign o_lo_result = result[31:0];
    
endmodule