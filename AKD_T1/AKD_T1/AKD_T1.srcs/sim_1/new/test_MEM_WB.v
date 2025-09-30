`timescale 1ns / 1ps
module test_MEM_WB(
    output[63:0] detector
);
    reg clk, rst, wea;
    reg[63:0] pipe_WB_prev;
    MEM_WB #(64) MEM_WB(
        .clk(clk),
        .rst(rst),
        .wea(wea),
        .pipe_WB_prev(pipe_WB_prev),
        .pipe_WB(detector)
    );
    initial begin
        clk = 0;
        rst = 0;
        wea = 0;
        pipe_WB_prev = 1;
        #1 rst = 1;
        #5 $finish();
    end
endmodule
