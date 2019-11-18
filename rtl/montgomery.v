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
    wire[513:0] in_AddA;
    reg [3:0] showFluffyPonies;
    wire doneAdd;
    wire[511:0] resultAdd;
    wire c_zero;
    reg shiftAdd;
    reg enableC;
    wire carryAdd;
    // Student tasks:
     // 1. Instantiate an Adder
     mpadder dut (
         .shift    (shiftAdd),
         .clk      (clk     ),
         .resetn   (startAdd ),
         .subtract (subtract),
         .in_a     (in_AddA   ),
         .c_zero   (c_zero),
         .trueResult   ({2'b0, resultAdd}  ),
         .enableC  (enableC),
         .showFluffyPonies (showFluffyPonies),
         .done     (doneAdd    ),
         .carry    (carryAdd ));
    // 2. Use the Adder to implement the Montgomery multiplier in hardware.
    // 3. Use tb_montgomery.v to simulate your design.
    //registers for A,M and B
    
    reg          regA_en;
    reg          regA_sh;
    wire [511:0] regA_D;
    reg          regA_Q;
    reg[511:0]   regA_save;
    reg[511:0]   regA_shift;
    always @(posedge clk)
    begin
        if(~ resetn)          regA_Q <= 514'd0;
        else if (regA_en) 
                  begin
                  regA_save <= regA_D;
                  regA_shift <= regA_D;
                  end
         else if (regA_sh)
                  begin
                  regA_shift <= {1'b0,regA_save[511:1]};        
                  regA_Q <= regA_shift[0];
                  end
     end
    
     assign regA_D = in_a; 
    
    reg          regB_en;
    wire [511:0] regB_D;
    reg  [511:0] regB_Q;
    always @(posedge clk)
    begin
        if(~ resetn)          regB_Q <= 514'd0;
        else if (regA_en)   regB_Q <= regB_D;
    end
    
    assign regB_D = in_b; 
    
    reg          regM_en;
    wire [511:0] regM_D;
    reg  [511:0] regM_Q;
    always @(posedge clk)
    begin
        if(~ resetn)          regM_Q <= 514'd0;
        else if (regA_en)   regM_Q <= regA_D;
    end
   
    assign regM_D = in_m; 
    
    
    reg[1:0]    mux_sel;
    reg[513:0]  muxOut; 
    always @(*)
    begin
        if       (mux_sel == 2'b0)  muxOut = {2'b0,regB_Q};
        else if  (mux_sel == 2'b1)  muxOut = {2'b0,regM_Q};
        else                        muxOut = 514'b0;
    end
    assign in_AddA = muxOut; 
    
    reg [3:0] state, nextstate;
    reg [3:0] extraState;
    always @(posedge clk)
    begin
        if(~ resetn)        state <= 4'd0;
        else              state <= nextstate;
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
    
    // This always block was added to ensure the tool doesn't trim away the montgomery module.
    // Feel free to remove [511:1this block
    always @(*)
    begin
       // Idle state; Here the FSM waits for the start signal
       // Enable input registers to fetch the inputs A and B when start is received
          if(state == 4'd0)       
              begin
               regM_en     <= 1'b1;
               regB_en     <= 1'b1;
               regA_en     <= 1'b1;
               regA_sh     <= 1'b0;
               startAdd    <= 1'b0;
               subtract    <= 1'b0;
               mux_sel     <= 2'b0;
               enableC     <= 1'b0;
               shiftAdd    <= 1'b0;
               reset       <= 1'b1;
               countEn     <= 1'b0;
               showFluffyPonies <= 4'd8;
              end
        // firsrt state
          else if(state == 4'd1)       
              begin
               regM_en     <= 1'b1;
               regB_en     <= 1'b1;
               regA_en     <= 1'b1;
               regA_sh     <= 1'b0;
               startAdd    <= 1'b0;
               subtract    <= 1'b0;
               mux_sel     <= 2'b0;
               enableC     <= 1'b0;
               shiftAdd    <= 1'b0;
               reset       <= 1'b0;
               countEn     <= 1'b0;
               showFluffyPonies <= 4'd8;
              end  
          else if(state == 4'd2)       
              begin
               regM_en     <= 1'b0;
               regB_en     <= 1'b0;
               regA_en     <= 1'b0;
               regA_sh     <= 1'b0;
               startAdd    <= 1'b1;
               subtract    <= 1'b0;
               mux_sel     <= 2'b0;
               enableC     <= 1'b1;
               shiftAdd    <= 1'b0;
               reset       <= 1'b0;
               countEn     <= 1'b0;
               showFluffyPonies <= 4'd8;
              end 
          else if(state == 4'd3)       
              begin
               regM_en     <= 1'b0;
               regB_en     <= 1'b0;
               regA_en     <= 1'b0;
               regA_sh     <= 1'b1;
               startAdd    <= 1'b1;
               subtract    <= 1'b0;
               mux_sel     <= 2'b1;
               enableC     <= 1'b1;
               shiftAdd    <= 1'b1;
               reset       <= 1'b0;
               countEn     <= 1'b1;
               showFluffyPonies <= 4'd8;
              end    
          else if(state == 4'd4)       
              begin
               regM_en     <= 1'b0;
               regB_en     <= 1'b0;
               regA_en     <= 1'b0;
               regA_sh     <= 1'b1;
               startAdd    <= 1'b1;
               subtract    <= 1'b0;
               mux_sel     <= 2'd2;
               enableC     <= 1'b1;
               shiftAdd    <= 1'b1;
               reset       <= 1'b0;
               countEn     <= 1'b1;
               showFluffyPonies <= 4'd8;
              end 
          else if(state == 4'd5)       
              begin
               regM_en          <= 1'b0;
               regB_en          <= 1'b0;
               regA_en          <= 1'b0;
               regA_sh          <= 1'b0;
               startAdd         <= 1'b1;//our resetn
               subtract         <= 1'b1;
               mux_sel          <= 2'd1;//select regM_Q
               enableC          <= 1'b0;// I'm setting this to 0 and using the register to save our result
               shiftAdd         <= 1'b0;
               reset            <= 1'b0; //counter reset
               countEn          <= 1'b0;
               showFluffyPonies <= 4'd8;
              end 
          else if(state == 4'd6)       
              begin
               regM_en          <= 1'b1;
               regB_en          <= 1'b1;
               regA_en          <= 1'b1;
               regA_sh          <= 1'b0;
               startAdd         <= 1'b1;
               subtract         <= 1'b0;
               mux_sel          <= 2'd1;
               enableC          <= 1'b1;
               shiftAdd         <= 1'b0;
               reset            <= 1'b0;
               countEn          <= 1'b0;
               showFluffyPonies <= extraState;
              end 
          else if(state == 4'd7)       
              begin
               regM_en          <= 1'b0;
               regB_en          <= 1'b0;
               regA_en          <= 1'b0;
               regA_sh          <= 1'b0;
               startAdd         <= 1'b1; //our resetn
               subtract         <= 1'b0;
               mux_sel          <= 2'd0; //select between M and B
               enableC          <= 1'b1; //shouldn't C be off?
               shiftAdd         <= 1'b0;
               reset            <= 1'b0; //counter reset
               countEn          <= 1'b0;
               showFluffyPonies <= extraState;
              end    
        else 
            begin
             regM_en          <= 1'b0;
             regB_en          <= 1'b0;
             regA_en          <= 1'b0;
             regA_sh          <= 1'b0;
             startAdd         <= 1'b1;
             subtract         <= 1'b0;
             mux_sel          <= 2'd0;
             enableC          <= 1'b1;
             shiftAdd         <= 1'b0;
             reset            <= 1'b0;
             countEn          <= 1'b0;
             showFluffyPonies <= extraState;
            end 
    end
    //next state logic
    always @(*)
    begin
        if(state == 4'd0) begin
           if(start)
                nextstate <= 4'd1;
            else
                nextstate <= 4'd0;
        end
        //begin state 
        else if (state == 4'd1) begin
            if(regA_Q)
                 nextstate <= 4'd2;
             else
                 nextstate <= 4'd4;           
        end
        else if (state == 4'd2) begin
            if(regA_Q || regB_Q[0])
                 if(c_zero)
                    nextstate <= 4'd3;
                 else
                    nextstate <= 4'd4;  
            else
                 if(c_zero^1'b1)
                    nextstate <= 4'd3;
                 else
                    nextstate <= 4'd4;
        end
        else if (state == 4'd3 || state == 4'd4) begin
             if (counter_up[9] == 1) nextstate <= 3'd7; // Go to the end
             else if(regA_Q)
                 nextstate <= 4'd2;
             else
                 if(c_zero)
                    nextstate <= 4'd3;
                 else
                    nextstate <= 4'd4;   
            end
            
            else if (state == 4'd7) begin
               if(extraState == 4'd0)  extraState<= 4'd1;
               else if( extraState == 4'd1)   extraState<= 4'd2;
               else if( extraState == 4'd2)   extraState<= 4'd3;
               else if( extraState == 4'd3)   extraState<= 4'd4;
               else if( extraState == 4'd4)
                   begin 
                       nextstate  <= 4'd5;
                       extraState <= 4'd0;
                  end
                else nextstate <= 4'd0;
           end
            
            
            
            
         else if (state == 4'd5)
            begin
                if (carryAdd == 1) nextstate <= 4'd6; //carryAdd is our subtract finished
                if(extraState == 4'd0)  extraState<= 4'd1;
               else if( extraState == 4'd1)   extraState<= 4'd2;
               else if( extraState == 4'd2)   extraState<= 4'd3;
               else if( extraState == 4'd3)   extraState<= 4'd4;
               else if( extraState == 4'd4)
               begin 
                   nextstate  <= 4'd8;
                   extraState <= 4'd0;
               end
            end
            
         //else if (state == 4'd6) nextstate <= 4'd8;
         

    else if (state == 3'd6) nextstate <= 3'd0; 
   end
    assign result = resultAdd;
    
    assign done = (state ==  4'd8) ? 1:0;
endmodule