# Yttrium
A MIPS pipeline processer

## 指令集
### 格式
#### R-type  
| op | rs | rt | rd | sa | func |
| -- | -- | -- | -- | -- | -- |
| 31 : 26 | 25 : 21 | 20 : 16 | 15 : 11 | 10 : 6 | 5 : 0 |

#### I-type
| op | rs | rt | imm |
| -- | -- | -- | -- |
| 31 : 26 | 25 : 21 | 20 : 16 | 15 : 0 |

#### J-type
| op | address |
| -- | -- |
| 31 : 26 | 25 : 0 |

### 指令
#### 0 and
| segment | value | token |
| -- | -- | -- |
| OP | 000000 | OP_SPECIAL |  
| FUNC | 100100 | FUNC_AND |
| ALU_opr1 | rs_raddr |
| ALU_opr2 | rt_raddr |
| ALU_op | ALU_AND |
| gpr_we | 1 |
| waddr | rd_addr |
| wdata | ALU_data |
| Hi_we | 0 |
| Lo_we | 0 |
| exception | 0 |
| is_branch | 0 |

#### 1 andi
| segment | value | token |
| -- | -- | -- |
| OP | 001100 | OP_ANDI |  
| FUNC | NA |  |
| ALU_opr1 | rs_raddr |
| ALU_opr2 | imm_zero_ext |
| ALU_op | ALU_AND |
| gpr_we | 1 |
| waddr | rd_addr |
| wdata | ALU_data |
| Hi_we | 0 |
| Lo_we | 0 |
| exception | 0 |
| is_branch | 0 |

#### 2 or
#### 3 ori
#### 4 xor
#### 5 xori
#### 6 nor
#### 7 lui
#### 8 sll
#### 9 sllv
#### 10 sra
#### 11 srav
#### 12 srl
#### 13 srlv
#### 14 movn
#### 15 movz
#### 16 mfhi
#### 17 mthi
#### 18 mflo
#### 19 mtlo
#### 20 add
| segment | value | token |
| -- | -- | -- |
| OP | 000000 | OP_SPECIAL |  
| FUNC | 100000 | FUNC_ADD |
| ALU_opr1 | rs_raddr |
| ALU_opr2 | rt_raddr |
| ALU_op | ALU_ADD |
| gpr_we | 1 |
| waddr | rd_addr |
| wdata | ALU_data |
| Hi_we | 0 |
| Lo_we | 0 |
| exception | ALU_overflow |
| is_branch | 0 |

#### 21 addi
| segment | value | token |
| -- | -- | -- |
| OP | 001000 | OP_ADDI |  
| FUNC | NA | |
| ALU_opr1 | rs_raddr |
| ALU_opr2 | imm_sig_ext |
| ALU_op | ALU_ADD |
| gpr_we | 1 |
| waddr | rd_addr |
| wdata | ALU_data |
| Hi_we | 0 |
| Lo_we | 0 |
| exception | ALU_overflow |
| is_branch | 0 |
#### 22 addiu
#### 23 addu
#### 24 sub
#### 25 subu
#### 26 clo
#### 27 clz
#### 28 slt
#### 29 slti
#### 30 sltiu
#### 31 sltu
#### 32 mul
#### 33 mult
#### 34 multu
#### 35 madd
#### 36 maddu
#### 37 msub
#### 38 msubu
#### 39 div
#### 40 divu
#### 41 jr
#### 42 jalr
#### 43 j
#### 44 jal
#### 45 b
#### 46 bal
#### 47 beq
#### 48 bgez
#### 49 bgezal
#### 50 bgtz
#### 51 blez
#### 52 bltz
#### 53 bltzal
#### 54 bne
#### 55 lb
#### 56 lbu
#### 57 lh
#### 58 lhu
#### 59 ll
#### 60 lw
#### 61 lwl
#### 62 lwr
#### 63 sb
#### 64 sc
对于单核CPU而言，仅当发生中断时，该指令会失效
#### 65 sh
#### 66 sw
#### 67 swl
#### 68 swr
#### 69 mtc0
#### 70 mfc0
#### 71 teq
#### 72 tge
#### 73 tgeu
#### 74 tlt
#### 75 tltu
#### 76 tne
#### 77 teqi
#### 78 tgei
#### 79 tgeiu
#### 80 tlti
#### 81 tltiu
#### 82 tnei
#### 83 syscall
#### 84 eret
#### 85 nop
#### 86 ssnop
#### 87 sync
#### 88 pref

## Info
MFC0 will be executed in MEM stage  
MTC0 will be executed in WB stage