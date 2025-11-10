
module top_level_alu_control(
    input  wire [7:0] alu_in,    // ALU data input
    input  wire [7:0] ctrl_in,   // ALU operation control
    output wire [7:0] alu_out,   // ALU controlled output (result or status)
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    // register for input and result
    reg [`DATA_WIDTH-1:0] a_i;
    reg [`DATA_WIDTH-1:0] b_i;
    reg [`DATA_WIDTH-1:0] alu_result_reg;
    reg carry_borrow_out_reg;
    reg [1:0] status_flag_reg;
    reg [`DATA_WIDTH-1:0] TEMP_alu_default_reg;
    
    reg [1:0] state, next_state, prev_state;
    localparam READ_A = 2'b00;
    localparam READ_B = 2'b01;
    localparam CALC = 2'b10;
    localparam STATUS = 2'b11;

    // alu output wires
    wire [`DATA_WIDTH-1:0] alu_result;
    wire alu_borrow_out;
    wire [1:0] alu_status_flag;

    eight_bit_alu eight_bit_alu_inst(
        .a8_i(a_i),
        .b8_i(b_i),
        .f8_i(ctrl_in[7:3]),
        .carry_borrow_i(ctrl_in[2]),
        .y8_o(alu_result),
        .carry_borrow_o(alu_borrow_out),
        .status_flag_o(alu_status_flag)
    );

    always @(posedge clk) begin
        if (rst_n) begin
            next_state <= READ_A;
            a_i <= 8'd0;
            b_i <= 8'd0;
            alu_result_reg <= 8'd0;
            carry_borrow_out_reg <= 1'b0;
            status_flag_reg <= 2'b0;
        end else begin
            // set state
            prev_state <= state;
            state <= next_state;

            // clear reg when state changes
            if (state !== prev_state) begin
                TEMP_alu_default_reg <= 8'd0;
            end

            case(state)
            READ_A : begin
                a_i <= alu_in;
            end
            READ_B : begin
                b_i <= alu_in;
            end
            CALC : begin
                TEMP_alu_default_reg <= alu_result;
            end
            STATUS : begin
                TEMP_alu_default_reg[1:0] <= alu_status_flag;
                TEMP_alu_default_reg[2] <= alu_borrow_out;
            end
            endcase
        end
    end

    always @(*) begin
        next_state <= state;
        case(ctrl_in[1:0])
        READ_A : begin
            next_state <= READ_A;
        end
        READ_B : begin
            next_state <= READ_B;
        end
        CALC : begin
            next_state <= CALC;
        end
        STATUS : begin
            next_state <= STATUS;
        end
        endcase
    end

    assign alu_out = TEMP_alu_default_reg;

endmodule