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

//localparam GYCONST = 256;
//localparam BYCONST = 256;
//localparam RYCONST = 256;

//localparam GCBCONST  = 88;
//localparam BCB1CONST = 256;
//localparam BCBCONST  = 198;
//localparam RCBCONST  = 0;

//localparam GCRCONST  = 183;
//localparam BCRCONST  = 0;
//localparam RCR1CONST = 256;
//localparam RCRCONST  = 103;

localparam GYCONST = 32;
localparam BYCONST = 32;
localparam RYCONST = 32;

localparam GCBCONST  = 11;
localparam BCB1CONST = 32;
localparam BCBCONST  = 25;
localparam RCBCONST  = 0;

localparam GCRCONST  = 23;
localparam BCRCONST  = 0;
localparam RCR1CONST = 32;
localparam RCRCONST  = 13;

wire signed [5:0] oY  = {1'b0,YCbCrData  [7:3]} - 6'h00;
wire signed [5:0] oCb = {1'b0,YCbCrData[15:11]} - 6'h10;
wire signed [5:0] oCr = {1'b0,YCbCrData[23:19]} - 6'h10;

reg signed [10:0] GY  ;
reg signed [10:0] GCb ;
reg signed [10:0] GCr ;

always @(posedge clk or negedge rstn)
    if (!rstn) GY  <= 11'h000 ;
     else GY  <= GYCONST*oY ;
always @(posedge clk or negedge rstn)
    if (!rstn) GCb <= 11'h000 ;
     else GCb <= GCBCONST*oCb;
always @(posedge clk or negedge rstn)
    if (!rstn) GCr <= 11'h000 ;
     else GCr <= GCRCONST*oCr;

reg signed [10:0] BY  ;
reg signed [10:0] BCb ;
reg signed [10:0] BCr ;

always @(posedge clk or negedge rstn)
    if (!rstn) BY  <= 11'h000 ;
     else BY  <= BYCONST*oY ;
always @(posedge clk or negedge rstn)
    if (!rstn) BCb <= 11'h000 ;
     else BCb <= BCB1CONST*oCb + BCBCONST*oCb;
always @(posedge clk or negedge rstn)
    if (!rstn) BCr <= 11'h000 ;
     else BCr <= BCRCONST*oCr;

reg signed [10:0] RY  ;
reg signed [10:0] RCb ;
reg signed [10:0] RCr ;

always @(posedge clk or negedge rstn)
    if (!rstn) RY  <= 11'h000 ;
     else RY  <= RYCONST*oY ;
always @(posedge clk or negedge rstn)
    if (!rstn) RCb <= 11'h000 ;
     else RCb <= RCBCONST*oCb;
always @(posedge clk or negedge rstn)
    if (!rstn) RCr <= 11'h000 ;
     else RCr <= RCR1CONST*oCr + RCRCONST*oCr;

wire signed [10:0] SLongR = RY + RCb + RCr;
wire signed [10:0] SLongG = GY - GCb - GCr;
wire signed [10:0] SLongB = BY + BCb + BCr;

wire [4:0] LongR = (SLongR[10:9] == 2'b10) ? 5'h1f : (SLongR[10:9] == 2'b11) ? 5'h00 : SLongR[9:5] ;
wire [4:0] LongG = (SLongG[10:9] == 2'b10) ? 5'h1f : (SLongG[10:9] == 2'b11) ? 5'h00 : SLongG[9:5] ;
wire [4:0] LongB = (SLongB[10:9] == 2'b10) ? 5'h1f : (SLongB[10:9] == 2'b11) ? 5'h00 : SLongB[9:5] ;


reg [23:0] Reg_RGBdata  ;

always @(posedge clk or negedge rstn)
    if (!rstn) Reg_RGBdata    <= 24'h000000;  
     else Reg_RGBdata  <= {LongR,3'b000,LongB,3'b000,LongG,3'b000};

assign RGBdata = Reg_RGBdata;
    
endmodule
