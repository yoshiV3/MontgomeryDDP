`timescale 1ns / 1ps

module mpadder(
    input  wire         clk,
    input  wire         resetn,
    input  wire         subtract,
    input  wire [511:0] B0,
    input  wire [512:0] B1,
    input  wire [513:0] B2,
    input  wire [514:0] B3,
    input  wire [511:0] M0,
    input  wire [512:0] M1,
    input  wire [513:0] M2,
    input  wire [514:0] M3,
    input  wire [512:0] subtraction, //now only for the subtract
    input  wire         c_doubleshift,
    //input  wire         enableC,
    input  wire [3:0]   showFluffyPonies,
    output wire [513:0] trueResult,
    output wire         cZero,
    output wire         carry, // better name would be subtract_finished
    output wire         cOne,
    output wire         cTwo,
    output wire         cThree
    //output wire         done
     );
     

     
     
     wire [512:0] result;
     
     



     wire        c_enable; //same things as enableC
     wire [516:0] C1bOut;
     wire [516:0] C1cOut;
     wire [515:0] C2b; 

     reg  [515:0] c_regb; //TWICE AS LARGE AS THE CORRECT RESULT!!!
     always @(posedge clk)
     begin
         if(~resetn)         c_regb <= 516'd0;
         else if (c_doubleshift)   c_regb <= {1'b0,C1bOut[516:2]}; //We only shift once now
         //else if (c_enable)  c_regb <= C1bOut[513:0];
         else if (subtract && showFluffyPonies == 4'b0)  c_regb <= {1'b0, result};
     end
     
  
     


     wire [516:0] C2c; 

     reg  [516:0] c_regc;//TWICE AS LARGE AS THE CORRECT RESULT!!!
     always @(posedge clk)
     begin
         if(~resetn)         c_regc <= 517'd0;
         else if (c_doubleshift)   c_regc <= {1'b0,C1cOut[516:1]}; //one shift because the other 3 shifts are done in the adder by starting at 0
         //else if (c_enable)  c_regc <= C1cOut;
     end
     
     

     //assign c_enable = enableC;
     assign C2b = c_regb;
     assign C2c = c_regc;
     //assign cZero = C2b[0]^C2c[0];This will always be 0
     wire [7:0] sumCarryAndBit;
     assign sumCarryAndBit = C2b[6:0] + C2c[6:0];
     assign {cThree,cTwo,cOne, cZero} = sumCarryAndBit[7:3]; //be don't need the 0 bit,
     // since it will be 0, and the first bit is not our concern
    // This can be optimized     
     
     //assign cOne = C2b[1]^C2c[1]^(C2b[0]&C2c[0]);

     
     wire [103:0] operandAShift;
     wire [103:0] operandBShift;
     wire [104:0] tempRes;
     


   

     //wire [102:0] result_d;

     reg  [103:0] result_regOne;
     reg  [103:0] result_regTwo;
     reg  [103:0] result_regThree;
     reg  [103:0] result_regFour;
     reg  [103:0] result_regFive;

     
     wire   resultOne_en ;  
     wire [103:0] result_d1;
      always @(posedge clk)
      begin
          if(~resetn)            result_regOne   <= 104'd0;
          else if (resultOne_en) result_regOne   <= result_d1;
     end
     wire [103:0] result_d2;
      wire   resultTwo_en ;  
      always @(posedge clk)
      begin
          if(~resetn)            result_regTwo   <= 104'd0;
          else if (resultTwo_en) result_regTwo   <= result_d2;
     end
     
     
      wire   resultThree_en ;
      wire [103:0] result_d3;  
      always @(posedge clk)
      begin
          if(~resetn)             result_regThree  <= 104'd0;
          else if (resultThree_en) result_regThree   <= result_d3;
     end
     
     wire   resultFour_en ; 
     wire [103:0] result_d4; 
     always @(posedge clk)
     begin
         if(~resetn)             result_regFour  <= 104'd0;
         else if (resultFour_en) result_regFour   <= result_d4;
    end
    
    wire   resultFive_en ;  //change this as required
    wire [100:0] result_d5; 
    always @(posedge clk)
    begin
        if(~resetn)             result_regFive  <= 101'd0;
        else if (resultFive_en) result_regFive   <= result_d5;
    end
        

     assign resultOne_en  = (showFluffyPonies == 4'd1);
     assign resultTwo_en  = (showFluffyPonies == 4'd2);
     assign resultThree_en  = (showFluffyPonies == 4'd3);
     assign resultFour_en  = (showFluffyPonies == 4'd4);
     assign resultFive_en  = (showFluffyPonies == 4'd5);

     assign result_d1 = tempRes[103:0];
     assign result_d2 = tempRes[103:0];
     assign result_d3 = tempRes[103:0]; 
     assign result_d4 = tempRes[103:0];
     assign result_d5 = tempRes[100:0];       
       
     assign result = {result_regFive, result_regFour, result_regThree, result_regTwo, result_regOne};
      
     
     // 104 bit adder
     reg  carry_inNew;
     always @(posedge clk)
     begin
         if(~resetn)          carry_inNew <= 1'd0;
         else if(showFluffyPonies[3] == 1'd0 && showFluffyPonies != 4'd0 ) carry_inNew <= tempRes[104];
     end
     
     
     wire [103:0] operandA; 
     wire [103:0] operandB;

      assign operandA = (showFluffyPonies == 4'b0) ? C2b[103:0] : 
     (showFluffyPonies == 4'd1) ? C2b[207:104] :
     (showFluffyPonies == 4'd2) ? C2b[311:208] : 
     (showFluffyPonies == 4'd3) ? C2b[415:312] : 
     C2b[515:415];
//     (showFluffyPonies == 4'd4) ? C2b[513:412]:
//     103'b0; 
     
     
      assign operandB = (showFluffyPonies == 4'b0) ? C2c[103:0] : 
      (showFluffyPonies == 4'd1) ? C2c[207:104] : 
      (showFluffyPonies == 4'd2) ? C2c[311:208] : 
      (showFluffyPonies == 4'd3) ? C2c[415:312] : 
      C2c[515:415];
//      (showFluffyPonies == 4'd4) ? C2c[514:412]:
//       103'b0; 
      

     assign operandAShift = (subtract) ? (
     (showFluffyPonies == 4'd0) ? result_regOne :
     (showFluffyPonies == 4'd1) ? result_regTwo :
     (showFluffyPonies == 4'd2) ? result_regThree :
     (showFluffyPonies == 4'd3) ? result_regFour :
     result_regFive
//     (showFluffyPonies == 4'd4) ? result_regFive :
//     103'b0
     ): operandA;                                                                                                                                                                                                                                                                                                                                                                                             

     assign operandBShift = (subtract) ? (
     (showFluffyPonies == 4'd0) ? subtraction[103:0] :
     (showFluffyPonies == 4'd1) ? subtraction[207:104] :
     (showFluffyPonies == 4'd2) ? subtraction[311:208] :
     (showFluffyPonies == 4'd3) ? subtraction[415:312] :
     subtraction[515:415] 
//     (showFluffyPonies == 4'd4) ? in_a[511:412] :
//     103'b0
     ) : operandB;
     

     wire   OperandAPipeline_en ; 
     reg [103:0] reg_opAPipelineQ; 
     wire [103:0] reg_opAPipelineD; 
     wire [103:0] reg_opAPipelineOut; 
     always @(posedge clk)
     begin
         if(~resetn)             reg_opAPipelineQ  <= 104'd0;
         else if (OperandAPipeline_en) reg_opAPipelineQ   <= reg_opAPipelineD;
     end
     
     
     wire   OperandBPipeline_en ; 
     reg [103:0] reg_opBPipelineQ; 
     wire [103:0] reg_opBPipelineD; 
     wire [103:0] reg_opBPipelineOut; 
     always @(posedge clk)
     begin
         if(~resetn)             reg_opBPipelineQ  <= 104'd0;
         else if (OperandBPipeline_en) reg_opBPipelineQ   <= reg_opBPipelineD;
     end
     

     
     wire LSBSum;
    assign OperandAPipeline_en = showFluffyPonies[3] == 1'b0;
    assign OperandBPipeline_en = showFluffyPonies[3] == 1'b0;
    
    assign reg_opBPipelineD = operandBShift;
    assign reg_opAPipelineD = operandAShift;
     
    assign reg_opBPipelineOut = reg_opBPipelineQ;
    assign reg_opAPipelineOut = reg_opAPipelineQ;
     
     assign LSBSum = ((showFluffyPonies == 4'b1) && (subtract)) || (carry_inNew && (showFluffyPonies != 4'b0 && showFluffyPonies != 4'b1 ));
     

     
     assign tempRes = reg_opBPipelineOut + reg_opAPipelineOut + LSBSum; //(subtract && showFluffyPonies because our muxout 
                                                                                                            //can't do an add)
     
     // multiplexer to fit tempres into this


     

     
     // but first initialize our cZerowith state register 'r_state_reg' using encoding 'one-hot' in module 'AXI4_S'
     
     wire [516:0] LeftCarry;
     wire [516:0] LeftBit;
     wire [516:0] RightCarry;
     wire [516:0] RightBit;
     wire [516:0] MiddleCarry;
     wire [516:0] MiddleBit;
     
     wire [516:0] LeftCarryShift = {1'b0,LeftCarry[515:0], 1'b0};
     wire [516:0] RightCarryShift = {1'b0,RightCarry[515:0], 1'b0};
     wire [516:0] MiddleCarryShift = {1'b0,MiddleCarry[515:0], 1'b0};
     
     wire [516:0] B0Pad = {2'b0, B0, 3'b0};
     wire [516:0] B1Pad = {1'b0,B1, 3'b0};
     wire [516:0] M0Pad = {2'b0, M0, 3'b0};
     wire [516:0] M1Pad = {1'b0,M1, 3'b0};
     
     wire [516:0] C2bPad = {1'b0, C2b};
     

     

     


     genvar i;
     generate
     for (i=0; i<=516; i = i+1) begin : do4Adders
     (* dont_touch = "true"*)
    add3 addLeft (
        .carry(C2c[i]), // upper bit
        .sum(C2bPad[i]), //lower bit of this
        .a(B0Pad[i]),    // input
        .result({LeftCarry[i],LeftBit[i]}) // C is the output wire in the outer module
    );
    
    add3 addRight (
        .carry(B1Pad[i]), // upper bit
        .sum(M0Pad[i]), //lower bit of this
        .a(M1Pad[i]),    // input
        .result({RightCarry[i],RightBit[i]}) // C is the output wire in the outer module
    );
    
    add3 addRightRight (
            .carry(B2Pad[i]), // upper bit
            .sum(M2Pad[i]), //lower bit of this
            .a(M3Pad[i]),    // input
            .result({RightCarry[i],RightBit[i]}) // C is the output wire in the outer module
        );
        
    add3 addMiddle (
        .carry(LeftCarryShift[i]), // upper bit
        .sum(LeftBit[i]), //lower bit of this
        .a(RightCarryShift[i]),    // input
        .result({MiddleCarry[i],MiddleBit[i]}) // C is the output wire in the outer module
    );
            
    add3 addBottom (
        .carry(MiddleCarryShift[i]), // upper bit
        .sum(MiddleBit[i]), //lower bit of this
        .a(RightBit[i]),    // input
        .result({C1cOut[i],C1bOut[i]}) // C is the output wire in the outer module
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
       else if (showFluffyPonies == 4'd5 && ~subtract)  upperBitsSubtract <= tempRes[102:101]; //maybe carry_in register could be used
       else if (overflow)                  upperBitsSubtract <= upperBitsSubtract_D - 1;
        //actually no overflowwith state register 'r_state_reg' using encoding 'one-hot' in module 'AXI4_S'


    end
    
    
    always @(posedge clk)
    begin
        if (~resetn)     upperBitsSubtract_D<=2'b0;
        else upperBitsSubtract_D <= upperBitsSubtract;
    end    
    
    assign overflow = (~tempRes[101] && showFluffyPonies == 4'd5 && subtract);//actually no overflow
    
    assign subtract_finished = (upperBitsSubtract_D == 2'b0 && overflow);
    
    
     assign trueResult = c_regb[512:1]; //we store the to be subtracted value in c_regb, and get our result from there once done   


    
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
    

     assign result = {upper, lower};
     
    endmodule