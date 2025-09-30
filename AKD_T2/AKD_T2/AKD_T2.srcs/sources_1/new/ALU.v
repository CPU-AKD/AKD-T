/*
and          1101
or           1100
nand         0000
nor          0001
xor          0010/1110
xnor         0110/1010
add          0011
sub          0111
*/
module ALU #(
    parameter width = 32
)(
    input [width - 1:0] data1_alu, data2_alu,
    input [12:0]        ALUop,
    output[width - 1:0] result_alu
);
    wire[width - 1:0] results_alu[1:0];
    wire[width - 1:0] cout;
    ALU_common #(width) ALU_common(
        .data1_alu(data1_alu),
        .data2_alu(data2_alu),
        .ALUop_common(ALUop[12:9]),
        .result_alu(results_alu[0])
    );
    ALU_shift #(width) ALU_shift(
        .data(data1_alu),
        .shift_amount(data2_alu[4:0]),
        .ALUop_shift(ALUop[12:11]),
        .result(results_alu[1])
    );
    assign result_alu = results_alu[ALUop[8]];
endmodule