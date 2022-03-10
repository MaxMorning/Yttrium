module clock_div (
    input wire clk_in1,
    input wire resetn,

    output wire clk_out1
);
    reg[14:0] cnt;

    always @(posedge clk_in1 or negedge resetn) begin
        if (~resetn) begin
            cnt <= 0;
        end
        else begin
            cnt <= cnt + 1;
        end
    end

    assign clk_out1 = cnt[14];
endmodule