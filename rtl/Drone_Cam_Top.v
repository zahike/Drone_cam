`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.08.2021 20:09:36
// Design Name: 
// Module Name: Drone_Cam_Top
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

module Drone_Cam_Top(
  output      hdmi_tx_clk_n   ,
  output      hdmi_tx_clk_p   ,
  output [2:0]hdmi_tx_data_n  ,
  output [2:0]hdmi_tx_data_p  ,
  input       sys_clock       ,
  output [4:1] jb_p,
  output [4:1] jb_n
    );
    
Drone_Cam_BD Drone_Cam_BD_inst
(
 .TMDS_Clk_n_0 (hdmi_tx_clk_n ),
 .TMDS_Clk_p_0 (hdmi_tx_clk_p ),
 .TMDS_Data_n_0(hdmi_tx_data_n),
 .TMDS_Data_p_0(hdmi_tx_data_p),
 .sys_clock    (sys_clock),
 .Out_pHSync(jb_n[1]),
 .Out_pVDE  (jb_p[2]),  
 .Out_pVSync(jb_p[1]),
 .PixelClk  (jb_n[4])  
 );
    
    
endmodule
