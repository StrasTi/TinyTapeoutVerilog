`timescale 1ns/1ns

module multiplexer;

    localparam AND_OUTPUT = 2'd0;
    localparam OR_OUTPUT = 2'd1;
    localparam XOR_OUTPUT = 2'd2;
    localparam ADDER_OUTPUT = 2'd3;
    
    // input signals
    reg and_output_i, or_output_i, xor_output_i, adder_output_i;
    // control signal
    reg [1:0] f_i;
    // output
    wire multiplexer_o;

    multiplexer dut_multiplexer(
        .and_r_i(and_output_i),
        .or_r_i(or_output_i),
        .xor_r_i(xor_output_i),
        .adder_r_i(adder_output_i),
        .f_i(f_i),
        .result_o(multiplexer_o)
    );

    initial begin 
        $dumpfile("tb/logic_gates_tb.vcd");
        $dumpvars(0, logic_gates_tb);
        #1;

        and_output_i = 1'b1; or_output_i = 1'b0; xor_output_i = 1'b0; adder_output_i = 1'b0;
    end
endmodule
