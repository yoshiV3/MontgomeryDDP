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
    
    reg start_exp1;
    wire done_exp1;
    reg resetn_exp1;
    wire[511:0]result_exp1;
	
	 reg  mod1_enable;
     reg  [511:0] in_modulus1;
     always @(posedge clk)
     begin
         if(~resetn)         in_modulus1 <= 512'd0;
         else if (mod1_enable)   in_modulus1 <= arm_to_fpga_data[511:0];
     end
	
     
	 
	 reg  Rmodm1_enable;
     reg  [511:0] in_Rmodm1;
     always @(posedge clk)
     begin
         if(~resetn)         in_Rmodm1 <= 512'd0;
         else if (Rmodm1_enable)   in_Rmodm1 <= arm_to_fpga_data[1023:512];
     end
	
    
	 reg  Rsqmodm1_enable;
     reg  [511:0] in_Rsqmodm1;
     always @(posedge clk)
     begin
         if(~resetn)         in_Rsqmodm1 <= 512'd0;
         else if (Rsqmodm1_enable)   in_Rsqmodm1 <= arm_to_fpga_data[511:0];
     end
	
	
	 reg  in_exp1_enable;
     reg  [511:0] in_exp1;
     always @(posedge clk)
     begin
         if(~resetn)         in_exp1 <= 512'd0;
         else if (in_exp1_enable)   in_exp1 <= arm_to_fpga_data[511:0];
     end
	 
	
	 reg  in_x1_enable;
     reg  [511:0] in_x1;
     always @(posedge clk)
     begin
         if(~resetn)         in_x1 <= 512'd0;
         else if (in_x1_enable)   in_x1 <= arm_to_fpga_data[1023:512];
     end
	
    reg in_mul_en1;
    exponentiation exponentiation1(     .clk        (clk    ),
                           .resetn      (resetn_exp1 ),
                           .startExponentiation       (start_exp1  ),
                           .modulus     (in_modulus1),
                           .Rmodm       (in_Rmodm1),
                           .Rsquaredmodm (in_Rsqmodm1),
                           .exponent    (in_exp1),
                           .x           (in_x1),
                           .multiplication_enable (in_mul_en1),
                           .done        (done_exp1   ),
                           .A_result    (result_exp1));

       
       //assign outExp_en = done_exp1 && outputExp_en;
                                   
    localparam STATE_BITS                   = 4;
    localparam STATE_WAIT_FOR_CMD           = 4'h0;
    localparam STATE_COMPUTE_EXP            = 4'h1; 
    localparam STATE_COMPUTE_MONT           = 4'h2;  
    localparam STATE_WRITE_DATA             = 4'h3;
    localparam STATE_ASSERT_DONE            = 4'h4;
    localparam STATE_READ_DATA_MOD          = 4'h5;
    localparam STATE_READ_DATA_RSQ          = 4'h6;
    localparam STATE_READ_DATA_EXP          = 4'h7;
    localparam STATE_RESET                  = 4'h8;
    localparam STATE_INIT_MONT		    = 4'h9;
    localparam STATE_INIT_EXP		    = 4'ha;

    reg [STATE_BITS-1:0] r_state;
    reg [STATE_BITS-1:0] next_state;
    
    localparam CMD_COMPUTE_EXP            = 3'h0;
    localparam CMD_COMPUTE_MONT           = 3'h1;
    localparam CMD_READ_MOD           	  = 3'h2;
    localparam CMD_READ_RSQ           	  = 3'h3;
    localparam CMD_READ_EXP               = 3'h4;
    localparam CMD_WRITE_EXP              = 3'h5;
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
                            case (arm_to_fpga_cmd[2:0])
                                 
                                CMD_READ_MOD:
                                    next_state <= STATE_READ_DATA_MOD;
                                CMD_READ_RSQ:
                                    next_state <= STATE_READ_DATA_RSQ;
                                CMD_READ_EXP:
                                    next_state <= STATE_READ_DATA_EXP;   
                                CMD_COMPUTE_EXP:                            
                                    next_state <= STATE_INIT_EXP;
                                CMD_COMPUTE_MONT:                            
                                    next_state <= STATE_INIT_MONT;
                                CMD_WRITE_EXP: 
                                    next_state <= STATE_WRITE_DATA;
                                default:
                                    next_state <= r_state;
                            endcase
                        end else
                            next_state <= r_state;
                    end

                
                STATE_READ_DATA_MOD:
                    next_state <= (arm_to_fpga_data_valid) ? STATE_ASSERT_DONE : r_state;  
                
                STATE_READ_DATA_RSQ:
                    next_state <= (arm_to_fpga_data_valid) ? STATE_ASSERT_DONE : r_state;
                STATE_READ_DATA_EXP:
                    next_state <= (arm_to_fpga_data_valid) ? STATE_ASSERT_DONE : r_state;
                STATE_COMPUTE_EXP:
                    next_state <= (done_exp1) ? STATE_ASSERT_DONE : r_state;
				STATE_INIT_MONT:
					next_state <= STATE_COMPUTE_MONT;
				STATE_INIT_EXP:
					next_state <= STATE_COMPUTE_EXP;
                STATE_COMPUTE_MONT:
                    next_state <= (done_exp1) ? STATE_ASSERT_DONE : r_state;
                STATE_WRITE_DATA:
                    next_state <= (fpga_to_arm_data_ready) ? STATE_RESET : r_state;
                STATE_ASSERT_DONE:
                    next_state <= (fpga_to_arm_done_read) ? STATE_WAIT_FOR_CMD : r_state;
                    
                STATE_RESET:
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

	
	
