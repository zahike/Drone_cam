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
// Zync signals
inout [14:0] DDR_addr,
inout [2:0] DDR_ba,
inout  DDR_cas_n,
inout  DDR_ck_n,
inout  DDR_ck_p,
inout  DDR_cke,
inout  DDR_cs_n,
inout [3:0] DDR_dm,
inout [31:0] DDR_dq,
inout [3:0] DDR_dqs_n,
inout [3:0] DDR_dqs_p,
inout  DDR_odt,
inout  DDR_ras_n,
inout  DDR_reset_n,
inout  DDR_we_n,
inout  FIXED_IO_ddr_vrn,
inout  FIXED_IO_ddr_vrp,
inout [53:0] FIXED_IO_mio,
inout  FIXED_IO_ps_clk,
inout  FIXED_IO_ps_porb,
inout  FIXED_IO_ps_srstb,

// MIPI Signal 
input  dphy_clk_lp_n,
input  dphy_clk_lp_p,
input [1:0] dphy_data_hs_n,
input [1:0] dphy_data_hs_p,
input [1:0] dphy_data_lp_n,
input [1:0] dphy_data_lp_p,
input  dphy_hs_clock_clk_n,
input  dphy_hs_clock_clk_p,

inout [0:0] cam_gpio_tri_io,
inout cam_iic_scl_io,
inout cam_iic_sda_io,

  output      hdmi_tx_clk_n   ,
  output      hdmi_tx_clk_p   ,
  output [2:0]hdmi_tx_data_n  ,
  output [2:0]hdmi_tx_data_p  ,
  input       sys_clock       ,
  output [4:1] jb_p,
  output [4:1] jb_n
    );

/////////////////////////////////////////////////////////
/////////////////      Drone Cam BD       ///////////////
/////////////////////////////////////////////////////////
//Outputs
wire ILA_clk;
//wire RxByteClkHS;             // output RxByteClkHS;
wire [0:0] GPIO_0_0_tri_o;		//output [0:0] GPIO_0_0_tri_o;
wire [0:0] GPIO_0_0_tri_t;		//output [0:0] GPIO_0_0_tri_t;
wire IIC_0_0_scl_o;		//output  IIC_0_0_scl_o;
wire IIC_0_0_scl_t;		//output  IIC_0_0_scl_t;
wire IIC_0_0_sda_o;		//output  IIC_0_0_sda_o;
wire IIC_0_0_sda_t;		//output  IIC_0_0_sda_t;

//Inputs
wire [0:0] GPIO_0_0_tri_i;		//input [0:0] GPIO_0_0_tri_i;
wire IIC_0_0_scl_i       ;		//input  IIC_0_0_scl_i;
wire IIC_0_0_sda_i       ;		//input  IIC_0_0_sda_i;
    
