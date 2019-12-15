`timescale 1ns / 1ps

module hweval_adder (
    input   clk     ,
    input   resetn  ,
    output  data_ok );

    reg          start;
    reg          subtract;
    reg  [513:0] in_a;
    wire [514:0] result;
    wire         done;
    wire         shift;
    wire         enableC;
    wire         zeroC;
       
    // Instantiate the adder    
    mpadder dut (
        .clk      (clk     ),
        .resetn   (resetn  ),
        .subtract (subtract),
        .in_a     (in_a    ),
        .shift    (shift    ),
        .enableC  (enableC),
        .result   (result  ),
        .cZero    (zeroC)
        );


    assign data_ok = done & result[514];
    
endmodule