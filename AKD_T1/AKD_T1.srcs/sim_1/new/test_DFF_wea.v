`timescale 1ns / 1ps
module test_DFF_wea(
    output Q
);
    reg datain, clk, rst, wea;
    DFF_wea DFF_wea(datain, clk, rst, wea, dataout);
    initial begin
        datain = 1;
        clk = 0;
        rst = 0;
        wea = 0;
        #1 rst = 1;
        #1 rst = 0;
        #5 $finish();
    end
endmodule
