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

input [7:0] Receive0Data,
input [7:0] Receive1Data,
input [7:0] Receive2Data,
input [7:0] Receive3Data
    );
    
wire Sync0 = (Receive0Data > 8'h7f) ? 1'b1 : 1'b0;
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
     else if (Receive0Data > 8'h7f) SetBitTime <= 1'b1;
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
wire FrameEven = (SyncShiftReg == 24'haab155) ? 1'b1 : 1'b0;         
wire FrameAdd  = (SyncShiftReg == 24'haa8d55) ? 1'b1 : 1'b0;         
wire HSync = (SyncShiftReg == 24'h00a355) ? 1'b1 : 1'b0;         

    
endmodule
