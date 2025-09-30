module IM #(
    parameter width = 32,
    parameter depth = 1024
)(
    input [$clog2(depth) - 1:0] pc,
    output[width - 1:0]         inst
);
    reg[width - 1:0] instruction[depth - 1:0];
    integer i;
    initial begin
        for (i = 0; i < depth; i = i + 1) begin
            instruction[i] = 0;
        end
        $readmemb("../test_program/Fibonacci.txt", instruction);
    end
    assign inst = instruction[pc];
endmodule