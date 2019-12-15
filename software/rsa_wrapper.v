`timescale 1ns / 1ps

// TX_SIZE is defined in params.vh
// It is set to 1024 for 1024-bit wide data transfers between Arm and FPGA
// If desired, the data width can be set to 512-bit. 
// It saves a bit: 300 LUTs, and 1000 registers, ...
// For changing the transfer width, first you have to modify params.vh.
// Then, you have to execute the following command: source ./tcl/configure.tcl
// Finally, adapt the C code for that data length.
// If you are not sure how to do it, please call a TA.
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
    input  [TX_SIZE-1:0] arm_to_fpga_data,
    
    output               fpga_to_arm_data_valid,
    input                fpga_to_arm_data_ready,
    output [TX_SIZE-1:0] fpga_to_arm_data,
    
    output [3:0]         leds

    );

    ////////////// - State Machine 

    /// - State Machine Parameters

    localparam STATE_BITS           = 3;    
    localparam STATE_WAIT_FOR_CMD   = 3'h0;  
    localparam STATE_READ_DATA      = 3'h1;
    localparam STATE_COMPUTE        = 3'h2;
    localparam STATE_WRITE_DATA     = 3'h3;
    localparam STATE_ASSERT_DONE    = 3'h4;
    

    reg [STATE_BITS-1:0] r_state;
    reg [STATE_BITS-1:0] next_state;
    
    localparam CMD_READ             = 32'h0;
    localparam CMD_COMPUTE          = 32'h1;    
    localparam CMD_WRITE            = 32'h2;

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
                                CMD_READ:
                                    next_state <= STATE_READ_DATA;
                                CMD_COMPUTE:                            
                                    next_state <= STATE_COMPUTE;
                                CMD_WRITE: 
                                    next_state <= STATE_WRITE_DATA;
                                default:
                                    next_state <= r_state;
                            endcase
                        end else
                            next_state <= r_state;
                    end

                STATE_READ_DATA:
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
                STATE_READ_DATA: begin
                    if (arm_to_fpga_data_valid) core_data <= arm_to_fpga_data;
                    else                        core_data <= core_data; 
                end
                
                STATE_COMPUTE: begin
                    // Bitwise-XOR the most signficant 32-bits with 0xDEADBEEF
                    core_data <= {core_data[TX_SIZE-1:TX_SIZE-32]^32'hDEADBEEF, core_data[TX_SIZE-33:0]};
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
        r_arm_to_fpga_data_ready = (r_state==STATE_READ_DATA);
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