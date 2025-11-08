module eight_bit_alu #(
        parameter F0 = 2'd0,
        parameter F1 = 2'd1,
        parameter F2 = 2'd2,
        parameter F3 = 2'd3)
    (
    input [7:0] a8_i,
    input [7:0] b8_i,
    input [3:0] f8_i,
    output [7:0] y8_o
    // maybe add status flags later
);

    wire [8:0] carry_bits;
    // use generate block to connect 8 one_bit_alu's
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin
            one_bit_alu one_bit_alu_inst (
                .a_i(a8_i[i]),
                .b_i(b8_i[i]),
                // for B - A, F3 will invert A and be used as first carry_in to create two's compliment of A
                .carry_in_i(i == 0 ? f8_i[F3] : carry_bits[i - 1]),
                .f_i(f8_i),
                .result_o(y8_o[i]),
                .carry_bit_o(carry_bits[i])
            );
        end
    endgenerate 

endmodule
