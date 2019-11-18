`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 08/22/2018 10:43:00 AM
// Design Name:
// Module Name: tb_mpadder
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

`define RESET_TIME 25
`define CLK_PERIOD 10
`define CLK_HALF 5

module tb_warmup2_mpadder();

    // Define internal regs and wires
    reg          clk;
    reg          reset;
    reg          instart;
    reg  [127:0] inA;
    reg  [127:0] inB;
    wire [128:0] outC;
    wire         outdone;

    warmup2_mpadder dut(
        clk,
        reset,
        instart,
        inA,
        inB,
        outC,
        outdone);

    // Generate Clock
    initial begin
        clk = 0;
        forever #`CLK_HALF clk = ~clk;
    end

    initial begin

        reset <= 1'b1;
        inA   <= 128'h0;
        inB   <= 128'h0;

        #`RESET_TIME

        reset <= 1'b0;

        #`CLK_PERIOD;


        inA     <= 128'hcbc87cf0da4497687834fad762e4fa0d;
        inB     <= 128'h88f32f2f5b948a6ccf335529fa86ee6c;
        instart <= 1'b1;
        #`CLK_PERIOD;
        instart <= 1'b0;

    end

endmodule
