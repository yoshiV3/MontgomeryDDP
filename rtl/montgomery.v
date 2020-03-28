`timescale 1ns / 1ps

module montgomery(
    input          clk,
    input          resetn,
    input          start,
    input  [511:0] in_a,
    input  [511:0] in_b,
    input  [511:0] in_m,
    output [511:0] result,  
    output         done
     );
 
 
    reg     startAdd;
    reg     subtract;
    reg [3:0] showFluffyPonies;
    wire[511:0] resultAdd;
    wire [7:0] c_prediction;
    //reg enableC;
    wire carryAdd;
    
    wire [511:0] B0;
    wire [512:0] B1;
    wire [513:0] B2;
    wire [514:0] B3;
    wire [511:0] M0;
    wire [512:0] M1;
    wire [513:0] M2;
    wire [514:0] M3;
    
    
    reg C_doubleshift;
    
    wire [511:0] negativeM;
    // Student tasks:
     // 1. Instantiate an Adder
     mpadder dut (

         .clk      (clk     ),
         .resetn   (startAdd ),
         .subtract (subtract),
         .B0     (B0),
         .B1     (B1),
         .B2     (B2),
         .B3     (B3),
         .M0     (M0),
         .M1     (M1),
         .M2     (M2),
         .M3     (M3),
         .subtraction   (negativeM),
         .c_doubleshift (C_doubleshift),
         .cPrediction (c_prediction),
         .trueResult   (resultAdd),
         //.enableC  (enableC),
         .showFluffyPonies (showFluffyPonies),
         .subtract_finished    (carryAdd ));
    // 2. Use the Adder to implement the Montgomery multiplier in hardware.
    // 3. Use tb_montgomery.v to simulate your design.
    //registers for A,M and B
    
    wire M0Select;
    wire M1Select;
    wire M2Select;
    wire M3Select;
    
    
    
    
    

    reg          regA_sh;
    wire [511:0] regA_D;
    reg[511:0]   regA_shift;

    always @(posedge clk)
    begin
        if(~ resetn)    begin
              regA_shift <= 512'd0;
        end
        else if (~regA_sh) 
                  begin
                  regA_shift <= regA_D;
                  end
         else
                  begin
                  regA_shift <= {4'b0,regA_shift[511:4]};        
                  end
     end
    
 
     assign regA_D = in_a; 
    
    

    wire [511:0] regB_D;
    reg  [511:0] regB_Q;
    always @(posedge clk)
    begin
        if(~ resetn)          regB_Q <= 514'd0;
        else if (~regA_sh)   regB_Q <= regB_D;
    end
    
    assign regB_D = in_b; 

    wire [511:0] regM_D;
    reg  [511:0] regM_Q;
    always @(posedge clk)
    begin
        if(~ resetn)          regM_Q <= 514'd0;
        else if (~regA_sh)   regM_Q <= regM_D;
    end
   
    assign regM_D = in_m; 
    
    

 
 
    assign negativeM =  ~regM_Q;   //WE BROKE AN ADD A PLUS ONE (we will add in the adder)
    // We no longer shift, so no more: //Also shift left the subtraction, which is why we add a one after shifting
    
    
    
        
//    assign M0Select = (c_zero ^ (regB_Q[0] & regA_shift[0]));
//    assign M0Carry = (c_zero & regB_Q[0]& regA_shift[0]) | (regM_Q[0] & M0Select & regB_Q[0]& regA_shift[0]) | (regM_Q[0] & M0Select & c_zero);
//    assign M1Select = M0Carry ^ c_one ^ (regA_shift[0] & regB_Q[1]) ^ (regM_Q[1] & M0Select) ^ (regA_shift[1] & regB_Q[0]);
    wire [8:0] tempSum0;
    wire [9:0] tempSum1;
    wire [9:0] tempSum2;
    wire [9:0] tempSum3;
    wire [5:0] tempSum4;
    wire [5:0] tempSum5;
    wire [5:0] tempSum6;
    wire [5:0] tempSum7;
    wire [3:0] resultSum;
    wire M0NextCycle;
    wire M1NextCycle;
    wire M2NextCycle;
    wire M3NextCycle;
    
    
    assign tempSum0 = c_prediction + (regB_Q[7:0] &  {regA_shift[0], regA_shift[0], regA_shift[0], regA_shift[0], regA_shift[0], regA_shift[0], regA_shift[0], regA_shift[0]});
    assign M0Select = tempSum0[0];
    assign tempSum1 = ((tempSum0 + (regM_Q[7:0] & {M0Select, M0Select, M0Select, M0Select, M0Select, M0Select, M0Select, M0Select}))>> 1) + (regB_Q[6:0] &  {regA_shift[1], regA_shift[1], regA_shift[1], regA_shift[1], regA_shift[1], regA_shift[1], regA_shift[1], regA_shift[1]});
    assign M1Select = tempSum1[0];
    assign tempSum2 = ((tempSum1 + (regM_Q[6:0] & {M1Select, M1Select, M1Select, M1Select, M1Select, M1Select, M1Select, M1Select}))>> 1) + (regB_Q[5:0] &  {regA_shift[2], regA_shift[2], regA_shift[2], regA_shift[2], regA_shift[2], regA_shift[2], regA_shift[2], regA_shift[2]});
    assign M2Select = tempSum2[0];
    assign tempSum3 = ((tempSum2 + (regM_Q[5:0] & {M2Select, M2Select, M2Select, M2Select, M2Select, M2Select, M2Select, M2Select}))>> 1) + (regB_Q[4:0] &  {regA_shift[3], regA_shift[3], regA_shift[3], regA_shift[3], regA_shift[3], regA_shift[3], regA_shift[3], regA_shift[3]});
    assign M3Select = tempSum3[0];
    assign resultSum = ((tempSum3 + (regM_Q[4:0] & {M3Select, M3Select, M3Select, M3Select, M3Select, M3Select, M3Select, M3Select}))>> 1);
    
    assign tempSum4 = resultSum + (regB_Q[3:0] &  {regA_shift[4], regA_shift[4], regA_shift[4], regA_shift[4]});
    assign M0NextCycle = tempSum4[0];
    assign tempSum5 = ((tempSum4 + (regM_Q[3:0] & {M0NextCycle, M0NextCycle, M0NextCycle, M0NextCycle}))>> 1) + (regB_Q[2:0] &  {regA_shift[5], regA_shift[5], regA_shift[5]});
    assign M1NextCycle = tempSum5[0];
    assign tempSum6 = ((tempSum5 + (regM_Q[2:0] & {M1NextCycle, M1NextCycle, M1NextCycle, M1NextCycle}))>> 1) + (regB_Q[1:0] &  {regA_shift[6], regA_shift[6]});
    assign M2NextCycle = tempSum6[0];
    assign tempSum7 = ((tempSum6 + (regM_Q[1:0] & {M2NextCycle, M2NextCycle, M2NextCycle, M2NextCycle}))>> 1) + (regB_Q[0] &  {regA_shift[7]});
    assign M3NextCycle = tempSum7[0];

    reg [511:0] M0_reg;
    always @(posedge clk)
    begin
        if (~resetn || (~M0Select & ~regA_sh) || (~M0NextCycle & regA_sh)) 
            M0_reg <= 512'b0;
        else 
            M0_reg<= regM_Q;
    end
    
    reg [511:0] M1_reg;
    always @(posedge clk)
    begin
        if (~resetn || (~M1Select & ~regA_sh) || (~M1NextCycle & regA_sh))
            M1_reg <= 512'b0;
        else 
            M1_reg<= regM_Q;
    end
    reg [511:0] M2_reg;
    always @(posedge clk)
    begin
        if (~resetn || (~M2Select & ~regA_sh) || (~M2NextCycle & regA_sh))
            M2_reg <= 512'b0;
        else 
            M2_reg<= regM_Q;
    end
    
    reg [511:0] M3_reg;
    always @(posedge clk)
    begin
        if (~resetn || (~M3Select & ~regA_sh) || (~M3NextCycle & regA_sh))
            M3_reg <= 512'b0;
        else 
            M3_reg<= regM_Q;
    end     
    
//    genvar i;
//    generate
//    for (i=0; i<=511; i = i+1) begin : multiplexWithZeroIsAnd
////    assign B0[i] = regA_shift[0] & regB_Q[i];
////    assign B1[i+1] = regA_shift[1] & regB_Q[i]; //We automatically shift
//    assign M0[i] = M0Select & regM_Q[i];
//    assign M1[i+1] = M1Select & regM_Q[i]; //We automatically shift
//    assign M2[i+2] = M2Select & regM_Q[i];
//    assign M3[i+3] = M3Select & regM_Q[i]; //We automatically shift
//    end
//    endgenerate

    assign M0[511:0] = M0_reg;
    assign M1[512:1] = M1_reg;
    assign M2[513:2] = M2_reg;
    assign M3[514:3] = M3_reg;
    
//    assign B1[0] = 1'b0; //shifted left so we can shift right twice at the end
    assign M1[0] = 1'b0;
    assign M2[1:0] = 2'b0;
    assign M3[2:0] = 3'b0;
    
    reg [511:0] B0_reg;
    always @(posedge clk)
    begin
        if (~resetn || (~regA_D[0] & ~regA_sh) || (~regA_shift[4] & regA_sh))
            B0_reg <= 512'b0;
        else
            B0_reg <= regB_Q;
    end
    
    reg [512:0] B1_reg;
    always @(posedge clk)
    begin
        if (~resetn || (~regA_D[1] & ~regA_sh) || (~regA_shift[5] & regA_sh))
            B1_reg <= 513'b0;
        else
            B1_reg <= {regB_Q, 1'b0};
    end
    
    reg [513:0] B2_reg;
    always @(posedge clk)
    begin
        if (~resetn || (~regA_D[2] & ~regA_sh) || (~regA_shift[6] & regA_sh))
            B2_reg <= 514'b0;
        else
            B2_reg <= {regB_Q, 2'b0};
    end
    
    reg [514:0] B3_reg;
    always @(posedge clk)
    begin
        if (~resetn || (~regA_D[3] & ~regA_sh) || (~regA_shift[7] & regA_sh))
            B3_reg <= 515'b0;
        else
            B3_reg <= {regB_Q, 3'b0};
    end
    
    assign B0 = B0_reg;
    assign B1 = B1_reg;
    assign B2 = B2_reg;
    assign B3 = B3_reg;

    
    reg [3:0] state, nextstate;
    reg [3:0] extraState;
    reg [3:0] extraStateNext;
    always @(posedge clk)
    begin
        if(~ resetn)
        begin        
        state <= 4'd0;
        extraState <= 4'd0;
        end
        else
        begin              
        state <= nextstate;
        extraState <= extraStateNext;
        end
    end  
    
    reg [9:0] counter_up;
    reg countEn;
    reg reset;
    always @(posedge clk)
    begin
    if(~resetn || reset)
     counter_up <= 10'd0;
    else if(countEn)
     counter_up <= counter_up + 10'd1;
    end
    
    //reg [511:0] debug;
    // This always block was added to ensure the tool doesn't trim away the montgomery module.
    // Feel free to remove [511:1this block
    always @(*)
    begin
       // Idle state; Here the FSM waits for the start signal
       // Enable input registers to fetch the inputs A and B when start is received
          if(state == 4'd0)       
              begin
               regA_sh     <= 1'b0;
               startAdd    <= 1'b0;
               subtract    <= 1'b0;
               //enableC     <= 1'b0;
               reset       <= 1'b1;
               countEn     <= 1'b0;
               showFluffyPonies <= 4'd8;
               C_doubleshift <= 1'b0;
               
              end
          else if(state == 4'd1)// Identical to the zero statem just to give us some breathing space       
            begin

             regA_sh     <= 1'b0;
             startAdd    <= 1'b0;
             subtract    <= 1'b0;
             //enableC     <= 1'b0;
             reset       <= 1'b1;
             countEn     <= 1'b0;
             showFluffyPonies <= 4'd8;
             C_doubleshift <= 1'b0;
             
            end
              
        // firsrt state
//          else if(state == 4'd1)       
//              begin
//               regM_en     <= 1'b1;
//               regB_en     <= 1'b1;
//               regA_en     <= 1'b1;
//               regA_sh     <= 1'b0;
//               startAdd    <= 1'b0;
//               subtract    <= 1'b0;
//               enableC     <= 1'b0;
//               reset       <= 1'b0;
//               countEn     <= 1'b0;
//               showFluffyPonies <= 4'd8;
//               C_doubleshift <= 1'b0;
//              end  
//          else if(state == 4'd2)       
//              begin
//               regM_en     <= 1'b0;
//               regB_en     <= 1'b0;
//               regA_en     <= 1'b0;
//               regA_sh     <= 1'b0;
//               startAdd    <= 1'b1;
//               subtract    <= 1'b0;
//               mux_sel     <= 2'b0;
//               enableC     <= 1'b1;
//               shiftAdd    <= 1'b0;
//               reset       <= 1'b0;
//               countEn     <= 1'b0;
//               showFluffyPonies <= 4'd8;
//              end 
          else if(state == 4'd3)       
              begin

               regA_sh     <= 1'b1; //We shift every cycle
               startAdd    <= 1'b1;
               subtract    <= 1'b0;
               //enableC     <= 1'b1;
               reset       <= 1'b0;
               countEn     <= 1'b1;
               showFluffyPonies <= 4'd8;
               C_doubleshift <= 1'b1;
              end    
//          else if(state == 4'd4)       
//              begin
//               regM_en     <= 1'b0;
//               regB_en     <= 1'b0;
//               regA_en     <= 1'b0;
//               regA_sh     <= 1'b1;
//               startAdd    <= 1'b1;
//               subtract    <= 1'b0;
//               mux_sel     <= 2'd2;
//               enableC     <= 1'b1;
//               shiftAdd    <= 1'b1;
//               reset       <= 1'b0;
//               countEn     <= 1'b1;
//               showFluffyPonies <= 4'd8;
//              end 
//          else if(state == 4'd6)       
//                  begin
//                   regM_en     <= 1'b0;
//                   regB_en     <= 1'b0;
//                   regA_en     <= 1'b0;
//                   regA_sh     <= 1'b0;
//                   startAdd    <= 1'b1;
//                   subtract    <= 1'b0;
//                   mux_sel     <= 2'd2;
//                   enableC     <= 1'b1;
//                   shiftAdd    <= 1'b0;
//                   reset       <= 1'b0;
//                   countEn     <= 1'b0;
//                   showFluffyPonies <= 4'd8;
//                  end 
          else if(state == 4'd5)       
              begin
               regA_sh          <= 1'b0;
               startAdd         <= 1'b1;//our resetn
               subtract         <= 1'b1;
               //enableC          <= 1'b0;// I'm setting this to 0 and using the register to save our result
               reset            <= 1'b0; //counter reset
               countEn          <= 1'b0;
               showFluffyPonies <= extraState;
               C_doubleshift <= 1'b0;
              end 
          else if(state == 4'd7)       
              begin
               regA_sh          <= 1'b0;
               startAdd         <= 1'b1; //our resetn
               subtract         <= 1'b0;
               //enableC          <= 1'b0; //shouldn't C be off?
               reset            <= 1'b0; //counter reset
               countEn          <= 1'b0;
               showFluffyPonies <= extraState;
               C_doubleshift <= 1'b0;
              end    
         else 
            begin
             regA_sh          <= 1'b0;
             startAdd         <= 1'b1;
             subtract         <= 1'b0;
             //enableC          <= 1'b1;
             reset            <= 1'b0;
             countEn          <= 1'b0;
             showFluffyPonies <= extraState;
             C_doubleshift <= 1'b0;
            end 
    end
    //next state logic

    always @(*)
    begin
        if(state == 4'd0) begin
            extraStateNext <= 4'd8;
           if(start)
                nextstate <= 4'd1;
            else
                nextstate <= 4'd0;
        end
        
        
        else if(state == 4'd1) begin
           extraStateNext <= 4'd8;
           nextstate <= 4'd3;
        end
        
//        //begin state 
//        else if (state == 4'd1) begin
//            extraStateNext <= 4'd8;
//            if(regA_Q)
//                 nextstate <= 4'd2;
//             else
//                 nextstate <= 4'd4;           
//        end

        
        else if (state == 4'd3) begin
             if (counter_up == 10'd127) //switch 9
             begin
                nextstate <= 4'd7; // Go to the end
                extraStateNext <= 4'd0;
             end
             else 
             begin
                 nextstate <= 4'd3; // Go to the end
                 extraStateNext <= 4'd8;
             end
             

        end
        
//        else if (state == 4'd6) begin
//            extraStateNext <= 4'd8;
//            if (c_zero) nextstate <= 4'd3;
//            else        nextstate <= 4'd4;
//        end
        
        
//        else if (state == 4'd4) begin
//             if (counter_up == 10'd511) //switch 9
//             begin
//                nextstate <= 4'd7; // Go to the end
//                extraStateNext <= 4'd0;
//             end
//             else if(regA_shift[1]) 
//             begin
//             nextstate <= 4'd2;
//             extraStateNext <= 4'd8;
//             end
//             else
//             begin
//                 extraStateNext <= 4'd8;
//                 if(c_one)
//                    nextstate <= 4'd3;
//                 else
//                    nextstate <= 4'd4;   
//             end
//        end      
              
            else if (state == 4'd7) begin
               //debug <= 512'hdeadbeef;
                 if(extraState == 4'd0)  
                 begin
                 extraStateNext<= 4'd1;
                 nextstate <= 4'd7;
                 end
               else if( extraState == 4'd1) begin   extraStateNext<= 4'd2; nextstate <= 4'd7; end
               else if( extraState == 4'd2) begin  extraStateNext<= 4'd3; nextstate <= 4'd7; end
               else if( extraState == 4'd3) begin extraStateNext<= 4'd4; nextstate <= 4'd7; end
               else if( extraState == 4'd4) begin extraStateNext<= 4'd5; nextstate <= 4'd7; end
               else if( extraState == 4'd5)
                   begin 
                       nextstate  <= 4'd5;  //CHANGE TO FIVE
                       extraStateNext <= 4'd0;
                  end
               else
               begin
                 extraStateNext <= 4'd8;
                 nextstate <= 4'd0;
               end
             end
            
         else if (state == 4'd5)   begin

                if (carryAdd == 1'b1) begin nextstate <= 4'd8; extraStateNext<= 4'd8; end //carryAdd is our subtract finished What does this line do????
               else if(extraState == 4'd0)  begin extraStateNext<= 4'd1; nextstate <= 4'd5; end
               else if( extraState == 4'd1) begin extraStateNext<= 4'd2; nextstate <= 4'd5; end
               else if( extraState == 4'd2) begin extraStateNext<= 4'd3; nextstate <= 4'd5; end
               else if( extraState == 4'd3) begin extraStateNext<= 4'd4; nextstate <= 4'd5; end
               else if( extraState == 4'd4) begin extraStateNext<= 4'd5; nextstate <= 4'd5; end
               else if( extraState == 4'd5)
               begin 
                   nextstate  <= 4'd5; //TODO set back to 5
                   extraStateNext <= 4'd0;
               end
               else
               begin
                 extraStateNext <= 4'd8;
                 nextstate <= 4'd0;
               end
            end
         else 
         begin
         nextstate <= 4'd0;
         extraStateNext <= 4'd8;
         end
          
    end
         
    assign result = resultAdd; //trueResult
    
    assign done = (state ==  4'd8);
endmodule