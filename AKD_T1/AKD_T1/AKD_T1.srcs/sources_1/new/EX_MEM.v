module EX_MEM #(
    parameter width = 32
)(
    input clk, rst, wea,
    input[width - 1:0] pipe_MEM_prev,
    output reg[width - 1:0] pipe_MEM
);
    always@(posedge clk, posedge rst) begin
        if (rst == 1) pipe_MEM <= 0;
        else if (wea == 1) pipe_MEM <= pipe_MEM_prev;
    end
endmodule