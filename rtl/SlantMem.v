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

input  wire Sel,
input  wire [23 : 0] Sel_RGB    ,

input [3:0] Mem_cont,

output        s_axis_video_tready,
input  [23:0] s_axis_video_tdata ,
input         s_axis_video_tvalid,
input         s_axis_video_tuser ,
input         s_axis_video_tlast ,

output FraimSync,

input Hclk,

input HVsync  ,
input HMemRead,
input pVDE    ,
output [23:0] HDMIdata
    );

reg Del_Last;
always @(posedge Cclk or negedge rstn)
    if (!rstn) Del_Last <= 1'b0;
     else Del_Last <= s_axis_video_tlast;
reg Del_Valid;
always @(posedge Cclk or negedge rstn)
    if (!rstn) Del_Valid <= 1'b0;
     else Del_Valid <= s_axis_video_tvalid;

//reg [11:0] DelData;
////reg [8:0] DelData;
//always @(posedge Cclk or negedge rstn)
//    if (!rstn) DelData <= 12'h000;
//     else if (s_axis_video_tvalid) DelData <= {s_axis_video_tdata[23:20],s_axis_video_tdata[15:12],s_axis_video_tdata[7:4]};     
////     else if (s_axis_video_tvalid) DelData <= {s_axis_video_tdata[23:21],s_axis_video_tdata[15:13],s_axis_video_tdata[7:5]};     
wire [4:0] YData  = /*( s_axis_video_tdata[2] )                            ? s_axis_video_tdata[7:3]   + 1 :*/ s_axis_video_tdata[7:3]  ; 
wire [4:0] CbData = /*( s_axis_video_tdata[15] &&  s_axis_video_tdata[10]) ? s_axis_video_tdata[15:11] + 1 :*/ 
                    /*(~s_axis_video_tdata[15] && ~s_axis_video_tdata[10]) ? s_axis_video_tdata[15:11] - 1 :*/ s_axis_video_tdata[15:11];
wire [4:0] CrData = /*( s_axis_video_tdata[23] &&  s_axis_video_tdata[18]) ? s_axis_video_tdata[23:19] + 1 :*/  
                    /*(~s_axis_video_tdata[23] && ~s_axis_video_tdata[18]) ? s_axis_video_tdata[23:19] - 1 :*/ s_axis_video_tdata[23:19];
reg [4:0] DelYData;
always @(posedge Cclk or negedge rstn)
    if (!rstn) DelYData <= 5'h00;
     else if (s_axis_video_tvalid) DelYData <= YData;     
reg [4:0] DelCbData;
always @(posedge Cclk or negedge rstn)
    if (!rstn) DelCbData <= 5'h00;
     else if (s_axis_video_tvalid) DelCbData <= CbData;     
reg [4:0] DelCrData;
always @(posedge Cclk or negedge rstn)
    if (!rstn) DelCrData <= 5'h00;
     else if (s_axis_video_tvalid) DelCrData <= CrData;     

reg Valid_odd;
always @(posedge Cclk or negedge rstn)
    if (!rstn) Valid_odd <= 1'b0;
     else if (s_axis_video_tuser && s_axis_video_tvalid)  Valid_odd <=  ~Valid_odd;
     else if (Del_Last)  Valid_odd <=  Valid_odd;
     else if (s_axis_video_tvalid) Valid_odd <= ~Valid_odd;

reg Reg_FraimSync;
always @(posedge Cclk or negedge rstn) 
    if (!rstn) Reg_FraimSync <= 1'b0;
     else if (s_axis_video_tuser && s_axis_video_tvalid && Valid_odd) Reg_FraimSync <= 1'b1;
     else if (s_axis_video_tuser && s_axis_video_tvalid && ~Valid_odd) Reg_FraimSync <= 1'b0;
assign FraimSync = Reg_FraimSync;

reg [19:0] CWadd;
always @(posedge Cclk or negedge rstn)
    if (!rstn) CWadd <= 20'h00000;
     else if (s_axis_video_tvalid && s_axis_video_tuser && s_axis_video_tready) CWadd <= 20'h00000;
     else if (s_axis_video_tvalid && Valid_odd) CWadd <= CWadd + 1;

reg [3:0] WEnslant;
always @(posedge Cclk or negedge rstn)
    if (!rstn) WEnslant <= 4'h1;
     else if (s_axis_video_tvalid && s_axis_video_tuser && s_axis_video_tready) WEnslant <= 4'h1;
     else if (Valid_odd && s_axis_video_tlast) WEnslant <= WEnslant;
     else if (Valid_odd && Del_Last) WEnslant <= WEnslant;
     else if (s_axis_video_tvalid && Valid_odd) WEnslant <= {WEnslant[2:0],WEnslant[3]};

reg Line_Odd;
always @(posedge Cclk or negedge rstn)
    if (!rstn) Line_Odd <= 1'b0;
     else if (Del_Last && ~Valid_odd) Line_Odd <= Reg_FraimSync ;
     else if (Del_Last &&  Valid_odd) Line_Odd <= ~Reg_FraimSync ;

wire [4:0] DelCData = (CWadd[0] == Line_Odd) ? DelCrData : DelCbData;

