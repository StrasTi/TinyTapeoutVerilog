`timescale 1ns/1ns

module full_subtractor_tb;

    // input signals
    reg tb_a_i, tb_b_i, tb_borrow_in_i;
    // output signals
    wire tb_borrow_out_o, tb_diff_o;

    full_subtractor dut_full_subtractor(
        .a_i(tb_a_i),
        .b_i(tb_b_i),
        .borrow_in_i(tb_borrow_in_i),
        .borrow_out_o(tb_borrow_out_o),
        .diff_o(tb_diff_o)
    );

    initial begin 
    $dumpfile("tb/full_subtractor_tb.vcd");
    $dumpvars(0, full_subtractor_tb);
    #1;

    // call tests
    test_full_subtractor();

    end

    task run_test;
        input a_i;
        input b_i;
        input borrow_in_i;
        input expected_difference;
        input expected_borrow_out;
        begin
            tb_a_i = a_i;
            tb_b_i = b_i;
            tb_borrow_in_i = borrow_in_i;
            #10; // wait 10 time units

            if (tb_diff_o !== expected_difference || tb_borrow_out_o !== expected_borrow_out)
                $display("FAILED: A=%b B=%b → got diff=%b, borrow=%b expected diff=%b, borrow=%b",
                         a_i, b_i, tb_diff_o, tb_borrow_out_o, expected_difference, expected_borrow_out);
            else
                $display("PASSED: A=%d B=%d → result diff=%b, borrow=%b",
                         a_i, b_i, tb_diff_o, tb_borrow_out_o);
        end
    endtask

    /* go through truth table of full subtractor */
    task test_full_subtractor;
        begin
            run_test(0,0,0,0,0);
            run_test(0,0,1,1,1);
            run_test(0,1,0,1,1);
            run_test(0,1,1,0,1);
            run_test(1,0,0,1,0);
            run_test(1,0,1,0,0);
            run_test(1,1,0,0,0);
            run_test(1,1,1,1,1);
        end
    endtask

endmodule
