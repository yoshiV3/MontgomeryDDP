`timescale 1ns / 1ps


module exponentiation(
    input clk,
    input resetn,
    input startExponentiation,
    input [511:0] modulus,
    input [511:0] Rmodm, // We assume these stick around for at least the first state
    input [511:0] Rsquaredmodm,
    input [511:0] exponent,
    input [511:0] x,
    //Montgomery Multiplication mode
    input         multiplication_enable,
    
    output done,
    output [511:0] A_result
    );
    wire          resetnMont;
    reg          start;
    wire  [511:0] in_a;
    wire  [511:0] in_b;
    wire  [511:0] in_m;
    wire [511:0] result;
    wire montgomeryDone;
    
    assign in_m = modulus;
    
    reg select_a;
    reg [1:0] select_b;
        
    
    reg   [511:0] A;
    reg           A_en;
    reg           A_Rmodm;
    always @(posedge clk)
    begin
    if (~resetn)
        A <=512'b0;
    else if (A_en)
        if (A_Rmodm == 1'b1)
            A <= Rmodm;
        else if (montgomeryDone)
            A <= result;    
    end
    
    assign A_result = A;
    

    
    
    
    reg startMont;
    always @(posedge clk)
    begin
        if (~resetn)
            startMont <= 1'b0;
        else if (start)
            startMont <= 1'b1;
        else
            startMont <= 1'b0;
    end
    
    assign resetnMont = resetn && (~start || startMont); // reset if resetn is 0 or if start and not startMont yet
    // resetnMont is negative
    
  
    
     montgomery montgomery_instance( .clk    (clk      ),
                                    .resetn (resetnMont   ),
                                    .start  (startMont    ),
                                    .in_a   (in_a     ),
                                    .in_b   (in_b     ),
                                    .in_m   (in_m     ),
                                    .result (result   ),
                                    .done   (montgomeryDone     ));
    
    
    
    wire eZero;
    
    
    
    
    reg [511:0] xDash;
    always @(posedge clk)
    begin
    if (~resetn)
        xDash <= 512'b0;
    else if (select_a && montgomeryDone) //select a is used to determine whether we're on state == 1
        xDash <= result;
    end
    
    reg R2_en;
    
    
    reg [511:0] Rsquaredmodm_reg;
    always @(posedge clk)
    begin
        if (~resetn || montgomeryDone) //if we're no longer in begin mode, set to 0 so we can OR
            Rsquaredmodm_reg <= 511'b0;
        else if (R2_en)
            Rsquaredmodm_reg <= Rsquaredmodm;
    end

    
    
    
    wire [511:0] xDashOrR2mod = Rsquaredmodm_reg | xDash;
    
    assign in_a = select_a ? x : A;
    assign in_b = (select_b == 2'd0) ? xDashOrR2mod :
    (select_b == 2'd1) ? A :
    512'd1;
    
    //reg xdash
    
    
    
    
    wire shift;
    
    
    
    
    reg [8:0] count;
    always @(posedge clk)
    begin
        if(~resetn)
            count <= 9'b0;
        else if (shift)
            count <= count + 1;
    end
    
    reg initial_shift;
    
    
    
    
    reg exponent_en;
    reg [511:0] exponent_reg;
    reg exponent_shift;
    always @(posedge clk)
    begin
        if(~resetn)
            exponent_reg <= 9'b0;
        else if (exponent_en)
            exponent_reg <= exponent;
        else if (shift)
            exponent_reg <= {exponent_reg[510:0], 1'b0};
    end
    
    assign eZero = exponent_reg[511];
    assign shift = exponent_shift || (initial_shift && ~eZero);

    
    reg [2:0] state, nextstate;
    always @(posedge clk)
    begin
        if(~resetn)
        begin        
        state <= 3'd0;
        end
        else
        begin              
        state <= nextstate;
        end
    end     
    


    
    always @(*)
    begin
        
        if (state ==3'd0)
            begin
                exponent_en <= 1'b1;
                initial_shift <= 1'b0;
                A_en <= 1'b1;
                A_Rmodm <= 1'b1;
                select_a <= 1'b1;
                select_b <= 2'd0;
                R2_en <= 1'b1;
            end
        
        else if (state ==3'd1)
            begin
                exponent_en <= 1'b0;
                initial_shift <= 1'b1;
                A_en <= 1'b1;
                A_Rmodm <= 1'b1;
                select_a <= 1'b1;
                select_b <= 2'd0;            
                R2_en <= 1'b0;
            end
        
        else if (state ==3'd2)
            begin
                exponent_en <= 1'b0;
                initial_shift <= 1'b0;
                A_en <= 1'b1;
                A_Rmodm <= 1'b0;
                select_a <= 1'b0;
                select_b <= 2'd1;
                R2_en <= 1'b0;            
            end
            
        else if (state ==3'd3)
            begin
                exponent_en <= 1'b0;
                initial_shift <= 1'b0;
                A_en <= 1'b1;
                A_Rmodm <= 1'b0;
                select_a <= 1'b0;
                select_b <= 2'd0;
                R2_en <= 1'b0;            
            end
            
        else if (state ==3'd4)
            begin
                exponent_en <= 1'b0;
                initial_shift <= 1'b0;
                A_en <= 1'b1;
                A_Rmodm <= 1'b0;
                select_a <= 1'b0;
                select_b <= 2'd3;
                R2_en <= 1'b0;            
            end
            
            else if (state ==3'd6) //use state 1 and remove this if you want to save space
                begin
                    exponent_en <= 1'b0;// honestly don't care, but whatever
                    initial_shift <= 1'b0;// honestly don't care, but whatever
                    A_en <= 1'b1;
                    A_Rmodm <= 1'b0; // honestly don't care, but whatever
                    select_a <= 1'b1;
                    select_b <= 2'd0;
                    R2_en <= 1'b0;            
                end
            
        else //if (state ==3'd5)
            begin
                exponent_en <= 1'b0;
                initial_shift <= 1'b0;
                A_en <= 1'b0;
                A_Rmodm <= 1'b0;
                select_a <= 1'b0; //don't care
                select_b <= 2'b0;
                R2_en <= 1'b0;            
            end
        
        
    end
    
    
    
    reg montgomeryDoneFirstTime;
    always @(posedge clk)
    begin
        if (~resetn)
            montgomeryDoneFirstTime <= 1'b0;
        else if (montgomeryDone)
            montgomeryDoneFirstTime <= 1'b1;
    end
 
    
    
    always @(*)
    begin
    if (state == 3'd0)
    begin
        exponent_shift <= 1'b0;
        start <= 1'b0;
        if (startExponentiation && ~multiplication_enable)
            begin
            nextstate <= 3'd1;
            end
        else if (startExponentiation && multiplication_enable)
            begin
            nextstate <= 3'd6;
            end
        else
            begin
            nextstate <= 3'd0;
            end
    end 
    else if (state == 3'd1)
    begin
        exponent_shift <= 1'b0;
        if (~(montgomeryDoneFirstTime && eZero))
            begin
            start <= 1'b1;
            nextstate <= 3'd1;
            end
        else
            begin
            start <= 1'b0;
            nextstate <= 3'd2;
            end
    end
    else if (state == 3'd2)
    begin
        if (~montgomeryDone)
            begin
            start <= 1'b1;
            nextstate <= 3'd2;
            exponent_shift <= 1'b0;
            end
        else if (eZero==1'b1)
            begin
            start <= 1'b0;
            nextstate <= 3'd3;
            exponent_shift <= 1'b0;
            end
        else if (count == 9'd511)
            begin
            start <= 1'b0;
            nextstate <= 3'd4;
            exponent_shift <= 1'b0;
            end
        else
            begin
            start <= 1'b0;
            nextstate <= 3'd2;
            exponent_shift <= 1'b1;
            end
    end
    else if (state == 3'd3)
    begin
        if (~montgomeryDone)
            begin
            start <= 1'b1;
            nextstate <= 3'd3;
            exponent_shift <= 1'b0;
            end
        else if (count == 9'd511)
            begin
            start <= 1'b0;
            exponent_shift <= 1'b0;
            nextstate <= 3'd4;
            end
        else
            begin
            start <= 1'b0;
            exponent_shift <= 1'b1;
            nextstate <= 3'd2;
            end
    end
    else if (state == 3'd4)
    begin
        exponent_shift <= 1'b0;
        if (~montgomeryDone)
            begin
            start <= 1'b1;
            nextstate <= 3'd4;
            end
        else
            begin
            nextstate <= 3'd5;
            start <= 1'b0;
            end
    end
    else if (state == 3'd6)
    begin
        exponent_shift <=1'b0;
        if (~montgomeryDone)
            begin
            start <= 1'b1;
            nextstate <= 3'd6;
            end
        else
            begin
            nextstate <= 3'd5;
            start <= 1'b0;
            end
    
    end
    else
    begin
        start <= 1'b0;
        exponent_shift <= 1'b0;
        nextstate <= 3'd0;
    end
    end
    
    assign done = (state == 3'd5);
endmodule
