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

    MotherBoard mother_board(
        .clk(clk),
        .reset(reset),

        .i_interruption(interruption)
    );

    assign pc = mother_board.core0.MEM_current_pc;
    assign inst = mother_board.core0.MEM_current_instr;
    assign ANSCODE = mother_board.dmem_inst.data_array[0];

    initial begin
        clk = 0;
        forever begin
            #5 clk = ~clk;
        end
    end

    initial begin
        $dumpfile("result.vcd");
        $dumpvars(5);

        $readmemh("./MIPS/WORKSPACE/instr.txt", mother_board.imem_inst.inst_array);
        $readmemh("./MIPS/DMEM.txt", mother_board.dmem_inst.data_array);
        fout = $fopen("./MIPS/WORKSPACE/result.txt", "w+");
        reset = 1;
        interruption = 0;
        #7
        reset = 0;

        #49;
        for (check_loop = 0; check_loop < 8192; check_loop = check_loop + 1) begin
            $fdisplay(fout, "pc: %h", pc);
            $fdisplay(fout, "instr: %h", inst);

            for (i = 0; i < 32; i = i + 1) begin
                $fdisplay(fout, "regfile%d: %h", i, mother_board.core0.gpr_inst.array_reg[i]);
            end
            #10;
        end

        $fclose(fout);

        $finish;
    end
endmodule