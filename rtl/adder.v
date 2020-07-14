`timescale 1ns / 1ps

//Use video Design Analysis and Floorplanning to synthesize this block as its own structure

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
    input  wire [511:0] subtraction, //now only for the subtract
    input  wire         c_doubleshift,
    //input  wire         enableC,
    input  wire [3:0]   showFluffyPonies,
    output wire [511:0] trueResult,
    
    output wire         subtract_finished, // better name would be subtract_finished
    output wire         cZero,
    output wire         cOne,
    output wire         cTwo,
    output wire         cThree
    //output wire         done
     );
     

     
     
     wire [519:0] fullResultSum; //So we can fit 5 103 regs, the other option is dropping tyhe last 3 and rolling with that
     wire [512:0] result;
     



     wire [519:0] C1bOut;
     wire [519:0] C1cOut;

     reg  [517:0] c_regb; //TWICE AS LARGE AS THE CORRECT RESULT!!!
     always @(posedge clk)
     begin
         if(~resetn)         c_regb <= 518'd0;
         //else   c_regb <= C1bOut[519:2];
         else if (c_doubleshift)   c_regb <= C1bOut[519:2]; //We only shift once now
         //else   c_regb <= C1bOut[519:2];
         //else if (c_enable)  c_regb <= C1bOut[513:0];
         //else if (subtract && showFluffyPonies == 4'b0)  c_regb <= {6'b0, result[511:0]};
     end
     
     reg [511:0] resultReg;
     always @(posedge clk)
     begin
        if(~resetn)         resultReg <= 512'd0;
        else if (subtract && showFluffyPonies == 4'b0) resultReg <= result[511:0];
     end     
  
     


     reg  [518:0] c_regc;//TWICE AS LARGE AS THE CORRECT RESULT!!!
     always @(posedge clk)
     begin
         if(~resetn)         c_regc <= 519'd0;
         else if (c_doubleshift)   c_regc <= C1cOut[519:1]; //one shift because the other 3 shifts are done in the adder by starting at 0
         //else  c_regc <= C1cOut[519:1]; //THIS WILL FIX THE TIMING ISSUE, BUT REQUIRES Mselect = 0 a change in indices and Aselect = 0, which will add crit path
         //else if (c_enable)  c_regc <= C1cOut;
     end
     
//     reg [6:0] c_regcDuplicate;
//     always @(posedge clk)
//     begin 
//        if(~resetn)       c_regcDuplicate <= 7'b0;
//        else if (c_doubleshift) c_regcDuplicate <= C1cOut[9:3];
//     end
     
//      reg [6:0] c_regbDuplicate;
//     always @(posedge clk)
//     begin 
//        if(~resetn)       c_regbDuplicate <= 7'b0;
//        else if (c_doubleshift) c_regbDuplicate <= C1bOut[10:4];
//     end
     

     //assign c_enable = enableC;

     //assign cZero = C2b[0]^C2c[0];This will always be 0
     wire [6:0] sumCarryAndBit;
     assign sumCarryAndBit = c_regb[8:2] + c_regc[8:2];
     //assign sumCarryAndBit = c_regbDuplicate[6:0] + c_regcDuplicate[6:0];
     assign {cThree,cTwo,cOne, cZero} = sumCarryAndBit[6:3]; //be don't need the 0 bit,
     // since it will be 0, and the first bit is not our concern
    // This can be optimized     
     
     //assign cOne = C2b[1]^C2c[1]^(C2b[0]&C2c[0]);

     
//     wire [103:0] operandAShift;
//     wire [103:0] operandBShift;
     reg [103:0] operandAShift;
     reg [103:0] operandBShift;
     wire [104:0] tempRes;
     


   

     //wire [102:0] result_d;

     reg  [103:0] result_regOne;
     reg  [103:0] result_regTwo;
     reg  [103:0] result_regThree;
     reg  [103:0] result_regFour;
     reg  [103:0] result_regFive;

     
     wire   resultOne_en ;  
      always @(posedge clk)
      begin
          if(~resetn)            result_regOne   <= 104'd0;
          else if (resultOne_en) result_regOne   <= tempRes[103:0];
     end

      wire   resultTwo_en ;  
      always @(posedge clk)
      begin
          if(~resetn)            result_regTwo   <= 104'd0;
          else if (resultTwo_en) result_regTwo   <= tempRes[103:0];
     end
     
     
      wire   resultThree_en ;

      always @(posedge clk)
      begin
          if(~resetn)             result_regThree  <= 104'd0;
          else if (resultThree_en) result_regThree   <= tempRes[103:0];
     end
     
     wire   resultFour_en ; 

     always @(posedge clk)
     begin
         if(~resetn)             result_regFour  <= 104'd0;
         else if (resultFour_en) result_regFour   <= tempRes[103:0];
    end
    
    wire   resultFive_en ;  //change this as required

    always @(posedge clk)
    begin
        if(~resetn)             result_regFive  <= 104'd0;
        else if (resultFive_en) result_regFive   <= tempRes[103:0];
    end
        

     assign resultOne_en  = (showFluffyPonies == 4'd1);
     assign resultTwo_en  = (showFluffyPonies == 4'd2);
     assign resultThree_en  = (showFluffyPonies == 4'd3);
     assign resultFour_en  = (showFluffyPonies == 4'd4);
     assign resultFive_en  = (showFluffyPonies == 4'd5);

       
     assign fullResultSum = {result_regFive, result_regFour, result_regThree, result_regTwo, result_regOne};
      
     assign result = fullResultSum[515:3];
     // 104 bit adder
     reg  carry_inNew;
     always @(posedge clk)
     begin
         if(~resetn)          carry_inNew <= 1'd0;
         else if(showFluffyPonies[3] == 1'd0 && showFluffyPonies != 4'd0 ) carry_inNew <= tempRes[104];
     end
     

     wire [103:0] operandA; 
     wire [103:0] operandB;

//      assign operandA = (showFluffyPonies == 4'b0) ? c_regb[105:2] : 
//     (showFluffyPonies == 4'd1) ? c_regb[209:106] :
//     (showFluffyPonies == 4'd2) ? c_regb[313:210] : 
//     (showFluffyPonies == 4'd3) ? c_regb[417:314] : 
//     c_regb[517:418];

     
     
//      assign operandB = (showFluffyPonies == 4'b0) ? c_regc[105:2] : 
//      (showFluffyPonies == 4'd1) ? c_regc[209:106] : 
//      (showFluffyPonies == 4'd2) ? c_regc[313:210] : 
//      (showFluffyPonies == 4'd3) ? c_regc[417:314] : 
//      c_regc[518:418];

    wire [3:0] subtractFluffyPonies;
    assign subtractFluffyPonies = showFluffyPonies +   (4'b0101 & {subtract, subtract, subtract, subtract});
    
    wire [515:0] resultShiftedThree;
    wire [514:0] subtractionShiftedThree;

     always @(*) 
     begin
        case(subtractFluffyPonies)
            4'b0000 : operandAShift = c_regb[105:2];
            4'b0001 : operandAShift = c_regb[209:106];
            4'b0010 : operandAShift = c_regb[313:210];
            4'b0011 : operandAShift = c_regb[417:314];
            4'b0100 : operandAShift = c_regb[517:418];
            4'b0101 : operandAShift = resultShiftedThree[103:0];
            4'b0110 : operandAShift = resultShiftedThree[207:104];
            4'b0111 : operandAShift = resultShiftedThree[311:208];
            4'b1000 : operandAShift = resultShiftedThree[415:312];
            default : operandAShift = resultShiftedThree[514:416];
            
        endcase
     end
     
     always @(*) 
     begin
        case(subtractFluffyPonies)
            4'b0000 : operandBShift = c_regc[105:2];
            4'b0001 : operandBShift = c_regc[209:106];
            4'b0010 : operandBShift = c_regc[313:210];
            4'b0011 : operandBShift = c_regc[417:314];
            4'b0100 : operandBShift = c_regc[518:418];
            4'b0101 : operandBShift = subtractionShiftedThree[103:0];
            4'b0110 : operandBShift = subtractionShiftedThree[207:104];
            4'b0111 : operandBShift = subtractionShiftedThree[311:208];
            4'b1000 : operandBShift = subtractionShiftedThree[415:312];
            default : operandBShift = subtractionShiftedThree[514:416];
            
        endcase
     end

      

     
     assign resultShiftedThree =  {result, 3'b0}; //so don't have to multiplex for subtraction
     assign subtractionShiftedThree = {subtraction, 3'b111};// this way we can simply load it into the same circuit
     // we used for calculating the final result
     // The reason we shift subtraction with 3 ones is because of LSB, which we want to carry

//     assign operandAShift = (subtract) ? (
//     (showFluffyPonies == 4'd0) ? resultShiftedThree[103:0] :
//     (showFluffyPonies == 4'd1) ? resultShiftedThree[207:104] :
//     (showFluffyPonies == 4'd2) ? resultShiftedThree[311:208] :
//     (showFluffyPonies == 4'd3) ? resultShiftedThree[415:312] :
//     {5'b0, resultShiftedThree[514:416]} //not 515, because that goes into upper bits
//     ): operandA;                                                                                                                                                                                                                                                                                                                                                                                             

//     assign operandBShift = (subtract) ? (
//     (showFluffyPonies == 4'd0) ? subtractionShiftedThree[103:0] :
//     (showFluffyPonies == 4'd1) ? subtractionShiftedThree[207:104] :
//     (showFluffyPonies == 4'd2) ? subtractionShiftedThree[311:208] :
//     (showFluffyPonies == 4'd3) ? subtractionShiftedThree[415:312] :
//     {5'b0, subtractionShiftedThree[514:416]} 
//     ) : operandB;
     

     reg [103:0] reg_opAPipelineQ; // Yoshi's reg for reaching the timing
     always @(posedge clk)
     begin
         if(~resetn)             reg_opAPipelineQ  <= 104'd0;
         else if (showFluffyPonies[3] == 1'b0) reg_opAPipelineQ   <= operandAShift;
     end
     
      
     reg [103:0] reg_opBPipelineQ; 
     always @(posedge clk)
     begin
         if(~resetn)             reg_opBPipelineQ  <= 104'd0;
         else if (showFluffyPonies[3] == 1'b0) reg_opBPipelineQ   <= operandBShift;
     end
     

     
     wire LSBSum;
    
     
     
     assign LSBSum = ((showFluffyPonies == 4'b1) && (subtract)) ||(carry_inNew && (showFluffyPonies != 4'b0 && showFluffyPonies != 4'b1 ));
     //(subtract && showFluffyPonies because our muxout 
     //can't do an add)

     
     assign tempRes = reg_opBPipelineQ + reg_opAPipelineQ + LSBSum; 
     
     // multiplexer to fit tempres into this


     

     
     // but first initialize our cZerowith state register 'r_state_reg' using encoding 'one-hot' in module 'AXI4_S'
     
     wire [519:0] LC1;
     wire [519:0] LB1;
   //  wire [519:0] MC1;
   //  wire [519:0] MB1;
     wire [519:0] RC1;
     wire [519:0] RB1;
          
     wire [519:0] LC2;
     wire [519:0] LB2;
     wire [519:0] RC2;
     wire [519:0] RB2;
     
     wire [519:0] LC3;
     wire [519:0] LB3;
     wire [519:0] RC3;
     wire [519:0] RB3;
          
     wire [519:0] LC4;
     wire [519:0] LB4;
     
     
     wire [519:0] LeftCarryShift = {LC1[518:0], 1'b0};
     //wire [519:0] RightCarryShift = {MC1[518:0], 1'b0};
     wire [519:0] RightCarryRightShift = {RC1[518:0], 1'b0};
     
     wire [519:0] LC2Shift = {LC2[518:0], 1'b0};
     wire [519:0] RC2Shift = {RC2[518:0], 1'b0};
     
     wire [519:0] LC3Shift = {LC3[518:0], 1'b0};
     wire [519:0] RC3Shift = {RC3[518:0], 1'b0};
     
     wire [519:0] LC4Shift = {LC4[518:0], 1'b0};
     
     wire [519:0] B0Pad = {5'b0, B0, 3'b0};
     wire [519:0] B1Pad = {4'b0,B1, 3'b0};
     wire [519:0] B2Pad =  {3'b0,B2, 3'b0};
     wire [519:0] B3Pad = {2'b0,B3, 3'b0};
     wire [519:0] M0Pad = {5'b0, M0, 3'b0};
     wire [519:0] M1Pad = {4'b0,M1, 3'b0};
     wire [519:0] M2Pad = {3'b0, M2, 3'b0};
     wire [519:0] M3Pad = {2'b0,M3, 3'b0};
     
     wire [519:0] C2bPad = {4'b0, c_regb[517:2]};//we've shifted with 2 in the regs, 
                                                 //we now shift with 5 = 2bits lost + 3 bits saved
     wire [519:0] C2cPad = {3'b0, c_regc[518:2]}; //during the addition we add 3 and and then we add 4 due to the algorithm
     // which is supposed to be shifted by 4 every time
     


     


     genvar i;
     generate
     for (i=0; i<=519; i = i+1) begin : do4Adders
    add3 L1 (
        .carry(C2cPad[i]), // upper bit
        .sum(C2bPad[i]), //lower bit of this
        .a(B0Pad[i]),    // input
        .result({LC1[i],LB1[i]}) // C is the output wire in the outer module
    );
    
//    add3 M1 (
//        .carry(B1Pad[i]), // upper bit
//        .sum(M0Pad[i]), //lower bit of this
//        .a(M1Pad[i]),    // input
//        .result({MC1[i],MB1[i]}) // C is the output wire in the outer module
//    );
    
    add3 R1 (
            .carry(B2Pad[i]), // upper bit
            .sum(B1Pad[i]), //lower bit of this
            .a(B3Pad[i]),    // input
            .result({RC1[i],RB1[i]}) // C is the output wire in the outer module
        );
        
    add3 L2 (
        .carry(LeftCarryShift[i]), // upper bit
        .sum(LB1[i]), //lower bit of this
        .a(M1Pad[i]),    // input
        .result({LC2[i],LB2[i]}) // C is the output wire in the outer module
    );
    
    
    add3 R2 (
            .carry(M0Pad[i]), // upper bit
            .sum(RightCarryRightShift[i]), //lower bit of this
            .a(RB1[i]),    // input
            .result({RC2[i],RB2[i]}) // C is the output wire in the outer module
    );    
    
        
        
    add3 L3 (
        .carry(LC2Shift[i]), // upper bit
        .sum(LB2[i]), //lower bit of this
        .a(RC2Shift[i]),    // input
        .result({LC3[i],LB3[i]}) // C is the output wire in the outer module
    );
    
    add3 R3 (
            .carry(RB2[i]), // upper bit
            .sum(M2Pad[i]), //lower bit of this
            .a(M3Pad[i]),    // input
            .result({RC3[i],RB3[i]}) // C is the output wire in the outer module
        );
            
    add3 L4 (
        .carry(LC3Shift[i]), // upper bit
        .sum(LB3[i]), //lower bit of this
        .a(RC3Shift[i]),    // input
        .result({LC4[i],LB4[i]}) // C is the output wire in the outer module
    );
    
    add3 L5 (
            .carry(LC4Shift[i]), // upper bit
            .sum(LB4[i]), //lower bit of this
            .a(RB3[i]),    // input
            .result({C1cOut[i],C1bOut[i]}) // C is the output wire in the outer module
     );
    
    
    
    end
    endgenerate
    

    wire overflow;
    reg upperBitSubtract;
    reg upperBitSubtract_D;

    always @(posedge clk)
    begin
       if (~resetn)        upperBitSubtract<=1'b0;
       else if (showFluffyPonies == 4'd5 && ~subtract)  upperBitSubtract <= tempRes[99];//bit 512 and 513 of the result 
       else if (overflow)                  upperBitSubtract <= upperBitSubtract_D - 1;
        //actually no overflowwith state register 'r_state_reg' using encoding 'one-hot' in module 'AXI4_S'
    end
    
    
    always @(posedge clk)
    begin
        if (~resetn)     upperBitSubtract_D<=2'b0;
        else upperBitSubtract_D <= upperBitSubtract;
    end    
    
    assign overflow = (~tempRes[99] && showFluffyPonies == 4'd5 && subtract);//actually no overflow
    
    assign subtract_finished = (upperBitSubtract_D == 2'b0 && overflow);
    
    
     //assign trueResult = c_regb[511:0]; //we store the to be subtracted value in c_regb, and get our result from there once done   
    assign trueResult = resultReg[511:0];

    
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