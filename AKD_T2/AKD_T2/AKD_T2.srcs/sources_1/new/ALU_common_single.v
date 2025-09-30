module ALU_common_single(
    input        a, b, cin,
    input  [3:0] ALUop_common,
    output       result, cout
);
    wire[3:0] preresult;
    wire[1:0] MUXsel;
    assign {aconv, bconv, MUXsel} = ALUop_common;
    assign a_after = a ^ aconv;
    assign b_after = b ^ bconv;
    assign preresult[0] = ~(a_after & b_after);
    assign preresult[1] = ~(a_after | b_after);
    assign preresult[2] = a_after ^ b_after;
    assign preresult[3] = preresult[2] ^ cin;
    assign cout = ~(preresult[0] & ~(cin & a_after) & ~(cin & b_after));
    assign result = preresult[MUXsel];
endmodule