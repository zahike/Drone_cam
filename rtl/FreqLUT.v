`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/10/2021 12:24:42 PM
// Design Name: 
// Module Name: FreqLUT
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


module FreqLUT(
input clk,
input rstn,

input  [4:0]  FreqNum,
output [31:0] FreqData
    );



   reg [31:0] RegData;

   always @(posedge clk)
      if (rstn)
         case (FreqNum)
            5'b00000: RegData <= 32'h0c000d3c;
            5'b00001: RegData <= 32'h0c300d3c;
            5'b00010: RegData <= 32'h0c600d3c;
            5'b00011: RegData <= 32'h0c900d3c;
            5'b00100: RegData <= 32'h0cC00d3c;
            5'b00101: RegData <= 32'h0cF00d3c;
            5'b00110: RegData <= 32'h0c200d3d;
            5'b00111: RegData <= 32'h0c500d3d;
            5'b01000: RegData <= 32'h0c800d3d;
            5'b01001: RegData <= 32'h0cB00d3d;
            5'b01010: RegData <= 32'h0cE00d3d;
            5'b01011: RegData <= 32'h0c100d3e;
            5'b01100: RegData <= 32'h0c400d3e;
            5'b01101: RegData <= 32'h0c700d3e;
            5'b01110: RegData <= 32'h0cA00d3e;
            5'b01111: RegData <= 32'h0cD00d3e;
            5'b10000: RegData <= 32'h0c000d3f;
            5'b10001: RegData <= 32'h0c300d3f;
            5'b10010: RegData <= 32'h0c600d3f;
            5'b10011: RegData <= 32'h0c900d3f;
            5'b10100: RegData <= 32'h0cC00d3f;
            5'b10101: RegData <= 32'h0cF00d3f;
            5'b10110: RegData <= 32'h0c200d40;
            5'b10111: RegData <= 32'h0c500d40;
            5'b11000: RegData <= 32'h0c800d40;
            5'b11001: RegData <= 32'h0cB00d40;
            5'b11010: RegData <= 32'h0cE00d40;
            5'b11011: RegData <= 32'h0c100d41;
            5'b11100: RegData <= 32'h0c400d41;
            5'b11101: RegData <= 32'h0c700d41;
            5'b11110: RegData <= 32'h0cA00d41;
            5'b11111: RegData <= 32'h0cD00d41;
            default:   RegData <= 32'h0c000d3c;
         endcase

assign FreqData =  RegData;   
endmodule
