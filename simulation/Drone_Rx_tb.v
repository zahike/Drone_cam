`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.11.2021 14:01:03
// Design Name: 
// Module Name: Drone_Rx_tb
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


module Drone_Rx_tb();
reg sys_clk;
reg rstn;
initial begin 
sys_clk = 1'b0;
rstn    = 1'b0;
#100;
rstn    = 1'b1;
end 

always #4 sys_clk = ~sys_clk;

Drone_Rx_Top Drone_Rx_Top_inst(
.sys_clock(sys_clk)       
);

endmodule
