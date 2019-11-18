`timescale 1ns / 1ps

`define RESET_TIME 25
`define CLK_PERIOD 10
`define CLK_HALF 5

module tb_adder();

    // Define internal regs and wires
    reg           clk;
    reg           resetn;
    reg  [513:0]  in_a;
    reg           subtract;
    reg           shift;
    reg           enableC;
    wire [513:0]  result;
    wire          zeroC;
    reg          carry_en;
    reg [514:0]  expected;
    reg           result_ok;
    reg  [3:0]    return;
    reg [513:0] number1 ;
    

    // Instantiating adder
    mpadder dut (
        .clk      (clk     ),
        .resetn   (resetn  ),
        .subtract (subtract),
        .in_a     (in_a    ),
        .shift    (shift    ),
        .enableC  (enableC),
        .enableCarry (carry_en),
        .debugResult   (result  ),
        .showFluffyPonies (return),
        .cZero    (zeroC)
    );

    // Generate Clock
    initial begin
        clk = 0;
        forever #`CLK_HALF clk = ~clk;
    end

    
    // Initialize signals to zero
    initial begin
        in_a     <= 0;
        subtract <= 0;
        shift    <= 0;
        return <= 4'd8;
        enableC <= 0;
    end

    // Reset the circuit
    initial begin
        resetn = 0;
        #`RESET_TIME
        resetn = 1;
    end


 task perform_add;
        input [511:0] a;
        begin
            in_a <= a;
            subtract <= 1'd0;
            enableC <= 1'd1;
             shift    <= 0;
            #`CLK_PERIOD;
            
        end
    endtask
    
     task perform_add2;
           input [511:0] a;
           begin
               in_a <= a;
               subtract <= 1'd0;
               enableC <= 1'd1;
               shift    <= 1;
               #`CLK_PERIOD;
           end
       endtask

//    task perform_sub;
//        input [513:0] a;
//        begin
//            in_a <= a;
//            start <= 1'd1;
//            subtract <= 1'd1;
//            #`CLK_PERIOD;
//            start <= 1'd0;
//            wait (done==1);
//            #`CLK_PERIOD;
//        end
//    endtask

    initial begin

    #`RESET_TIME

    /*************TEST ADDITION*************/
    
    $display("\nAddition with testvector 1");
    
    // Check if 1+1=2
    #`CLK_PERIOD;
    assign number1 = 514'b11011001110110100111101111101010000110100011000111011000101010111110001010100010011110110100111010000101010111000101110001011100010100001110110100000000110001001000001110001000111010101001101100001111101101111100001000000100110000101100000100101101001110011001011100010101011110100110111111001000111001001011101111100100001100101100010000001101001101011111001001110001011000001001001011101011101000000010111000110111100110000001011111010110001101101010000101000100010101010001110111110100100110101101111000110111;
    assign expected = 6 ;//+ number1 + number1+number1+1; //
    //assign expected = {1'b0,expected[514:1]};
    assign carry_en = 1'b0;
    perform_add(514'd3);
    perform_add(514'd3);
    perform_add(514'd0);
    //perform_add(514'b11011001110110100111101111101010000110100011000111011000101010111110001010100010011110110100111010000101010111000101110001011100010100001110110100000000110001001000001110001000111010101001101100001111101101111100001000000100110000101100000100101101001110011001011100010101011110100110111111001000111001001011101111100100001100101100010000001101001101011111001001110001011000001001001011101011101000000010111000110111100110000001011111010110001101101010000101000100010101010001110111110100100110101101111000110111);
    //perform_add(514'b11011001110110100111101111101010000110100011000111011000101010111110001010100010011110110100111010000101010111000101110001011100010100001110110100000000110001001000001110001000111010101001101100001111101101111100001000000100110000101100000100101101001110011001011100010101011110100110111111001000111001001011101111100100001100101100010000001101001101011111001001110001011000001001001011101011101000000010111000110111100110000001011111010110001101101010000101000100010101010001110111110100100110101101111000110111);
    //perform_add(number1);
    //perform_add2(1);
     
    enableC <= 1'd0;
    shift    <= 0;
    return  <= 4'd0;
   #`CLK_PERIOD
    shift    <= 0;
    enableC <= 1'd0;
    return  <= 4'd1;
    assign carry_en = 1'b1;
    #`CLK_PERIOD
    return  <= 4'd2;
    #`CLK_PERIOD
    return  <= 4'd3;
    #`CLK_PERIOD
    return  <= 4'd4;
    #`CLK_PERIOD
    return  <= 4'd8;
    #`CLK_PERIOD
    result_ok = (expected==result); // #7 means wait 7 clock cycles
    assign carry_en = 1'b0;
    $display("result calculated=%x", result);
    $display("result expected  =%x", expected);
    $display("error            =%x", expected-result);
    #`CLK_PERIOD;   
    
//    $display("\nAddition with testvector 2");

//    // Test addition with large test vectors. 
//    // You can generate your own vectors with testvector generator python script.
//    perform_add(514'h25a168a552f4f012bc5739d778d3359e6a6d93301e0e1fd39eb387b99035be1253bde7845f04952d67729b6d628cf2c781c97fc9e09abd1a8ccf07df631a25376);
//    perform_add(514'h3d98f4d0b19bd93b7555963ef02a487f598c28d335344a5ecc8cf9d98caf08748a7558f1691857923f52d4fc8c055b094eb9712cad132a8352826246b67bd3899);
//    expected  = 515'h633a5d760490c94e31acd01668fd7e1dc3f9bc0353426a326b4081931ce4c686de334075c81cecbfa6c57069ee924dd0d082f0f68dade79ddf516a261995f8c0f;
//    #7
//    result_ok = (expected==result);
//    $display("result calculated=%x", result);
//    $display("result expected  =%x", expected);
//    $display("error            =%x", expected-result);
//    #`CLK_PERIOD;     
    
//    /*************TEST SUBTRACTION*************/

//    $display("\nSubtraction with testvector 1");
    
//    // Check if 1-1=0
//    #`CLK_PERIOD;
//    perform_sub(514'h1, 
//                514'h1);
//    expected  = 515'h0;
//    wait (done==1);
//    result_ok = (expected==result);
//    $display("result calculated=%x", result);
//    $display("result expected  =%x", expected);
//    $display("error            =%x", expected-result);
//    #`CLK_PERIOD;    


//    $display("\nSubtraction with testvector 2");

//    // Test subtraction with large test vectors. 
//    // You can generate your own vectors with testvector generator python script.
//    perform_sub(514'h329e3c39498f09ad105029d84a0cd39bfae260be1a2c18a9b6765a619e1f7114e3d6f85471846dca91071d6001a5c69db3fd36bada0499566a037125b70466b62,
//                514'h21bd2189a5b2de4b579ba4b0eeeb74645d6ab55875fcf441ccae3f63df9bd513aebaf0902c4e718e6d75354f4cc4927536318016eda7745db1c2d9688ddb90a54);
//    expected  = 515'h10e11aafa3dc2b61b8b485275b215f379d77ab65a42f2467e9c81afdbe839c01351c07c44535fc3c2391e810b4e134287dcbb6a3ec5d24f8b84097bd2928d610e;
//    wait (done==1);
//    result_ok = (expected==result);
//    $display("result calculated=%x", result);
//    $display("result expected  =%x", expected);
//    $display("error            =%x", expected-result);
//    #`CLK_PERIOD;     

    $finish;

    end

endmodule