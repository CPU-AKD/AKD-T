module DFF_wea(
    input datain, clk, rst, wea,
    output dataout
);
    DFF DFF(~wea & dataout | wea & datain, clk, rst, dataout);
endmodule