//	 reg  core_data_enable;
//     reg  [TX_SIZE-1:0] core_data;
//     always @(posedge clk)
//     begin
//         if(~resetn)         core_data <= 1024'hdeadbeaf;
//         else if (done_exp1)  begin
//						core_data[511:0]    <=result_exp1;
//		 end
//     end
     
	  //THIS IS THE START OF THE CODE THAT BREAKS SOME OF THE CODE DOWN FOR DEBUGGING by replacing done_exp1
      //with a counter that adds certain  segments of the code
     reg [8:0] debugCounter;
     always @(posedge (clk))
     begin
     if (~resetn) begin
        debugCounter <= 9'b0;
     end
     else
     begin
        debugCounter = debugCounter + 1;
     end
     end     
     
     // 4c85c326 (24) 76ddf19e (23) 000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000 xxxxxxxx deadbeaf     // received: 62E9342 947C05C2 2ACFC468 8F701B22 70FBD3CA D568E520 6B6673F0 CAB71422 DD15E4F3 3F8DA4C3 BC0E6476  7E5A51A F04A9014 23D43CFA 7FAFD51F DB5821FE
     reg  core_data_enable;
     reg  [TX_SIZE-1:0] core_data;
     always @(posedge clk)
     begin
         if(~resetn)         core_data <= 1024'hdeadbeaf;
         else if (debugCounter == 9'd0)  
                        core_data[31:0]    <=result_exp1[31:0];
         else if (debugCounter == 9'd1)  
         core_data[63:32]    <=result_exp1[31:0];
         else if (debugCounter == 9'd2)  
         core_data[95:64]    <=result_exp1[31:0];
         else if (debugCounter == 9'd3)  
         core_data[127:96]    <=result_exp1[31:0];
         else if (debugCounter == 9'd4)  
         core_data[159:128]    <=result_exp1[31:0];
         else if (debugCounter == 9'd5)  
         core_data[191:160]    <=result_exp1[31:0];
         else if (debugCounter == 9'd6)  
         core_data[223:192]    <=result_exp1[31:0];
         else if (debugCounter == 9'd7)  
         core_data[255:224]    <=result_exp1[31:0];
         else if (debugCounter == 9'd8)  
               core_data[287:256]    <=result_exp1[31:0];
         else if (debugCounter == 9'd9)  
         core_data[319:288]    <=result_exp1[31:0];
         else if (debugCounter == 9'd10)  
         core_data[351:320]    <=result_exp1[31:0];
         else if (debugCounter == 9'd20)  
         core_data[383:352]    <=result_exp1[31:0];
         else if (debugCounter == 9'd21)  
         core_data[415:384]    <=result_exp1[31:0];
         else if (debugCounter == 9'd22)  
         core_data[447:416]    <=result_exp1[31:0];
         else if (debugCounter == 9'd23)  
         core_data[479:448]    <=result_exp1[31:0];
         else if (debugCounter == 9'd24)  
         core_data[511:480]    <=result_exp1[31:0];                                        
     end     
     // FOR THE VERSION THAT TAKES THE FIRST 16 VALUES AFTER EXP
     
     //4c85c32676ddf19e000000000000000000000000000000000000000000000000
     //          4647278e dbbe865c 6c9d07cd 1efede34 6353dad4 5283c93c 88962ecc a9570c8f 4c85c326 76ddf19e 00000000 00000000 00000000 00000000 00000000 00000000
     // received: 62E9342 947C05C2 2ACFC468 8F701B22 70FBD3CA D568E520 6B6673F0 CAB71422 DD15E4F3 3F8DA4C3 BC0E6476  7E5A51A F04A9014 23D43CFA 7FAFD51F DB5821FE
 
     
     
     
//a2d37c92491f811b4ff767b793b623e72c467bc3d800a1a6019e0e9b00000000
         
     // In C we get:    6B9DBED2 778B6CDE 3F71ABCB 9DE08C9A 81D99197 4DFD2508 C8EA8937 DB5821FE (correct order)
              
     
/*     reg  core_data_enable;
     reg  [TX_SIZE-1:0] core_data;
     always @(posedge clk)
     begin
         if(~resetn)         core_data <= 1024'hdeadbeaf;
//         else if (debugCounter == 9'd0)  
//                        core_data[31:0]    <=result_exp1[31:0];
         else if (debugCounter == 9'd31)  
         core_data[63:32]    <=result_exp1[31:0];
         else if (debugCounter == 9'd63)  
         core_data[95:64]    <=result_exp1[31:0];//d800a1a6
         else if (debugCounter == 9'd95)  
         core_data[127:96]    <=result_exp1[31:0];//2c467bc3
         else if (debugCounter == 9'd127)  
         core_data[159:128]    <=result_exp1[31:0];//93b623e7
         else if (debugCounter == 9'd159)  
         core_data[191:160]    <=result_exp1[31:0];//4ff767b7
         else if (debugCounter == 9'd191)  
         core_data[223:192]    <=result_exp1[31:0];//491f811b
         else if (debugCounter == 9'd224)  
         core_data[255:224]    <=result_exp1[31:0];//e5a5f4a7   actually, this takes 219    so a2d37c92                                         
     end*/
	

    always @(posedge(clk)) begin
        if (resetn==1'b0) begin
            resetn_exp1  <= 1'b0;
            start_exp1   <= 1'b0;
            
        end
        else begin
            case (r_state)
            
                STATE_READ_DATA_MOD: begin
					if (arm_to_fpga_data_valid) 	begin 
													mod1_enable 	<= 1'b1;
													in_exp1_enable	<= 1'b0;
													in_x1_enable 	<= 1'b0;
													Rmodm1_enable	<= 1'b0;
													Rsqmodm1_enable	<= 1'b0;
													core_data_enable<= 1'b0;
													end
                    
                end	
                
                
                STATE_READ_DATA_RSQ: begin
                    if (arm_to_fpga_data_valid)      begin
                                                    							
													mod1_enable 	<= 1'b0;
													in_exp1_enable	<= 1'b0;
													in_x1_enable 	<= 1'b1;
													Rmodm1_enable	<= 1'b0;
													Rsqmodm1_enable	<= 1'b1;
													core_data_enable<= 1'b0;
                                                     end
                    
                end
                
                STATE_READ_DATA_EXP: begin
                    if (arm_to_fpga_data_valid)     begin 
                                                    mod1_enable  	<= 1'b0;
													in_exp1_enable	<= 1'b1;
													in_x1_enable 	<= 1'b0;
													Rmodm1_enable	<= 1'b1;
													Rsqmodm1_enable	<= 1'b0;
													core_data_enable<= 1'b0;
                                                    end
                    
                end
              
				STATE_INIT_MONT: begin
					in_mul_en1 <= 1'b1;
				end
				
				STATE_INIT_EXP: begin
					in_mul_en1 <= 1'b0;
				end
				
                STATE_COMPUTE_EXP: begin
                    start_exp1 <= 1'b1;
                    core_data_enable<= 1'b1;
                    
                end 
                STATE_COMPUTE_MONT: begin
                    start_exp1 <= 1'b1;     
                    core_data_enable<= 1'b1;                           
                end
                STATE_ASSERT_DONE: begin
                    resetn_exp1 <= 1'b1;
					core_data_enable<= 1'b0;
                end
                
                STATE_RESET: begin
                    start_exp1 <= 1'b0;
                    resetn_exp1 <= 1'b0;
					core_data_enable<= 1'b0;
                 end
                default: begin
					core_data_enable<= 1'b0;
					mod1_enable 	<= 1'b0;
			        in_exp1_enable	<= 1'b0;
					in_x1_enable 	<= 1'b0;
					Rmodm1_enable	<= 1'b0;
					Rsqmodm1_enable	<= 1'b0;
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
        r_fpga_to_arm_data_valid <= (r_state==STATE_WRITE_DATA);
        r_arm_to_fpga_data_ready <= (r_state==STATE_READ_DATA_MOD || r_state==STATE_READ_DATA_EXP || r_state==STATE_READ_DATA_RSQ);
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

    assign leds             = {4'd4};

endmodule
