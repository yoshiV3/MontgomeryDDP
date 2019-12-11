`timescale 1ns / 1ps


`define NUM_OF_CORES 2


`define RESET_TIME 25
`define CLK_PERIOD 10
`define CLK_HALF 5

module tb_rsa_wrapper();
    
    reg           clk;
    reg           resetn;
    reg  [  31:0] arm_to_fpga_cmd;
    reg           arm_to_fpga_cmd_valid;
    wire          fpga_to_arm_done;
    reg           fpga_to_arm_done_read;

    reg           arm_to_fpga_data_valid;
    wire          arm_to_fpga_data_ready;
    reg  [1023:0] arm_to_fpga_data;

    wire          fpga_to_arm_data_valid;
    reg           fpga_to_arm_data_ready;
    wire [1023:0] fpga_to_arm_data;

    wire [   3:0] leds;

    reg  [1023:0] input_data_a_and_b;
    reg  [1023:0] input_data_m;
    reg  [1023:0] output_data;
        
    rsa_wrapper rsa_wrapper(
        .clk                    (clk                    ),
        .resetn                 (resetn                 ),

        .arm_to_fpga_cmd        (arm_to_fpga_cmd        ),
        .arm_to_fpga_cmd_valid  (arm_to_fpga_cmd_valid  ),
        .fpga_to_arm_done       (fpga_to_arm_done       ),
        .fpga_to_arm_done_read  (fpga_to_arm_done_read  ),

        .arm_to_fpga_data_valid (arm_to_fpga_data_valid ),
        .arm_to_fpga_data_ready (arm_to_fpga_data_ready ), 
        .arm_to_fpga_data       (arm_to_fpga_data       ),

        .fpga_to_arm_data_valid (fpga_to_arm_data_valid ),
        .fpga_to_arm_data_ready (fpga_to_arm_data_ready ),
        .fpga_to_arm_data       (fpga_to_arm_data       ),

        .leds                   (leds                   )
        );
        
    // Generate a clock
    initial begin
        clk = 0;
        forever #`CLK_HALF clk = ~clk;
    end
    
    // Reset
    initial begin
        resetn = 0;
        #`RESET_TIME resetn = 1;
    end
    
    // Initialise the values to zero
    initial begin
        arm_to_fpga_cmd         = 0;
        arm_to_fpga_cmd_valid   = 0;
        fpga_to_arm_done_read   = 0;
        arm_to_fpga_data_valid  = 0;
        arm_to_fpga_data        = 0;
        fpga_to_arm_data_ready  = 0;
    end

    task send_cmd_to_hw;
    input [31:0] command;
    begin
        // Assert the command and valid
        arm_to_fpga_cmd <= command;
        arm_to_fpga_cmd_valid <= 1'b1;
        #`CLK_PERIOD;
        // Desassert the valid signal after one cycle
        arm_to_fpga_cmd_valid <= 1'b0;
        #`CLK_PERIOD;
    end
    endtask

    task send_data_to_hw_a_and_b;
    input [1023:0] data;
    begin
        // Assert data and valid
        arm_to_fpga_data <= data;
        arm_to_fpga_data_valid <= 1'b1;
        #`CLK_PERIOD;
        // Wait till accelerator is ready to read it
        wait(arm_to_fpga_data_ready == 1'b1);
        // It is read, do not continue asserting valid
        arm_to_fpga_data_valid <= 1'b0;   
        #`CLK_PERIOD;
    end
    endtask
    
     task send_data_to_hw_m;
       input [1023:0] data;
       begin
           // Assert data and valid
           arm_to_fpga_data <= data;
           arm_to_fpga_data_valid <= 1'b1;
           #`CLK_PERIOD;
           // Wait till accelerator is ready to read it
           wait(arm_to_fpga_data_ready == 1'b1);
           // It is read, do not continue asserting valid
           arm_to_fpga_data_valid <= 1'b0;   
           #`CLK_PERIOD;
       end
       endtask

    task read_data_from_hw;
    output [1023:0] odata;
    begin
        // Assert ready signal
        fpga_to_arm_data_ready <= 1'b1;
        #`CLK_PERIOD;
        // Wait for valid signal
        wait(fpga_to_arm_data_valid == 1'b1);
        // If valid read the output data
        odata = fpga_to_arm_data;
        // Co not continue asserting ready
        fpga_to_arm_data_ready <= 1'b0;
        #`CLK_PERIOD;
    end
    endtask

    task waitdone;
    begin
        // Wait for accelerator's done
        wait(fpga_to_arm_done == 1'b1);
        // Signal that is is read
        fpga_to_arm_done_read <= 1'b1;
        #`CLK_PERIOD;
        // Desassert the signal after one cycle
        fpga_to_arm_done_read <= 1'b0;
        #`CLK_PERIOD;
    end 
    endtask


    localparam CMD_READ_EXP               = 32'h0;
    localparam CMD_READ_A_B_MONT          = 32'h1;
    localparam CMD_READ_M_MONT            = 32'h2;
    localparam CMD_COMPUTE_EXP            = 32'h3;
    localparam CMD_COMPUTE_MONT           = 32'h4;
    localparam CMD_READ_EXP_MOD_RMOD      = 32'h5;
    localparam CMD_READ_EXP_RSQ_EXP       = 32'h6;
    localparam CMD_READ_EXP_X             = 32'h7;
    localparam CMD_WRITE_EXP              = 32'h8;

    
    initial begin

        #`RESET_TIME
        
        // Your task: 
        // Design a testbench to test your accelerator using the tasks defined above: send_cmd_to_hw, send_data_to_hw, read_data_from_hw, waitdone
        input_data_a_and_b <= 1024'h12887b21d93a10f35511c8d56264a6f95f0245d8004e0d3557c7ec2b396b4ed3cabda34f88e0c8154e9ffab2761e626a720eef1da7ee31ce6c31fcdeaec38eb9589901702c94e8d7f3c733aafa46a6b43948148fd2f08761b134bc6815c3a69f4fc4ca4cbec55a2e1e70178549683bf79db5fec9631717e6ae69a5ea5c9eb2a118d;
        input_data_m       <=  1024'hf8f635bfae6507fc726853e48b8ff18f8037f58fbef63debba0381f2a7da936679f14a270b1129a730d905d283459a275b4dd75470965dfa6386b5321563997d;
        

        #`CLK_PERIOD;

        ///////////////////// START EXAMPLE  /////////////////////
        
        //// --- Send the read command and transfer input data to FPGA

        $display("Test for input a and b %h", input_data_a_and_b);
        $display("with mod m  %h", input_data_m);
        $display("Sending read command for A and B");
        send_cmd_to_hw(CMD_READ_A_B_MONT);
        send_data_to_hw_a_and_b(input_data_a_and_b);
        waitdone();
        
        $display("Sending read command for M");
                send_cmd_to_hw(CMD_READ_M_MONT);
                send_data_to_hw_m(input_data_m);
                waitdone();


        //// --- Perform the compute operation

        $display("Sending compute command");
        send_cmd_to_hw(CMD_COMPUTE_MONT);
        waitdone();


	    //// --- Send write command and transfer output data from FPGA
        
        $display("Sending write command");
        send_cmd_to_hw(CMD_WRITE);
        read_data_from_hw(output_data);
        waitdone();


        //// --- Print the array contents

        $display("Output is      %h", output_data);
                  
        ///////////////////// END EXAMPLE  /////////////////////  
        
        $finish;
    end
endmodule
