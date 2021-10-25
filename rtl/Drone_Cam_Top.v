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

//inout [0:0] cam_gpio_tri_io,
output [0:0] cam_gpio_tri_io,
inout cam_iic_scl_io,
inout cam_iic_sda_io,

  output      hdmi_tx_clk_n   ,
  output      hdmi_tx_clk_p   ,
  output [2:0]hdmi_tx_data_n  ,
  output [2:0]hdmi_tx_data_p  ,
  input       sys_clock       ,
  input  [3:0] sw,
  input  [3:0] btn,
  output [3:0] ja_p,
  output [3:0] ja_n,
  output [4:1] jb_p,
  output [4:1] jb_n,
  output [4:1] jc_p,
  output [4:1] jc_n,
  inout [4:1] jd_n,
  inout [4:1] jd_p,
  output [8:1] je
    );


/////////////////////////////////////////////////////////
/////////////////      Drone Cam BD       ///////////////
/////////////////////////////////////////////////////////
//Outputs
wire ILA_clk;
wire rstn;               // output [0:0]rstn;
//wire RxByteClkHS;             // output RxByteClkHS;
wire [0:0] GPIO_0_0_tri_o;		//output [0:0] GPIO_0_0_tri_o;
wire [0:0] GPIO_0_0_tri_t;		//output [0:0] GPIO_0_0_tri_t;
wire IIC_0_0_scl_o;		//output  IIC_0_0_scl_o;
wire IIC_0_0_scl_t;		//output  IIC_0_0_scl_t;
wire IIC_0_0_sda_o;		//output  IIC_0_0_sda_o;
wire IIC_0_0_sda_t;		//output  IIC_0_0_sda_t;

wire GPIO_0;          //  output GPIO_0;
wire sccb_clk_0;      //  output sccb_clk_0;
wire sccb_clk_en_0;   //  output sccb_clk_en_0;
wire sccb_data_en_0;  //  output sccb_data_en_0;
wire sccb_data_out_0; //  output sccb_data_out_0;

//Inputs
wire [0:0] GPIO_0_0_tri_i;		//input [0:0] GPIO_0_0_tri_i;
wire IIC_0_0_scl_i       ;		//input  IIC_0_0_scl_i;
wire IIC_0_0_sda_i       ;		//input  IIC_0_0_sda_i;
wire sccb_data_in_0      ;           //  input sccb_data_in_0;

wire DDS_CSn_0;          //   output DDS_CSn_0;
wire [7:0]DDS_DataIn_0;   //   input [7:0]DDS_DataIn_0;
wire [7:0]DDS_DataOut_0; //   output [7:0]DDS_DataOut_0;
wire DDS_IOup_0;         //   output DDS_IOup_0;
wire DDS_PCLK_0;         //   output DDS_PCLK_0;
wire DDS_RWn_0;          //   output DDS_RWn_0;
wire DDS_ReadEn_0;       //   output DDS_ReadEn_0;
wire DDS_Ref;            //   output DDS_Ref;
    
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

.DDS_CSn_0     (DDS_CSn_0    ),      //   output DDS_CSn_0;
.DDS_DataIn_0  (DDS_DataIn_0 ),  //   input [7:0]DDS_DataIn_0;
.DDS_DataOut_0 (DDS_DataOut_0), //   output [7:0]DDS_DataOut_0;
.DDS_IOup_0    (DDS_IOup_0   ),      //   output DDS_IOup_0;
.DDS_PCLK_0    (DDS_PCLK_0   ),      //   output DDS_PCLK_0;
.DDS_RWn_0     (DDS_RWn_0    ),      //   output DDS_RWn_0;
.DDS_ReadEn_0  (DDS_ReadEn_0 ),      //   output DDS_ReadEn_0;
.DDS_Ref       (DDS_Ref      ),      //   output DDS_Ref;

