module ID_EX #(
    parameter width = 32
)(
    input clk, rst, wea,
    input[width - 1:0] pipe_EX_prev,
    output reg[width - 1:0] pipe_EX
);
    always@(posedge clk, posedge rst) begin
        if (rst == 1) pipe_EX <= 0;
        else if (wea == 1) pipe_EX <= pipe_EX_prev;
    end
endmodule