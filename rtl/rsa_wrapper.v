`timescale 1ns / 1ps

// TX_SIZE is defined in params.vh
// It is set to 1024 for 1024-bit wide data transfers between Arm and FPGA

`include "params.vh"

module rsa_wrapper 
(
    // The clock and active low reset
    input                clk,
    input                resetn,
    
    input  [31:0]        arm_to_fpga_cmd,
    input                arm_to_fpga_cmd_valid,
    output               fpga_to_arm_done,
    input                fpga_to_arm_done_read,

    input                arm_to_fpga_data_valid,
    output               arm_to_fpga_data_ready,
    input  [TX_SIZE-1:0] arm_to_fpga_data_A, 
    input  [TX_SIZE-1:0] arm_to_fpga_data_x,
    input  [TX_SIZE-1:0] arm_to_fpga_data_Rsqmodm,
    input  [TX_SIZE-1:0] arm_to_fpga_data_e,
    
    output               fpga_to_arm_data_valid,
    input                fpga_to_arm_data_ready,
    output [TX_SIZE-1:0] fpga_to_arm_data_A,
    output [TX_SIZE-1:0] fpga_to_arm_data_x,
    output [TX_SIZE-1:0] fpga_to_arm_data_Rsqmodm,
    output [TX_SIZE-1:0] fpga_to_arm_data_e,
    
    output [3:0]         leds

    );

    ////////////// - State Machine 

    /// - State Machine Parameters
    

    exp exponentiation(.clk    (clk    ),
                           .resetn (resetn ),
                           .start  (start  ),
                           .done   (done   ),
                           .result (result ),
                           .in_A   (fpga_to_arm_data_A   ),
                           .in_x   (fpga_to_arm_data_x   ),
                           .in_Rsqmodm  (fpga_to_arm_data_Rsamodm   ),
                           .in_e   (fpga_to_arm_data_e   ));

    localparam STATE_BITS               = 4;    
    localparam STATE_WAIT_FOR_CMD       = 4'h0;  
    localparam STATE_READ_DATA_A        = 4'h1;
    localparam STATE_READ_DATA_x        = 4'h2;
    localparam STATE_READ_DATA_Rsqmodm = 4'h3;
    localparam STATE_READ_DATA_e        = 4'h4;
    localparam STATE_COMPUTE            = 4'h5;
    localparam STATE_WRITE_DATA         = 4'h6;
    localparam STATE_ASSERT_DONE        = 4'h7;
    

    reg [STATE_BITS-1:0] r_state;
    reg [STATE_BITS-1:0] next_state;
    
    localparam CMD_READ_EXP_A             = 32'h0;
    localparam CMD_READ_EXP_x             = 32'h1;
    localparam CMD_READ_EXP_Rsqmodm       = 32'h2;
    localparam CMD_READ_EXP_e             = 32'h3;
    localparam CMD_COMPUTE_EXP            = 32'h4;    
    localparam CMD_WRITE_EXP              = 32'h5;

    /// - State Transition

    always @(*)
    begin
        if (resetn==1'b0)
            next_state <= STATE_WAIT_FOR_CMD;
        else
        begin
            case (r_state)
                STATE_WAIT_FOR_CMD:
                    begin
                        if (arm_to_fpga_cmd_valid) begin
                            case (arm_to_fpga_cmd)
                                CMD_READ_EXP_A:
                                    next_state <= STATE_READ_DATA_A;
                                CMD_READ_EXP_x:
                                    next_state <= STATE_READ_DATA_x;
                                CMD_READ_EXP_Rsqmodm:
                                    next_state <= STATE_READ_DATA_Rsqmodm;
                                CMD_READ_EXP_e:
                                    next_state <= STATE_READ_DATA_e;                                                                   
                                CMD_COMPUTE_EXP:                            
                                    next_state <= STATE_COMPUTE;
                                CMD_WRITE_EXP: 
                                    next_state <= STATE_WRITE_DATA;
                                default:
                                    next_state <= r_state;
                            endcase
                        end else
                            next_state <= r_state;
                    end

                STATE_READ_DATA_A:
                    next_state <= (arm_to_fpga_data_valid) ? STATE_ASSERT_DONE : r_state;
                    
                STATE_READ_DATA_x:
                    next_state <= (arm_to_fpga_data_valid) ? STATE_ASSERT_DONE : r_state;
                    
                STATE_READ_DATA_Rsqmodm:
                    next_state <= (arm_to_fpga_data_valid) ? STATE_ASSERT_DONE : r_state;
                    
                STATE_READ_DATA_e:
                    next_state <= (arm_to_fpga_data_valid) ? STATE_ASSERT_DONE : r_state;
                                
                STATE_COMPUTE: 
                    next_state <= STATE_ASSERT_DONE;

                STATE_WRITE_DATA:
                    next_state <= (fpga_to_arm_data_ready) ? STATE_ASSERT_DONE : r_state;

                STATE_ASSERT_DONE:
                    next_state <= (fpga_to_arm_done_read) ? STATE_WAIT_FOR_CMD : r_state;

                default:
                    next_state <= STATE_WAIT_FOR_CMD;

            endcase
        end
    end

    /// - Synchronous State Update

    always @(posedge(clk))
        if (resetn==1'b0)
            r_state <= STATE_WAIT_FOR_CMD;
        else
            r_state <= next_state;   

    ////////////// - Computation

    reg [TX_SIZE-1:0] core_data;
    
    always @(posedge(clk)) begin
        if (resetn==1'b0) begin
            core_data <= 'b0;
        end
        else begin
            case (r_state)
                STATE_READ_DATA_A: begin
                    if (arm_to_fpga_data_valid) core_data <= arm_to_fpga_data_A;
                    else                        core_data <= core_data; 
                end
                STATE_READ_DATA_x: begin
                    if (arm_to_fpga_data_valid) core_data <= arm_to_fpga_data_x;
                    else                        core_data <= core_data; 
                end
                STATE_READ_DATA_Rsqmodm: begin
                    if (arm_to_fpga_data_valid) core_data <= arm_to_fpga_data_Rsqmodm;
                    else                        core_data <= core_data; 
                end
                STATE_READ_DATA_e: begin
                    if (arm_to_fpga_data_valid) core_data <= arm_to_fpga_data_e;
                    else                        core_data <= core_data; 
                end
                STATE_COMPUTE: begin
                    // Bitwise-XOR the most signficant 32-bits with 0xDEADBEEF
                    //TODO
                end
                
                default: begin
                    core_data <= core_data;
                end
                
            endcase
        end
    end
    
    assign fpga_to_arm_data       = core_data;

    ////////////// - Valid signals for notifying that the computation is done

    /// - Port handshake

    reg r_fpga_to_arm_data_valid;
    reg r_arm_to_fpga_data_ready;

    always @(posedge(clk)) begin
        r_fpga_to_arm_data_valid = (r_state==STATE_WRITE_DATA);
        r_arm_to_fpga_data_ready = (r_state==STATE_READ_DATA_A || r_state==STATE_READ_DATA_x || r_state==STATE_READ_DATA_Rsqmodm || r_state==STATE_READ_DATA_e);
    end
    
    assign fpga_to_arm_data_valid = r_fpga_to_arm_data_valid;
    assign arm_to_fpga_data_ready = r_arm_to_fpga_data_ready;
    
    /// - Done signal
    
    reg r_fpga_to_arm_done;

    always @(posedge(clk))
    begin        
        r_fpga_to_arm_done <= (r_state==STATE_ASSERT_DONE);
    end

    assign fpga_to_arm_done = r_fpga_to_arm_done;
    
    ////////////// - Debugging signals
    
    // The four LEDs on the board can be used as debug signals.
    // Here they are used to check the state transition.

    assign leds             = {1'b0,r_state};

endmodule
