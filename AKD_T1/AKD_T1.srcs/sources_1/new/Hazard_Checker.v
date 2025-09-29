module Hazard_Checker(
    input[31:0] inst_EX, inst_MEM, inst_WB,
    input[4:0] waddr_EX_wbreg, waddr_MEM_wbreg, waddr_WB_wbreg,
    input[4:0] raddr1_ID_reg, raddr2_ID_reg, waddr_ID_reg,
    input jump,
    output hazard_data, hazard_structure
);
    assign hazard_data =
        raddr1_ID_reg != 0 & (//不检测零号寄存器相关
            (raddr1_ID_reg == waddr_EX_wbreg)|
            (raddr1_ID_reg == waddr_MEM_wbreg)|
            (raddr1_ID_reg == waddr_WB_wbreg)
        ) |
        raddr2_ID_reg != 0 & (//不检测零号寄存器相关
            (raddr2_ID_reg == waddr_EX_wbreg)|
            (raddr2_ID_reg == waddr_MEM_wbreg)|
            (raddr2_ID_reg == waddr_WB_wbreg)
        );//不需要考虑EX/MEM/WB之间的数据冒险，因为已经在ID阶段通过流水线暂停解决了，而且是顺序执行
    assign hazard_structure = (waddr_ID_reg != 0) & (waddr_WB_wbreg != 0);
endmodule