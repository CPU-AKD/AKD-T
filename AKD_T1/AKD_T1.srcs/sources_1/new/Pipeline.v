module Pipeline #(
    parameter width = 32
)(
    input clk, rst, wea,
    input[width - 1:0] pipe_prev,
    output reg[width - 1:0] pipe
);
    always@(posedge clk, posedge rst) begin
        if (rst == 1) pipe <= 0;
        else if (wea == 1) pipe <= pipe_prev;
    end
endmodule