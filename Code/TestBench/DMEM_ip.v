module DMEM (
    input wire clk,
    input wire we,
    input wire[31:0] addr,
    input wire[3:0] wdata_sel,
    input wire[31:0] wdata,
    
    output wire[31:0] rdata
);

    wire[3:0] wea = {4{we}} & wdata_sel;

    blk_mem your_instance_name (
        .clka(clk),    // input wire clka
        .wea(wea),      // input wire [3 : 0] wea
        .addra(addr),  // input wire [16 : 0] addra
        .dina(wdata),    // input wire [31 : 0] dina
        .douta(rdata)  // output wire [31 : 0] douta
    );
endmodule