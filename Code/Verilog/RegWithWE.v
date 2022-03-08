module RegWithWE #(
    parameter LENGTH = 32,
    parameter ENABLE_OVERRIDE = 1'b0,
    parameter INIT_VALUE = 0
) (
    input wire                      clk,
    input wire                      resetn,

    input wire[LENGTH - 1 : 0]      i_data,
    input wire                      i_we,

    output wire[LENGTH - 1 : 0]    o_data
);
    reg[LENGTH - 1 : 0] data_reg;

    assign o_data = ENABLE_OVERRIDE ? ({LENGTH{i_we}} & data_reg) : data_reg;

    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            data_reg <= INIT_VALUE;
        end
        else begin
            if (i_we) begin
                data_reg <= i_data;
            end
        end
    end
    
endmodule