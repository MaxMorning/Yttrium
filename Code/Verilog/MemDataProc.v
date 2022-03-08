`include "OP.v"

// this module will be placed in EXE stage
module MemDataProc (
    input wire  [5:0]   i_instr_op,

    input wire  [1:0]   i_addr_last_two_bit,
    input wire  [31:0]  i_mem_data,
    input wire  [31:0]  i_reg_data,

    output reg  [31:0]  o_proc_data
);
    always @(*) begin
        case (i_instr_op)
            `OP_LW:
            begin
                o_proc_data <= i_mem_data;
            end

            `OP_LH:
            begin
                o_proc_data <= i_addr_last_two_bit[1] ? {{17{i_mem_data[15]}}, i_mem_data[14:0]} : {{17{i_mem_data[31]}}, i_mem_data[30:16]};
            end

            `OP_LHU:
            begin
                o_proc_data <= i_addr_last_two_bit[1] ? {16'h0, i_mem_data[15:0]} : {16'h0, i_mem_data[31:16]};
            end

            `OP_LB:
            begin
                case (i_addr_last_two_bit)
                    2'b00:
                    begin
                        o_proc_data <= {{25{i_mem_data[31]}}, i_mem_data[30:24]};
                    end

                    2'b01:
                    begin
                        o_proc_data <= {{25{i_mem_data[23]}}, i_mem_data[22:16]};
                    end

                    2'b10:
                    begin
                        o_proc_data <= {{25{i_mem_data[15]}}, i_mem_data[14:8]};
                    end

                    default:
                    begin
                        o_proc_data <= {{25{i_mem_data[7]}}, i_mem_data[6:0]};
                    end
                endcase
            end

            `OP_LBU:
            begin
                case (i_addr_last_two_bit)
                    2'b00:
                    begin
                        o_proc_data <= {24'h0, i_mem_data[31:24]};
                    end

                    2'b01:
                    begin
                        o_proc_data <= {24'h0, i_mem_data[23:16]};
                    end

                    2'b10:
                    begin
                        o_proc_data <= {24'h0, i_mem_data[15:8]};
                    end

                    default:
                    begin
                        o_proc_data <= {24'h0, i_mem_data[7:0]};
                    end
                endcase
            end

            `OP_LWL:
            begin
                case (i_addr_last_two_bit)
                    2'b00:
                    begin
                        o_proc_data <= i_mem_data;
                    end

                    2'b01:
                    begin
                        o_proc_data <= {i_mem_data[31:24], i_reg_data[23:0]};
                    end

                    2'b10:
                    begin
                        o_proc_data <= {i_mem_data[31:16], i_reg_data[15:0]};
                    end

                    default:
                    begin
                        o_proc_data <= {i_mem_data[31:8], i_reg_data[7:0]};
                    end
                endcase
            end

            `OP_LWR:
            begin
                case (i_addr_last_two_bit)
                    2'b00:
                    begin
                        o_proc_data <= {i_reg_data[31:8], i_mem_data[31:24]};
                    end

                    2'b01:
                    begin
                        o_proc_data <= {i_reg_data[31:16], i_mem_data[31:16]};
                    end

                    2'b10:
                    begin
                        o_proc_data <= {i_reg_data[31:24], i_mem_data[31:8]};
                    end

                    default:
                    begin
                        o_proc_data <= i_mem_data;
                    end
                endcase
            end

            default:
            begin
                o_proc_data <= 32'hX;
            end
        endcase
    end
endmodule