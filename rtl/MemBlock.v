`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.08.2021 18:01:09
// Design Name: 
// Module Name: MemBlock
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module MemBlock(
input Cclk,
input rstn,

output        s_axis_video_tready,
input  [23:0] s_axis_video_tdata ,
input         s_axis_video_tvalid,
input         s_axis_video_tuser ,
input         s_axis_video_tlast ,

input Hclk,

input HVsync,
input HMemRead,
output [11:0] HDMIdata

    );

reg [19:0] CWadd;
always @(posedge Cclk or negedge rstn)
    if (!rstn) CWadd <= 20'h00000;
     else if (s_axis_video_tvalid && s_axis_video_tuser && s_axis_video_tready) CWadd <= 20'h00000;
     else if (s_axis_video_tvalid) CWadd <= CWadd + 1;

reg [11:0] DelValid;
always @(posedge Cclk or negedge rstn)
    if (!rstn) DelValid <= 1'b0;
     else DelValid <= s_axis_video_tvalid;
reg [11:0] DelData;
always @(posedge Cclk or negedge rstn)
    if (!rstn) DelData <= 12'h000;
     else if (s_axis_video_tvalid) DelData <= {s_axis_video_tdata[23:20],s_axis_video_tdata[15:12],s_axis_video_tdata[7:4]};     

reg [19:0] HRadd;
always @(posedge Hclk or negedge rstn)
    if (!rstn) HRadd <= 20'h00000;
     else if (!HVsync) HRadd <= 20'h00000;
     else if (HMemRead) HRadd <= HRadd + 1;

/////// Memory //////
reg [11:0] Mem [0:307199];
reg [11:0] Reg_mem;
always @(posedge Cclk)
    if (DelValid) Mem[CWadd] <= DelData;

always @(posedge Hclk)
    Reg_mem <=  Mem[HRadd];

assign HDMIdata = Reg_mem;

assign s_axis_video_tready = 1'b1;   
    
endmodule
