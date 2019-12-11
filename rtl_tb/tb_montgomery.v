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
//        in_a     <= 512'h87b21d93a10f35511c8d56264a6f95f0245d8004e0d3557c7ec2b396b4ed3cabda34f88e0c8154e9ffab2761e626a720eef1da7ee31ce6c31fcdeaec38eb9589;
//        in_b     <= 512'h733f6233b70f1ff7bc7ea9a38d69c2d083bec7c1d73000a3c36a6b4699300aff43a2c4da76786ac6878e16ad896b861ad351008baa901886630148792eca57ad;
//        in_m     <= 512'hd97a21880ab3b85681ef6162732ffcd3cf303982004568f7fba23d0d411ced4080fd567efcd793b308936f7522ead3c53ad80440edd50088935d2a3d9b9c5885;
//        expected <= 512'hb78d54b19ee244993b93693e0e0a09c18fb79b3bd21358f715c85042fbc0930064fc0ff636026c2cc5690db76b7067e1557d91adc5506abe4ccd9c49c0135905;
//        in_a     <= 512'h87b21d93a10f35511c8d56264a6f95f0245d8004e0d3557c7ec2b396b4ed3cabda34f88e0c8154e9ffab2761e626a720eef1da7ee31ce6c31fcdeaec38eb9589;
//        in_b     <= 512'h901702c94e8d7f3c733aafa46a6b43948148fd2f08761b134bc6815c3a69f4fc4ca4cbec55a2e1e70178549683bf79db5fec9631717e6ae69a5ea5c9eb2a118d;
//        in_m     <= 512'hf8f635bfae6507fc726853e48b8ff18f8037f58fbef63debba0381f2a7da936679f14a270b1129a730d905d283459a275b4dd75470965dfa6386b5321563997d;
//        expected <= 512'hefbbb81aee8737730fcc1b52630ad7056a18df6a9b0c0f0744d2c0f0cc7ac28991b23733a539d8a06329f65394307f2b4f0a3e146227179be2d5ce9f71561b2;
//        in_a     <= 512'h858396813701bf926998e056880795842e0762317511cd98631d8a0a81e21432fabd44f1930c614f47328327f8fd00f888175ce4def8cb898ba012694703de4a;
//        in_b     <= 512'h912a110074df0ceb16ef71e6391703cc4fc1dc1298e834601f0136b547ae56f66eefb314b835cb984515f05b04820469e546210b2ff06efdbdffdd7a8fae03ba;
//        in_m     <= 512'ha69ae36d5549e57f60b66d0c01c391e836e5c0dadd153e8c1143fa008be81efd0a1cd02d42a5ce6793e21fb25fb31f06f5c36ef0f0ec05f61132a287366af077;
//        expected <= 512'h61f051f099b4ceb973fef00f570933bc7c80a053ad4878fbcff2b30e43fc16780b858d790b8788cac314fa4dcd41058e799abd3f6e7b8efd58b422997489ff5a;
//        in_a     <= 512'hc61580d64383684719d20d6ff68fec3e13bc1001b8f4f8c51458bce05d18ed0da753553a5b0f167c07713a92d541d9fe3979f79f4718f79ca7df647811e14692;
//        in_b     <= 512'hcabe8494b51e533c3982f519de2f29a8631da6cb3a8af36b02edd0b8df05607756905a551de9b64cba87a2b538cfc8ca967870327437df9577f88d7951777580;
//        in_m     <= 512'hbde121ba1060d96fff9d8257793661809b16fe5a8f04fa4539e2ff0a9b729071cf2cdf208b9ebd952ac4de5b72ed6a7bd09d0a0a961bf86413b7e95f40ea3679;
//        expected <= 512'hb3c6f516755a32ef97fab185b929e6b2cfa593ef22607d11ad82b13459e1c96e9fe0720f8420319dca8272f6fe22610b9d6075a964737db109f38fbad3db5873;
        in_a     <= 512'hba420e34ecd596a66b3e9c34c2ea29e205e4b8e03e6f4eb782c789f266239e1acb7667b8ef0b3831a80a0907e4c1db6c49984b7c24c223f6bfc1bd76004908c3;
        in_b     <= 512'ha3c3f1452b23e90c9d368c257394900ca95d0850a22e858f85f3f15a63046e6fdf89bb08d63f1220850ad8b3c51d7a70502f6ea228d09554b790a74c87ad21ef;
        in_m     <= 512'ha56fda1cc183a10cef2c21e2b2275bc8b1d7fcb83863cb1b3da46c6d0c19ff576c767ecb6a51edefccd4c91d962afe1865af06febe62f9257822bda70a843951;
        expected <= 512'h49ce02e114f41e94c696cc9b25b0604f333f5839d63bb6cc74bf7a275e35d37ed5639e32e304d830b36c4cda78082669868d2de53a0e22304b35eb8d9d257833;
                    
         
         $display("start the madness");
        start<=1;
        #`CLK_PERIOD;
        //#`CLK_PERIOD;
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