.FIXED_IO_ddr_vrn(FIXED_IO_ddr_vrn),        //inout  FIXED_IO_ddr_vrn
.FIXED_IO_ddr_vrp(FIXED_IO_ddr_vrp),        //inout  FIXED_IO_ddr_vrp
.FIXED_IO_mio(FIXED_IO_mio),        //inout [53:0] FIXED_IO_mio
.FIXED_IO_ps_clk(FIXED_IO_ps_clk),        //inout  FIXED_IO_ps_clk
.FIXED_IO_ps_porb(FIXED_IO_ps_porb),        //inout  FIXED_IO_ps_porb
.FIXED_IO_ps_srstb(FIXED_IO_ps_srstb),        //inout  FIXED_IO_ps_srstb
.FCLK_CLK2_0(ILA_clk),
.rstn(rstn),                            //output [0:0]rstn;
.dphy_clk_lp_n(dphy_clk_lp_n),        //input  dphy_clk_lp_n
.dphy_clk_lp_p(dphy_clk_lp_p),        //input  dphy_clk_lp_p
.dphy_data_hs_n(dphy_data_hs_n),        //input [1:0] dphy_data_hs_n
.dphy_data_hs_p(dphy_data_hs_p),        //input [1:0] dphy_data_hs_p
.dphy_data_lp_n(dphy_data_lp_n),        //input [1:0] dphy_data_lp_n
.dphy_data_lp_p(dphy_data_lp_p),        //input [1:0] dphy_data_lp_p
.dphy_hs_clock_clk_n(dphy_hs_clock_clk_n),        //input  dphy_hs_clock_clk_n
.dphy_hs_clock_clk_p(dphy_hs_clock_clk_p),        //input  dphy_hs_clock_clk_p

.GPIO_0         (GPIO_0         ),    //  output GPIO_0;
.Mem_cont       (sw             ),    // input [3:0]Mem_cont;
.sccb_clk_0     (sccb_clk_0     ),    //  output sccb_clk_0;
.sccb_clk_en_0  (sccb_clk_en_0  ),    //  output sccb_clk_en_0;
.sccb_data_en_0 (sccb_data_en_0 ),    //  output sccb_data_en_0;
.sccb_data_in_0 (sccb_data_in_0 ),    //  input sccb_data_in_0;
.sccb_data_out_0(sccb_data_out_0),    //  output sccb_data_out_0;

 .TMDS_Clk_n_0 (hdmi_tx_clk_n ),
 .TMDS_Clk_p_0 (hdmi_tx_clk_p ),
 .TMDS_Data_n_0(hdmi_tx_data_n),
 .TMDS_Data_p_0(hdmi_tx_data_p),
 .sys_clock    (sys_clock),
.tlast(jb_p[3]),  //output tlast;
.tuser(jb_n[3]),  //output tuser;
 .Out_pHSync(jb_n[1]),
 .Out_pVDE  (jb_p[2]),  
 .Out_pVSync(jb_p[1]),
 .RxByteClkHS(jb_p[4]),
 .PixelClk  (jb_n[4])  
 );

//  output [3:0] ja_p,
//  output [3:0] ja_n,
//  output [4:1] jb_p,
//  output [4:1] jb_n,
//  output [4:1] jc_p,
//  output [4:1] jc_n,
//  inout [4:1] jd_n,
//  inout [4:1] jd_p

//assign ja_n[3] = DDS_Ref;
assign je[8] = DDS_Ref;
// assign JA[5] = ~rstn; // reset
// assign JA[2] = 1'b0;  // PowerDown
// assign JA[6] = RegIOup;  // IO_update
// assign JA[3] = RegCS;  // CSB
// assign JA[7] = RegRWn;  // RWn
// assign JA[4] = RegPclk;  // PCLK
// assign JA[8] = 1'b1;  // PAR
// assign JB[1] = (!ReadData) ? RegData[7] : 1'bz;   
// assign JB[5] = (!ReadData) ? RegData[6] : 1'bz;   
// assign JB[2] = (!ReadData) ? RegData[5] : 1'bz;   
// assign JB[6] = (!ReadData) ? RegData[4] : 1'bz;   
// assign JB[3] = (!ReadData) ? RegData[3] : 1'bz;   
// assign JB[7] = (!ReadData) ? RegData[2] : 1'bz;   
// assign JB[4] = (!ReadData) ? RegData[1] : 1'bz;   
// assign JB[8] = (!ReadData) ? RegData[0] : 1'bz;   

