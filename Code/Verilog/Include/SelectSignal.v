// write GPR data selection
parameter GPR_W_SEL_ALU = 3'h0;
parameter GPR_W_SEL_MUL = 3'h1;
parameter GPR_W_SEL_LLBIT = 3'h2;
parameter GPR_W_SEL_CP0 = 3'h3;
parameter GPR_W_SEL_LO = 3'h4;
parameter GPR_W_SEL_HI = 3'h5;
parameter GPR_W_SEL_MEM = 3'h6;
parameter GPR_W_SEL_PC = 3'h7;

// write lo / hi
parameter LH_W_SEL_GPR = 2'h0;
parameter LH_W_SEL_MCALC = 2'h1;
parameter LH_W_SEL_MUL = 2'h2;
parameter LH_W_SEL_DIV = 2'h3;

// jump / branch addr
parameter B_ADDR_ALU = 2'h0;
parameter B_ADDR_RS = 2'h1;