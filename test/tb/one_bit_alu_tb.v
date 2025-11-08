`timescale 1ns/1ns

module one_bit_alu_tb;
    // input signals
    reg tb_a_i, tb_b_i, tb_carry_in_i;
    // control signal
    reg [3:0] tb_f_i;
    // output
    wire tb_result_o, tb_carry_bit_o;

    localparam ALL_ZERO = 4'b0000;
    localparam OUTPUT_A = 4'b0001;
    localparam OUTPUT_NOT_A = 4'b1001;
    localparam OUTPUT_A_AND_B = 4'b0100;
    localparam OUTPUT_A_OR_B = 4'b0101;
    localparam OUTPUT_A_XOR_B = 4'b0110;
    localparam OUTPUT_A_PLUS_B = 4'b0111;
    localparam OUTPUT_B_MINUS_A = 4'b1111;

    one_bit_alu one_bit_alu(
        .a_i(tb_a_i),
        .b_i(tb_b_i),
        .carry_in_i(tb_carry_in_i),
        .f_i(tb_f_i),
        .result_o(tb_result_o),
        .carry_bit_o(tb_carry_bit_o)
    );

    initial begin 
    $dumpfile("tb/one_bit_alu_tb.vcd");
    $dumpvars(0, one_bit_alu_tb);
    #1;

    tb_a_i = 1'b0;
    tb_b_i = 1'b0;

    // test by going through truth table of basic 1 bit alu

    // ALL ZERO
    /* multiplexer should output and_gate result,
        since b input is disabled result should always be 0 */
    tb_f_i = ALL_ZERO;
    tb_a_i = 1'b1;
    tb_b_i = 1'b1;
    /* result:
            tb_result_o = 0
            tb_carry_bit_o = 0
    */
    #10; // wait 10 time units

    // A
    /* multiplexer should output or_gate result, 
        since b input is disabled result should A */
    tb_a_i = 1'b0;
    tb_b_i = 1'b1;
    tb_f_i = OUTPUT_A;
    #10; // wait 10 time units
    /* result:
            tb_result_o = 0
            tb_carry_bit_o = 0
    */

    tb_a_i = 1'b1;
    tb_b_i = 1'b0;
    #10; // wait 10 time units
    /* result:
            tb_result_o = 1
            tb_carry_bit_o = 0
    */

    // NOT A
    /* multiplexer should output or_gate result, 
        b input is disabled and a input gets inverted, so result should NOT A */
    tb_a_i = 1'b1;
    tb_f_i = OUTPUT_NOT_A;
    #10; // wait 10 time units
    /* result: tb_result_o = 0 */

    tb_a_i = 1'b0;
    #10; // wait 10 time units
    /* result: tb_result_o = 1 */

    // A AND B
    /* multiplexer should output and_gate result, 
        b input is enabled, result should A AND B */
    tb_a_i = 1'b0;
    tb_b_i = 1'b0;
    tb_f_i = OUTPUT_A_AND_B;
    #10; // wait 10 time units

    tb_a_i = 1'b1;
    tb_b_i = 1'b0;
    #10; // wait 10 time units

    tb_a_i = 1'b0;
    tb_b_i = 1'b1;
    #10; // wait 10 time units
    /* result: tb_result_o = 0 */

    tb_a_i = 1'b1;
    tb_b_i = 1'b1;
    #10; // wait 10 time units
    /* result: tb_result_o = 1 */

    // A OR B
    /* multiplexer should output or_gate result, 
        b input is enabled, result should A OR B */
    tb_a_i = 1'b0;
    tb_b_i = 1'b0;
    tb_f_i = OUTPUT_A_OR_B;
    #10; // wait 10 time units
    /* result: tb_result_o = 0 */

    tb_a_i = 1'b1;
    tb_b_i = 1'b0;
    #10; // wait 10 time units

    tb_a_i = 1'b0;
    tb_b_i = 1'b1;
    #10; // wait 10 time units

    tb_a_i = 1'b1;
    tb_b_i = 1'b1;
    #10; // wait 10 time units
    /* result: tb_result_o = 1 */

    // A XOR B
    /* multiplexer should output xor_gate result, 
        b input is enabled, result should A XOR B */
    tb_a_i = 1'b0;
    tb_b_i = 1'b0;
    tb_f_i = OUTPUT_A_XOR_B;
    #10; // wait 10 time units
    /* result: tb_result_o = 0 */

    tb_a_i = 1'b1;
    tb_b_i = 1'b0;
    #10; // wait 10 time units

    tb_a_i = 1'b0;
    tb_b_i = 1'b1;
    #10; // wait 10 time units
    /* result: tb_result_o = 1 */

    tb_a_i = 1'b1;
    tb_b_i = 1'b1;
    #10; // wait 10 time units
    /* result: tb_result_o = 0 */

    // A + B
    /*  multiplexer should output full_adder result, 
        result should A + B */

    // (carry_in) A + B = Result
    // (0) 0 + 0 = 00
    tb_a_i = 1'b0;
    tb_b_i = 1'b0;
    tb_carry_in_i = 1'b0;
    tb_f_i = OUTPUT_A_PLUS_B;
    #10; // wait 10 time units
    /*  result: tb_result_o = 0 
        tb_carry_bit_o = 0 */

    // (1) 0 + 0 = 01
    tb_carry_in_i = 1'b1;
    #10; // wait 10 time units
    /*  result: tb_result_o = 1 
        tb_carry_bit_o = 0 */

    // (0) 1 + 0 = 01
    tb_a_i = 1'b1;
    tb_b_i = 1'b0;
    tb_carry_in_i = 1'b0;
    #10; // wait 10 time units
    /*  result: tb_result_o = 1
        tb_carry_bit_o = 0 */

    // (1) 1 + 0 = 10
    tb_carry_in_i = 1'b1;
    #10; // wait 10 time units
    /*  result: tb_result_o = 0 
        tb_carry_bit_o = 1 */

    // (0) 0 + 1 = 01
    tb_a_i = 1'b0;
    tb_b_i = 1'b1;
    tb_carry_in_i = 1'b0;
    #10; // wait 10 time units
    /*  result: tb_result_o = 1
        tb_carry_bit_o = 0 */

    // (1) 0 + 1 = 10
    tb_carry_in_i = 1'b1;
    #10; // wait 10 time units
    /*  result: tb_result_o = 0 
        tb_carry_bit_o = 1 */

    // (0) 1 + 1 = 10
    tb_a_i = 1'b1;
    tb_b_i = 1'b1;
    tb_carry_in_i = 1'b0;
    #10; // wait 10 time units
    /*  result: tb_result_o = 0
        tb_carry_bit_o = 1 */

    // (1) 1 + 1 = 11
    tb_carry_in_i = 1'b1;
    #10; // wait 10 time units
    /*  result: tb_result_o = 1 
        tb_carry_bit_o = 1 */

    tb_carry_in_i = 1'b0;

    end

endmodule
