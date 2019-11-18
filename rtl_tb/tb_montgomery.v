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
        in_a     <= 512'hc61580d64383684719d20d6ff68fec3e13bc1001b8f4f8c51458bce05d18ed0da753553a5b0f167c07713a92d541d9fe3979f79f4718f79ca7df647811e14692;
        in_b     <= 512'hcabe8494b51e533c3982f519de2f29a8631da6cb3a8af36b02edd0b8df05607756905a551de9b64cba87a2b538cfc8ca967870327437df9577f88d7951777580;
        in_m     <= 512'hbde121ba1060d96fff9d8257793661809b16fe5a8f04fa4539e2ff0a9b729071cf2cdf208b9ebd952ac4de5b72ed6a7bd09d0a0a961bf86413b7e95f40ea3679;
        expected <= 512'hb3c6f516755a32ef97fab185b929e6b2cfa593ef22607d11ad82b13459e1c96e9fe0720f8420319dca8272f6fe22610b9d6075a964737db109f38fbad3db5873;
        
        
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