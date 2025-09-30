module IF_ID #(
    parameter width = 32
)(
    input clk, rst, lock_IF_ID,
    input[31:0] inst,
    output[31:0] pipe_ID 
);
    Register_lock #(width) Register_lock(clk, rst, lock_IF_ID, inst, pipe_ID);
endmodule