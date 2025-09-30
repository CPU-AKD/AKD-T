module ALU_shift_single #(
    parameter width_data = 32,
    parameter width_shift = 16
)(
    input[width_data - 1:0] data,
    input[1:0] op_shift,
    output[width_data - 1:0] result
);
    genvar i;
    generate
        for(i = width_data - 1; i >= width_data - width_shift; i = i - 1) begin
            assign result[i] = ~op_shift[1] & ~op_shift[0] & data[i] |
                               ~op_shift[1] &  op_shift[0] & data[i - width_shift] |
                                op_shift[1] & ~op_shift[0] & 1'b0 |
                                op_shift[1] &  op_shift[0] & data[width_data - 1];
        end
        for(i = width_data - width_shift - 1; i >= width_shift; i = i - 1) begin
            assign result[i] = ~op_shift[1] & ~op_shift[0] & data[i] |
                               ~op_shift[1] &  op_shift[0] & data[i - width_shift] |
                                op_shift[1] &  data[i + width_shift];
        end
        for(i = width_shift - 1; i >= 0; i = i - 1) begin
            assign result[i] = ~op_shift[1] & ~op_shift[0] & data[i] |
                               ~op_shift[1] &  op_shift[0] & 1'b0 |
                                op_shift[1] &  data[i + width_shift];
        end
    endgenerate
endmodule
