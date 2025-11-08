`include "../src/constants/constants.vh"
`timescale 1ns/1ns

module eight_bit_alu_tb;

    // input signals
    reg [`DATA_WIDTH-1:0] tb_a8_i, tb_b8_i;
    // control signal
    reg [3:0] tb_f8_i;
    // output
    wire [`DATA_WIDTH-1:0] tb_y8_o;

    eight_bit_alu eight_bit_alu_inst(
        .a8_i(tb_a8_i),
        .b8_i(tb_b8_i),
        .f8_i(tb_f8_i),
        .y8_o(tb_y8_o)
    );

    initial begin 
    $dumpfile("tb/eight_bit_alu_tb.vcd");
    $dumpvars(0, eight_bit_alu_tb);
    #1;

    // call tests
    test_subtraction();

    end

    /* using taks for testing*/
    task run_test;
        input [3:0] func;
        input [`DATA_WIDTH-1:0] a;
        input [`DATA_WIDTH-1:0] b;
        input [`DATA_WIDTH-1:0] expected;
        begin
            tb_f8_i = func;
            tb_a8_i = a;
            tb_b8_i = b;
            #10; // wait 10 time units

            if (tb_y8_o !== expected)
                $display("FAILED: f=%b A=%d B=%d → got=%d expected=%d",
                         func, a, b, tb_y8_o, expected);
            else
                $display("PASSED: f=%b A=%d B=%d → result=%d",
                         func, a, b, tb_y8_o);
        end
    endtask

    task test_output_a_not_a;
        begin
            run_test(`ALL_ZERO, 8'd255, 8'd255, 8'd0);
            run_test(`OUTPUT_A, 8'd255, 8'd0, 8'd255);
            run_test(`OUTPUT_A, 8'd100, 8'd255, 8'd100);
            run_test(`OUTPUT_A, 8'd0, 8'd255, 8'd0);
            run_test(`OUTPUT_NOT_A, 8'b11111111, 8'd0, 8'b00000000);
            run_test(`OUTPUT_NOT_A, 8'b00000000, 8'd0, 8'b11111111);
            run_test(`OUTPUT_NOT_A, 8'b10101010, 8'd0, 8'b01010101);
        end
    endtask

    task test_and_or_xor;
        begin
            // AND
            run_test(`OUTPUT_A_AND_B, 8'b11111111, 8'b00000000, 8'b00000000);
            run_test(`OUTPUT_A_AND_B, 8'b00000000, 8'b11111111, 8'b00000000);
            run_test(`OUTPUT_A_AND_B, 8'b10101010, 8'b01010101, 8'b00000000);
            run_test(`OUTPUT_A_AND_B, 8'b11111111, 8'b10010001, 8'b10010001);
            run_test(`OUTPUT_A_AND_B, 8'b01000010, 8'b11111111, 8'b01000010);
            run_test(`OUTPUT_A_AND_B, 8'b11111111, 8'b11111111, 8'b11111111);
            // OR
            run_test(`OUTPUT_A_OR_B, 8'b00000000, 8'b00000000, 8'b00000000);
            run_test(`OUTPUT_A_OR_B, 8'b11111111, 8'b00000000, 8'b11111111);
            run_test(`OUTPUT_A_OR_B, 8'b00000000, 8'b11111111, 8'b11111111);
            run_test(`OUTPUT_A_OR_B, 8'b00000000, 8'b11111111, 8'b11111111);
            run_test(`OUTPUT_A_OR_B, 8'b11110000, 8'b00001111, 8'b11111111);
            run_test(`OUTPUT_A_OR_B, 8'b10101010, 8'b01010101, 8'b11111111);
            // XOR
            run_test(`OUTPUT_A_XOR_B, 8'b00000000, 8'b00000000, 8'b00000000);
            run_test(`OUTPUT_A_XOR_B, 8'b11111111, 8'b11111111, 8'b00000000);
            run_test(`OUTPUT_A_XOR_B, 8'b10101010, 8'b10101010, 8'b00000000);
            run_test(`OUTPUT_A_XOR_B, 8'b11110000, 8'b00001111, 8'b11111111);
            run_test(`OUTPUT_A_XOR_B, 8'b10101010, 8'b01010101, 8'b11111111);
            run_test(`OUTPUT_A_XOR_B, 8'b01000010, 8'b10010001, 8'b11010011);
        end
    endtask

    task test_addition;
        begin
            // A + B
            run_test(`OUTPUT_A_PLUS_B, 8'd0, 8'd0, 8'd0);
            run_test(`OUTPUT_A_PLUS_B, 8'd100, 8'd0, 8'd100);
            run_test(`OUTPUT_A_PLUS_B, 8'd0, 8'd100, 8'd100);
            run_test(`OUTPUT_A_PLUS_B, 8'd50, 8'd50, 8'd100);
            run_test(`OUTPUT_A_PLUS_B, 8'd33, 8'd66, 8'd99);
            run_test(`OUTPUT_A_PLUS_B, 8'd255, 8'd0, 8'd255);
            run_test(`OUTPUT_A_PLUS_B, 8'd0, 8'd255, 8'd255);
            // results in overflow (1)00000000
            run_test(`OUTPUT_A_PLUS_B, 8'd255, 8'd1, 8'd0);
            // results in overflow (1)01011110
            run_test(`OUTPUT_A_PLUS_B, 8'd200, 8'd150, 8'b01011110);
            // results in overflow (1)11111110
            run_test(`OUTPUT_A_PLUS_B, 8'd255, 8'd255, 8'b11111110);
        end
    endtask

    task test_subtraction;
        begin
            // B - A
            // 0 - 0 = 0
            run_test(`OUTPUT_B_MINUS_A, 8'd0, 8'd0, 8'd0);
            // 1 - 0 = 1
            run_test(`OUTPUT_B_MINUS_A, 8'd0, 8'd1, 8'd1);
            // 1 - 1 = 0
            run_test(`OUTPUT_B_MINUS_A, 8'd1, 8'd1, 8'd0);
            // 0 - 1 = -1, should result in two's compliment value of (1)11111111
            run_test(`OUTPUT_B_MINUS_A, 8'd1, 8'd0, 8'b11111111);
            // 10 - 5 = 5, should result in unsigned binary output 5
            run_test(`OUTPUT_B_MINUS_A, 8'd5, 8'd10, 8'b00000101);
            // 5 - 10 = -5, should result in two's compliment representing -5
            run_test(`OUTPUT_B_MINUS_A, 8'd10, 8'd5, 8'b11111011);
            // 100 - 50 = 50, should result in unsigned binary output 50
            run_test(`OUTPUT_B_MINUS_A, 8'd50, 8'd100, 8'b0110010);
            // 255 - 255 = 0
            run_test(`OUTPUT_B_MINUS_A, 8'd255, 8'd255, 8'b00000000);
            // 50 - 100 = -50, should result in two's compliment representing -50
            run_test(`OUTPUT_B_MINUS_A, 8'd100, 8'd50, 8'b11001110);
            // 50 - 255 = -205, should result in two's compliment representing -50, with overflow (1)00110011 
            run_test(`OUTPUT_B_MINUS_A, 8'd255, 8'd50, 8'b00110011);
        end 
    endtask

endmodule
