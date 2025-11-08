module one_bit_alu #(
        parameter F0 = 2'd0,
        parameter F1 = 2'd1,
        parameter F2 = 2'd2,
        parameter F3 = 2'd3)
    (
    input a_i,
    input b_i,
    input carry_in_i,
    input [3:0] f_i,
    output result_o,
    output carry_bit_o
);

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
        .enable_i(f_i[F2]),
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
        .a_i(inverter_a_o),
        .b_i(enable_b_o),
        .result_o(xor_o)
    );

    full_adder full_adder(
        .a_i(inverter_a_o),
        .b_i(enable_b_o),
        .carry_in_i(carry_in_i),
        .carry_out_o(carry_bit_o),
        .sum_o(adder_o)
    );

    multiplexer multiplexer(
        .and_r_i(and_o),
        .or_r_i(or_o),
        .xor_r_i(xor_o),
        .adder_r_i(adder_o),
        // connect F0 and F1
        .f_i(f_i[1:0]),
        .result_o(result_o)
    );

endmodule
