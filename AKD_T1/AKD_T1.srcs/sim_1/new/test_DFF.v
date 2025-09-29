`timescale 1ns / 1ps
module test_DFF(
    output Q
);
    reg data, clk, rst;
    DFF DFF(data, clk, rst, Q);
    initial begin
        rst = 0;
        clk = 0;
        data = 0;
        #1 rst = 1;
        #1 rst = 0;
        #5 $finish();
    end
endmodule
