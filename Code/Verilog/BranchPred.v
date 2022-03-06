module BranchPred (
    input wire clk,
    input wire resetn,


    input wire[31:0] i_current_pc,
    input wire[31:0] i_instr,

    input wire i_ID_is_branch,
    input wire i_ID_is_jump_imm,

    input wire[31:0] i_MEM_branch_pc,
    input wire i_MEM_is_branch_instr,
    input wire i_MEM_is_take_branch,

    output wire  o_pred_is_branch,
    output wire[31:0] o_pred_next_pc
);

    wire[31:0] branch_dst_pc = i_current_pc + {{15{i_instr[15]}}, i_instr[14:0], 2'b00};

    wire[31:0] jump_dst_pc = {i_current_pc[31:28], i_instr[25:0], 2'b00};

    reg[2047:0] two_bit_BHT[1:0];

    wire[31:0] pc_plus_4 = i_current_pc + 4;

    assign o_pred_is_branch = two_bit_BHT[i_current_pc[12:2]][1]; 
    assign o_pred_next_pc = o_pred_is_branch ? (i_ID_is_jump_imm ? jump_dst_pc : (i_ID_is_branch ? branch_dst_pc : pc_plus_4) : pc_plus_4);

    integer i;
    always @(posedge clk) begin
        if (!resetn) begin
            for (i = 0; i < 2048; i = i + 1) begin
                two_bit_BHT[i] <= 0;
            end
        end
        else if (i_MEM_is_branch_instr) begin
            if (i_MEM_is_take_branch) begin
                case (two_bit_BHT[i_MEM_branch_pc[12:2]])
                    2'b00:
                        two_bit_BHT[i_MEM_branch_pc[12:2] <= 2'b01;

                    2'b01:
                        two_bit_BHT[i_MEM_branch_pc[12:2] <= 2'b10;

                    2'b10:
                        two_bit_BHT[i_MEM_branch_pc[12:2] <= 2'b11;
                endcase
            end
            else begin
                case (two_bit_BHT[i_MEM_branch_pc[12:2]])
                    2'b01:
                        two_bit_BHT[i_MEM_branch_pc[12:2] <= 2'b00;

                    2'b10:
                        two_bit_BHT[i_MEM_branch_pc[12:2] <= 2'b01;

                    2'b11:
                        two_bit_BHT[i_MEM_branch_pc[12:2] <= 2'b10;
                endcase
            end
            
        end
    end
endmodule