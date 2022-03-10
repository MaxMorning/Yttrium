// first three add in EXE
module Mult_Stage_0 (
    input wire[31:0] i_opr1,
    input wire[31:0] i_opr2,

    input wire is_unsigned,

    output wire result_need_process,
    output wire[4 * 42 - 1 : 0] stage_0_result
);
    wire[31:0] always_positive_opr1 = (~is_unsigned & i_opr1[31]) ? (~i_opr1 + 1) : i_opr1;
    wire[31:0] always_positive_opr2 = (~is_unsigned & i_opr2[31]) ? (~i_opr2 + 1) : i_opr2;

    wire [31:0] wire_lv0[31:0];
    wire [33:0] wire_lv1[15:0];
    wire [36:0] wire_lv2[7:0];
    wire [41:0] wire_lv3[3:0];

    assign result_need_process = ~is_unsigned & (i_opr1[31] ^ i_opr2[31]);

    generate
        genvar i;
        for (i = 0; i < 32; i = i + 1)
        begin : lv0
            assign wire_lv0[i] = always_positive_opr2[i] == 1 ? always_positive_opr1 : 32'h0;
        end
    endgenerate

    generate
        for (i = 0; i < 16; i = i + 1)
        begin : lv1
            assign wire_lv1[i] = {{{1'b0, wire_lv0[2 * i + 1]} + {2'b00, wire_lv0[2 * i][31:1]}}, wire_lv0[2 * i][0]};
        end
    endgenerate

    generate
        for (i = 0; i < 8; i = i + 1)
        begin : lv2
            assign wire_lv2[i] = {{{1'b0, wire_lv1[2 * i + 1]} + {3'b000, wire_lv1[2 * i][33:2]}}, wire_lv1[2 * i][1:0]};
        end
    endgenerate

    generate
        for (i = 0; i < 4; i = i + 1)
        begin : lv3
            assign wire_lv3[i] = {{{1'b0, wire_lv2[2 * i + 1]} + {5'b00000, wire_lv2[2 * i][36:4]}}, wire_lv2[2 * i][3:0]};

            assign stage_0_result[42 * i + 41 -: 42] = wire_lv3[i];
        end
    endgenerate

endmodule