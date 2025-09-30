`timescale 1ns / 1ps
module test_ALU(
    output[31:0] result_alu
);
    reg[31:0] data1_alu, data2_alu;
    reg[12:0] ALUop;
    ALU #(32) ALU(
        .data1_alu(data1_alu),
        .data2_alu(data2_alu),
        .ALUop(ALUop),
        .result_alu(result_alu)
    );
    initial begin
        data1_alu = 4;
        data2_alu = 1;
        ALUop = 13'b0111000000000;
        #10 $finish;
    end
endmodule
