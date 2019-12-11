`timescale 1ns / 1ps

`define RESET_TIME 25
`define CLK_PERIOD 10
`define CLK_HALF 5

module tb_expontation();
    reg clk; 
    reg resetn;
    reg start;
    reg result_ok;
    reg [511:0] in_m;
    reg [511:0] Rmodm; // We assume these stick around for at least the first state
    reg [511:0] Rsquaredmodm;
    reg [1023:0] in_e;
    reg [511:0] in_x;
    wire done;
    wire [511:0] result;
    reg [511:0] expected;
    
    exponentiation exponentiation(.clk    (clk    ),
                                   .resetn (resetn ),
                                   .startExponentiation  (start  ),
                                   .done   (done   ),
                                   .A_result (result ),
                                   .x   (in_x   ),
                                   .modulus   (in_m   ),
                                   .exponent   (in_e   ),
                                   .Rmodm (Rmodm),
                                   .Rsquaredmodm (Rsquaredmodm));
    initial begin
       clk = 0;
       forever #`CLK_HALF clk = ~clk;
    end
    
    initial begin
        in_x         <= 0;
        in_m         <= 0;
        in_e         <= 0;
        start        <= 0;
        Rmodm        <= 0;
        Rsquaredmodm <= 0;
    end
    
    
    initial begin
        resetn = 0;
        #`RESET_TIME
        resetn = 1;
    end
    
    
    initial begin
        #`RESET_TIME
        $display("\exponentation with testvector 1");
        in_x         <=  512'h87b21d93a10f35511c8d56264a6f95f0245d8004e0d3557c7ec2b396b4ed3cabda34f88e0c8154e9ffab2761e626a720eef1da7ee31ce6c31fcdeaec38eb9589;
        in_e         <=  512'haf;
        in_m         <=  512'hd97a21880ab3b85681ef6162732ffcd3cf303982004568f7fba23d0d411ced4080fd567efcd793b308936f7522ead3c53ad80440edd50088935d2a3d9b9c5885;
        expected     <=  512'hbdb2a4a461dbff5011756139d13f5446a7eb6c9979b55e8fa687b6edaa842d502fc159a825fe144175f9b5616000e5c971e67f150f5135dd5d6fd220f7400189;
        Rmodm        <=  512'h2685de77f54c47a97e109e9d8cd0032c30cfc67dffba9708045dc2f2bee312bf7f02a98103286c4cf76c908add152c3ac527fbbf122aff776ca2d5c26463a77b;
        Rsquaredmodm <=  512'h733f6233b70f1ff7bc7ea9a38d69c2d083bec7c1d73000a3c36a6b4699300aff43a2c4da76786ac6878e16ad896b861ad351008baa901886630148792eca57ad;
        #`CLK_PERIOD;
        start <= 1'b1;
        #`CLK_PERIOD;
        wait (done==1);
        start <= 1'b1;
        $display("result calculated=%x", result);
        $display("result expected  =%x", expected);
        $display("error            =%x", expected-result);
        result_ok = (expected==result);
        #`CLK_PERIOD;   
        
        $finish;
    end
endmodule
