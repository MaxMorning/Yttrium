`include "OP.v"

module ALU (
    input wire[31:0] i_opr1,
    input wire[31:0] i_opr2,
    input wire[4:0] i_op,

    output reg[31:0]  o_result,
    output reg o_overflow,
    output reg o_no_write_override // 0 to force not write GPR
);

    wire[32:0] ext_opr1 = {i_opr1[31], i_opr1};
    wire[32:0] ext_opr2 = {i_opr2[31], i_opr2};

    wire[32:0] add_result = ext_opr1 + ext_opr2;
    wire[31:0] addu_result = i_opr1 + i_opr2;

    wire[32:0] sub_result = ext_opr1 - ext_opr2;
    wire[31:0] subu_result = i_opr1 - i_opr2;

    wire[31:0] and_result = i_opr1 & i_opr2;
    wire[31:0] or_result = i_opr1 | i_opr2;
    wire[31:0] xor_result = i_opr1 ^ i_opr2;
    wire[31:0] nor_result = ~(i_opr1 | i_opr2);

    wire[31:0] slt_result = $signed(i_opr1) < $signed(i_opr2) ? 32'h1 : 32'h0;
    wire[31:0] sltu_result = i_opr1 < i_opr2 ? 32'h1 : 32'h0;

    wire[31:0] sll_result = i_opr2 << i_opr1;
    wire[31:0] srl_result = i_opr2 >> i_opr1;
    wire[31:0] sra_result = i_opr2[31] ? (~(32'hffffffff >> i_opr1) | (i_opr2 >> i_opr1)) : i_opr2 >> i_opr1;

    wire[31:0] lui_result = {i_opr2[15:0], 16'h0};

    wire[31:0] movn_result = i_opr1;

    wire[31:0] neg_opr1 = ~ i_opr1;
    wire[31:0] clo_result;
    wire[31:0] clz_result;


    CLZCalculator clz_inst(
        .i_data(i_opr1),

        .o_clz_result(clz_result)
    );

    CLZCalculator clo_inst(
        .i_data(neg_opr1),

        .o_clz_result(clo_result)
    );

    always @(*) begin
        case (i_op)
            `ALU_AND:
            begin
                o_result <= and_result;
                o_overflow <= 0;
                o_no_write_override <= 1;
            end

            `ALU_OR:
            begin
                o_result <= or_result;
                o_overflow <= 0;
                o_no_write_override <= 1;
            end

            `ALU_XOR:
            begin
                o_result <= xor_result;
                o_overflow <= 0;
                o_no_write_override <= 1;
            end

            `ALU_NOR:
            begin
                o_result <= nor_result;
                o_overflow <= 0;
                o_no_write_override <= 1;
            end

            `ALU_SLL:
            begin
                o_result <= sll_result;
                o_overflow <= 0;
                o_no_write_override <= 1;
            end

            `ALU_SRA:
            begin
                o_result <= sra_result;
                o_overflow <= 0;
                o_no_write_override <= 1;
            end

            `ALU_SRL:
            begin
                o_result <= srl_result;
                o_overflow <= 0;
                o_no_write_override <= 1;
            end

            `ALU_MOVN:
            begin
                o_result <= movn_result;
                o_overflow <= 0;
                o_no_write_override <= (i_opr2 != 0);
            end

            `ALU_MOVZ:
            begin
                o_result <= movn_result;
                o_overflow <= 0;
                o_no_write_override <= (i_opr2 == 0);
            end

            `ALU_ADD:
            begin
                o_result <= add_result[31:0];
                o_overflow <= add_result[32] ^ add_result[31];
                o_no_write_override <= add_result[32] ~^ add_result[31];
            end

            `ALU_ADDU:
            begin
                o_result <= addu_result;
                o_overflow <= 0;
                o_no_write_override <= 1;
            end

            `ALU_SUB:
            begin
                o_result <= sub_result[31:0];
                o_overflow <= sub_result[32] ^ sub_result[31];
                o_no_write_override <= sub_result[32] ~^ sub_result[31];
            end

            `ALU_SUBU:
            begin
                o_result <= subu_result;
                o_overflow <= 0;
                o_no_write_override <= 1;
            end

            `ALU_SLT,
            `ALU_LT:
            begin
                o_result <= slt_result;
                o_overflow <= 0;
                o_no_write_override <= 1;
            end

            `ALU_SLTU,
            `ALU_LTU:
            begin
                o_result <= sltu_result;
                o_overflow <= 0;
                o_no_write_override <= 1;
            end

            `ALU_EQUAL:
            begin
                o_result <= {31'h0, ~(| xor_result)};
                o_overflow <= 0;
                o_no_write_override <= 1;
            end

            `ALU_GE:
            begin
                o_result <= ~slt_result[0];
                o_overflow <= 0;
                o_no_write_override <= 1;
            end

            `ALU_GEU:
            begin
                o_result <= ~sltu_result[0];
                o_overflow <= 0;
                o_no_write_override <= 1;
            end

            `ALU_NE:
            begin
                o_result <= {31'h0, (| xor_result)};
                o_overflow <= 0;
                o_no_write_override <= 1;
            end

            `ALU_CLO:
            begin
                o_result <= clo_result;
                o_no_write_override <= 1;
                o_overflow <= 0;
            end

            `ALU_CLZ:
            begin
                o_result <= clz_result;
                o_no_write_override <= 1;
                o_overflow <= 0;
            end

            `ALU_LUI:
            begin
                o_result <= lui_result;
                o_no_write_override <= 1;
                o_overflow <= 0;
            end

            default:
            begin
                o_result <= 32'hcdcdcdcd;
                o_no_write_override <= 1;
                o_overflow <= 0;
            end
        endcase
    end
    
endmodule