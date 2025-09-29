`timescale 1ns / 1ps
module test_MEM(
    output[31:0] douta
);
    reg clk, wea;
    reg[15:0] addra;
    reg[31:0] dina;
    MEM MEM (
      .clka(clk),    // input wire clka
      .wea(wea),      // input wire [0 : 0] wea
      .addra(addra),  // input wire [15 : 0] addra
      .dina(dina),    // input wire [31 : 0] dina
      .douta(douta)  // output wire [31 : 0] douta
    );
    initial begin
        clk = 0;
        wea = 1;
        addra = 0;
        dina = 4;
        #1 clk = 1;
        #1 clk = 0;
        addra = 0;
        #1 clk = 1;
        #1 clk = 0;
        #5 $finish();
    end
endmodule
