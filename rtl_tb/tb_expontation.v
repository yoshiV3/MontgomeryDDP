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
        in_x         <=  512'hae29d39857a373bba96627c9eb85a6f50f7aab71015401c550d27449d7cf7067b1075bb656c3684e2f1731739aeb48163f7a13102b521a7b8fedf3145d2b54bb;
        in_e         <= 1024'h908f37944d172b75b20f7ff4e7967ccd37defa108f6cb25f761eed782c309a9b41fc8d483774f810a60a343a298a7dadab39cddd1147ed9224245ff620dd0f1;
        in_m         <=  512'hc908f37944d172b75b20f7ff4e7967ccd37defa108f6cb25f761eed782c309a9b41fc8d483774f810a60a343a298a7dadab39cddd1147ed9224245ff620dd0f1;
        expected     <=  512'ha7e01d86695965c21feaf8dd2d24a26bf670977f597648fe0b2bcd38f7bd15a7614c9d551763fa162692eca43b45a7295ed4838673093d671f1421bff386f6af;
        Rmodm        <=  512'h36f70c86bb2e8d48a4df0800b18698332c82105ef70934da089e11287d3cf6564be0372b7c88b07ef59f5cbc5d675825254c63222eeb8126ddbdba009df22f0f;
        Rsquaredmodm <=  512'h323d568ce49e2914f27429b73ad6ee04ef37501703961e8a0d64faadb14eedde16881a21f36536b3fe97da5ba3a4a81b0478afb480e24f2f62415ac9a4dc06c0;
        #`CLK_PERIOD;
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
        
        $finish;
    end
endmodule
