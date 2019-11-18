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
    wire [514:0]  result;
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
        .trueResult   (result  ),
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
    assign expected = 6 + number1 + number1+number1+1; //
    //assign expected = {1'b0,expected[514:1]};
    assign carry_en = 1'b0;
    perform_add(514'd3);
    perform_add(514'd3);
    perform_add(514'd0);
    perform_add(514'b11011001110110100111101111101010000110100011000111011000101010111110001010100010011110110100111010000101010111000101110001011100010100001110110100000000110001001000001110001000111010101001101100001111101101111100001000000100110000101100000100101101001110011001011100010101011110100110111111001000111001001011101111100100001100101100010000001101001101011111001001110001011000001001001011101011101000000010111000110111100110000001011111010110001101101010000101000100010101010001110111110100100110101101111000110111);
    perform_add(514'b11011001110110100111101111101010000110100011000111011000101010111110001010100010011110110100111010000101010111000101110001011100010100001110110100000000110001001000001110001000111010101001101100001111101101111100001000000100110000101100000100101101001110011001011100010101011110100110111111001000111001001011101111100100001100101100010000001101001101011111001001110001011000001001001011101011101000000010111000110111100110000001011111010110001101101010000101000100010101010001110111110100100110101101111000110111);
    perform_add(number1);
    perform_add2(1);
     
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
    
    
    return  <= 4'd0;
    #`CLK_PERIOD
    return  <= 4'd1;
    #`CLK_PERIOD
    return  <= 4'd2;
    #`CLK_PERIOD
    return  <= 4'd3;
    #`CLK_PERIOD
    return  <= 4'd4;
    #`CLK_PERIOD
    result_ok = (expected==result); // #7 means wait 7 clock cycles
    assign carry_en = 1'b0;
    $display("result calculated=%x", result);
    $display("result expected  =%x", expected);
    $display("error            =%x", expected-result);
    #`CLK_PERIOD;   
    

    $finish;

    end

endmodule