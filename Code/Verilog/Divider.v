module Divider (
    input wire clk,
    input wire resetn,

    input wire[31:0] i_dividend,
    input wire[31:0] i_divisor,
    input wire i_is_unsigned,
    input wire i_div_start,

    output wire[31:0] o_quotient,
    output wire[31:0] o_remainder,
    output wire o_div_busy
);
    reg r_signal;
    reg q_signal;
    reg [4:0] cnt;
    reg r_sign;
    reg [31:0] reg_b;
    reg [31:0] reg_r;
    reg [31:0] reg_q;

    reg busy;
    wire [31:0] temp_r;
    wire [32:0] sub_add;

    assign sub_add = r_sign ? ({reg_r, reg_q[31]} + {1'b0, reg_b}) : ({reg_r, reg_q[31]} - {1'b0, reg_b});
    assign temp_r = r_sign ? reg_r + reg_b : reg_r;
    assign o_quotient = q_signal ? ~reg_q + 1 : reg_q; 
    assign o_remainder = r_signal ? ~temp_r + 1 : temp_r;

    assign o_div_busy = busy;
    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            cnt <= 0;
            
            busy <= 1'b0;
        end
        else begin
            if (i_div_start) begin
                busy <= 1'b1;
                reg_q <= ~i_is_unsigned & i_dividend[31] ? ~i_dividend + 1 : i_dividend;
                r_signal <= ~i_is_unsigned & i_dividend[31];
                reg_r <= 32'h0;
                reg_b <= ~i_is_unsigned & i_divisor[31] ? ~i_divisor + 1 : i_divisor;
                q_signal <= ~i_is_unsigned & (i_divisor[31] ^ i_dividend[31]);
                r_sign <= 1'b0;
                cnt <= 1'b0;
            end
            else if (busy) begin
                reg_r <= sub_add[31:0];
                r_sign <= sub_add[32];
                reg_q <= {reg_q[30:0], ~sub_add[32]};
                cnt <= cnt + 1'b1;
                if (cnt == 5'b11111) begin
                    busy <= 1'b0;
                end
            end
        end
    end
endmodule