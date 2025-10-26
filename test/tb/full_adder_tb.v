`timescale 1ns/1ns

module full_adder_tb;

    // input signals
    reg a_i, b_i, carry_in_i;
    // output signals
    wire sum_o, carry_out_o;

    full_adder dut_full_adder(
        .a_i(a_i),
        .b_i(b_i),
        .carry_in_i(carry_in_i),
        .carry_out_o(carry_out_o),
        .sum_o(sum_o)
    );

    initial begin 
        $dumpfile("tb/full_adder_tb.vcd");
        $dumpvars(0, full_adder_tb);
        #1;

        a_i = 1'b0; b_i = 1'b0; carry_in_i = 1'b0;
        /* result:
            sum_o = 0
            carry_out_o = 0
        */
        #10; // wait 10 time units

        a_i = 1'b1; b_i = 1'b0; carry_in_i = 1'b0;
        /* result:
            sum_o = 1
            carry_out_o = 0
        */
        #10; // wait 10 time units

        a_i = 1'b0; b_i = 1'b1; carry_in_i = 1'b0;
        /* result:
            sum_o = 1
            carry_out_o = 0
        */
        #10; // wait 10 time units

        a_i = 1'b0; b_i = 1'b0; carry_in_i = 1'b1;
        /* result:
            sum_o = 1
            carry_out_o = 0
        */
        #10; // wait 10 time units

        a_i = 1'b1; b_i = 1'b0; carry_in_i = 1'b1;
        /* result:
            sum_o = 0
            carry_out_o = 1
        */
        #10; // wait 10 time units

        a_i = 1'b1; b_i = 1'b1; carry_in_i = 1'b1;
        /* result:
            sum_o = 1
            carry_out_o = 1
        */
        #10; // wait 10 time units

    end

endmodule
