`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/09/13 15:00:19
// Design Name: 
// Module Name: test_IM
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module test_IM(
    output[31:0] pipe_ID
);
    reg clk, ena;
    reg[15:0] pc;
    IM_entire IM_entire (
      .clka(clk),    // input wire clka
      .ena(ena),      // input wire ena
      .addra(pc),  // input wire [15 : 0] addra
      .douta(pipe_ID)  // output wire [31 : 0] douta
    );
    always #0.5 clk = ~clk;
    always@(clk) begin
        pc <= pc + 1;
    end
    initial begin
        clk = 0;
        ena = 1;
        pc = 0;
        #20 $finish();
    end
endmodule
