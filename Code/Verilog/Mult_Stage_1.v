// last two add in MEM
module Mult_Stage_1 (
    input wire[4 * 42 - 1 : 0] stage_0_result,
    input wire result_need_process,

    output wire[31:0] o_hi_result,
    output wire[31:0] o_lo_result
);
    wire[63:0] result;

    wire [41:0] wire_lv3[3:0];
    wire [50:0] wire_lv4[1:0];
    wire [63:0] wire_lv5;

    generate
        for (i = 0; i < 4; i = i + 1)
        begin : lv3
            assign wire_lv3[i] = stage_0_result[42 * i + 41 -: 42];
        end
    endgenerate

    assign wire_lv4[0] = {{{1'b0, wire_lv3[1]} + {9'h0, wire_lv3[0][41:8]}}, wire_lv3[0][7:0]};
    assign wire_lv4[1] = {{{1'b0, wire_lv3[3]} + {9'h0, wire_lv3[2][41:8]}}, wire_lv3[2][7:0]};

    assign wire_lv5 = {{wire_lv4[1][47:0] + {13'h0, wire_lv4[0][50:16]}}, wire_lv4[0][15:0]};


    assign result = result_need_process ? (~wire_lv5 + 32'h1) : wire_lv5;

    assign o_hi_result = result[63:32];
    assign o_lo_result = result[31:0];
endmodule