module multiplexer #(
        parameter AND_OUTPUT = 2'd0,
        parameter OR_OUTPUT = 2'd1,
        parameter XOR_OUTPUT = 2'd2,
        parameter ADDER_OUTPUT = 2'd3)
    (
    input and_r_i,
    input or_r_i,
    input xor_r_i,
    input adder_r_i,
    input [1:0] f_i,
    // reg because i want to use always-block
    output reg result_o
);

    // synthesizes to logic
    always @(*) begin : multiplexer
        case(f_i)
            AND_OUTPUT: begin
                result_o = and_r_i;
            end
            OR_OUTPUT: begin
                result_o = or_r_i;
            end
            XOR_OUTPUT: begin
                result_o = xor_r_i;
            end
            ADDER_OUTPUT: begin
                result_o = adder_r_i;
            end
        endcase
    end

endmodule
