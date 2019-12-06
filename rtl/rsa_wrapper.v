`timescale 1ns / 1ps

// TX_SIZE is defined in params.vh
// It is set to 1024 for 1024-bit wide data transfers between Arm and FPGA

module rsa_wrapper #(
    parameter TX_SIZE = 1024
)(
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
    
    reg start_exp;
    reg done_exp;
    reg result_exp;
    exp exponentiation(.clk    (clk    ),
                           .resetn      (resetn ),
                           .start       (start_exp  ),
                           .done        (done_exp   ),
                           .result      (result_exp ),
                           .in_A        (fpga_to_arm_data ),
                           .in_x        (fpga_to_arm_data ),
                           .in_Rsqmodm  (fpga_to_arm_data ),
                           .in_e        (fpga_to_arm_data ));
    
    reg start_mont;
    reg result_mont;
    reg done_mont;
    montgomery montgomery_instance( .clk    (clk    ),
                                                               .resetn (resetn ),
                                                               .start  (start_mont  ),
                                                               .in_a   (fpga_to_arm_data   ),
                                                               .in_b   (fpga_to_arm_data   ),
                                                               .in_m   (fpga_to_arm_data   ),
                                                               .result (result_mont ),
                                                               .done   (done_mont   ));


    localparam STATE_BITS               = 4;
    localparam STATE_WAIT_FOR_CMD       = 4'h0;
    localparam STATE_READ_DATA          = 4'h1;
    localparam STATE_COMPUTE_EXP        = 4'h2; 
    localparam STATE_COMPUTE_MONT       = 4'h3;  
    localparam STATE_WRITE_DATA         = 4'h4;
    localparam STATE_ASSERT_DONE        = 4'h5;
    

    reg [STATE_BITS-1:0] r_state;
    reg [STATE_BITS-1:0] next_state;
    
    localparam CMD_READ_EXP               = 32'h0;
    localparam CMD_COMPUTE_EXP            = 32'h1;
    localparam CMD_COMPUTE_MONT           = 32'h3;
    localparam CMD_WRITE_EXP              = 32'h4;

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
                                CMD_READ_EXP:
                                    next_state <= STATE_READ_DATA;                                                                   
                                CMD_COMPUTE_EXP:                            
                                    next_state <= STATE_COMPUTE_EXP;
                                CMD_COMPUTE_MONT:                            
                                    next_state <= STATE_COMPUTE_MONT;
                                CMD_WRITE_EXP: 
                                    next_state <= STATE_WRITE_DATA;
                                default:
                                    next_state <= r_state;
                            endcase
                        end else
                            next_state <= r_state;
                    end

                STATE_READ_DATA:
                    next_state <= (arm_to_fpga_data_valid) ? STATE_ASSERT_DONE : r_state;
                           
                STATE_COMPUTE_EXP: 
                    next_state <= STATE_ASSERT_DONE;
                    
                STATE_COMPUTE_MONT: 
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
                STATE_COMPUTE_EXP: begin
                    start_exp <= 1'b1;
                    wait (done_exp==1);
                    core_data <=result_exp;
                end 
                STATE_COMPUTE_MONT: begin
                    start_mont <= 1'b1;
                    wait (done_mont==1);
                    core_data <=result_mont;                                   
                end
                default: begin
                    core_data <= core_data;
                end
                
            endcase
        end
    end
    
    assign fpga_to_arm_data    = core_data;

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
