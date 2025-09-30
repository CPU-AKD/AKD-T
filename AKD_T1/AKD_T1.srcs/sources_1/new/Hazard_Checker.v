module Hazard_Checker(
    input[31:0] inst_EX, inst_MEM, inst_WB,
    input[4:0] waddr_EX_wbreg, waddr_MEM_wbreg, waddr_WB_wbreg,
    input[4:0] raddr1_ID_reg, raddr2_ID_reg, waddr_ID_reg,
    input jump,
    output hazard_data, hazard_structure
);
    assign hazard_data =
        raddr1_ID_reg != 0 & (//�������żĴ������
            (raddr1_ID_reg == waddr_EX_wbreg)|
            (raddr1_ID_reg == waddr_MEM_wbreg)|
            (raddr1_ID_reg == waddr_WB_wbreg)
        ) |
        raddr2_ID_reg != 0 & (//�������żĴ������
            (raddr2_ID_reg == waddr_EX_wbreg)|
            (raddr2_ID_reg == waddr_MEM_wbreg)|
            (raddr2_ID_reg == waddr_WB_wbreg)
        );//����Ҫ����EX/MEM/WB֮�������ð�գ���Ϊ�Ѿ���ID�׶�ͨ����ˮ����ͣ����ˣ�������˳��ִ��
    assign hazard_structure = (waddr_ID_reg != 0) & (waddr_WB_wbreg != 0);
endmodule