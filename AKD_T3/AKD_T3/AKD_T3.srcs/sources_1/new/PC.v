module PC #(
    parameter width = 16
)(
    input               clk, rst, wea_pc,
    input [width - 1:0] pc_next,
    output reg [width - 1:0] pc
);
    always@(posedge clk, posedge rst) begin
        if (rst == 1) pc <= 0;
        else if(wea_pc == 1) pc <= pc_next;
    end
endmodule