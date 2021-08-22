`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.08.2021 14:07:48
// Design Name: 
// Module Name: HDMIdebug
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


module HDMIdebug(
input clk,
input rstn,

input [15:0] colom,
input [15:0] Line,

output [23:0] Out_pData ,
output        Out_pVSync,
output        Out_pHSync,
output        Out_pVDE  ,

output [31:0] Deb_Vsync_counter,
output [15:0] Deb_Hsync_counter,
output [15:0] Deb_Line_counter 
    );

reg [31:0] Vsync_counter;
reg [15:0] Hsync_counter;
reg [15:0] Line_counter;
reg        Reg_VSync;
reg        Reg_HSync;
reg        activeData;
reg        Reg_pVDE;

always @(posedge clk or negedge rstn) 
    if (!rstn) Vsync_counter <= 32'h00000000;
     else if (Vsync_counter == 32'd419999) Vsync_counter <= 32'h00000000;
     else Vsync_counter <= Vsync_counter + 1;
always @(posedge clk or negedge rstn) 
    if (!rstn) Reg_VSync <= 1'b1;
     else if (Vsync_counter == 32'd419999) Reg_VSync <= 1'b0;
     else if (Vsync_counter == 32'd1599) Reg_VSync <= 1'b1;
	 
always @(posedge clk or negedge rstn) 
    if (!rstn) Hsync_counter <= 16'h0000;
     else if (Vsync_counter == 32'd419999) Hsync_counter <= 16'h0000;
     else if (Hsync_counter == 16'd799) Hsync_counter <= 16'h0000;
     else Hsync_counter <= Hsync_counter + 1;
always @(posedge clk or negedge rstn) 
    if (!rstn) Reg_HSync <= 1'b1;
     else if (Hsync_counter == 16'd799) Reg_HSync <= 1'b0;
     else if (Hsync_counter == 16'd95) Reg_HSync <= 1'b1;

always @(posedge clk or negedge rstn) 
    if (!rstn) Line_counter <= 16'h0000;
     else if (Vsync_counter == 32'h00000000) Line_counter <= 16'h0000;
     else if (Hsync_counter == 16'h0000) Line_counter <= Line_counter + 1;

always @(posedge clk or negedge rstn) 
    if (!rstn) activeData <= 1'b0;
     else if (Reg_HSync && (Line_counter == 16'd35)) activeData <= 1'b1;
     else if (Reg_HSync && (Line_counter == 16'd515)) activeData <= 1'b0;

always @(posedge clk or negedge rstn) 
    if (!rstn) Reg_pVDE <= 1'b0;
     else if (activeData && (Hsync_counter == 16'd143)) Reg_pVDE <= 1'b1;
     else if (activeData && (Hsync_counter == 16'd783)) Reg_pVDE <= 1'b0;
//wire [15:0] BotLine = {8'h02,Switch};   
wire [23:0] Static_Data = (!Reg_pVDE) ? 24'h000000 :
                          ((Line_counter == Line ) && (Hsync_counter == colom)) ? 24'hffffff :  24'hff0000;
//                          ((Line_counter == 16'h0019) && (Hsync_counter == 16'd0260)) ? 24'hffffff :
//                          ((Line_counter == 16'h0019) && (Hsync_counter == 16'd1539)) ? 24'hffffff :
//                          ((Line_counter == BotLine ) && (Hsync_counter == 16'd0260)) ? 24'hffffff :
//                          ((Line_counter == BotLine ) && (Hsync_counter == 16'd1539)) ? 24'hffffff :  24'hff0000;

//assign Out_pData  = (!Switch[2]) ? vid_pData  : Static_Data ;
//assign Out_pVSync = (!Switch[2]) ? vid_pVSync : Reg_VSync ;
//assign Out_pHSync = (!Switch[2]) ? vid_pHSync : Reg_HSync ;
//assign Out_pVDE   = (!Switch[2]) ? vid_pVDE   : Reg_pVDE  ;
assign Out_pData  =  Static_Data ;
assign Out_pVSync =  Reg_VSync ;
assign Out_pHSync =  Reg_HSync ;
assign Out_pVDE   =  Reg_pVDE  ;

assign Deb_Vsync_counter = Vsync_counter;
assign Deb_Hsync_counter = Hsync_counter;
assign Deb_Line_counter  = Line_counter ;
                                  
endmodule
