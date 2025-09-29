module MEM #(
    parameter width = 32,
    parameter depth = 1024
)(
    input                       clk, rst, wena,
    input [width - 1        :0] data_mem,
    input [$clog2(depth) - 1:0] addr_mem,
    output[width - 1        :0] result_mem,
    output[width - 1        :0] disp_mem//结果展示
);
    wire[width - 1:0] dataouts[depth - 1:0];
    generate
        genvar i;
        for (i = 0; i < depth; i = i + 1) begin
            Register_lock #(32) Register_lock(
                .clk(clk),
                .rst(rst),
                .lock(~wena),
                .datain(data_mem),
                .dataout(dataouts[i])
            );
        end
    endgenerate
    assign result_mem = dataouts[addr_mem];
    assign disp_mem = dataouts[0];
endmodule
