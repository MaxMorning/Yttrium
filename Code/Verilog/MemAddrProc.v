`include "OP.v"

// this module will be placed in ID stage
module MemAddrProc (
    input wire  [5:0]   i_instr_op,
    input wire  [15:0]  i_offset,
    input wire  [31:0]  i_base_reg_value,
    input wire  [31:0]  i_reg_wdata,

    output wire [31:0]  o_mem_addr,
    output reg  [31:0]  o_mem_wdata,
    output reg  [3:0]   o_mem_sel,
    output reg          o_bad_addr
);
    wire[31:0] target_addr = i_base_reg_value + {{17{i_offset[15]}}, i_offset[14:0]};

    assign o_mem_addr = target_addr;

    always @(*) begin
        case (i_instr_op)
            `OP_LW,
            `OP_SW,
            `OP_LL,
            `OP_SC:
            begin
                if (target_addr[1:0] != 2'b00) begin
                    o_mem_sel <= 4'bxxxx;
                    o_bad_addr <= 1;
                    o_mem_wdata <= 32'hX;
                end
                else begin
                    o_mem_sel <= 4'b1111;
                    o_bad_addr <= 0;
                    o_mem_wdata <= i_reg_wdata;
                end
            end

            `OP_LH,
            `OP_LHU,
            `OP_SH:
            begin
                if (target_addr[0] != 1'b0) begin
                    o_mem_sel <= 4'bxxxx;
                    o_bad_addr <= 1;
                    o_mem_wdata <= 32'hX;
                end
                else begin
                    o_mem_sel <= target_addr[1] ? 4'b0011 : 4'b1100;
                    o_bad_addr <= 0;

                    if (target_addr[1]) begin
                        o_mem_sel <= 4'b0011;
                        o_mem_wdata <= i_reg_wdata;
                    end
                    else begin
                        o_mem_sel <= 4'b1100;
                        o_mem_wdata <= {i_reg_wdata[15:0], 16'h0};
                    end
                end
            end

            `OP_LB,
            `OP_LBU,
            `OP_SB:
            begin
                o_bad_addr <= 0;

                case (target_addr[1:0])
                    2'b00:
                    begin
                        o_mem_sel <= 4'b1000;
                        o_mem_wdata <= {i_reg_wdata[7:0], 24'h0};
                    end

                    2'b01:
                    begin
                        o_mem_sel <= 4'b0100;
                        o_mem_wdata <= {8'h0, i_reg_wdata[7:0], 16'h0};
                    end

                    2'b10:
                    begin
                        o_mem_sel <= 4'b0010;
                        o_mem_wdata <= {16'h0, i_reg_wdata[7:0], 8'h0};
                    end

                    default: // 2'b11
                    begin
                        o_mem_sel <= 4'b0001;
                        o_mem_wdata <= {24'h0, i_reg_wdata[7:0]};
                    end
                endcase
            end

            `OP_LWL,
            `OP_SWL:
            begin
                o_bad_addr <= 0;

                case (target_addr[1:0])
                    2'b00:
                    begin
                        o_mem_sel <= 4'b1111;
                        o_mem_wdata <= i_reg_wdata;
                    end

                    2'b01:
                    begin
                        o_mem_sel <= 4'b0111;
                        o_mem_wdata <= {8'h0, i_reg_wdata[31:8]};
                    end

                    2'b10:
                    begin
                        o_mem_sel <= 4'b0011;
                        o_mem_wdata <= {16'h0, i_reg_wdata[31:16]};
                    end

                    default: // 2'b11
                    begin
                        o_mem_sel <= 4'b0001;
                        o_mem_wdata <= {24'h0, i_reg_wdata[31:24]};
                    end
                endcase
            end

            `OP_LWR,
            `OP_SWR:
            begin
                o_bad_addr <= 0;

                case (target_addr[1:0])
                    2'b00:
                    begin
                        o_mem_sel <= 4'b1000;
                        o_mem_wdata <= {i_reg_wdata[7:0], 24'h0};
                    end

                    2'b01:
                    begin
                        o_mem_sel <= 4'b1100;
                        o_mem_wdata <= {i_reg_wdata[15:0], 16'h0};
                    end

                    2'b10:
                    begin
                        o_mem_sel <= 4'b1110;
                        o_mem_wdata <= {i_reg_wdata[23:0], 8'h0};
                    end

                    default: // 2'b11
                    begin
                        o_mem_sel <= 4'b1111;
                        o_mem_wdata <= i_reg_wdata;
                    end
                endcase
            end
            
            default:
            begin
                o_mem_sel <= 4'bxxxx;
                o_bad_addr <= 0;
                o_mem_wdata <= 32'hX;
            end
        endcase
    end
endmodule