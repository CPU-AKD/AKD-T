module Register #(
    parameter width = 32
)(
    input clk, rst,
    input[width - 1:0] datain,
    output[width - 1:0] dataout
);
    generate
        genvar i;
        for(i = 0; i < width; i = i + 1) begin
            DFF DFF(datain[i], clk, rst, dataout[i]);
        end
    endgenerate
endmodule
