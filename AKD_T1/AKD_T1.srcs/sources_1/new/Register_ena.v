module Register_ena #(
    parameter widthd = 16
)(
    input clk, rst, lock,
    input[widthd - 1:0] datain,
    output[widthd - 1:0] dataout
);
    Register #(widthd)(clk, rst, lock == 0 ? datain : dataout, dataout);
endmodule
