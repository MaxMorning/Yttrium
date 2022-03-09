# 新建work库
vlib work

# 建立映射
vmap work work

# 编译Verilog文件
vlog Verilog/OP.v
vlog Verilog/ALU.v
vlog Verilog/BranchProc.v
vlog Verilog/CLZCalculator.v
vlog Verilog/Exception.v
vlog Verilog/CP0.v
vlog Verilog/SelectSignal.v
vlog Verilog/Core.v
vlog Verilog/DMEM.v
vlog Verilog/Decoder.v
vlog Verilog/Divider.v
vlog Verilog/EXE_MEM_reg.v
vlog Verilog/GPRByPass.v
vlog Verilog/MotherBoard.v
vlog TestBench/soc_tb.v

# 设定仿真最小时间单位
vsim soc_tb -t 1ns

# 添加信号
add wave -group "Input"     -color #00e3ab  -label "Clock"          /soc_tb/clk
add wave -group "Input"     -color #00e3ab  -label "Reset"         /soc_tb/reset
add wave -group "Input"     -color #00e3ab  -label "Inter"         /soc_tb/interruption

# 进行仿真
run -all