//wire DDS_CSn_0;          //   output DDS_CSn_0;
//wire [7:0]DDS_DataIn_0;   //   input [7:0]DDS_DataIn_0;
//wire [7:0]DDS_DataOut_0; //   output [7:0]DDS_DataOut_0;
//wire DDS_IOup_0;         //   output DDS_IOup_0;
//wire DDS_PCLK_0;         //   output DDS_PCLK_0;
//wire DDS_RWn_0;          //   output DDS_RWn_0;
//wire DDS_ReadEn_0;       //   output DDS_ReadEn_0;
//wire DDS_Ref;            //   output DDS_Ref;

 assign jc_p[3] = (btn[0]) ? 1'b1 : ~rstn; // reset
 assign jc_n[1] = 1'b0;  // PowerDown
 assign jc_n[3] = DDS_IOup_0;  // IO_update
 assign jc_p[2] = DDS_CSn_0;  // CSB
 assign jc_p[4] = DDS_RWn_0;  // RWn
 assign jc_n[2] = DDS_PCLK_0;  // PCLK
 assign jc_n[4] = 1'b1;  // PAR
 assign jd_p[1] = (!DDS_ReadEn_0) ? DDS_DataOut_0[7] : 1'bz;   
 assign jd_p[3] = (!DDS_ReadEn_0) ? DDS_DataOut_0[6] : 1'bz;   
 assign jd_n[1] = (!DDS_ReadEn_0) ? DDS_DataOut_0[5] : 1'bz;   
 assign jd_n[3] = (!DDS_ReadEn_0) ? DDS_DataOut_0[4] : 1'bz;   
 assign jd_p[2] = (!DDS_ReadEn_0) ? DDS_DataOut_0[3] : 1'bz;   
 assign jd_p[4] = (!DDS_ReadEn_0) ? DDS_DataOut_0[2] : 1'bz;   
 assign jd_n[2] = (!DDS_ReadEn_0) ? DDS_DataOut_0[1] : 1'bz;   
 assign jd_n[4] = (!DDS_ReadEn_0) ? DDS_DataOut_0[0] : 1'bz;   

assign DDS_DataIn_0[7] = jd_p[1];
assign DDS_DataIn_0[6] = jd_p[3];
assign DDS_DataIn_0[5] = jd_n[1];
assign DDS_DataIn_0[4] = jd_n[3];
assign DDS_DataIn_0[3] = jd_p[2];
assign DDS_DataIn_0[2] = jd_p[4];
assign DDS_DataIn_0[1] = jd_n[2];
assign DDS_DataIn_0[0] = jd_n[4];
 
assign ja_n[0]         = GPIO_0; 
assign cam_gpio_tri_io = GPIO_0; 

assign cam_iic_scl_io  = (sccb_clk_en_0) ? sccb_clk_0 : 1'b1;
assign cam_iic_sda_io = (~sccb_data_en_0) ? sccb_data_out_0 : 1'bz;
assign sccb_data_in_0 = cam_iic_sda_io;

assign ja_p[0] = cam_iic_scl_io; 
assign ja_p[1] = cam_iic_sda_io;

reg [1:0] DevIIC;
always @(posedge ILA_clk or negedge rstn)
    if (!rstn) DevIIC <= 2'b00;
     else DevIIC <= {DevIIC[0],cam_iic_scl_io};
reg [31:0] IICshift;
always @(posedge ILA_clk or negedge rstn)
    if (!rstn) IICshift <= 32'h00000000;
     else if (DevIIC == 2'b01) IICshift <= {IICshift[30:0],sccb_data_in_0};

endmodule
