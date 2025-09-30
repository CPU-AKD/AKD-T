module REG #(
    parameter width = 32,
    parameter depth = 32
)(
    input clk, rst,
    input[4:0] raddr1, raddr2, waddr,
    input[width - 1:0] regdata,
    output[width - 1:0] result1_reg, result2_reg
);
    reg[width - 1:0] registers[depth - 1:1];
    integer i;
    always@(posedge clk, posedge rst) begin
        if (rst == 1)begin
            for (i = 1; i < depth; i = i + 1) registers[i] <= 0;
        end
        else registers[waddr] <= regdata;
    end
    wire[width - 1:0] results_reg[depth - 1:0];
    assign results_reg[0] = 0;
    genvar j;
    generate
        for (j = 1; j < depth; j = j + 1) begin
            assign results_reg[j] = registers[j];
        end
    endgenerate
    assign result1_reg = results_reg[raddr1];
    assign result2_reg = results_reg[raddr2];
endmodule