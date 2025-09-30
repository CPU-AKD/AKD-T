`timescale 1ns / 1ps
module test_AKD_T1(
    output[31:0] result_mem,
    output[15:0] detector_pc,
    output[31:0] detector_pipe_ID,
    output[31:0] detector_pipe_EX,
    output[31:0] detector_pipe_MEM,
    output[31:0] detector_pipe_WB,
    output detector_hazard_data,
    output detector_hazard_structure,
    output detector_jump
);
    reg clk, rst;
    wire cpu_halt;
    always #0.5 clk = ~clk;
    AKD_T3 #(
        .widthi(32),
        .widthd(32),
        .depthim(65536),
        .depthmem(65536)
    ) AKD_T3(
        .clk(clk),
        .rst(rst),
        .cpu_halt(cpu_halt),
        .result_mem(result_mem),
        .detector_pc(detector_pc),
        .detector_pipe_ID(detector_pipe_ID),
        .detector_pipe_EX(detector_pipe_EX),
        .detector_pipe_MEM(detector_pipe_MEM),
        .detector_pipe_WB(detector_pipe_WB),
        .detector_hazard_data(detector_hazard_data),
        .detector_hazard_structure(detector_hazard_structure),
        .detector_jump(detector_jump)
    );
    always@(posedge cpu_halt) begin
        #1 $finish();
    end
    initial begin
        clk = 0;
        #0.1 rst = 1;
        #0.1 rst = 0;
    end
endmodule
