module Divivder (
    input wire clk,
    input wire resetn,

    input wire[31:0] i_dividend,
    input wire[31:0] i_divisor,
    input wire i_is_unsigned,
    input wire i_div_start,

    output wire[31:0] o_quotient,
    output wire[31:0] o_remainder,
    output wire o_div_busy,
    output wire o_div_done
);
    
endmodule