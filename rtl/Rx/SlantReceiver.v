`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/04/2021 02:04:00 PM
// Design Name: 
// Module Name: SlantReceiver
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


module SlantReceiver(
input clk,
input rstn,

input [5:0] Receive0Data,
input [5:0] Receive1Data,
input [5:0] Receive2Data,
input [5:0] Receive3Data,

output wire [3:0] FrameEven ,        
output wire [3:0] FrameAdd  ,        
output wire [3:0] HSync     ,       

output FraimSync,
input[1:0]  FraimSel,

output PixelClk,

input HVsync  ,
input HMemRead,
input pVDE    ,
output [23:0] HDMIdata

    );
parameter FRAME1 = 24'haab155;
parameter FRAME0 = 24'haa8d55;
parameter HSYNC  = 8'h55;
wire [3:0] WriteRxY         ;           
wire [3:0] WriteRxC         ;           
wire [16:0] WriteRxAdd[0:3];

genvar i;
wire [5:0] RxData [0:3];
assign RxData[0] = Receive0Data;
assign RxData[1] = Receive1Data;
assign RxData[2] = Receive2Data;
assign RxData[3] = Receive3Data;

generate 
for (i=0;i<4;i=i+1)begin   
    writeRxData 
    #(
    .FRAME1(FRAME1),
    .FRAME0(FRAME0),
    .HSYNC (HSYNC )
    )
    writeRxData_inst
    (
    .clk (clk ),                  // input wire clk,
    .rstn(rstn),                 // input wire rstn,
                              // 
    .ReceiveData(RxData[i]),    // input wire [5:0] ReceiveData,
                        // 
    .WriteRxY  (WriteRxY  [i]),            // output wire WriteRxY,
    .WriteRxC  (WriteRxC  [i]),            // output wire WriteRxC,
    .WriteRxAdd(WriteRxAdd[i]),   // output wire [17:0] WriteRxAdd,
                         // 
    .FrameEven(FrameEven[i]) ,          // output wire FrameEven ,        
    .FrameAdd (FrameAdd [i]) ,          // output wire FrameAdd  ,        
    .HSync    (HSync    [i])            // output wire HSync            
        );
end 
endgenerate     

reg [4:0] YMem0 [0:38399]; // 95ff
reg [4:0] YMem1 [0:38399];
reg [4:0] YMem2 [0:38399];
reg [4:0] YMem3 [0:38399];
always @(posedge clk)
    if (WriteRxY[0]) YMem0[WriteRxAdd[0]] <= Receive0Data;
always @(posedge clk)
    if (WriteRxY[1]) YMem1[WriteRxAdd[1]] <= Receive1Data;
always @(posedge clk)
    if (WriteRxY[2]) YMem2[WriteRxAdd[2]] <= Receive2Data;
always @(posedge clk)
    if (WriteRxY[3]) YMem3[WriteRxAdd[3]] <= Receive3Data;
reg [4:0] CMem0 [0:38399];
reg [4:0] CMem1 [0:38399];
reg [4:0] CMem2 [0:38399];
reg [4:0] CMem3 [0:38399];
always @(posedge clk)
    if (WriteRxC[0]) CMem0[WriteRxAdd[0]] <= Receive0Data;
always @(posedge clk)
    if (WriteRxC[1]) CMem1[WriteRxAdd[1]] <= Receive1Data;
always @(posedge clk)
    if (WriteRxC[2]) CMem2[WriteRxAdd[2]] <= Receive2Data;
always @(posedge clk)
    if (WriteRxC[3]) CMem3[WriteRxAdd[3]] <= Receive3Data;

reg Reg_FraimSync;
always @(posedge clk or negedge rstn) 
    if (!rstn) Reg_FraimSync <= 1'b0;
     else if (FraimSel == 2'b11) Reg_FraimSync <= 1'b1;
     else if (FraimSel == 2'b10) Reg_FraimSync <= 1'b0;
     else if (FrameEven) Reg_FraimSync <= 1'b1;
     else if (FrameAdd ) Reg_FraimSync <= 1'b0;
assign FraimSync = Reg_FraimSync;

reg [2:0] Cnt_Div_Clk;
always @(posedge clk or negedge rstn)
    if (!rstn) Cnt_Div_Clk <= 3'b000;
     else if (Cnt_Div_Clk == 3'b100) Cnt_Div_Clk <= 3'b000;
     else Cnt_Div_Clk <= Cnt_Div_Clk + 1;
reg Reg_Div_Clk;
always @(posedge clk or negedge rstn)
    if (!rstn) Reg_Div_Clk <= 1'b0;
     else if (Cnt_Div_Clk == 3'b000)  Reg_Div_Clk <= 1'b1;
     else if (Cnt_Div_Clk == 3'b010)  Reg_Div_Clk <= 1'b0;

   BUFG BUFG_inst (
      .O(PixelClk), // 1-bit output: Clock output
      .I(Reg_Div_Clk)  // 1-bit input: Clock input
   );
//assign PixelClk = Reg_Div_Clk;

reg [19:0] HRadd;

reg [4:0] Reg_YMem0;
reg [4:0] Reg_YMem1;
reg [4:0] Reg_YMem2;
reg [4:0] Reg_YMem3;
always @(posedge clk)
    Reg_YMem0 <=  YMem0[HRadd[19:3]];
always @(posedge clk)
    Reg_YMem1 <=  YMem1[HRadd[19:3]];
always @(posedge clk)
    Reg_YMem2 <=  YMem2[HRadd[19:3]];
always @(posedge clk)
    Reg_YMem3 <=  YMem3[HRadd[19:3]];
reg [4:0] Reg_CMem0;
reg [4:0] Reg_CMem1;
reg [4:0] Reg_CMem2; 
reg [4:0] Reg_CMem3; 
always @(posedge clk)
    Reg_CMem0 <=  CMem1[HRadd[19:3]];
always @(posedge clk)
    Reg_CMem1 <=  CMem1[HRadd[19:3]];
always @(posedge clk)
    Reg_CMem2 <=  CMem2[HRadd[19:3]];
always @(posedge clk)
    Reg_CMem3 <=  CMem3[HRadd[19:3]];

always @(posedge clk or negedge rstn)
    if (!rstn) HRadd <= 20'h00001;
     else if (!HVsync) HRadd <= 20'h00001;
     else if ((Cnt_Div_Clk == 3'b000) && HMemRead) HRadd <= HRadd + 1;

reg Del_HMemRead;
always @(posedge clk or negedge rstn) 
    if (!rstn) Del_HMemRead <= 1'b0;
     else Del_HMemRead <= HMemRead;
reg [3:0] REnslant;
always @(posedge clk or negedge rstn)
    if (!rstn) REnslant <= 4'h1;
     else if (!HVsync) REnslant <= 4'h1;
     else if ((Cnt_Div_Clk == 3'b001) && !HMemRead && Del_HMemRead) REnslant <= {REnslant[0],REnslant[3:1]};
     else if ((Cnt_Div_Clk == 3'b000) && HMemRead && !HRadd[0]) REnslant <= {REnslant[2:0],REnslant[3]};

reg [95:0] YCbCr4Pix;
always @(posedge clk or negedge rstn)
    if (!rstn) YCbCr4Pix <= {96{1'b0}};
     else if (Cnt_Div_Clk == 3'b011) YCbCr4Pix <= {Reg_CMem3,3'b000,Reg_CMem2,3'b000,Reg_YMem3,3'b000,
                                                   Reg_CMem3,3'b000,Reg_CMem2,3'b000,Reg_YMem2,3'b000,
                                                   Reg_CMem1,3'b000,Reg_CMem0,3'b000,Reg_YMem1,3'b000,
                                                   Reg_CMem1,3'b000,Reg_CMem0,3'b000,Reg_YMem0,3'b000};
wire [95:0] RGB4Pix;
generate 
for (i=0;i<4;i=i+1) begin
        PixYCbCr2RGB PixYCbCr2RGB_inst(
        .clk      (clk),
        .rstn     (rstn),
                 
        .YCbCrData(YCbCr4Pix[24*i+23:24*i]),
        .RGBdata  (RGB4Pix[24*i+23:24*i])
    );

    end
endgenerate     

assign  HDMIdata = (REnslant[0]) ? RGB4Pix[23:0] :
                   (REnslant[1]) ? RGB4Pix[47:24] :
                   (REnslant[2]) ? RGB4Pix[71:48] :
                   (REnslant[3]) ? RGB4Pix[95:72] : 24'h000000;
    
endmodule
