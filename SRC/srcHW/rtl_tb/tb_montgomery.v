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
        
        $display("start debugging now");
        
        // You can generate your own with test vector generator python script
        in_a     <= 512'h87b21d93a10f35511c8d56264a6f95f0245d8004e0d3557c7ec2b396b4ed3cabda34f88e0c8154e9ffab2761e626a720eef1da7ee31ce6c31fcdeaec38eb9589;
        in_b     <= 512'h901702c94e8d7f3c733aafa46a6b43948148fd2f08761b134bc6815c3a69f4fc4ca4cbec55a2e1e70178549683bf79db5fec9631717e6ae69a5ea5c9eb2a118d;
        in_m     <= 512'hf8f635bfae6507fc726853e48b8ff18f8037f58fbef63debba0381f2a7da936679f14a270b1129a730d905d283459a275b4dd75470965dfa6386b5321563997d;
        expected <= 512'hefbbb81aee8737730fcc1b52630ad7056a18df6a9b0c0f0744d2c0f0cc7ac28991b23733a539d8a06329f65394307f2b4f0a3e146227179be2d5ce9f71561b2;
             
         $display("start the madness");
        start<=1;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        start<=0;
        
         $display("waiting till done");
        wait (done==1);
         $display("done");
        
        $display("result calculated=%x", result);
        $display("result expected  =%x", expected);
        $display("error            =%x", expected-result);
        result_ok = (expected==result);
        #`CLK_PERIOD;   

        
        $finish;
    end
           
endmodule