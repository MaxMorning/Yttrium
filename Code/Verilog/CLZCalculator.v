module CLZCalculator (
    input wire[31:0] i_data,

    output wire[31:0] o_clz_result
);
    assign o_clz_result[31:6] = 26'h0000;
    assign o_clz_result[5] = ~(| i_data);
    assign o_clz_result[4] = ~o_clz_result[5] & ~(| i_data[31:16]);
    reg[3:0] clzResult;
    assign o_clz_result[3:0] = {4{~o_clz_result[5]}} & clzResult;

    always @ (*) begin
        if (o_clz_result[4]) begin
            clzResult[3] <= ~(| i_data[15:8]);
        end
        else begin
            clzResult[3] <= ~(| i_data[31:24]);
        end
    end

    always @(*) begin
        case (o_clz_result[4:3])
            2'b00:
                begin
                    clzResult[2] <= ~(| i_data[31:28]);
                end
            2'b01:
                begin
                    clzResult[2] <= ~(| i_data[23:20]);
                end
            2'b10:
                begin
                    clzResult[2] <= ~(| i_data[15:12]);
                end
            2'b11: 
                begin
                    clzResult[2] <= ~(| i_data[7:4]);
                end
        endcase
    end

    always @(*) begin
        case (o_clz_result[4:2])
            3'b000:
                begin
                    clzResult[1] <= ~(| i_data[31:30]);
                end 
            3'b001: 
                begin
                    clzResult[1] <= ~(| i_data[27:26]);
                end 
            3'b010:
                begin
                    clzResult[1] <= ~(| i_data[23:22]);
                end 
            3'b011:
                begin
                    clzResult[1] <= ~(| i_data[19:18]);
                end 
            3'b100:
                begin
                    clzResult[1] <= ~(| i_data[15:14]);
                end 
            3'b101:
                begin
                    clzResult[1] <= ~(| i_data[11:10]);
                end
            3'b110:
                begin
                    clzResult[1] <= ~(| i_data[7:6]);
                end 
            3'b111:
                begin
                    clzResult[1] <= ~(| i_data[3:2]);
                end
        endcase
    end

    always @(*) begin
        clzResult[0] <= ~i_data[31 - {o_clz_result[4:1], 1'b0}];
    end

endmodule