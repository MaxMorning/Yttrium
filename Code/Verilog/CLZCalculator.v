module CLZCalculator (
    input wire[31:0] i_data,

    output wire[31:0] o_clz_result
);
    assign o_clz_result[31:6] = 26'h0000;
    assign o_clz_result[5] = ~(| i_data); // i_data[31:0] == 0
    assign o_clz_result[4] = ~o_clz_result[5] & ~(| i_data[31:16]); // i_data[31:16] == 0
    
    wire[15:0] val_16 = o_clz_result[4] ? i_data[15:0] : i_data[31:16];

    assign o_clz_result[3] = ~(| val_16[15:8]); // val_16[15:8] == 0

    wire[7:0] val_8 = o_clz_result[3] ? val_16[7:0] : val_16[15:8];

    assign o_clz_result[2] = ~(| val_8[7:4]); // val_8[7:4] == 0

    wire[3:0] val_4 = o_clz_result[2] ? val_8[3:0] : val_8[7:4];

    assign o_clz_result[1] = ~(| val_4[3:2]); // val_4[3:2] == 0;

    assign o_clz_result[0] = o_clz_result[1] ? ~val_4[1] : ~val_4[3];

endmodule