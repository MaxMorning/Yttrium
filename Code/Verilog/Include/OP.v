`define OP_SPECIAL  6'b000000
`define OP_SPECIAL2 6'b011100

`define OP_ANDI     6'b001100
`define OP_ORI      6'b001101
`define OP_XORI     6'b001110
`define OP_LUI      6'b001111

`define OP_PREF     6'b110011

`define OP_SLTI     6'b001010
`define OP_SLTIU    6'b001011

`define OP_ADDI     6'b001000
`define OP_ADDIU    6'b001001

`define OP_J        6'b000010
`define OP_JAL      6'b000011
`define OP_BEQ      6'b000100

`define OP_REGIMM   6'b000001
`define OP_BGTZ     6'b000111
`define OP_BLEZ     6'b000110
`define OP_BNE      6'b000101

`define OP_LB       6'b100000
`define OP_LBU      6'b100100
`define OP_LH       6'b100001
`define OP_LHU      6'b100101
`define OP_LL       6'b110000
`define OP_LW       6'b100011
`define OP_LWL      6'b100010
`define OP_LWR      6'b100110

`define OP_SB       6'b101000
`define OP_SC       6'b111000
`define OP_SH       6'b101001
`define OP_SW       6'b101011
`define OP_SWL      6'b101010
`define OP_SWR      6'b101110

`define OP_COP0     6'b010000
// Func

`define FUNC_AND    6'b100100
`define FUNC_OR     6'b100101
`define FUNC_XOR    6'b100110
`define FUNC_NOR    6'b100111

`define FUNC_SLL    6'b000000
`define FUNC_SLLV   6'b000100
`define FUNC_SRL    6'b000010
`define FUNC_SRLV   6'b000110
`define FUNC_SRA    6'b000011
`define FUNC_SRAV   6'b000111
`define FUNC_SYNC   6'b001111

`define FUNC_MOVZ   6'b001010
`define FUNC_MOVN   6'b001011
`define FUNC_MFHI   6'b010000
`define FUNC_MTHI   6'b010001
`define FUNC_MFLO   6'b010010
`define FUNC_MTLO   6'b010011

`define FUNC_SLT    6'b101010
`define FUNC_SLTU   6'b101011

`define FUNC_ADD    6'b100000
`define FUNC_ADDU   6'b100001
`define FUNC_SUB    6'b100010
`define FUNC_SUBU   6'b100011

`define FUNC_CLZ    6'b100000
`define FUNC_CLO    6'b100001

`define FUNC_MULT   6'b011000
`define FUNC_MULTU  6'b011001
`define FUNC_MUL    6'b000010
`define FUNC_MADD   6'b000000
`define FUNC_MADDU  6'b000001
`define FUNC_MSUB   6'b000100
`define FUNC_MSUBU  6'b000101

`define FUNC_DIV    6'b011010
`define FUNC_DIVU   6'b011011

`define FUNC_JALR   6'b001001
`define FUNC_JR     6'b001000

`define FUNC_TEQ    6'b110100
`define FUNC_TGE    6'b110000
`define FUNC_TGEU   6'b110001
`define FUNC_TLT    6'b110010
`define FUNC_TLTU   6'b110011
`define FUNC_TNE    6'b110110

`define FUNC_SYSCALL 6'b001100

// branch link op
`define RT_BGEZ     5'b00001
`define RT_BGEZAL   5'b10001
`define RT_BLTZ     5'b00000
`define RT_BLTZAL   5'b10000

`define RT_TEQI     5'b01100
`define RT_TGEI     5'b01000
`define RT_TGEIU    5'b01001
`define RT_TLTI     5'b01010
`define RT_TLTIU    5'b01011
`define RT_TNEI     5'b01110

// mfc0, mtc0 op
`define RS_MT       5'b00100
`define RS_MF       5'b00000

`define RS_ERET     5'b10000

// ALU Op
`define ALU_AND     5'h0
`define ALU_OR      5'h1
`define ALU_XOR     5'h2
`define ALU_NOR     5'h3
`define ALU_SLL     5'h4
`define ALU_SRA     5'h5
`define ALU_SRL     5'h6
`define ALU_MOVN    5'h7
`define ALU_MOVZ    5'h8
`define ALU_ADD     5'h9
`define ALU_ADDU    5'ha
`define ALU_SUB     5'hb
`define ALU_SUBU    5'hc
`define ALU_SLT     5'hd
`define ALU_SLTU    5'he
// `define ALU_EQUAL   5'hf
// `define ALU_GE      5'h10
// `define ALU_GEU     5'h11
// `define ALU_LT      5'h12
// `define ALU_LTU     5'h13
// `define ALU_NE      5'h14
`define ALU_CLO     5'h15
`define ALU_CLZ     5'h16
`define ALU_LUI     5'h17
`define ALU_NOP     5'h18