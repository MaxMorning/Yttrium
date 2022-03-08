module soc_tb ();
    reg clk;
    reg reset;

    reg[4:0] interruption;

    wire[31:0] inst;
    wire[31:0] pc;

    MotherBoard mother_board(
        .clk(clk),
        .reset(reset),

        .i_interruption(interruption)
    );

    assign pc = soc.core0.exe_pc_out;
    assign inst = soc.core0.id_exe_reg_inst.exe_instr_out;

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
        reset = 0;
        system_ena = 1;
        interrupt = 0;
        #3
        reset = 1;

        #29;
        for (check_loop = 0; check_loop < 512; check_loop = check_loop + 1) begin
            $fdisplay(fout, "pc: %h", pc);
            $fdisplay(fout, "instr: %h", inst);

            for (i = 0; i < 32; i = i + 1) begin
                $fdisplay(fout, "regfile%d: %h", i, soc.core0.gpr_inst.array_reg[i]);
            end
            #10;
        end

        $fclose(fout);

        $finish;
    end
endmodule