`timescale 1ns / 1ps

// TX_SIZE is defined in params.vh
// It is set to 1024 for 1024-bit wide data transfers between Arm and FPGA

module rsa_wrapper #(parameter TX_SIZE = 1024)(
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
    wire done_exp;
    reg resetn_exp;
    wire [511:0]result_exp;
    reg [511:0]in_modulus;
    reg [511:0]in_Rmodm;
    reg [511:0]in_Rsqmodm;
    reg [511:0]in_exp;
    reg [511:0]in_x;
    
    /*exponentiation exponentiation(     .clk        (clk    ),
                           .resetn      (resetn_exp ),
                           .startExponentiation       (start_exp  ),
                           .modulus     (in_modulus),
                           .Rmodm       (in_Rmodm),
                           .Rsquaredmodm (in_Rsqmodm),
                           .exponent    (in_exp),
                           .x           (in_x),
                           .done        (done_exp   ),
                           .A_result    (result_exp));*/
    reg start_mont;
    reg resetn_mont;
    wire [511:0]result_mont;
    wire done_mont;
    reg [511:0]in_a;
    reg [511:0]in_b;
    reg [511:0]in_m;
    montgomery montgomery_instance(     .clk    (clk      ),
                                        .resetn (resetn_mont  ),
                                        .start  (start_mont    ),
                                        .in_a   (in_a     ),
                                        .in_b   (in_b ),
                                        .in_m   (in_m     ),
                                        .result (result_mont   ),
                                        .done   (done_mont     ));
                                   
    localparam STATE_BITS               = 4;
    localparam STATE_WAIT_FOR_CMD       = 4'h0;
    localparam STATE_READ_DATA_A_AND_B  = 4'h1;
    localparam STATE_READ_DATA_M        = 4'h2;
    localparam STATE_READ_DATA_EXP      = 4'h3;
    localparam STATE_COMPUTE_EXP        = 4'h4; 
    localparam STATE_COMPUTE_MONT       = 4'h5;  
    localparam STATE_WRITE_DATA         = 4'h6;
    localparam STATE_ASSERT_DONE        = 4'h7;
    localparam STATE_READ_DATA_MOD_RMOD  = 4'h8;
    localparam STATE_READ_DATA_EXP_RSQ_EXP = 4'h9;
    localparam STATE_READ_DATA_X         =4'ha;
    localparam STATE_RESET_MONT          =4'hb;

    reg [STATE_BITS-1:0] r_state;
    reg [STATE_BITS-1:0] next_state;
    
    localparam CMD_READ_EXP               = 32'h0;
    localparam CMD_READ_A_B_MONT          = 32'h1;
    localparam CMD_READ_M_MONT            = 32'h2;
    localparam CMD_COMPUTE_EXP            = 32'h3;
    localparam CMD_COMPUTE_MONT           = 32'h4;
    localparam CMD_READ_EXP_MOD_RMOD      = 32'h5;
    localparam CMD_READ_EXP_RSQ_EXP       = 32'h6;
    localparam CMD_READ_EXP_X             = 32'h7;
    localparam CMD_WRITE_EXP              = 32'h8;
    localparam CMD_RESET_MONT             = 32'h9;
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
                                CMD_READ_A_B_MONT:
                                    next_state <= STATE_READ_DATA_A_AND_B;                               
                                CMD_READ_M_MONT:
                                    next_state <= STATE_READ_DATA_M;   
                                CMD_READ_EXP_MOD_RMOD:
                                    next_state <= STATE_READ_DATA_MOD_RMOD;
                                CMD_READ_EXP_RSQ_EXP:
                                    next_state <= STATE_READ_DATA_EXP_RSQ_EXP;
                                CMD_READ_EXP_X:
                                    next_state <= STATE_READ_DATA_X;                                                                     
                                CMD_COMPUTE_EXP:                            
                                    next_state <= STATE_COMPUTE_EXP;
                                CMD_COMPUTE_MONT:                            
                                    next_state <= STATE_COMPUTE_MONT;
                                CMD_WRITE_EXP: 
                                    next_state <= STATE_WRITE_DATA;
                                CMD_RESET_MONT:
                                    next_state <= STATE_RESET_MONT;
                                default:
                                    next_state <= r_state;
                            endcase
                        end else
                            next_state <= r_state;
                    end

                STATE_READ_DATA_A_AND_B:
                    next_state <= (arm_to_fpga_data_valid) ? STATE_ASSERT_DONE : r_state;
                STATE_READ_DATA_M:
                    next_state <= (arm_to_fpga_data_valid) ? STATE_ASSERT_DONE : r_state;
                STATE_READ_DATA_MOD_RMOD:
                    next_state <= (arm_to_fpga_data_valid) ? STATE_ASSERT_DONE : r_state;  
                STATE_READ_DATA_EXP_RSQ_EXP:
                    next_state <= (arm_to_fpga_data_valid) ? STATE_ASSERT_DONE : r_state;     
                STATE_READ_DATA_X:
                    next_state <= (arm_to_fpga_data_valid) ? STATE_ASSERT_DONE : r_state;    
                STATE_COMPUTE_EXP: 
                    next_state <= (done_exp) ? STATE_ASSERT_DONE : r_state;
                    
                STATE_COMPUTE_MONT:
                    next_state <= (done_mont) ? STATE_ASSERT_DONE : r_state;
                    
                STATE_WRITE_DATA:
                    next_state <= (fpga_to_arm_data_ready) ? STATE_RESET_MONT : r_state;
                    
                STATE_ASSERT_DONE:
                    next_state <= (fpga_to_arm_done_read) ? STATE_WAIT_FOR_CMD : r_state;
                    
                STATE_RESET_MONT:
                    next_state <= STATE_ASSERT_DONE;
                default:
                    next_state <= STATE_WAIT_FOR_CMD;

            endcase
        end
    end

    /// - Synchronous State Update

    always @(posedge(clk))
        begin
            if (resetn==1'b0)
                r_state <= STATE_WAIT_FOR_CMD;
            else
                r_state <= next_state;   
        end
    ////////////// - Computation

    reg [TX_SIZE-1:0] core_data;
    always @(posedge(clk)) begin
        if (resetn==1'b0) begin
            core_data <= 1024'b0;
            resetn_mont <= 1'b0;
            resetn_exp  <= 1'b0;
        end
        else begin
            case (r_state)
            
                STATE_READ_DATA_A_AND_B: begin
                    if (arm_to_fpga_data_valid)begin 
                                                in_a <= arm_to_fpga_data[1023:512]; 
                                                in_b <= arm_to_fpga_data[511:0];
                                                end
                    else
                        core_data <= core_data;
                     
                end
                STATE_READ_DATA_M: begin
                    if (arm_to_fpga_data_valid) in_m <= arm_to_fpga_data[511:0];
                    else
                        core_data <= core_data;                     
                end
                
                STATE_READ_DATA_MOD_RMOD: begin
                    if (arm_to_fpga_data_valid)begin in_Rmodm <= arm_to_fpga_data[511:0];
                                                in_modulus <= arm_to_fpga_data[1023:512]; end
                    else
                        core_data <= core_data;
                end
                
                STATE_READ_DATA_EXP_RSQ_EXP: begin
                    if (arm_to_fpga_data_valid)begin in_exp <= arm_to_fpga_data[511:0];
                                                in_Rsqmodm <= arm_to_fpga_data[1023:512]; end
                    else
                        core_data <= core_data;
                end
                
                STATE_READ_DATA_X: begin
                    if (arm_to_fpga_data_valid)begin in_x <= arm_to_fpga_data[511:0];
                                                 end
                    else
                        core_data <= core_data;
                end
                
                STATE_COMPUTE_EXP: begin
                    start_exp <= 1'b1;
                    core_data <=result_exp;
                    
                end 
                STATE_COMPUTE_MONT: begin
                    start_mont <= 1'b1;
                    core_data <=result_mont;                             
                end
                STATE_ASSERT_DONE: begin
                    resetn_exp <= 1'b1;
                    resetn_mont <= 1'b1;
                end
                STATE_RESET_MONT: begin
                    resetn_mont <= 1'b0;
                    resetn_exp  <= 1'b0;
                    end
                default: begin
                    core_data <= core_data;
                end
                
            endcase
        end
    end
    
    assign fpga_to_arm_data = core_data;

    ////////////// - Valid signals for notifying that the computation is done

    /// - Port handshake

    reg r_fpga_to_arm_data_valid;
    reg r_arm_to_fpga_data_ready;

    always @(posedge(clk)) begin
        r_fpga_to_arm_data_valid = (r_state==STATE_WRITE_DATA);
        r_arm_to_fpga_data_ready = (r_state==STATE_READ_DATA_A_AND_B || r_state==STATE_READ_DATA_M || r_state==STATE_READ_DATA_MOD_RMOD || r_state==STATE_READ_DATA_EXP_RSQ_EXP || r_state==STATE_READ_DATA_X);
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
