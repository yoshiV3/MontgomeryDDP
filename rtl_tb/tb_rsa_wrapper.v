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

    reg  [1023:0] input_data_a;
    reg  [1023:0] input_data_m;
    reg  [1023:0] output_data;
    reg  [1023:0] output_data_exp;
    reg  [1023:0] in_e;
    reg  [1023:0] in_m;
    reg  [1023:0] in_Rsquaredmodm;
    reg  [511:0] expected;
    reg [511:0] multiply_expected;
    reg  result_ok;
        
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
        wait(fpga_to_arm_done == 1'b1);
        // Signal that is is read
        fpga_to_arm_done_read <= 1'b1;
        #`CLK_PERIOD;
        // Desassert the signal after one cycle
        fpga_to_arm_done_read <= 1'b0;
        #`CLK_PERIOD;
    end 
    endtask

	
    localparam CMD_COMPUTE_EXP            = 32'h6;
    localparam CMD_COMPUTE_MONT           = 32'h1;
    localparam CMD_READ_MOD           	  = 32'h2; //for both mods
    localparam CMD_READ_RSQ		          = 32'h3; // for [x rsq] or [A B]
    localparam CMD_READ_EXP           	  = 32'h4; // for [rmod  exp]
    localparam CMD_WRITE                  = 32'h5;
    
    initial begin

        #`RESET_TIME
        
        // Your task: 
        // Design a testbench to test your accelerator using the tasks defined above: send_cmd_to_hw, send_data_to_hw, read_data_from_hw, waitdone
        input_data_a[1023:512] <= 512'hda8f5c927d37bf2ac65743ee08ebc8667c330d8c28b8d34ba6a7e1fe6055d81498d8b668012ac09f1e4a56c1933a4d1e1b2479d5a209116b9704268dc33a1372;
        input_data_a[511:0] <= 512'hdebcfd28c2d12d122208ae0edaf47fed345d17b62405c20c7eb9a0ca6396f35db871a75f05e43d3b3f771c3f4eba864e3106f880acbb31d3b78a1752edbbe33c;
        input_data_m <= 512'h8dc4379cfd6eb140014faf07379c9f93982df051edf1795c4d869657ae77882afd7babf74e49a42ac238f0700424a00ca89fb32dad407fdcf1e3a8f422657e83;
        multiply_expected <= 512'h1ad69deed52a69bc901130b76c7c30351364ba636d2ff549709f50d0c42726e52618b76ddb9facdabb1326b91644634aacf653e92101df12ff8cea8935541f33;
        
        
        
        
        //Exponentiation
        
        
        expected     <=  512'hbdb2a4a461dbff5011756139d13f5446a7eb6c9979b55e8fa687b6edaa842d502fc159a825fe144175f9b5616000e5c971e67f150f5135dd5d6fd220f7400189;


        in_Rsquaredmodm            <=  512'h733f6233b70f1ff7bc7ea9a38d69c2d083bec7c1d73000a3c36a6b4699300aff43a2c4da76786ac6878e16ad896b861ad351008baa901886630148792eca57ad;
        in_Rsquaredmodm[1023:512]  <=  512'h87b21d93a10f35511c8d56264a6f95f0245d8004e0d3557c7ec2b396b4ed3cabda34f88e0c8154e9ffab2761e626a720eef1da7ee31ce6c31fcdeaec38eb9589;
                
        in_e            <=  512'haf;
        
        in_m            <=  512'hd97a21880ab3b85681ef6162732ffcd3cf303982004568f7fba23d0d411ced4080fd567efcd793b308936f7522ead3c53ad80440edd50088935d2a3d9b9c5885;
                
        
        in_e[1023:512] <=  512'h2685de77f54c47a97e109e9d8cd0032c30cfc67dffba9708045dc2f2bee312bf7f02a98103286c4cf76c908add152c3ac527fbbf122aff776ca2d5c26463a77b;
             
        #`CLK_PERIOD;

        /////////////////// START EXAMPLE  /////////////////////
        
        // --- Send the read command and transfer input data to FPGA

        $display("Test montgomery input a  and b %h", input_data_a);
        $display("with mod m  %h", input_data_m);
        $display("Sending read command for A");
        send_cmd_to_hw(CMD_READ_RSQ);
        send_data_to_hw(input_data_a);
        waitdone();
        
        $display("Sending read command for M");
        send_cmd_to_hw(CMD_READ_MOD);
        send_data_to_hw(input_data_m);
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
        $display("result expected  =%x", multiply_expected);
        $display("error            =%x", multiply_expected-output_data);
            
        result_ok = (multiply_expected==output_data[511:0]);
        $display("result OK?       =%x", result_ok);   
                  
$display("Test exponentiation ");
                
                
                $display("Sending read command for M %h" ,in_m);
                send_cmd_to_hw(CMD_READ_MOD);
                send_data_to_hw(in_m);
                waitdone();
                        
                $display("Sending read command for exp %h" ,in_e);
                send_cmd_to_hw(CMD_READ_EXP);
                send_data_to_hw(in_e);
                waitdone();
             
                $display("Sending read command for Rsqmod %h" ,in_Rsquaredmodm);
                send_cmd_to_hw(CMD_READ_RSQ);
                send_data_to_hw(in_Rsquaredmodm);
                waitdone();
        
                //// --- Perform the compute operation
        
                $display("Sending compute command");
                send_cmd_to_hw(CMD_COMPUTE_EXP);
                waitdone();
        
        
                //// --- Send write command and transfer output data from FPGA
                
                $display("Sending write command");
                send_cmd_to_hw(CMD_WRITE);
                read_data_from_hw(output_data_exp);
                waitdone();
        
                
                //// --- Print the array contents
                $display("Output is      %h", output_data_exp[511:0]);        
                $display("result expected  =%x", expected);
                $display("error            =%x", expected-output_data_exp[511:0]);
                    
                result_ok = (expected==output_data_exp[511:0]);
                $display("result OK?       =%x", result_ok);      

        ///////////////////// END EXAMPLE  /////////////////////  
        
        $finish;
    end
endmodule