Drone_Cam_BD Drone_Cam_BD_inst
(
.DDR_addr(DDR_addr),		//inout [14:0] DDR_addr
.DDR_ba(DDR_ba),        //inout [2:0] DDR_ba
.DDR_cas_n(DDR_cas_n),        //inout  DDR_cas_n
.DDR_ck_n(DDR_ck_n),        //inout  DDR_ck_n
.DDR_ck_p(DDR_ck_p),        //inout  DDR_ck_p
.DDR_cke(DDR_cke),        //inout  DDR_cke
.DDR_cs_n(DDR_cs_n),        //inout  DDR_cs_n
.DDR_dm(DDR_dm),        //inout [3:0] DDR_dm
.DDR_dq(DDR_dq),        //inout [31:0] DDR_dq
.DDR_dqs_n(DDR_dqs_n),        //inout [3:0] DDR_dqs_n
.DDR_dqs_p(DDR_dqs_p),        //inout [3:0] DDR_dqs_p
.DDR_odt(DDR_odt),        //inout  DDR_odt
.DDR_ras_n(DDR_ras_n),        //inout  DDR_ras_n
.DDR_reset_n(DDR_reset_n),        //inout  DDR_reset_n
.DDR_we_n(DDR_we_n),        //inout  DDR_we_n
.FIXED_IO_ddr_vrn(FIXED_IO_ddr_vrn),        //inout  FIXED_IO_ddr_vrn
.FIXED_IO_ddr_vrp(FIXED_IO_ddr_vrp),        //inout  FIXED_IO_ddr_vrp
.FIXED_IO_mio(FIXED_IO_mio),        //inout [53:0] FIXED_IO_mio
.FIXED_IO_ps_clk(FIXED_IO_ps_clk),        //inout  FIXED_IO_ps_clk
.FIXED_IO_ps_porb(FIXED_IO_ps_porb),        //inout  FIXED_IO_ps_porb
.FIXED_IO_ps_srstb(FIXED_IO_ps_srstb),        //inout  FIXED_IO_ps_srstb
.FCLK_CLK2_0(ILA_clk),
.GPIO_0_0_tri_i(GPIO_0_0_tri_i),        //input [0:0] GPIO_0_0_tri_i
.GPIO_0_0_tri_o(GPIO_0_0_tri_o),        //output [0:0] GPIO_0_0_tri_o
.GPIO_0_0_tri_t(GPIO_0_0_tri_t),        //output [0:0] GPIO_0_0_tri_t
.IIC_0_0_scl_i(IIC_0_0_scl_i),        //input  IIC_0_0_scl_i
.IIC_0_0_scl_o(IIC_0_0_scl_o),        //output  IIC_0_0_scl_o
.IIC_0_0_scl_t(IIC_0_0_scl_t),        //output  IIC_0_0_scl_t
.IIC_0_0_sda_i(IIC_0_0_sda_i),        //input  IIC_0_0_sda_i
.IIC_0_0_sda_o(IIC_0_0_sda_o),        //output  IIC_0_0_sda_o
.IIC_0_0_sda_t(IIC_0_0_sda_t),        //output  IIC_0_0_sda_t
.dphy_clk_lp_n(dphy_clk_lp_n),        //input  dphy_clk_lp_n
.dphy_clk_lp_p(dphy_clk_lp_p),        //input  dphy_clk_lp_p
.dphy_data_hs_n(dphy_data_hs_n),        //input [1:0] dphy_data_hs_n
.dphy_data_hs_p(dphy_data_hs_p),        //input [1:0] dphy_data_hs_p
.dphy_data_lp_n(dphy_data_lp_n),        //input [1:0] dphy_data_lp_n
.dphy_data_lp_p(dphy_data_lp_p),        //input [1:0] dphy_data_lp_p
.dphy_hs_clock_clk_n(dphy_hs_clock_clk_n),        //input  dphy_hs_clock_clk_n
.dphy_hs_clock_clk_p(dphy_hs_clock_clk_p),        //input  dphy_hs_clock_clk_p

 .TMDS_Clk_n_0 (hdmi_tx_clk_n ),
 .TMDS_Clk_p_0 (hdmi_tx_clk_p ),
 .TMDS_Data_n_0(hdmi_tx_data_n),
 .TMDS_Data_p_0(hdmi_tx_data_p),
// .sys_clock    (sys_clock),
 .Out_pHSync(jb_n[1]),
 .Out_pVDE  (jb_p[2]),  
 .Out_pVSync(jb_p[1]),
 .RxByteClkHS(jb_p[4]),
 .PixelClk  (jb_n[4])  
 );
 
   IOBUF GPIO_IOBUF_inst (
      .O(GPIO_0_0_tri_i),   // 1-bit output: Buffer output
      .I(GPIO_0_0_tri_o),   // 1-bit input: Buffer input
      .IO(cam_gpio_tri_io), // 1-bit inout: Buffer inout (connect directly to top-level port)
      .T(GPIO_0_0_tri_t)    // 1-bit input: 3-state enable input
   );

   IOBUF SCL_IOBUF_inst (
      .O(IIC_0_0_scl_i),   // 1-bit output: Buffer output
      .I(IIC_0_0_scl_o),   // 1-bit input: Buffer input
      .IO(cam_iic_scl_io), // 1-bit inout: Buffer inout (connect directly to top-level port)
      .T(IIC_0_0_scl_t)    // 1-bit input: 3-state enable input
   );

   IOBUF SDA_IOBUF_inst (
      .O(IIC_0_0_sda_i),   // 1-bit output: Buffer output
      .I(IIC_0_0_sda_o),   // 1-bit input: Buffer input
      .IO(cam_iic_sda_io), // 1-bit inout: Buffer inout (connect directly to top-level port)
      .T(IIC_0_0_sda_t)    // 1-bit input: 3-state enable input
   );

//----------- Begin Cut here for INSTANTIATION Template ---// INST_TAG
   ila_0 Slow_Sign_ila (
       .clk(ILA_clk), // input wire clk   
   
       .probe0(GPIO_0_0_tri_i), // input wire [0:0]  probe0  
       .probe1(GPIO_0_0_tri_o), // input wire [0:0]  probe1 
       .probe2(GPIO_0_0_tri_t), // input wire [0:0]  probe2 
       .probe3(IIC_0_0_scl_i ), // input wire [0:0]  probe3 
       .probe4(IIC_0_0_scl_o ), // input wire [0:0]  probe4 
       .probe5(IIC_0_0_scl_t ), // input wire [0:0]  probe5 
       .probe6(IIC_0_0_sda_i ), // input wire [0:0]  probe6 
       .probe7(IIC_0_0_sda_o ), // input wire [0:0]  probe7 
       .probe8(IIC_0_0_sda_t ) // input wire [0:0]  probe8
   );
    
endmodule
