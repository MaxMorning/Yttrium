`timescale 1ns / 1ps

module soc_tb ();
    reg clk;
    reg reset;

    reg[4:0] interruption;

    wire[31:0] inst;
    wire[31:0] pc;

    wire[31:0] ANSCODE;

    integer fout;
    integer check_loop;
    integer i;

    SoC mother_board(
        .base_clk(clk),
        .reset(reset)
    );

    assign pc = mother_board.core_IMEM_raddr;
    assign inst = mother_board.IMEM_core_rdata;
    assign ANSCODE = mother_board.ANSCODE;

    initial begin
        clk = 0;
        forever begin
            #5 clk = ~clk;
        end
    end

    initial begin
        $dumpfile("result.vcd");
        $dumpvars(5);

        // $readmemh("./MIPS/WORKSPACE/instr.txt", mother_board.imem_inst.inst_array);
        // $readmemh("./MIPS/DMEM.txt", mother_board.dmem_inst.data_array);
        fout = $fopen("result.txt", "w+");
        reset = 1;
        interruption = 0;
        
        #7
        reset = 0;

        #49;
        for (check_loop = 0; check_loop < 4096; check_loop = check_loop + 1) begin
            $fdisplay(fout, "pc: %h", pc);
            $fdisplay(fout, "instr: %h", inst);

            for (i = 0; i < 32; i = i + 1) begin
                $fdisplay(fout, "regfile%d: %h", i, mother_board.core0.gpr_inst.array_reg[i]);
            end
            #10;
        end

        $fclose(fout);

//         $finish;
    end
endmodule