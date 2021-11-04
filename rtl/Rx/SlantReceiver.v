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

output wire FrameEven ,        
output wire FrameAdd  ,        
output wire HSync     ,       

input [3:0] Mem_cont,

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
/*    
wire Sync0 = (Receive0Data > 6'h1f) ? 1'b1 : 1'b0;
reg [1:0] DevRe0Data;
always @(posedge clk or negedge rstn) 
    if (!rstn) DevRe0Data <= 2'b00;
     else DevRe0Data <= {DevRe0Data[0],Sync0};
wire PosRe0Data = (DevRe0Data == 2'b01) ? 1'b1 : 1'b0;     
wire NegRe0Data = (DevRe0Data == 2'b10) ? 1'b1 : 1'b0;

reg [7:0] Bit0MeasureCount;
reg [7:0] EndOfBit;
reg [7:0] BitTime0Counter;
reg [7:0] configBitTime [0:3];
reg [4:0] configBitSR;
reg SetBitTime;

always @(posedge clk or negedge rstn)
    if (!rstn) SetBitTime <= 1'b0;
     else if (Receive0Data > 6'h1f) SetBitTime <= 1'b1;
     else if (Bit0MeasureCount > 8'h24) SetBitTime <= 1'b0;

always @(posedge clk or negedge rstn)
    if (!rstn) Bit0MeasureCount <= 8'h00;
     else if (!SetBitTime) Bit0MeasureCount <= 8'h00;      
     else if (PosRe0Data || NegRe0Data) Bit0MeasureCount <= 8'h00;      
     else Bit0MeasureCount <= Bit0MeasureCount + 1;
     
always @(posedge clk or negedge rstn)
    if (!rstn) begin 
            configBitTime[0] <= 8'h00;
            configBitTime[1] <= 8'h00;
            configBitTime[2] <= 8'h00;
            configBitTime[3] <= 8'h00;
            configBitSR      <= 5'h00;
         end 
     else if (!SetBitTime) begin 
            configBitTime[0] <= 8'h00;
            configBitTime[1] <= 8'h00;
            configBitTime[2] <= 8'h00;
            configBitTime[3] <= 8'h00;
            configBitSR      <= 5'h00;
         end
     else if (PosRe0Data || NegRe0Data) begin 
                configBitTime[0] <= Bit0MeasureCount;
                configBitTime[1] <= configBitTime[0];
                configBitTime[2] <= configBitTime[1];
                configBitTime[3] <= configBitTime[2];
                configBitSR      <= {configBitSR[3:0],SetBitTime};
             end

wire [9:0] avrageBitTime = configBitTime[3] + configBitTime[2] + configBitTime[1] + configBitTime[0];


always @(posedge clk or negedge rstn)
    if (!rstn) EndOfBit <= 8'h18;
     else if (configBitSR == 5'h1f) EndOfBit <= avrageBitTime[9:2];
    
always @(posedge clk or negedge rstn)
    if (!rstn) BitTime0Counter <= 8'h00;
     else if (PosRe0Data || NegRe0Data) BitTime0Counter <= 8'h00;      
     else if (BitTime0Counter == EndOfBit) BitTime0Counter <= 8'h00;      
     else BitTime0Counter <= BitTime0Counter + 1;

reg [23:0] SyncShiftReg;
always @(posedge clk or negedge rstn) 
    if (!rstn) SyncShiftReg <= 24'h000000;
     else if (BitTime0Counter == 8'h14) SyncShiftReg <= {SyncShiftReg[22:0],Sync0};
assign FrameEven = (SyncShiftReg == FRAME1) ? 1'b1 : 1'b0;         
assign FrameAdd  = (SyncShiftReg == FRAME0) ? 1'b1 : 1'b0;         
assign HSync     = (SyncShiftReg == {16'h0000,HSYNC}) ? 1'b1 : 1'b0;         


reg Frame0_received;
reg [17:0] Frame0_nextLine;
reg [17:0] RXadd0;
always @(posedge clk or negedge rstn)
    if (!rstn) Frame0_received <= 1'b0;
     else if (FrameEven || FrameAdd) Frame0_received <= 1'b1; 
     else if (RXadd0 == 18'h12C00) Frame0_received <= 1'b0;
always @(posedge clk or negedge rstn)
    if (!rstn) Frame0_nextLine <= 18'h0009e;
     else if (FrameEven || FrameAdd) Frame0_nextLine <= 18'h0009e;    
     else if ((BitTime0Counter == 8'h00) && HSync) Frame0_nextLine <= Frame0_nextLine + 18'h000a0;    
always @(posedge clk or negedge rstn)
    if (!rstn) RXadd0 <= 18'h00000;
     else if (FrameEven || FrameAdd) RXadd0 <= 18'h00000;
     else if ((BitTime0Counter == 8'h16) && HSync) RXadd0 <= Frame0_nextLine;
     else if (BitTime0Counter == 8'h16) RXadd0 <= RXadd0 + 1;
*/
wire WriteRxY         ;           
wire WriteRxC         ;           
wire [17:0] WriteRxAdd;
  
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
.ReceiveData(Receive0Data),    // input wire [5:0] ReceiveData,
                    // 
