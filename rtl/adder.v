`timescale 1ns / 1ps

module mpadder(
    input  wire         clk,
    input  wire         resetn,
    input  wire         subtract,
    input  wire [513:0] in_a,
    input  wire         shift,
    input  wire         enableC,
    input  wire [3:0]   showFluffyPonies,
    output wire [513:0] trueResult,
    output wire [513:0] debugResult,
    output wire         cZero,
    output wire         carry, // better name would be subtract_finished
    output wire         cOne
    //output wire         done
     );
     

     
     
     wire [511:0] result;
     
     
     wire [513:0] addInput;


     wire        c_enable; //same things as enableC
     wire        c_shift;

     wire [513:0] C1b; //514* 2, + the last one which is a a shiftSave

     wire [513:0] C2b; 
     wire [513:0] c_db;
     reg  [513:0] c_regb;
     always @(posedge clk)
     begin
         if(~resetn)         c_regb <= 514'd0;
         else if (c_shift)   c_regb <= {1'b0,c_db[513:1]};
         else if (c_enable)  c_regb <= c_db;
         else if (subtract && showFluffyPonies == 4'b0)  c_regb <= {2'b0, result};
     end
     

     wire [513:0] C1c; //514* 2, + the last one which is a a shiftSave
     wire [514:0] C2c; 
     wire [513:0] c_dc;
     reg  [514:0] c_regc;
     always @(posedge clk)
     begin
         if(~resetn)         c_regc <= 515'd0;
         else if (c_shift)   c_regc <= {1'b0,c_dc};
         else if (c_enable)  c_regc <= {c_dc,1'b0};
     end
     
     
     
     assign c_db = C1b;
     assign c_dc = C1c;
     assign c_enable = enableC;
     assign C2b = c_regb;
     assign C2c = c_regc;
     assign cZero = C2b[0]^C2c[0]; // C[0] is our carry for the shift
     assign c_shift = shift;
     
     wire [102:0] operandAShift;
     wire [102:0] operandBShift;
     wire [103:0] tempRes;
     


   
     wire [102:0] result_d;
     reg  [102:0] result_regOne;
     reg  [102:0] result_regTwo;
     reg  [102:0] result_regThree;
     reg  [102:0] result_regFour;
     reg  [99:0] result_regFive;

     
     wire   resultOne_en ;  
     wire [102:0] result_d1;
      always @(posedge clk)
      begin
          if(~resetn)            result_regOne   <= 103'd0;
          else if (resultOne_en) result_regOne   <= result_d1;
     end
     wire [102:0] result_d2;
      wire   resultTwo_en ;  
      always @(posedge clk)
      begin
          if(~resetn)            result_regTwo   <= 103'd0;
          else if (resultTwo_en) result_regTwo   <= result_d2;
     end
     
     
      wire   resultThree_en ;
      wire [102:0] result_d3;  
      always @(posedge clk)
      begin
          if(~resetn)             result_regThree  <= 103'd0;
          else if (resultThree_en) result_regThree   <= result_d3;
     end
     
     wire   resultFour_en ; 
     wire [102:0] result_d4; 
     always @(posedge clk)
     begin
         if(~resetn)             result_regFour  <= 103'd0;
         else if (resultFour_en) result_regFour   <= result_d4;
    end
    
    wire   resultFive_en ; 
    wire [99:0] result_d5; 
    always @(posedge clk)
    begin
        if(~resetn)             result_regFive  <= 100'd0;
        else if (resultFive_en) result_regFive   <= result_d5;
    end
        
    wire [3:0] delay;
//         always @(posedge clk)
//     begin
//         if(~resetn)             delay  <= 4'd8;
//         else                    delay  <= showFluffyPonies;
//     end
     
     assign delay =     showFluffyPonies; 
     assign resultOne_en  = (delay == 4'b0)? 1'b1:1'b0;
     assign resultTwo_en  = (delay == 4'b1)? 1'b1:1'b0;
     assign resultThree_en  = (delay == 4'd2)? 1'b1:1'b0;
     assign resultFour_en  = (delay == 4'd3)? 1'b1:1'b0;
     assign resultFive_en  = (delay == 4'd4)? 1'b1:1'b0;

     assign result_d1 = tempRes[102:0];
     assign result_d2 = tempRes[102:0];
     assign result_d3 = tempRes[102:0]; 
     assign result_d4 = tempRes[102:0];
     assign result_d5 = tempRes[99:0];       
       
     assign result = {result_regFive, result_regFour, result_regThree, result_regTwo, result_regOne};
      
     
     // 103 bit adder
     reg  carry_inNew;
     always @(posedge clk)
     begin
         if(~resetn)          carry_inNew <= 2'd0;
         else if(showFluffyPonies[3] == 1'b0) carry_inNew <= tempRes[103];
     end
     

     
     wire LSBSum;

     
   
     
     assign LSBSum = ((showFluffyPonies == 4'b0) && (subtract)) || (carry_inNew && (showFluffyPonies != 4'b0));
     

     
     
     
     assign tempRes = operandAShift + operandBShift + LSBSum; //(subtract && showFluffyPonies because our muxout 
                                                                                                            //can't do an add)
     
     // multiplexer to fit tempres into this
     
     wire [102:0] operandA; 
     wire [102:0] operandB;

      assign operandA = (showFluffyPonies == 4'b0) ? C2b[102:0] : 
     (showFluffyPonies == 4'd1) ? C2b[205:103] : 
     (showFluffyPonies == 4'd2) ? C2b[308:206] : 
     (showFluffyPonies == 4'd3) ? C2b[411:309] : 
     C2b[513:412]; 
     
     
      assign operandB = (showFluffyPonies == 4'b0) ? C2c[102:0] : 
      (showFluffyPonies == 4'd1) ? C2c[205:103 ] : 
      (showFluffyPonies == 4'd2) ? C2c[308:206] : 
      (showFluffyPonies == 4'd3) ? C2c[411:309] : 
      C2c[515:412];
 
     assign operandAShift = (subtract) ? (
     (showFluffyPonies == 4'd0) ? result_regOne :
     (showFluffyPonies == 4'd1) ? result_regTwo :
     (showFluffyPonies == 4'd2) ? result_regThree :
     (showFluffyPonies == 4'd3) ? result_regFour :
     result_regFive
     ): operandA;                                                                                                                                                                                                                                                                                                                                                                                             

     assign operandBShift = (subtract) ? (
     (showFluffyPonies == 4'd0) ? in_a[102:0] :
     (showFluffyPonies == 4'd1) ? in_a[205:103] :
     (showFluffyPonies == 4'd2) ? in_a[308:206] :
     (showFluffyPonies == 4'd3) ? in_a[411:309] :
     in_a[511:412]
     ) : operandB;
     
     assign addInput = in_a;
     
     // but first initialize our cZero
     genvar i;
     generate
     for (i=0; i<=513; i = i+1) begin : somelabel
     (* dont_touch = "true"*)
    add3 addCZero (
        .carry(C2c[i]), // upper bit
        .sum(C2b[i]), //lower bit of this
        .a(addInput[i]),    // input
        .result({C1c[i],C1b[i]}) // C is the output wire in the outer module
    );
     
    end
    endgenerate
    
    wire subtract_finished;
    
    assign carry = subtract_finished;
    wire overflow;
    reg [1:0] upperBitsSubtract;
    reg [1:0] upperBitsSubtract_D;

    always @(posedge clk)
    begin
       if (~resetn)        upperBitsSubtract<=2'b0;
       else if (showFluffyPonies == 4'd4 && ~subtract)  upperBitsSubtract <= tempRes[101:100]; //maybe carry_in register could be used
       else if (overflow)                  upperBitsSubtract <= upperBitsSubtract_D - 1;
        //actually no overflow
    end
    
    
    always @(posedge clk)
    begin
        if (~resetn)     upperBitsSubtract_D<=2'b0;
        else upperBitsSubtract_D <= upperBitsSubtract;
    end    
    
    assign overflow = (~tempRes[100] && showFluffyPonies == 4'd4 && subtract);//actually no overflow
    
    assign subtract_finished = (upperBitsSubtract_D == 2'b0 && overflow);
    
    
     assign trueResult = c_regb[511:0]; //we store the to be subtracted value in c_regb, and get our result from there once done   

    assign debugResult = {upperBitsSubtract , result};
    assign cOne = C2c[1]^C2b[1];
    
endmodule
module add3(
    input   wire  carry,
    input   wire  sum,
    input   wire  a,
    output  wire  [1:0] result
    );
    
    wire  lower;
    wire  upper;
    assign upper = (carry && sum) || (carry && a) || (a && sum);
    assign lower = carry ^ sum ^ a;
    
//    reg [1:0] C;
//    always @(posedge clk)
//    begin
//        if (~ resetn)   C <= 2'b0;
//        else if (enableC) C <= {upper, lower};
//     end
     assign result = {upper, lower};
     
    endmodule