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
//input  wire [23 : 0] s_axis_video_tdata    ,
input  wire [31 : 0] s_axis_video_tdata ,
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
//localparam YRCONST = 77;
//localparam YGCONST = 150;
//localparam YBCONST = 29;

//localparam CBRCONST = 43;
//localparam CBGCONST = 85;
//localparam CBBCONST = 128;

//localparam CRRCONST = 128;
//localparam CRGCONST = 107;
//localparam CRBCONST = 21;

//localparam YGCONST = 19;
localparam YGCONST = 13;
localparam YBCONST = 4;
localparam YRCONST = 10;

//localparam CBGCONST = 11;
localparam CBGCONST = 5;
localparam CBBCONST = 16;
localparam CBRCONST = 5;

//localparam CRGCONST = 13;
localparam CRGCONST = 7;
localparam CRBCONST = 3;
localparam CRRCONST = 16;

wire [4:0] G =  s_axis_video_tdata  [9:5];
wire [4:0] B =  s_axis_video_tdata[19:15];
wire [4:0] R =  s_axis_video_tdata[29:25];

reg [9:0] YG ;
reg [9:0] YB ;
reg [9:0] YR ;

always @(posedge clk or negedge rstn)
    if (!rstn) YG <= 10'h000 ;
     else YG <= YGCONST*G;
always @(posedge clk or negedge rstn)
    if (!rstn) YB <= 10'h000 ;
     else YB <= YBCONST*B;
always @(posedge clk or negedge rstn)
    if (!rstn) YR <= 10'h000 ;
     else YR <= YRCONST*R;

reg [9:0] CbG ;
reg [9:0] CbB ;
reg [9:0] CbR ;

always @(posedge clk or negedge rstn)
    if (!rstn) CbG <= 10'h000 ;
     else CbG <= CBGCONST*G;
always @(posedge clk or negedge rstn)
    if (!rstn) CbB <= 10'h000 ;
     else CbB <= CBBCONST*B;
always @(posedge clk or negedge rstn)
    if (!rstn) CbR <= 10'h000 ;
     else CbR <= CBRCONST*R;

reg [9:0] CrG ;
reg [9:0] CrB ;
reg [9:0] CrR ;

always @(posedge clk or negedge rstn)
    if (!rstn) CrG <= 10'h000 ;
     else CrG <= CRGCONST*G;
always @(posedge clk or negedge rstn)
    if (!rstn) CrB <= 10'h000 ;
     else CrB <= CRBCONST*B;
always @(posedge clk or negedge rstn)
    if (!rstn) CrR <= 10'h000 ;
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

wire [10:0] LongY  = 10'h000 + YR  + YG  + YB; 
wire [10:0] LongCb = 10'h200 - CbR - CbG + CbB; 
wire [10:0] LongCr = 10'h200 + CrR - CrG - CrB; 

wire [4:0] Y  = (LongY[10:9] == 2'b10) ? 5'h1f : LongY [9:5]  ;
wire [4:0] Cb = (LongY[10:9] == 2'b10) ? 5'h1f : LongCb[9:5] ;
wire [4:0] Cr = (LongY[10:9] == 2'b10) ? 5'h1f : LongCr[9:5] ;



reg [23:0] Reg1_m_axis_video_tdata  ;
reg        Reg1_m_axis_video_tvalid ;
reg        Reg1_s_axis_video_tready ;
reg        Reg1_m_axis_video_tlast  ;
reg        Reg1_m_axis_video_tuser  ;   

always @(posedge clk or negedge rstn)
    if (!rstn) Reg1_m_axis_video_tdata  <= 24'h000000;
     else Reg1_m_axis_video_tdata  <= {Cr,3'b000,Cb,3'b000,Y,3'b000};
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
