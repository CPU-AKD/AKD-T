module DFF(
    input data, clk, rst,
    output Q
);
    wire Qmiddle;
    DLatch DLatch1(data, ~clk, rst, Qmiddle);
    DLatch DLatch2(Qmiddle, clk, rst, Q);
endmodule
module DLatch(
    input data, clk, rst,
    output Q
);
    // 修正的复位逻辑
    wire S = clk & data & ~rst;
    wire R = clk & ~data | rst;  // 复位时强制R=1
    
    wire Q1 = ~(Q | S);
    assign Q = ~(Q1 | R);
endmodule