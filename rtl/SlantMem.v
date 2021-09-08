`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.09.2021 10:03:14
// Design Name: 
// Module Name: SlantMem
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


module SlantMem(
input Cclk,
input rstn,

input [3:0] Mem_cont,

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

reg Del_Last;
always @(posedge Cclk or negedge rstn)
    if (!rstn) Del_Last <= 1'b0;
     else Del_Last <= s_axis_video_tlast;
reg Del_Valid;
always @(posedge Cclk or negedge rstn)
    if (!rstn) Del_Valid <= 1'b0;
     else Del_Valid <= s_axis_video_tvalid;

reg [11:0] DelData;
//reg [8:0] DelData;
always @(posedge Cclk or negedge rstn)
    if (!rstn) DelData <= 12'h000;
     else if (s_axis_video_tvalid) DelData <= {s_axis_video_tdata[23:20],s_axis_video_tdata[15:12],s_axis_video_tdata[7:4]};     
//     else if (s_axis_video_tvalid) DelData <= {s_axis_video_tdata[23:21],s_axis_video_tdata[15:13],s_axis_video_tdata[7:5]};     

reg Valid_odd;
always @(posedge Cclk or negedge rstn)
    if (!rstn) Valid_odd <= 1'b0;
     else if (s_axis_video_tuser && s_axis_video_tvalid)  Valid_odd <=  ~Valid_odd;
     else if (Del_Last)  Valid_odd <=  Valid_odd;
     else if (s_axis_video_tvalid) Valid_odd <= ~Valid_odd;

reg [19:0] CWadd;
always @(posedge Cclk or negedge rstn)
    if (!rstn) CWadd <= 20'h00000;
     else if (s_axis_video_tvalid && s_axis_video_tuser && s_axis_video_tready) CWadd <= 20'h00000;
     else if (s_axis_video_tvalid && Valid_odd) CWadd <= CWadd + 1;
/*     
reg [19:0] HRadd;
always @(posedge Hclk or negedge rstn)
    if (!rstn) HRadd <= 20'h00000;
     else if (!HVsync) HRadd <= 20'h00000;
     else if (HMemRead) HRadd <= HRadd + 1;

/////// Memory //////
//reg [11:0] Mem [0:153599];
reg [8:0] Mem [0:153599];
reg [8:0] Reg_mem;
always @(posedge Cclk)
    if (Del_Valid && Valid_odd) Mem[CWadd] <= DelData;

always @(posedge Hclk)
    Reg_mem <=  Mem[HRadd[19:1]];

assign HDMIdata = {Reg_mem[8:6],1'b1,Reg_mem[5:3],1'b1,Reg_mem[2:0],1'b1};
*/

     

reg [3:0] WEnslant;
always @(posedge Cclk or negedge rstn)
    if (!rstn) WEnslant <= 4'h1;
     else if (s_axis_video_tvalid && s_axis_video_tuser && s_axis_video_tready) WEnslant <= 4'h1;
     else if (Valid_odd && s_axis_video_tlast) WEnslant <= WEnslant;
     else if (Valid_odd && Del_Last) WEnslant <= WEnslant;
     else if (s_axis_video_tvalid && Valid_odd) WEnslant <= {WEnslant[2:0],WEnslant[3]};
      
reg [11:0] Mem0 [0:38399];
reg [11:0] Mem1 [0:38399];
reg [11:0] Mem2 [0:38399];
reg [11:0] Mem3 [0:38399];
//reg [8:0] Mem0 [0:38399];
//reg [8:0] Mem1 [0:38399];
//reg [8:0] Mem2 [0:38399];
//reg [8:0] Mem3 [0:38399];
always @(posedge Cclk)
    if (WEnslant[0] && Del_Valid && Valid_odd) Mem0[CWadd[19:2]] <= DelData;
always @(posedge Cclk)                                       
    if (WEnslant[1] && Del_Valid && Valid_odd) Mem1[CWadd[19:2]] <= DelData;
always @(posedge Cclk)                                       
    if (WEnslant[2] && Del_Valid && Valid_odd) Mem2[CWadd[19:2]] <= DelData;
always @(posedge Cclk)                                       
    if (WEnslant[3] && Del_Valid && Valid_odd) Mem3[CWadd[19:2]] <= DelData;

reg [19:0] HRadd;
always @(posedge Hclk or negedge rstn)
    if (!rstn) HRadd <= 20'h00001;
     else if (!HVsync) HRadd <= 20'h00001;
     else if (HMemRead) HRadd <= HRadd + 1;

reg [11:0] Reg_Mem0;
reg [11:0] Reg_Mem1;
reg [11:0] Reg_Mem2;
reg [11:0] Reg_Mem3;
//reg [8:0] Reg_Mem0;
//reg [8:0] Reg_Mem1;
//reg [8:0] Reg_Mem2;
//reg [8:0] Reg_Mem3;
always @(posedge Hclk)
    Reg_Mem0 <=  Mem0[HRadd[19:3]];
always @(posedge Hclk)
    Reg_Mem1 <=  Mem1[HRadd[19:3]];
always @(posedge Hclk)
    Reg_Mem2 <=  Mem2[HRadd[19:3]];
always @(posedge Hclk)
    Reg_Mem3 <=  Mem3[HRadd[19:3]];

reg Del_HMemRead;
always @(posedge Hclk or negedge rstn) 
    if (!rstn) Del_HMemRead <= 1'b0;
     else Del_HMemRead <= HMemRead;
reg [3:0] REnslant;
always @(posedge Hclk or negedge rstn)
    if (!rstn) REnslant <= 4'h1;
     else if (!HVsync) REnslant <= 4'h1;
     else if (!HMemRead && Del_HMemRead) REnslant <= {REnslant[0],REnslant[3:1]};
     else if (HMemRead && !HRadd[0]) REnslant <= {REnslant[2:0],REnslant[3]};

assign  HDMIdata = (REnslant[0] && Mem_cont[0]) ? Reg_Mem0 :
                   (REnslant[1] && Mem_cont[1]) ? Reg_Mem1 :
                   (REnslant[2] && Mem_cont[2]) ? Reg_Mem2 :
                   (REnslant[3] && Mem_cont[3]) ? Reg_Mem3 : 12'h000;
//assign  HDMIdata = (REnslant[0] && Mem_cont[0]) ? {Reg_Mem0[8:6],1'b1,Reg_Mem0[5:3],1'b1,Reg_Mem0[2:0],1'b1} :
//                   (REnslant[1] && Mem_cont[1]) ? {Reg_Mem1[8:6],1'b1,Reg_Mem1[5:3],1'b1,Reg_Mem1[2:0],1'b1} :
//                   (REnslant[2] && Mem_cont[2]) ? {Reg_Mem2[8:6],1'b1,Reg_Mem2[5:3],1'b1,Reg_Mem2[2:0],1'b1} :
//                   (REnslant[3] && Mem_cont[3]) ? {Reg_Mem3[8:6],1'b1,Reg_Mem3[5:3],1'b1,Reg_Mem3[2:0],1'b1} : 12'h000;
  
assign s_axis_video_tready = 1'b1;   

assign Debug_Add = HRadd;
  
endmodule
