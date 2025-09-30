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
    wire[width - 1:0] cout;
    ALU_single ALU_single_0(data1_alu[0], data2_alu[0], ALUop[11], ALUop[12:9], result_alu[0], cout[0]);
    generate
        genvar i;
        for (i = 1; i < width; i = i + 1) begin
            ALU_single ALU_single(data1_alu[i], data2_alu[i], cout[i - 1], ALUop[12:9], result_alu[i], cout[i]);
        end
    endgenerate
endmodule

module ALU_single(
    input        a, b, cin,
    input  [3:0] ALUop,
    output       result, cout
);
    wire[3:0] preresult;
    wire[1:0] MUXsel;
    assign {aconv, bconv, MUXsel} = ALUop;
    assign a_after = a ^ aconv;
    assign b_after = b ^ bconv;
    assign preresult[0] = ~(a_after & b_after);
    assign preresult[1] = ~(a_after | b_after);
    assign preresult[2] = a_after ^ b_after;
    assign preresult[3] = preresult[2] ^ cin;
    assign cout = ~(preresult[0] & ~(cin & a_after) & ~(cin & b_after));
    assign result = preresult[MUXsel];
endmodule