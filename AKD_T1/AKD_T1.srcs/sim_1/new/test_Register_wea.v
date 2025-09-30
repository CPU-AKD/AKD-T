`timescale 1ns / 1ps
module test_Register_wea(
    output[31:0] dataout
);
    reg[31:0] datain;
    reg clk, rst, wea;
    Register_wea #(32) Register_wea(
        clk, rst, wea, datain, dataout
    );
    initial begin
        clk = 0;
        rst = 0;
        wea = 0;
        datain = 1;
        #1 rst = 1;
        #1 rst = 0;
        #5 $finish();
    end
endmodule
