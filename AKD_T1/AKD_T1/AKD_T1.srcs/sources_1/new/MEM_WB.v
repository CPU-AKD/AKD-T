module MEM_WB #(
    parameter width = 32
)(
    input clk, rst, wea,
    input[width - 1:0] pipe_WB_prev,
    output reg[width - 1:0] pipe_WB
);
    always@(posedge clk, posedge rst) begin
        if (rst == 1) pipe_WB <= 0;
        else if (wea == 1) pipe_WB <= pipe_WB_prev;
    end
endmodule