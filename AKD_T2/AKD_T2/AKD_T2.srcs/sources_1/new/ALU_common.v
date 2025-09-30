/*
nand         0000
nor          0001
xor          0010/1110
xnor         0110/1010
add          0011
sub          0111
or           1100
and          1101
*/
module ALU_common #(
    parameter width = 32
)(
    input [width - 1:0] data1_alu, data2_alu,
    input [3:0]        ALUop_common,
    output[width - 1:0] result_alu
);
    wire[width - 1:0] cout;
    ALU_common_single ALU_common_single_0(
        .a(data1_alu[0]),
        .b(data2_alu[0]),
        .cin(ALUop_common[2]),
        .ALUop_common(ALUop_common),
        .result(result_alu[0]),
        .cout(cout[0])
    );
    generate
        genvar i;
        for (i = 1; i < width; i = i + 1) begin
            ALU_common_single ALU_common_single(
                .a(data1_alu[i]),
                .b(data2_alu[i]),
                .cin(cout[i - 1]),
                .ALUop_common(ALUop_common),
                .result(result_alu[i]),
                .cout(cout[i])
            );
        end
    endgenerate
endmodule