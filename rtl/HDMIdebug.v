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

output        Mem_Read,
output [18:0] Mem_Read_Add ,
input  [11:0] Mem_Data,

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
reg        Reg_MemRead;

///////////////////////////////////////////////////////
/////////////// HDMI control Signals //////////////////
///////////////////////////////////////////////////////
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
/////////////// END HDMI control Signals //////////////////

always @(posedge clk or negedge rstn) 
    if (!rstn) Reg_MemRead <= 1'b0;
     else if (activeData && (Hsync_counter == 16'd142)) Reg_MemRead <= 1'b1;
     else if (activeData && (Hsync_counter == 16'd782)) Reg_MemRead <= 1'b0;

reg [19:0] Reg_Read_Men_add;
always @(posedge clk or negedge rstn)
    if (!rstn) Reg_Read_Men_add <= 20'h00000;
     else if (!Reg_VSync) Reg_Read_Men_add <= 20'h00000;
     else if (Reg_MemRead) Reg_Read_Men_add <= Reg_Read_Men_add + 1;

//reg Frame_odd;
//always @(posedge clk or negedge rstn)
//    if (!rstn) Frame_odd <= 1'b0;
//     else if (Vsync_counter == 32'd419999) Frame_odd <= ~Frame_odd;    

reg Line_odd;
always @(posedge clk or negedge rstn)
    if (!rstn) Line_odd <= 1'b0;
     else if (Vsync_counter == 32'd419999) Line_odd <= ~Line_odd;    
     else if ((Hsync_counter == 16'd783) && activeData) Line_odd <= ~Line_odd;    
     
//wire [15:0] BotLine = {8'h02,Switch};   
wire [23:0] Static_Data = (!Reg_pVDE) ? 24'h000000 : 
                          ((Line[15:12] == 4'h8 ) || (colom[15:12] == 4'h8)) ? 
                                                (Reg_Read_Men_add[0] == Line_odd) ? 1'b0 : {Mem_Data[11:8],colom[3:0],Mem_Data[7:4],colom[3:0],Mem_Data[3:0],colom[3:0]} :
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

//assign Mem_Read = Reg_MemRead;
assign Mem_Read = Reg_pVDE;
assign Mem_Read_Add = Reg_Read_Men_add[19:1];


assign Deb_Vsync_counter = Vsync_counter;
assign Deb_Hsync_counter = Hsync_counter;
assign Deb_Line_counter  = Line_counter ;
                                  
endmodule
