/*
01:sll
10:srl
11:sra
*/
module ALU_shift #(
    parameter width_data = 32
)(
    input[width_data - 1:0] data,
    input[$clog2(width_data) - 1:0] shift_amount,
    input[1:0] ALUop_shift,
    output[width_data - 1:0] result
);
    wire[width_data - 1:0] results[$clog2(width_data) - 1:0];
    genvar i;
    generate
        for (i = 16; i > 0; i = i / 2) begin
            ALU_shift_single #(
                .width_data(width_data),
                .width_shift(i)
            ) ALU_shift_single(
                .data(data),
                .op_shift(ALUop_shift & {2{shift_amount[$clog2(i)]}}),
                .result(results[$clog2(i)])
            );
        end
    endgenerate
    assign result = results[0];
endmodule
