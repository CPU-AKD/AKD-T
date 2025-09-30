module DFF_ena(
    input data, clk, rst, lock,
    output Q
);
    DFF(~lock & data | lock & Q, clk, rst, Q);
endmodule
