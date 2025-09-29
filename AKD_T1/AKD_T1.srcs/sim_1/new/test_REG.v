`timescale 1ns / 1ps
module test_REG(
    output[31:0] result1_reg, result2_reg
);
    reg clk, rst, ena_low;
    reg[4:0] raddr1, raddr2, waddr;
    reg[31:0] regdata;
    REG #(32, 32) REG(
    .clk(clk),
    .rst(rst),
    .ena_low(ena_low),
    .raddr1(raddr1),
    .raddr2(raddr2),
    .waddr(waddr),
    .regdata(regdata),
    .result1_reg(result1_reg),
    .result2_reg(result2_reg)
);
    initial begin
        clk = 0;
        rst = 1;
        ena_low = 1;
        raddr1 = 1;
        raddr2 = 2;
        waddr = 1;
        regdata = 3;
        #0.5 rst = 0;
        #0.5 clk = 1;
        #0.5 clk = 0;
        waddr = 2;
        regdata = 5;
        #0.5 clk = 1;
        #2 $finish();
    end
endmodule
