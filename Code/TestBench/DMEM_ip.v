module DMEM (
    input wire clk,
    input wire resetn,
    input wire we,
    input wire[31:0] addr,
    input wire[3:0] wdata_sel,
    input wire[31:0] wdata,
    
    output reg[31:0] ANSCODE_reg,
    output wire[31:0] rdata
);

    wire[3:0] wea = {4{we}} & wdata_sel;


    blk_mem bmem (
        .clka(clk),    // input wire clka
        .wea(wea),      // input wire [3 : 0] wea
        .addra(addr[31:2]),  // input wire [16 : 0] addra
        .dina(wdata),    // input wire [31 : 0] dina
        .douta(rdata)  // output wire [31 : 0] douta
    );

    always @(posedge clk or negedge resetn) begin
        if (~resetn) begin
            ANSCODE_reg <= 0;
        end
        else begin
            if (we && addr[31:2] == 30'h04004000) begin
                if (wdata_sel[3]) begin
                    ANSCODE_reg[31:24] <= wdata[31:24];
                end
                
                if (wdata_sel[2]) begin
                    ANSCODE_reg[23:16] <= wdata[23:16];
                end

                if (wdata_sel[1]) begin
                    ANSCODE_reg[15:8] <= wdata[15:8];
                end

                if (wdata_sel[0]) begin
                    ANSCODE_reg[7:0] <= wdata[7:0];
                end
            end
        end
    end
endmodule