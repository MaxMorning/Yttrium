`include "Include/OP.v"

// this module will be placed in EXE stage
module MemAddrProc (
    input wire  [5:0]   i_instr_op,
    input wire  [15:0]  i_offset,
    input wire  [31:0]  i_base_reg_value,

    output wire [31:0]  o_mem_addr,
    output reg  [3:0]   o_mem_sel,
    output reg          o_bad_addr
);
    wire[31:0] target_addr = i_base_reg_value + {{17{i_offset[15]}}, i_offset[14:0]};

    assign o_mem_addr = {target_addr[31:2], 2'b00};

    always @(*) begin
        case (i_instr_op)
            `OP_LW:
            `OP_SW:
            `OP_LL:
            `OP_SC:
            begin
                if (target_addr[1:0] != 2'b00) begin
                    o_mem_sel <= 4'bxxxx;
                    o_bad_addr <= 1;
                end
                else begin
                    o_mem_sel <= 4'b1111;
                    o_bad_addr <= 0;
                end
            end

            `OP_LH:
            `OP_LHU:
            `OP_SH:
            begin
                if (target_addr[0] != 1'b0) begin
                    o_mem_sel <= 4'bxxxx;
                    o_bad_addr <= 1;
                end
                else begin
                    o_mem_sel <= target_addr[1] ? 4'b0011 : 4'b1100;
                    o_bad_addr <= 0;
                end
            end

            `OP_LB:
            `OP_LBU:
            `OP_SB:
            begin
                o_bad_addr <= 0;

                case (target_addr[1:0])
                    2'b00:
                        o_mem_sel <= 4'b1000;

                    2'b01:
                        o_mem_sel <= 4'b0100;

                    2'b10:
                        o_mem_sel <= 4'b0010;

                    default: // 2'b11
                        o_mem_sel <= 4'b0001;
                endcase
            end

            `OP_LWL:
            `OP_SWL:
            begin
                o_bad_addr <= 0;

                case (target_addr[1:0])
                    2'b00:
                        o_mem_sel <= 4'b1111;

                    2'b01:
                        o_mem_sel <= 4'b0111;

                    2'b10:
                        o_mem_sel <= 4'b0011;

                    default: // 2'b11
                        o_mem_sel <= 4'b0001;
                endcase
            end

            `OP_LWR:
            `OP_SWR:
            begin
                o_bad_addr <= 0;

                case (target_addr[1:0])
                    2'b00:
                        o_mem_sel <= 4'b1000;

                    2'b01:
                        o_mem_sel <= 4'b1100;

                    2'b10:
                        o_mem_sel <= 4'b1110;

                    default: // 2'b11
                        o_mem_sel <= 4'b1111;
                endcase
            end
            
            default:
            begin
                o_mem_sel <= 4'bxxxx;
                o_bad_addr <= 0;
            end
        endcase
    end
endmodule