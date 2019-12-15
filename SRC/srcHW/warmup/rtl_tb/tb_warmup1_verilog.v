`timescale 1 ps / 1 ps

module tb_warmup1_verilog();

    reg clk;
    reg resetn;
    wire [3:0] a_out;
    wire [3:0] b_out;
    wire [3:0] c_out;

    warmup1_verilog dut (
        .clk    (clk     ),
        .a_out  (a_out   ),
        .b_out  (b_out   ),
        .c_out  (c_out   ),
        .resetn (resetn  ));


    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        resetn = 0;
        #20 resetn = 1;
    end

endmodule
