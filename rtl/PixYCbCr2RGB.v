`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.09.2021 22:15:58
// Design Name: 
// Module Name: PixYCbCr2RGB
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


module PixYCbCr2RGB(
input  wire clk ,
input  wire rstn,

input [23:0] YCbCrData,
output [23:0] RGBdata
    );

localparam RYCONST = 256;
localparam GYCONST = 256;
localparam BYCONST = 256;

localparam RCBCONST  = 0;
localparam GCBCONST  = 88;
localparam BCB1CONST = 256;
localparam BCBCONST  = 198;

localparam RCR1CONST = 256;
localparam RCRCONST  = 103;
localparam GCRCONST  = 183;
localparam BCRCONST  = 0;

wire signed [8:0] oY  = {1'b0,YCbCrData  [7:0]} - 9'h000;
wire signed [8:0] oCb = {1'b0,YCbCrData [15:8]} - 9'h080;
wire signed [8:0] oCr = {1'b0,YCbCrData[23:16]} - 9'h080;

reg signed [17:0] RY  ;
reg signed [17:0] RCb ;
reg signed [17:0] RCr ;

always @(posedge clk or negedge rstn)
    if (!rstn) RY  <= 18'h00000 ;
     else RY  <= RYCONST*oY ;
always @(posedge clk or negedge rstn)
    if (!rstn) RCb <= 18'h00000 ;
     else RCb <= RCBCONST*oCb;
always @(posedge clk or negedge rstn)
    if (!rstn) RCr <= 18'h00000 ;
     else RCr <= RCR1CONST*oCr + RCRCONST*oCr;

reg signed [17:0] GY  ;
reg signed [17:0] GCb ;
reg signed [17:0] GCr ;

always @(posedge clk or negedge rstn)
    if (!rstn) GY  <= 18'h00000 ;
     else GY  <= GYCONST*oY ;
always @(posedge clk or negedge rstn)
    if (!rstn) GCb <= 18'h00000 ;
     else GCb <= GCBCONST*oCb;
always @(posedge clk or negedge rstn)
    if (!rstn) GCr <= 18'h00000 ;
     else GCr <= GCRCONST*oCr;

reg signed [17:0] BY  ;
reg signed [17:0] BCb ;
reg signed [17:0] BCr ;

always @(posedge clk or negedge rstn)
    if (!rstn) BY  <= 18'h00000 ;
     else BY  <= BYCONST*oY ;
always @(posedge clk or negedge rstn)
    if (!rstn) BCb <= 18'h00000 ;
     else BCb <= BCB1CONST*oCb + BCBCONST*oCb;
always @(posedge clk or negedge rstn)
    if (!rstn) BCr <= 18'h00000 ;
     else BCr <= BCRCONST*oCr;

wire signed [17:0] SLongR = RY + RCb + RCr;
wire signed [17:0] SLongG = GY - GCb - GCr;
wire signed [17:0] SLongB = BY + BCb + BCr;

wire [15:0] LongR = (SLongR[17:15] == 3'b010) ? 16'hff00 : (SLongR[17:15] == 3'b111) ? 16'h0000 : SLongR[15:0] ;
wire [15:0] LongG = (SLongG[17:15] == 3'b010) ? 16'hff00 : (SLongG[17:15] == 3'b111) ? 16'h0000 : SLongG[15:0] ;
wire [15:0] LongB = (SLongB[17:15] == 3'b010) ? 16'hff00 : (SLongB[17:15] == 3'b111) ? 16'h0000 : SLongB[15:0] ;


reg [23:0] Reg_RGBdata  ;

always @(posedge clk or negedge rstn)
    if (!rstn) Reg_RGBdata    <= 24'h000000;  
     else Reg_RGBdata  <= {LongR[15:8],LongB[15:8],LongG[15:8]};

assign RGBdata = Reg_RGBdata;
    
endmodule
