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
    reg [511:0] in_e;
    reg [511:0] in_x;
    wire done;
    wire [511:0] result;
    reg [511:0] expected;
    reg         multiply;
    
    exponentiation exponentiation(.clk    (clk    ),
                                   .resetn (resetn ),
                                   .startExponentiation  (start  ),
                                   .multiplication_enable (multiply),
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
        
        //testvector 2020
        
//        in_x         <=  512'hda8f5c927d37bf2ac65743ee08ebc8667c330d8c28b8d34ba6a7e1fe6055d81498d8b668012ac09f1e4a56c1933a4d1e1b2479d5a209116b9704268dc33a1372;
//        in_e         <=  512'hf5;
//        in_m         <=  512'hba3e64477e930dcc5ebcfd28c2d12d122208ae0edaf47fed345d17b62405c20c7eb9a0ca6396f35db871a75f05e43d3b3f771c3f4eba864e3106f880acbb31d3 ;
//        expected     <=  512'hab4940220f1246165dc7889ccd945786d1ffe2756df70cbc0958480300d2c79e51a9b3482d74b4fa90d622f6dad5a7dee6c35dbe8f12c4bf5eb210829770ac09;
//        Rmodm        <=  512'h45c19bb8816cf233a14302d73d2ed2edddf751f1250b8012cba2e849dbfa3df381465f359c690ca2478e58a0fa1bc2c4c088e3c0b14579b1cef9077f5344ce2d;
//        Rsquaredmodm <=  512'h7a07c54ae634d17d06bed9332932823257bb73745a0be9453069a22c45bcc3db2342077752bb20d9d3e82cc26de56f89247d6b24e696661ee4225dcd3a4465c5;
        multiply     <= 1'b0;     
        
        
in_x       <= 512'hd5361227d967c7f995234a06ec5647a390c7a1b7e289e6d45cd49535432e9b8dc62019e1e62dc7125d446dc8f6ccdabe1eb72802d7f1a13be8491161e85202b2;
in_e         <= 512'hb7;
in_m         <= 512'hf21ecbae4caa3d4cdd348aef6fda09dba3711da0b2e360d04b3667e5efa2dca83f4faf7f14029492ef9091feedb6940d1a97214da1f70b84755bc94ee46bdf4d;
expected     <= 512'h73f84efd6c94f0ae74b37449a202e865a27f9c2b1b33540e4226e5f763490e043f7edff236acc160df5576d3b979a193d4e802a64e4db42054d0b9924f8c3c3e;
Rmodm        <= 512'hde13451b355c2b322cb75109025f6245c8ee25f4d1c9f2fb4c9981a105d2357c0b05080ebfd6b6d106f6e0112496bf2e568deb25e08f47b8aa436b11b9420b3;
Rsquaredmodm <= 512'hcb8a1584ecd03605c6a711c3a1e8902eba4207292108d6b8503d4b8881c532acffdd86d9072e56f619a72e65ce0f29d41a4a12c4d2b78d71cc8f33dc89b119d4;
        
//        in_x         <=  512'h87b21d93a10f35511c8d56264a6f95f0245d8004e0d3557c7ec2b396b4ed3cabda34f88e0c8154e9ffab2761e626a720eef1da7ee31ce6c31fcdeaec38eb9589;
//        in_e         <=  512'haf;
//        in_m         <=  512'hd97a21880ab3b85681ef6162732ffcd3cf303982004568f7fba23d0d411ced4080fd567efcd793b308936f7522ead3c53ad80440edd50088935d2a3d9b9c5885;
//        expected     <=  512'hbdb2a4a461dbff5011756139d13f5446a7eb6c9979b55e8fa687b6edaa842d502fc159a825fe144175f9b5616000e5c971e67f150f5135dd5d6fd220f7400189;
//        Rmodm        <=  512'h2685de77f54c47a97e109e9d8cd0032c30cfc67dffba9708045dc2f2bee312bf7f02a98103286c4cf76c908add152c3ac527fbbf122aff776ca2d5c26463a77b;
//        Rsquaredmodm <=  512'h733f6233b70f1ff7bc7ea9a38d69c2d083bec7c1d73000a3c36a6b4699300aff43a2c4da76786ac6878e16ad896b861ad351008baa901886630148792eca57ad;
//        multiply     <= 1'b0;
        
//        in_x         <=  512'h88583ec8b11db437837fe11aca3e7648c6d88dade783e643465a82a3294e190b1872bc8499caf3e87fd9b9ff5b6a839f65201df4978f53c298c8f398a32bdf2b;
//        in_e         <=  512'ha0;
//        in_m         <=  512'hb7ae940f1e537437f19175d5a1197cfb9d009d3565e73859fdd404143ce6d2f593ec6637b79d898f8b03cfd0c12102f8b5cddb6bc165d89bd2c5dd8e568aee41;
//        expected     <=  512'h37f02a691202d1a986b8ac06bd4d8426efa8ec376d04b87a607d229c21a68587d0ffc07d00b6cda51385a7d9c29d33692085222a85aee0bba532d7734b311bd9;
//        Rmodm        <=  512'h48516bf0e1ac8bc80e6e8a2a5ee6830462ff62ca9a18c7a6022bfbebc3192d0a6c1399c84862767074fc302f3edefd074a3224943e9a27642d3a2271a97511bf;
//        Rsquaredmodm <=  512'h155d47fe104ed2ef3e84d1c3b0b8717bf0a84c9957df2530bbdc7e08a6f19f5b80648cb698d73aecb9286eff39eac78f6584b1355de50bc3ce6ef056715d73fa;
//        multiply     <= 1'b0;
        
       in_x         <=  512'hcc3abd06ff8100f135535b982344d1ae1abc9c78b05ceb6e8fde131f23ea03704f6b1d7cf231b13d43692d0b5e01f829bc48e383bd046aeaddb63768c405987d;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        in_m         <=  512'ha1223da67930dd73e1dd07fee62e4bfad65059e30de1fdd96f95e899de1604259a13b36f8a8f19f661b3ab0ac0e49eeaebc73f9c2c8ba9b0b5d635816d379c4d;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        expected     <=  512'h5764fd9614a860b0f2e8015678119047e8c22124a441e9db6ede6e177fc5173d09cd96258a3c317f5a3c3ef9d86b96cc9e3fa154b238d3abd80dc2a35f22cdec;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        Rmodm        <=  512'h2685de77f54c47a97e109e9d8cd0032c30cfc67dffba9708045dc2f2bee312bf7f02a98103286c4cf76c908add152c3ac527fbbf122aff776ca2d5c26463a77b;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        Rsquaredmodm <=  512'hd26eb20cba1484f9e844b8a13fccb76b56f7cf02e6192d787c56da163d6dbb9f43fbfc0a4d4be1a7303806455a605906ad14cab5d7f5ba375ff7466b3e2681ab;
        #`CLK_PERIOD;
        #`CLK_PERIOD;
        multiply     <= 1'b1;        

        start <= 1'b1;
        //#`CLK_PERIOD;
        wait (done==1);
        start <= 1'b1;
        $display("result calculated=%x", result);
        $display("result expected  =%x", expected);
        $display("error            =%x", expected-result);
        result_ok = (expected==result);
        $display("result OK?       =%x", result_ok);
        #`CLK_PERIOD;   
        
        $finish;
    end
endmodule
