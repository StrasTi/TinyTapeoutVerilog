module 1_bit_alu(
    input a_i,
    input b_i,
    input [3:0] f_i,
    output result_o,
    output carry_bit_o
);

    localparam F0 = 0;
    localparam F1 = 1;
    localparam F2 = 2;
    localparam F3 = 3;

    wire inverter_a_o, enable_b_o, and_o, or_o, xor_o, adder_o;

    // inputs: A, F3
    inverter_gate inverter_gate (
        .input_i(a_i),
        .invert_i(f_i[F3]),
        .output_o(inverter_a_o)
    );

    // inputs: B, F2 
    enable_gate enable_gate (
        .input_i(b_i),
        .enable_i(f_i[F3]),
        .output_o(enable_b_o)
    );

    and_gate and_gate (
        .a_i(inverter_a_o),
        .b_i(enable_b_o),
        .result_o(and_o)
    );

    or_gate or_gate(
        .a_i(inverter_a_o),
        .b_i(enable_b_o),
        .result_o(or_o)
    );

    xor_gate xor_gate(
        
    );

endmodule
