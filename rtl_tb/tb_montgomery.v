`timescale 1ns / 1ps

`define RESET_TIME 25
`define CLK_PERIOD 10
`define CLK_HALF 5

module tb_montgomery();
    
    reg          clk;
    reg          resetn;
    reg          start;
    reg  [511:0] in_a;
    reg  [511:0] in_b;
    reg  [511:0] in_m;
    wire [511:0] result;
    wire         done;

    reg  [511:0] expected;
    reg          result_ok;
    
    //Instantiating montgomery module
    montgomery montgomery_instance( .clk    (clk    ),
                                    .resetn (resetn ),
                                    .start  (start  ),
                                    .in_a   (in_a   ),
                                    .in_b   (in_b   ),
                                    .in_m   (in_m   ),
                                    .result (result ),
                                    .done   (done   ));

    //Generate a clock
    initial begin
        clk = 0;
        forever #`CLK_HALF clk = ~clk;
    end
    
    //Reset
    initial begin
        resetn = 0;
        #`RESET_TIME resetn = 1;
    end
    
    // Test data
    initial begin

        #`RESET_TIME
        
        // You can generate your own with test vector generator python script
        in_a     <= 512'hac854dd86a88ee6accefadf4e45af10a3a79e375950c80d43e69d08b5fe850abbd45a7fff952e98e1b90f667ad679a8ef87787575ffe3604bd0d6fcfb0023214;
        in_b     <= 512'hf8ba931ef9df048c6ffe8d55b9992eb451ecccbc655bdaac49429ff67857d747ca5ae7cfcfcc2f38788ba36f4c98fee612fb5c7ed826a51f6e9ce8bbef662beb;
        in_m     <= 512'hc74d7b58ad456f6b6c997b318836afceea0ac62dc83e6c96c40403723ef246a0d30968ef3f7579f0cab0621e4a6bed06c894d20aa809cf347c4377c4ec4cb409;
        expected <= 512'h3f869127d962ca1ee7a3e30025438f9a13e884e22346ad294bbb9d5c4491aa217feb11b6b8529c3db9f55d8641bf66b39586d7959545d8ff0379679228f637c3;
        
        start<=1;
        #`CLK_PERIOD;
        start<=0;
        
        wait (done==1);
        
        $display("result calculated=%x", result);
        $display("result expected  =%x", expected);
        $display("error            =%x", expected-result);
        result_ok = (expected==result);
        #`CLK_PERIOD;   

        
        $finish;
    end
           
endmodule