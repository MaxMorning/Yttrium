module GPRByPass (
    input wire[4:0] i_ID_raddr1,
    input wire[4:0] i_ID_raddr2,
    input wire[31:0] i_ID_rdata1,
    input wire[31:0] i_ID_rdata2,

    input wire i_EXE_get_result_in_EXE, // when waddr is 0, this will be 1 too
    input wire i_EXE_get_result_in_MEM,
    input wire[4:0] i_EXE_waddr,
    input wire[31:0] i_EXE_wdata,

    input wire i_MEM_get_result_in_MEM,
    input wire[4:0] i_MEM_waddr,
    input wire[31:0] i_MEM_wdata,

    output reg[31:0] o_ID_valid_rdata1,
    output reg[31:0] o_ID_valid_rdata2,
    output reg o_ID_data_related_confict
);
    
    always @(*) begin
        if (i_EXE_get_result_in_EXE && i_EXE_waddr != 0 && i_EXE_waddr == i_ID_raddr1) begin
            o_ID_valid_rdata1 <= i_EXE_wdata;
        end
        else if (i_MEM_get_result_in_MEM && i_MEM_waddr != 0 && i_MEM_waddr == i_ID_raddr1) begin
            o_ID_valid_rdata1 <= i_MEM_wdata;
        end
        else begin
            o_ID_valid_rdata1 <= i_ID_rdata1;
        end
    end

    always @(*) begin
        if (i_EXE_get_result_in_EXE && i_EXE_waddr != 0 && i_EXE_waddr == i_ID_raddr2) begin
            o_ID_valid_rdata2 <= i_EXE_wdata;
        end
        else if (i_MEM_get_result_in_MEM && i_MEM_waddr != 0 && i_MEM_waddr == i_ID_raddr2) begin
            o_ID_valid_rdata2 <= i_MEM_wdata;
        end
        else begin
            o_ID_valid_rdata2 <= i_ID_rdata2;
        end
    end

    always @(*) begin
        if (i_EXE_get_result_in_MEM && i_EXE_waddr != 0 && (i_EXE_waddr == i_ID_raddr1 || i_EXE_waddr == i_ID_raddr2)) begin
            o_ID_data_related_confict <= 1;
        end
        else begin
            o_ID_data_related_confict <= 0;
        end
    end

endmodule