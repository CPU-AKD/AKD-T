// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
// Date        : Sat Sep  6 21:29:53 2025
// Host        : LAPTOP-3U3TC0C7 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               c:/Users/hp/Desktop/FPGA/CPU/AKD_T1/AKD_T1/AKD_T1/AKD_T1.gen/sources_1/ip/MEM/MEM_stub.v
// Design      : MEM
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z010clg400-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_4,Vivado 2020.2" *)
module MEM(clka, wea, addra, dina, douta)
/* synthesis syn_black_box black_box_pad_pin="clka,wea[1:0],addra[15:0],dina[15:0],douta[15:0]" */;
  input clka;
  input [1:0]wea;
  input [15:0]addra;
  input [15:0]dina;
  output [15:0]douta;
endmodule
