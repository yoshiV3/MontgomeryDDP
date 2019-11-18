`timescale 1ns / 1ps

module warmup2_mpadder(
    input  wire         clk,
    input  wire         rst,
    input  wire         start,
    input  wire [127:0] A,
    input  wire [127:0] B,
    output wire [128:0] C,
    output wire         done);

    // Task 1
    // Describe a 128-bit register for A
    // It will save the input data when enable signal is high
    // (Implemented below already for you, be sure you understand it)

    reg          regA_en;
    wire [127:0] regA_D;
    reg  [127:0] regA_Q;
    always @(posedge clk)
    begin
        if(rst)             regA_Q <= 128'd0;
        else if (regA_en)   regA_Q <= regA_D;
    end

    // Task 2
    // Describe a 128-bit register for B

                

    // Task 3
    // Describe a 2-input 128-bit Multiplexer for A
    // It should select either of these two:
    //   - the input A
    //   - the output of regA shifted-right by 64
    // Also connect the output of Mux to regA's input
    // (Implemented below already for you, be sure you understand it)

    reg          muxA_sel;
    wire [127:0] muxA_Out;
    assign muxA_Out = (muxA_sel == 0) ? A : {64'b0,regA_Q[127:64]};

    assign regA_D = muxA_Out;

    // Task 4
    // Describe a 2-input 64-bit Multiplexer for B
    // !! Use "always" statement for this combinatorial logic 

               

    // Task 5
    // Describe an adder
    // It should be a combinatorial logic:
    // Its inputs are two 64-bit operands and 1-bit carry-in
    // Its outputs are one 64-bit result  and 1-bit carry-out

    wire [63:0] operandA;
    wire [63:0] operandB;
    wire        carry_in;
    wire [63:0] result;
    wire        carry_out;



    // Task 6
    // Describe a 128-bit register for storing the result
    // The register should store adder's outputs at the msb 64-bits
    // and the shift the previous 64 msb bits to lsb.

              

    // Task 7
    // Describe a 1-bit register for storing the carry-out

               

    // Task 8
    // Describe a 1-bit multiplexer for selecting carry-in
    // It should select either of these two:
    //   - 0
    //   - carry-out

                

    // Task 9
    // Connect the inputs of adder to the outputs of A and B registers
    // and to the carry mux
               


    // Task 10
    // Describe output, concatenate the registers of carry_out and result
                


    // Task 11
    // Describe state machine registers
    // (Implemented below already for you, be careful with their width.
    // Think about how many bits you will need.)

    reg [1:0] state, nextstate;

    always @(posedge clk)
    begin
        if(rst)		state <= 2'd0;
        else        state <= nextstate;
    end

    // Task 12
    // Define your states
    // Describe your signals at each state
    always @(*)
    begin
        case(state)

            // Idle state; Here the FSM waits for the start signal
            // Enable input registers to fetch the inputs A and B when start is received
            2'd0: begin
                regA_en        <= 1'b1;
                regB_en        <= 1'b1;
                regResult_en   <= 1'b0;
                regCout_en     <= 1'b0;
                muxA_sel       <= 1'b0;
                muxB_sel       <= 1'b0;
                muxCarryIn_sel <= 1'b0;
            end

            // Add low:
            // Disable input registers
            // Calculate the first addition
            2'd1: begin



            end

            // Add-High state:
            // Calculate the second addition
            2'd2: begin



            end

        endcase
    end

    // Task 13
    // Describe next_state logic

    always @(*)
    begin
        case(state)
            2'd0: begin
                if(start)
                    nextstate <= 2'd1;
                else
                    nextstate <= 2'd0;
                end

               

        endcase
    end

    // Task 14
    // Describe done signal
    // It should be high at the same clock cycle when the output ready

               

endmodule
