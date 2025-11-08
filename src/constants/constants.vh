`ifndef CONSTANTS_VH
`define CONSTANTS_VH

// ALU operation codes
`define ALL_ZERO 4'b0000
`define OUTPUT_A 4'b0001
`define OUTPUT_NOT_A 4'b1001
`define OUTPUT_A_AND_B 4'b0100
`define OUTPUT_A_OR_B 4'b0101
`define OUTPUT_A_XOR_B 4'b0110
`define OUTPUT_A_PLUS_B 4'b0111
`define OUTPUT_B_MINUS_A 4'b1111

// Bit width definitions
`define DATA_WIDTH 8
`define ADDR_WIDTH 16

`endif