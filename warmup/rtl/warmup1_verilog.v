`timescale 1ns / 1ps

module warmup1_verilog(
    input wire clk,
    input wire resetn,
    output wire [3:0] a_out,
    output wire [3:0] b_out,
    output wire [3:0] c_out
    );

// Counter circuit
reg [3:0] cnt;
always @(posedge clk)
    if (resetn==0)
        cnt <= 0;
    else
        cnt <= cnt + 1;

// TASK 1: Simulate this design
// 1. Set "tb_warmup1_verilog" as top inside the project manager
// 2. Click on "Simulation | Run Simulation"
//
// QUESTION 1: Why is there a one-cycle delay for storing new values inside "b" (when compared to "a") ?
// Are both "a" and "b" flip-flops, or only "b"?

reg [3:0] a;
always @(*)
    if (resetn==0)
        a <= 0;
    else
    begin
        if (cnt==0)
            a <= 0;
        else if (cnt==1)
            a <= 1;
        else
            a <= 2;
    end

reg [3:0] b;
always @(posedge clk)
    if (resetn==0)
        b <= 0;
    else
    begin
        if (cnt==0)
            b <= 0;
        else if (cnt==1)
            b <= 1;
        else
            b <= 2;
    end

assign a_out = a;
assign b_out = b;

// TASK2: The following circuit produces a latch.
// 1. Notice that you cannot see the latch error in Simulation
// 2. Verify that you can see the latch error using "Synthesis | Run Synthesis".
// 3. Remove the latch by updating the code below (If it's not clear to you how to do this, consult the slides/TA
// 4. Verify that the latch was removed by running "Synthesis | Run Synthesis".

reg [3:0] c;
always @(*)
    if (resetn==0)
        c <= 0;
    else
    begin
        if (cnt==0)
            c <= 0;
        else if (cnt==1)
            c <= 1;
        else if (cnt==2)
            c <= 2;
    end

assign c_out = c;

endmodule
