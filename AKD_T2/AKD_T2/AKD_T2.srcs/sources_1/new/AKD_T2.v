/*
都是有符号数，暂时无前递机制
jl:x[rs1]<0则跳转/je:x[rs1]==0则跳转/jg:x[rs1]>0则跳转
j类指令在ID阶段同时完成检查数据、保存pc(所以不需要检测j指令的写回相关)、选择并更新pc
ISA
            kind
            k(j/l/a/s)(4) funct( 7)       immediate(16)  rd(5)
            k(j/l/a/s)(4) funct(13)[27:15] rs1(5) rs2(5) rd(5)
1. j            1000      1110000000000    rs1    rs2    rd (check rs1, pc_jump = x[rs2], x[rd] = pc)
2. jl           1000      1000000000000    rs1    rs2    rd (check rs1, pc_jump = x[rs2], x[rd] = pc)
3. je           1000      0100000000000    rs1    rs2    rd (check rs1, pc_jump = x[rs2], x[rd] = pc)
4. jg           1000      0010000000000    rs1    rs2    rd (check rs1, pc_jump = x[rs2], x[rd] = pc)
5. jle          1000      1100000000000    rs1    rs2    rd (check rs1, pc_jump = x[rs2], x[rd] = pc)
6. jlg          1000      1010000000000    rs1    rs2    rd (check rs1, pc_jump = x[rs2], x[rd] = pc)
7. jeg          1000      0110000000000    rs1    rs2    rd (check rs1, pc_jump = x[rs2], x[rd] = pc)
8. ldi          0100      0000000         immediate      rd
9. ldhi         0100      0100000         immediate      rd
10.ldm          0100      1000000000000    rs1  00000    rd
11.and          0010      1101000000000    rs1    rs2    rd
12.or           0010      1100000000000    rs1    rs2    rd
13.nand         0010      0000000000000    rs1    rs2    rd
14.nor          0010      0001000000000    rs1    rs2    rd
15.xor          0010      0010000000000    rs1    rs2    rd
16.xnor         0010      0110000000000    rs1    rs2    rd
17.add          0010      0011000000000    rs1    rs2    rd
18.sub          0010      0111000000000    rs1    rs2    rd
19.st           0001      0000000000000    rs1    rs2 00000 (M[rs1] = x[rs2])
20.nop          0000      0000000000000000000000000000
21.hlt          0000      1000000000000000000000000000
*/
module AKD_T2 #(
    parameter widthi = 32,
    parameter widthd = 32,
    parameter depthim = 65536,
    parameter depthmem = 65536
)(
    input clk, rst,
    output cpu_halt,
    output[widthd - 1:0] result_mem,
    output[15:0] detector_pc,
    output[31:0] detector_pipe_ID,
    output[31:0] detector_pipe_EX,
    output[31:0] detector_pipe_MEM,
    output[31:0] detector_pipe_WB,
    output detector_hazard_data,
    output detector_hazard_structure,
    output detector_jump,
    output detector_pc_jump
);
    wire jump, hazard_data, hazard_structure;
    wire stall_IF_ID, stall_ID_EX, stall_EX_MEM, stall_MEM_WB;
    wire[15:0] pc, pc_jump;
    PC #($clog2(depthim)) PC(
        .clk    (clk),
        .rst    (rst),
        .wea_pc (~(cpu_halt | hazard_data | hazard_structure)),//总是预测不跳转
        .pc_next(jump ? pc_jump : pc + 16'b1),
        .pc     (pc)
    );

    wire[widthi - 1:0] pipe_ID;
    assign stall_IF_ID = cpu_halt | hazard_data | hazard_structure;
    IM_entire IM_entire (
      .clka (clk),          // input  wire clka
      .ena  (~stall_IF_ID), // input  wire ena
      .addra(pc),           // input  wire [15 : 0] addra
      .douta(pipe_ID)       // output wire [31 : 0] douta
    );
    
    wire[5 + 16 + widthd + widthi - 1:0] pipe_WB;
    /*
        [84:80]waddr_WB_wbreg
        [79:64]imm
        [63:32]result_alu
        [31: 0]inst
    */
    wire wb_reg = |pipe_WB[84:80];
    wire[widthd - 1:0] result1_reg, result2_reg;
    wire[widthd - 1:0] wbdata;
    wire[4:0] raddr1_ID_reg = pipe_ID[14:10] & {5{pipe_ID[31] | pipe_ID[30] & (pipe_ID[27] | pipe_ID[26]) | pipe_ID[29] | pipe_ID[28]}};//如果kj或ldm或ldhi或alu或st则需要读
    wire[4:0] raddr2_ID_reg = pipe_ID[9:5] & {5{pipe_ID[31] & jump | pipe_ID[29] |  pipe_ID[28]}};//如果(kj且jump)或alu或st则需要读
    wire[4:0] waddr_ID_reg = pipe_ID[4:0] & {5{pipe_ID[31] & jump | pipe_ID[30] & ~pipe_ID[27]}};//如果(kj且jump)或(kl且不是ldm)则需要写
    wire[4:0] waddr_ID_wbreg = pipe_ID[4:0] & {5{pipe_ID[30] & pipe_ID[27] | pipe_ID[29]}};//如果(kl且ldm)或alu则需要写回
    wire ldi_ID = pipe_ID[30] & ~pipe_ID[27] & ~pipe_ID[26];
    wire ldhi_ID = pipe_ID[30] & ~pipe_ID[27] & pipe_ID[26];
    REG #(widthd, 32) REG(
        .clk    (clk),
        .rst    (rst),
        .raddr1 (ldhi_ID ? pipe_ID[4:0] : raddr1_ID_reg),
        .raddr2 (raddr2_ID_reg),
        .waddr  (wb_reg ? pipe_WB[84:80] : waddr_ID_reg),
        .regdata({
            wb_reg ? wbdata[31:16] : {16{ldi_ID & pipe_ID[20]}},//选择高16位数据
            wb_reg ? wbdata[15: 0] : (
                pc            & {16{jump}} |
                pipe_ID[20:5] & {16{ldi_ID}}
            )//选择低16位数据
        }),
        .result1_reg(result1_reg),
        .result2_reg(result2_reg)
    );
    wire satisfy_l = result1_reg[widthd - 1];
    wire satisfy_e = ~(|result1_reg);
    wire satisfy_g = ~(satisfy_l | satisfy_e);
    assign jump = pipe_ID[31] & (satisfy_l & pipe_ID[27] | satisfy_e & pipe_ID[26] | satisfy_g & pipe_ID[25]) & ~hazard_data;
    assign pc_jump = result2_reg[15:0];
    
    wire[5 + 16 + widthd * 2 + widthi - 1:0] pipe_EX;
    /*
        [116:112]waddr_EX_wbreg
        [111: 96]imm
        [ 95: 64]result1_reg
        [ 63: 32]result2_reg
        [ 31: 0]inst
    */
    assign stall_ID_EX = cpu_halt;
    reg bubble;
    always@(posedge clk, posedge rst) begin
        if (rst == 1) bubble <= 0;
        else bubble = jump;
    end
    Pipeline #(5 + 16 + widthd * 2 + widthi) ID_EX(
        .clk(clk),
        .rst(rst),
        .wea(~stall_ID_EX),
        .pipe_prev((hazard_data | hazard_structure | bubble) ? 0 : {waddr_ID_wbreg, pipe_ID[20:5], result1_reg, result2_reg, pipe_ID}),
        .pipe(pipe_EX)
    );
    
    wire[widthd - 1:0] result_alu;
    ALU #(widthd) ALU(
        .data1_alu(pipe_EX[95:64]),
        .data2_alu(pipe_EX[63:32]),
        .ALUop(pipe_EX[27:15]),
        .result_alu(result_alu)
    );
    
    wire[5 + 16 + widthd * 3 + widthi - 1:0] pipe_MEM;
    /*
        [148:144]waddr_MEM_wbreg
        [143:128]imm
        [127: 96]result1_reg
        [ 95: 64]result2_reg
        [ 63: 32]result_alu
        [ 31:  0]inst
    */
    assign stall_EX_MEM = cpu_halt;
    Pipeline #(5 + 16 + widthd * 3 + widthi) EX_MEM(
        .clk(clk),
        .rst(rst),
        .wea(~stall_EX_MEM),
        .pipe_prev({pipe_EX[116:32], result_alu, pipe_EX[31:0]}),
        .pipe(pipe_MEM)
    );
    
    assign stall_MEM_WB = cpu_halt;
    MEM MEM (
      .clka (clk),                      // input  wire clka
      .wea  (pipe_MEM[28]), // input  wire [ 0 : 0] wea
      .addra(pipe_MEM[79:64]),          // input  wire [15 : 0] addra
      .dina (pipe_MEM[127:96]),         // input  wire [31 : 0] dina
      .douta(result_mem)                // output wire [31 : 0] douta
    );
    
    Pipeline #(5 + 16 + widthd + widthi) MEM_WB(
        .clk(clk),
        .rst(rst),
        .wea(~stall_MEM_WB),
        .pipe_prev({pipe_MEM[148:128], pipe_MEM[63:0]}),
        .pipe(pipe_WB)
    );
    assign cpu_halt = (~|pipe_WB[31:28]) & pipe_WB[27];
    assign wbdata = (
        result_mem              & {widthd{pipe_WB[30] & pipe_WB[27]}} |              //如果ldm就用result_mem作为写回数据
        pipe_WB[63:32]          & {widthd{pipe_WB[29]}}|                             //如果alu就用传到WB阶段的alu结果
        {pipe_WB[79:64], 16'b0} & {widthd{pipe_WB[30] & ~pipe_WB[27] & pipe_WB[26]}} //如果ldhi就用传到WB阶段的立即数
    );
    Hazard_Checker Hazard_Checker(
        .inst_EX(pipe_EX[31:0]),
        .inst_MEM(pipe_MEM[31:0]),
        .inst_WB(pipe_WB[31:0]),
        .waddr_EX_wbreg(pipe_EX[116:112]),
        .waddr_MEM_wbreg(pipe_MEM[148:144]),
        .waddr_WB_wbreg(pipe_WB[84:80]),
        .raddr1_ID_reg(raddr1_ID_reg),
        .raddr2_ID_reg(raddr2_ID_reg),
        .waddr_ID_reg(waddr_ID_reg),
        .jump(jump),
        .hazard_data(hazard_data),
        .hazard_structure(hazard_structure)
    );
    assign detector_pc = pc;
    assign detector_pipe_ID = pipe_ID;
    assign detector_pipe_EX = pipe_EX;
    assign detector_pipe_MEM = pipe_MEM;
    assign detector_pipe_WB = pipe_WB;
    assign detector_hazard_data = hazard_data;
    assign detector_hazard_structure = hazard_structure;
    assign detector_jump = jump;
    assign detector_pc_jump = pc_jump;
endmodule