reg [4:0] YMem0 [0:38399];
reg [4:0] YMem1 [0:38399];
reg [4:0] YMem2 [0:38399];
reg [4:0] YMem3 [0:38399];
always @(posedge Cclk)
    if (WEnslant[0] && Del_Valid && Valid_odd) YMem0[CWadd[19:2]] <= DelYData;
always @(posedge Cclk)                                       
    if (WEnslant[1] && Del_Valid && Valid_odd) YMem1[CWadd[19:2]] <= DelYData;
always @(posedge Cclk)                                       
    if (WEnslant[2] && Del_Valid && Valid_odd) YMem2[CWadd[19:2]] <= DelYData;
always @(posedge Cclk)                                       
    if (WEnslant[3] && Del_Valid && Valid_odd) YMem3[CWadd[19:2]] <= DelYData;
reg [4:0] CMem0 [0:38399];
reg [4:0] CMem1 [0:38399];
reg [4:0] CMem2 [0:38399];
reg [4:0] CMem3 [0:38399];
always @(posedge Cclk)
    if (WEnslant[0] && Del_Valid && Valid_odd) CMem0[CWadd[19:2]] <= DelCData;
always @(posedge Cclk)                                       
    if (WEnslant[1] && Del_Valid && Valid_odd) CMem1[CWadd[19:2]] <= DelCData;
always @(posedge Cclk)                                       
    if (WEnslant[2] && Del_Valid && Valid_odd) CMem2[CWadd[19:2]] <= DelCData;
always @(posedge Cclk)                                       
    if (WEnslant[3] && Del_Valid && Valid_odd) CMem3[CWadd[19:2]] <= DelCData;

reg [19:0] HRadd;
always @(posedge Hclk or negedge rstn)
    if (!rstn) HRadd <= 20'h00001;
     else if (!HVsync) HRadd <= 20'h00001;
     else if (HMemRead) HRadd <= HRadd + 1;

reg [4:0] Reg_YMem0;
reg [4:0] Reg_YMem1;
reg [4:0] Reg_YMem2;
reg [4:0] Reg_YMem3;
always @(posedge Hclk)
    Reg_YMem0 <=  YMem0[HRadd[19:3]];
always @(posedge Hclk)
    Reg_YMem1 <=  YMem1[HRadd[19:3]];
always @(posedge Hclk)
    Reg_YMem2 <=  YMem2[HRadd[19:3]];
always @(posedge Hclk)
    Reg_YMem3 <=  YMem3[HRadd[19:3]];
reg [4:0] Reg_CMem0;
reg [4:0] Reg_CMem1;
reg [4:0] Reg_CMem2;
reg [4:0] Reg_CMem3;
always @(posedge Hclk)
    Reg_CMem0 <=  CMem0[HRadd[19:3]];
always @(posedge Hclk)
    Reg_CMem1 <=  CMem1[HRadd[19:3]];
always @(posedge Hclk)
    Reg_CMem2 <=  CMem2[HRadd[19:3]];
always @(posedge Hclk)
    Reg_CMem3 <=  CMem3[HRadd[19:3]];

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

reg [95:0] YCbCr4Pix;
always @(posedge Hclk or negedge rstn)
    if (!rstn) YCbCr4Pix <= {96{1'b0}};
     else if (HRadd[2:0] == 3'b001) YCbCr4Pix <= {Reg_CMem3,3'b000,Reg_CMem2,3'b000,Reg_YMem3,3'b000,
                                                  Reg_CMem3,3'b000,Reg_CMem2,3'b000,Reg_YMem2,3'b000,
                                                  Reg_CMem1,3'b000,Reg_CMem0,3'b000,Reg_YMem1,3'b000,
                                                  Reg_CMem1,3'b000,Reg_CMem0,3'b000,Reg_YMem0,3'b000};

wire [95:0] RGB4Pix;

genvar i;
generate 
for (i=0;i<4;i=i+1) begin
        PixYCbCr2RGB PixYCbCr2RGB_inst(
        .clk      (Hclk),
        .rstn     (rstn),
                 
        .YCbCrData(YCbCr4Pix[24*i+23:24*i]),
        .RGBdata  (RGB4Pix[24*i+23:24*i])
    );

    end
endgenerate     

reg [3:0] OutREnslant[0:2];
always @(posedge Hclk or negedge rstn)
    if (!rstn) begin 
            OutREnslant[0] <= 4'h1;
            OutREnslant[1] <= 4'h1;
            OutREnslant[2] <= 4'h1;
        end
//     else if (!HMemRead && !pVDE) begin
//            OutREnslant[0] <= REnslant;
//            OutREnslant[1] <= REnslant;
//            OutREnslant[2] <= REnslant;
//        end
     else  begin
            OutREnslant[0] <= REnslant;
            OutREnslant[1] <= OutREnslant[0];
            OutREnslant[2] <= OutREnslant[1];
           end

assign  HDMIdata = (Sel) ? Sel_RGB :
                   (OutREnslant[2][0] && Mem_cont[0]) ? RGB4Pix[23:0] :
                   (OutREnslant[2][1] && Mem_cont[1]) ? RGB4Pix[47:24] :
                   (OutREnslant[2][2] && Mem_cont[2]) ? RGB4Pix[71:48] :
                   (OutREnslant[2][3] && Mem_cont[3]) ? RGB4Pix[95:72] : 24'h000000;
  
assign s_axis_video_tready = 1'b1;   

  
endmodule
