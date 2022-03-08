// write GPR data selection
`define GPR_W_SEL_ALU   3'h0
`define GPR_W_SEL_MUL   3'h1
`define GPR_W_SEL_LLBIT 3'h2
`define GPR_W_SEL_CP0   3'h3
`define GPR_W_SEL_LO    3'h4
`define GPR_W_SEL_HI    3'h5
`define GPR_W_SEL_MEM   3'h6
`define GPR_W_SEL_PC    3'h7

// write lo / hi
`define LH_W_SEL_GPR    2'h0
`define LH_W_SEL_MCALC  2'h1
`define LH_W_SEL_MUL    2'h2
`define LH_W_SEL_DIV    2'h3

// jump / branch addr
`define B_ADDR_ALU      2'h0
`define B_ADDR_RS       2'h1