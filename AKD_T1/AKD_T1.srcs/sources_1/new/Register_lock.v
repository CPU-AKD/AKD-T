module Register_lock #(
    parameter width = 16
)(
    input clk, rst, wea,
    input[width - 1:0] datain,
    output[width - 1:0] dataout
);
    generate
        genvar i;
        for(i = 0; i < width; i = i + 1) begin
            DFF_wea DFF_wea(datain[i], clk, rst, wea, dataout[i]);
        end
    endgenerate
endmodule
