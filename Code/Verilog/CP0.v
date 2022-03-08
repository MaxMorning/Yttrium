`include "Exception.v"

//CP0 Reg Addr
`define CP0_REG_COUNT       5'b01001    // RW
`define CP0_REG_COMPARE     5'b01011    // RW
`define CP0_REG_STATUS      5'b01100    // RW
`define CP0_REG_CAUSE       5'b01101    // RO
`define CP0_REG_EPC         5'b01110    // RW
`define CP0_REG_PrId        5'b01111    // RO
`define CP0_REG_CONFIG      5'b10000    // RO

module CP0 (
    input wire          clk,
    input wire          resetn,

    input wire          i_we,
    input wire[4:0]     i_waddr,
    input wire[31:0]    i_wdata,
    input wire[4:0]     i_raddr,

    input wire[4:0]     i_except_cause,
    input wire[5:0]     i_int,
    input wire[31:0]    i_current_pc,
    input wire          i_is_in_delay_slot,
    input wire          i_is_eret,


    output wire[31:0]   o_rdata,

    output wire[31:0]   o_count_reg,
    output wire[31:0]   o_compare_reg,
    output wire[31:0]   o_status_reg,
    output wire[31:0]   o_cause_reg,
    output wire[31:0]   o_epc_reg,
    output wire[31:0]   o_config_reg,
    output wire[31:0]   o_prid_reg,

    output reg          o_timer_int,

    output wire         o_answer_exc
);

    reg[31:0] reg_file[31:0];

    assign o_rdata = reg_file[i_raddr];

    assign o_count_reg = reg_file[`CP0_REG_COUNT];
    assign o_compare_reg = reg_file[`CP0_REG_COMPARE];
    assign o_status_reg = reg_file[`CP0_REG_STATUS];
    assign o_cause_reg = reg_file[`CP0_REG_CAUSE];
    assign o_epc_reg = reg_file[`CP0_REG_EPC];
    assign o_config_reg = reg_file[`CP0_REG_CONFIG];
    assign o_prid_reg = reg_file[`CP0_REG_PrId];

    assign o_rdata = i_we && (i_raddr == i_waddr) ? i_wdata : reg_file[i_raddr];
    
    wire[5:0] masked_int = reg_file[`CP0_REG_STATUS][15:10] & i_int;

    assign o_answer_exc = (~reg_file[`CP0_REG_STATUS][1] && i_except_cause != `EXC_CAUSE_NOP) || (| (masked_int));

    always @(posedge clk or negedge resetn) begin
        if (~resetn) begin
            o_timer_int <= 1'b0;

            reg_file[0] <= 0;
            reg_file[1] <= 0;
            reg_file[2] <= 0;
            reg_file[3] <= 0;
            reg_file[4] <= 0;
            reg_file[5] <= 0;
            reg_file[6] <= 0;
            reg_file[7] <= 0;
            reg_file[8] <= 0;
            reg_file[9] <= 0;
            reg_file[10] <= 0;
            reg_file[11] <= 0;
            reg_file[`CP0_REG_STATUS] <= 32'h1000FF00;
            reg_file[13] <= 0;
            reg_file[14] <= 0;
            reg_file[`CP0_REG_PrId] <= 32'h00480101;
            reg_file[`CP0_REG_CONFIG] <= 32'h00008000;
            reg_file[17] <= 0;
            reg_file[18] <= 0;
            reg_file[19] <= 0;
            reg_file[20] <= 0;
            reg_file[21] <= 0;
            reg_file[22] <= 0;
            reg_file[23] <= 0;
            reg_file[24] <= 0;
            reg_file[25] <= 0;
            reg_file[26] <= 0;
            reg_file[27] <= 0;
            reg_file[28] <= 0;
            reg_file[29] <= 0;
            reg_file[30] <= 0;
            reg_file[31] <= 0;
        end
        else begin
            reg_file[`CP0_REG_COUNT] <= reg_file[`CP0_REG_COUNT] + 1;
            reg_file[`CP0_REG_CAUSE][15:10] <= i_int;

            if (reg_file[`CP0_REG_COMPARE] != 0 && reg_file[`CP0_REG_COUNT] == reg_file[`CP0_REG_COMPARE]) begin
                o_timer_int <= 1'b1;
            end
            else if (i_we && i_waddr == `CP0_REG_COMPARE) begin
                o_timer_int <= 1'b0;
            end

            if (i_we) begin
                case (i_waddr)
                    `CP0_REG_CAUSE:
                    begin
                        reg_file[`CP0_REG_CAUSE][9:8] <= i_wdata[9:8];
                        reg_file[`CP0_REG_CAUSE][23:22] <= i_wdata[23:22];
                    end

                    `CP0_REG_PrId,
                    `CP0_REG_CONFIG:
                    begin
                    end
                    
                    default:
                    begin
                        reg_file[i_waddr] <= i_wdata;
                    end
                endcase
            end

            if (i_is_eret) begin
                reg_file[`CP0_REG_STATUS][1] <= 1'b0;
            end
            else begin
                if (i_except_cause == `EXC_CAUSE_INT) begin
                    reg_file[`CP0_REG_EPC] <= i_current_pc - {i_is_in_delay_slot, 2'b00};
                    reg_file[`CP0_REG_CAUSE][31] <= i_is_in_delay_slot;

                    reg_file[`CP0_REG_STATUS][1] <= 1'b1;
                    reg_file[`CP0_REG_CAUSE][6:2] <= `EXC_CAUSE_INT;
                end
                else begin
                    if (!reg_file[`CP0_REG_STATUS][1]) begin
                        reg_file[`CP0_REG_EPC] <= i_current_pc - {i_is_in_delay_slot, 2'b00};
                        reg_file[`CP0_REG_CAUSE][31] <= i_is_in_delay_slot;

                        reg_file[`CP0_REG_STATUS][1] <= 1'b1;
                        reg_file[`CP0_REG_CAUSE][6:2] <= i_except_cause;
                    end
                end
            end
        end
    end

endmodule