.WriteRxY  (WriteRxY  ),            // output wire WriteRxY,
.WriteRxC  (WriteRxC  ),            // output wire WriteRxC,
.WriteRxAdd(WriteRxAdd),   // output wire [17:0] WriteRxAdd,
                     // 
.FrameEven(FrameEven) ,          // output wire FrameEven ,        
.FrameAdd (FrameAdd ) ,          // output wire FrameAdd  ,        
.HSync    (HSync    )            // output wire HSync            
    );
     
reg [4:0] YMem0 [0:38399]; // 95ff
//reg [4:0] YMem0 [0:127]; // 95ff
//reg [4:0] YMem1 [0:38399];
//reg [4:0] YMem2 [0:38399];
//reg [4:0] YMem3 [0:38399];
always @(posedge clk)
//    if (Frame0_received && (BitTime0Counter == 8'h14) && !RXadd0[0]) YMem0[RXadd0[17:1]] <= Receive0Data;
    if (WriteRxY) YMem0[WriteRxAdd[17:1]] <= Receive0Data;
//always @(posedge Cclk)                                       
//    if (WEnslant[1] && Del_Valid && Valid_odd) YMem1[CWadd[19:2]] <= DelYData;
//always @(posedge Cclk)                                       
//    if (WEnslant[2] && Del_Valid && Valid_odd) YMem2[CWadd[19:2]] <= DelYData;
//always @(posedge Cclk)                                       
//    if (WEnslant[3] && Del_Valid && Valid_odd) YMem3[CWadd[19:2]] <= DelYData;
reg [4:0] CMem0 [0:38399];
//reg [4:0] CMem0 [0:127];
//reg [4:0] CMem1 [0:38399];
//reg [4:0] CMem2 [0:38399];
//reg [4:0] CMem3 [0:38399];
always @(posedge clk)
//    if (Frame0_received && (BitTime0Counter == 8'h14) && RXadd0[0]) CMem0[RXadd0[17:1]] <= Receive0Data;
    if (WriteRxC) CMem0[WriteRxAdd[17:1]] <= Receive0Data;
//always @(posedge Cclk)                                       
//    if (WEnslant[1] && Del_Valid && Valid_odd) CMem1[CWadd[19:2]] <= DelCData;
//always @(posedge Cclk)                                       
//    if (WEnslant[2] && Del_Valid && Valid_odd) CMem2[CWadd[19:2]] <= DelCData;
//always @(posedge Cclk)                                       
//    if (WEnslant[3] && Del_Valid && Valid_odd) CMem3[CWadd[19:2]] <= DelCData;

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

//   BUFG BUFG_inst (
//      .O(PixelClk), // 1-bit output: Clock output
//      .I(Reg_Div_Clk)  // 1-bit input: Clock input
//   );
assign PixelClk = Reg_Div_Clk;

reg [19:0] HRadd;

reg [4:0] Reg_YMem0;
wire [4:0] Reg_YMem1 = 5'h00;
wire [4:0] Reg_YMem2 = 5'h00;
wire [4:0] Reg_YMem3 = 5'h00;
//reg [4:0] Reg_YMem1;
//reg [4:0] Reg_YMem2;
//reg [4:0] Reg_YMem3;
always @(posedge clk)
    Reg_YMem0 <=  YMem0[HRadd[19:3]];
//always @(posedge Cclk)
//    Reg_YMem1 <=  YMem1[readMemAdd];
//always @(posedge Cclk)
//    Reg_YMem2 <=  YMem2[readMemAdd];
//always @(posedge Cclk)
//    Reg_YMem3 <=  YMem3[readMemAdd];
wire [4:0] Reg_CMem0 = 5'h10; 
wire [4:0] Reg_CMem1 = 5'h10; 
wire [4:0] Reg_CMem2 = 5'h10; 
wire [4:0] Reg_CMem3 = 5'h10; 
//reg [4:0] Reg_CMem1;
//reg [4:0] Reg_CMem2;
//reg [4:0] Reg_CMem3;
//always @(posedge Cclk)
//    Reg_CMem1 <=  CMem1[readMemAdd];
//always @(posedge Cclk)
//    Reg_CMem2 <=  CMem2[readMemAdd];
//always @(posedge Cclk)
//    Reg_CMem3 <=  CMem3[readMemAdd];

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

genvar i;
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

assign  HDMIdata = (REnslant[0] && Mem_cont[0]) ? RGB4Pix[23:0] :
                   (REnslant[1] && Mem_cont[1]) ? RGB4Pix[47:24] :
                   (REnslant[2] && Mem_cont[2]) ? RGB4Pix[71:48] :
                   (REnslant[3] && Mem_cont[3]) ? RGB4Pix[95:72] : 24'h000000;
    
endmodule
