module RegWithWE #(
    parameter LENGTH = 32
) (
    input wire                      clk,
    input wire                      resetn,

    input wire[`LENGTH - 1 : 0]     i_data,
    input wire                      i_we,

    output reg[`LENGTH - 1 : 0]     o_data
);

    always @(posedge clk) begin
        if (!resetn) begin
            o_data <= 0;
        end
        else begin
            if (i_we) begin
                o_data <= i_data;
            end
        end
    end
    
endmodule