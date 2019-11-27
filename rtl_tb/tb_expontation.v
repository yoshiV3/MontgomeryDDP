`timescale 1ns / 1ps

`define RESET_TIME 25
`define CLK_PERIOD 10
`define CLK_HALF 5

module tb_expontation();
    reg           clk;
    reg           resetn;
    reg           result_ok;
    reg           start;
    reg           done;
    reg  [511:0]  expected;
    reg  [511:0]  in_x;
    reg  [511:0]  in_m;
    reg  [511:0]  in_e;
    wire [511:0]  result;
    
    exp exponentiation(.clk    (clk    ),
                       .resetn (resetn ),
                       .start  (start  ),
                       .done   (done   ),
                       .result (result ),
                       .in_x   (in_x   ),
                       .in_m   (in_m   ),
                       .in_e   (in_e   ));
    initial begin
       clk = 0;
       forever #`CLK_HALF clk = ~clk;
    end
    
    initial begin
        in_x     <= 0;
        in_m     <= 0;
        in_e     <= 0;
        start    <= 0;
    end
    
    
    initial begin
        resetn = 0;
        #`RESET_TIME
        resetn = 1;
    end
    
    
    initial begin
        #`RESET_TIME
        $display("\exponentation with testvector 1");
        in_x     <= 512'h87b21d93a10f35511c8d56264a6f95f0245d8004e0d3557c7ec2b396b4ed3cabda34f88e0c8154e9ffab2761e626a720eef1da7ee31ce6c31fcdeaec38eb9589;
        in_e     <= 512'haf;
        in_m     <= 512'hbdb2a4a461dbff5011756139d13f5446a7eb6c9979b55e8fa687b6edaa842d502fc159a825fe144175f9b5616000e5c971e67f150f5135dd5d6fd220f7400189;
        expected <= 512'hbdb2a4a461dbff5011756139d13f5446a7eb6c9979b55e8fa687b6edaa842d502fc159a825fe144175f9b5616000e5c971e67f150f5135dd5d6fd220f7400189;
        start <= 1'b1;
        #`CLK_PERIOD;
        wait (done==1);
        #`CLK_PERIOD;
        start <= 1'b1;
        $display("result calculated=%x", result);
        $display("result expected  =%x", expected);
        $display("error            =%x", expected-result);
        result_ok = (expected==result);
        #`CLK_PERIOD;   
    end
endmodule
