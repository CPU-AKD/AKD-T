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
    // �����ĸ�λ�߼�
    wire S = clk & data & ~rst;
    wire R = clk & ~data | rst;  // ��λʱǿ��R=1
    
    wire Q1 = ~(Q | S);
    assign Q = ~(Q1 | R);
endmodule