// file: param.v
`ifndef CPU_PARAM
`define CPU_PARAM

    // syntax: `define <macro name> <parameter>
    `define ADD 'b0000
    `define SUB 'b0001
    `define AND 'b0010
    `define OR  'b0011
    `define XOR 'b0100
    `define SLL 'b0101
    `define SRL 'b0110
    `define SRA 'b0111
    `define BEQ 'b1000
    `define BNE 'b1001
    `define BLT_SLT 'b1010
    `define BGE 'b1011
    `define LUI 'b1100
    `define SLTU 'b1101
    `define BLTU 'b1110
    `define BGEU 'b1111



`endif
