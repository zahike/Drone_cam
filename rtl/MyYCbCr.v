`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.09.2021 13:01:01
// Design Name: 
// Module Name: MyYCbCr
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


module MyYCbCr(
input  wire clk ,
input  wire rstn,
input  wire Sel,
input  wire [23 : 0] Sel_RGB    ,
input  wire [23 : 0] s_axis_video_tdata    ,
output wire s_axis_video_tready            ,
input  wire s_axis_video_tvalid            ,
input  wire s_axis_video_tlast             ,
input  wire s_axis_video_tuser         ,
output wire [23 : 0] m_axis_video_tdata    ,
output wire m_axis_video_tvalid            ,
input  wire m_axis_video_tready            ,
output wire m_axis_video_tlast             ,
output wire m_axis_video_tuser       
    );
localparam YRCONST = 77;
localparam YGCONST = 150;
localparam YBCONST = 29;

localparam CBRCONST = 43;
localparam CBGCONST = 85;
localparam CBBCONST = 128;

localparam CRRCONST = 128;
localparam CRGCONST = 107;
localparam CRBCONST = 21;

wire [7:0] G = (Sel) ? Sel_RGB  [7:0] : s_axis_video_tdata  [7:0];
wire [7:0] B = (Sel) ? Sel_RGB [15:8] : s_axis_video_tdata [15:8];
wire [7:0] R = (Sel) ? Sel_RGB[23:16] : s_axis_video_tdata[23:16];

reg [15:0] YG ;
reg [15:0] YB ;
reg [15:0] YR ;

always @(posedge clk or negedge rstn)
    if (!rstn) YG <= 16'h0000 ;
     else YG <= YGCONST*G;
always @(posedge clk or negedge rstn)
    if (!rstn) YB <= 16'h0000 ;
     else YB <= YBCONST*B;
always @(posedge clk or negedge rstn)
    if (!rstn) YR <= 16'h0000 ;
     else YR <= YRCONST*R;

//wire [15:0] YG = YGCONST*G;
//wire [15:0] YB = YBCONST*B;
//wire [15:0] YR = YRCONST*R;

reg [15:0] CbG ;
reg [15:0] CbB ;
reg [15:0] CbR ;

always @(posedge clk or negedge rstn)
    if (!rstn) CbG <= 16'h0000 ;
     else CbG <= CBGCONST*G;
always @(posedge clk or negedge rstn)
    if (!rstn) CbB <= 16'h0000 ;
     else CbB <= CBBCONST*B;
always @(posedge clk or negedge rstn)
    if (!rstn) CbR <= 16'h0000 ;
     else CbR <= CBRCONST*R;

//wire [15:0] CbG = CBGCONST*G;
//wire [15:0] CbB = CBBCONST*B;
//wire [15:0] CbR = CBRCONST*R;

reg [15:0] CrG ;
reg [15:0] CrB ;
reg [15:0] CrR ;

always @(posedge clk or negedge rstn)
    if (!rstn) CrG <= 16'h0000 ;
     else CrG <= CRGCONST*G;
always @(posedge clk or negedge rstn)
    if (!rstn) CrB <= 16'h0000 ;
     else CrB <= CRBCONST*B;
always @(posedge clk or negedge rstn)
    if (!rstn) CrR <= 16'h0000 ;
     else CrR <= CRRCONST*R;

reg        Reg_m_axis_video_tvalid ;
reg        Reg_s_axis_video_tready ;
reg        Reg_m_axis_video_tlast  ;
reg        Reg_m_axis_video_tuser  ;   

always @(posedge clk or negedge rstn)
    if (!rstn) Reg_m_axis_video_tvalid <= 1'b0;
     else Reg_m_axis_video_tvalid <= s_axis_video_tvalid;
always @(posedge clk or negedge rstn)
    if (!rstn) Reg_s_axis_video_tready <= 1'b0;
     else Reg_s_axis_video_tready <= m_axis_video_tready ;
always @(posedge clk or negedge rstn)
    if (!rstn) Reg_m_axis_video_tlast  <= 1'b0;
     else Reg_m_axis_video_tlast  <= s_axis_video_tlast ;
always @(posedge clk or negedge rstn)
    if (!rstn) Reg_m_axis_video_tuser  <= 1'b0;  
     else Reg_m_axis_video_tuser  <= s_axis_video_tuser ;     

//wire [15:0] CrG = CRGCONST*G;
//wire [15:0] CrB = CRBCONST*B;
//wire [15:0] CrR = CRRCONST*R;

//wire [16:0] LongY  = 16'h1000 + YRCONST*R  + YGCONST*G  + YBCONST*B; 
//wire [15:0] LongCb = 16'h8000 - CBRCONST*R - CBGCONST*G + CBBCONST*B; 
//wire [15:0] LongCr = 16'h8000 + CRRCONST*R - CRGCONST*G - CRBCONST*B; 

wire [17:0] LongY  = 16'h1000 + YR  + YG  + YB; 
wire [17:0] LongCb = 16'h8000 - CbR - CbG + CbB; 
wire [17:0] LongCr = 16'h8000 + CrR - CrG - CrB; 

wire [7:0] Y  = (LongY[16]) ? 8'hff :LongY[15:8]  ;
wire [7:0] Cb = LongCb[15:8] ;
wire [7:0] Cr = LongCr[15:8] ;



reg [23:0] Reg1_m_axis_video_tdata  ;
reg        Reg1_m_axis_video_tvalid ;
reg        Reg1_s_axis_video_tready ;
reg        Reg1_m_axis_video_tlast  ;
reg        Reg1_m_axis_video_tuser  ;   

always @(posedge clk or negedge rstn)
    if (!rstn) Reg1_m_axis_video_tdata  <= 24'h000000;
     else Reg1_m_axis_video_tdata  <= {Cr,Cb,Y};
always @(posedge clk or negedge rstn)
    if (!rstn) Reg1_m_axis_video_tvalid <= 1'b0;
     else Reg1_m_axis_video_tvalid <= Reg_m_axis_video_tvalid;
always @(posedge clk or negedge rstn)
    if (!rstn) Reg1_s_axis_video_tready <= 1'b0;
     else Reg1_s_axis_video_tready <= Reg_s_axis_video_tready ;
always @(posedge clk or negedge rstn)
    if (!rstn) Reg1_m_axis_video_tlast  <= 1'b0;
     else Reg1_m_axis_video_tlast  <= Reg_m_axis_video_tlast ;
always @(posedge clk or negedge rstn)
    if (!rstn) Reg1_m_axis_video_tuser  <= 1'b0;  
     else Reg1_m_axis_video_tuser  <= Reg_m_axis_video_tuser ;     


assign m_axis_video_tdata  = Reg1_m_axis_video_tdata ;
assign m_axis_video_tvalid = Reg1_m_axis_video_tvalid;
assign s_axis_video_tready = Reg1_s_axis_video_tready;
assign m_axis_video_tlast  = Reg1_m_axis_video_tlast ;
assign m_axis_video_tuser  = Reg1_m_axis_video_tuser ;    

endmodule
