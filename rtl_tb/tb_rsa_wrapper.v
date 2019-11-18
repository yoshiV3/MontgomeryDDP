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
    wire          arm_to_fpga_done;
    reg           arm_to_fpga_done_read;

    reg           arm_to_fpga_data_valid;
    wire          arm_to_fpga_data_ready;
    reg  [1023:0] arm_to_fpga_data;

    wire          fpga_to_arm_data_valid;
    reg           fpga_to_arm_data_ready;
    wire [1023:0] fpga_to_arm_data;

    wire [   3:0] leds;

    reg  [1023:0] input_data;
    reg  [1023:0] output_data;
        
    rsa_wrapper rsa_wrapper(
        .clk                    (clk                    ),
        .resetn                 (resetn                 ),

        .arm_to_fpga_cmd        (arm_to_fpga_cmd        ),
        .arm_to_fpga_cmd_valid  (arm_to_fpga_cmd_valid  ),
        .arm_to_fpga_done       (arm_to_fpga_done       ),
        .arm_to_fpga_done_read  (arm_to_fpga_done_read  ),

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
        arm_to_fpga_done_read   = 0;
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

    task send_data_to_hw;
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
        wait(arm_to_fpga_done == 1'b1);
        // Signal that is is read
        arm_to_fpga_done_read <= 1'b1;
        #`CLK_PERIOD;
        // Desassert the signal after one cycle
        arm_to_fpga_done_read <= 1'b0;
        #`CLK_PERIOD;
    end 
    endtask


    localparam CMD_READ    = 32'h0;
    localparam CMD_COMPUTE = 32'h1;    
    localparam CMD_WRITE   = 32'h2;
    
    initial begin

        #`RESET_TIME
        
        // Your task: 
        // Design a testbench to test your accelerator using the tasks defined above: send_cmd_to_hw, send_data_to_hw, read_data_from_hw, waitdone
        
        input_data  <= 1024'h00000000000000000123456789abcdef00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
        output_data <= 1024'b0;

        #`CLK_PERIOD;

        ///////////////////// START EXAMPLE  /////////////////////
        
        //// --- Send the read command and transfer input data to FPGA

        $display("Test for input %h", input_data);
        
        $display("Sending read command");
        send_cmd_to_hw(CMD_READ);
        send_data_to_hw(input_data);
        waitdone();


        //// --- Perform the compute operation

        $display("Sending compute command");
        send_cmd_to_hw(CMD_COMPUTE);
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