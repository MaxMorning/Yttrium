module Mult (
    input wire[31:0] i_opr1,
    input wire[31:0] i_opr2,

    input wire is_unsigned,

    output wire[31:0] o_hi_result,
    output wire[31:0] o_lo_result
);

    wire[31:0] always_positive_opr1 = (~is_unsigned & i_opr1[31]) ? (~i_opr1 + 1) : i_opr1;
    wire[31:0] always_positive_opr2 = (~is_unsigned & i_opr2[31]) ? (~i_opr2 + 1) : i_opr2;
    wire[63:0] result;

    wire [63:0] wire_lv0[31:0];
    wire [63:0] wire_lv1[15:0];
    wire [63:0] wire_lv2[7:0];
    wire [63:0] wire_lv3[3:0];
    wire [63:0] wire_lv4[1:0];
    wire [63:0] wire_lv5;

    generate
        genvar i;
        for (i = 0; i < 32; i = i + 1)
        begin : lv0
            assign wire_lv0[i] = always_positive_opr2[i] == 1 ? {{(32 - i){1'b0}}, always_positive_opr1, {i{1'b0}}} : 64'b0;
        end
    endgenerate

    generate
        for (i = 0; i < 16; i = i + 1)
        begin : lv1
            assign wire_lv1[i] = wire_lv0[2 * i] + wire_lv0[2 * i + 1];
        end
    endgenerate

    generate
        for (i = 0; i < 8; i = i + 1)
        begin : lv2
            assign wire_lv2[i] = wire_lv1[2 * i] + wire_lv1[2 * i + 1];
        end
    endgenerate

    generate
        for (i = 0; i < 4; i = i + 1)
        begin : lv3
            assign wire_lv3[i] = wire_lv2[2 * i] + wire_lv2[2 * i + 1];
        end
    endgenerate

    generate
        for (i = 0; i < 2; i = i + 1)
        begin : lv4
            assign wire_lv4[i] = wire_lv3[2 * i] + wire_lv3[2 * i + 1];
        end
    endgenerate

    // lv5
    assign wire_lv5 = wire_lv4[0] + wire_lv4[1];

    assign result = ~is_unsigned & (i_opr1[31] ^ i_opr2[31]) ? (~wire_lv5 + 32'h1) : wire_lv5;

    assign o_hi_result = result[63:32];
    assign o_lo_result = result[31:0];
    
endmodule