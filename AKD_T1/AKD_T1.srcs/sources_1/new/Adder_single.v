module Adder_single(
    input a, b, cin,
    output sum, cout
);
    assign sum = ~a & ~b & cin | ~a & b & ~cin | a & ~b & ~cin | a & b & cin;
    assign cout = a & b | a & cin | b & cin; 
endmodule
