module DMEM (
    input wire clk,
    input wire we,
    input wire[31:0] addr,
    input wire[3:0] wdata_sel,
    input wire[31:0] wdata,
    
    output wire[31:0] rdata
);
    // mimic Block memory behavior
    reg[31:0] data_array[0:1023];
    wire[31:0] src_rdata = data_array[addr[11:2]];

    reg[31:0] rdata_reg;

    assign rdata = rdata_reg;

    always @(posedge clk) begin
        if (we) begin
            if (wdata_sel[3]) begin
                data_array[addr[11:2]][31:24] <= wdata[31:24];
            end
            
            if (wdata_sel[2]) begin
                data_array[addr[11:2]][23:16] <= wdata[23:16];
            end

            if (wdata_sel[1]) begin
                data_array[addr[11:2]][15:8] <= wdata[15:8];
            end

            if (wdata_sel[0]) begin
                data_array[addr[11:2]][7:0] <= wdata[7:0];
            end
        end

        rdata_reg <= src_rdata;
    end
endmodule