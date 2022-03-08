module RegWithWE #(
    parameter LENGTH = 32,
    parameter ENABLE_OVERRIDE = 1'b0
) (
    input wire                      clk,
    input wire                      resetn,

    input wire[LENGTH - 1 : 0]      i_data,
    input wire                      i_we,

    output wire[LENGTH - 1 : 0]    o_data
);
    reg[LENGTH - 1 : 0] data_reg;

    assign o_data = ENABLE_OVERRIDE ? ({LENGTH{i_we}} & o_data) : o_data;

    always @(posedge clk) begin
        if (!resetn) begin
            data_reg <= 0;
        end
        else begin
            if (i_we) begin
                data_reg <= i_data;
            end
        end
    end
    
endmodule