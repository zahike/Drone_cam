`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.09.2021 20:05:47
// Design Name: 
// Module Name: Drone_Cam_tb
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


module Drone_Cam_tb();
reg clk;
reg rstn;
reg HDMIrstn;
initial begin 
clk = 1'b0;
rstn = 1'b0;
HDMIrstn = 1'b0;
#100;
rstn = 1'b1;
//#1000000;
#300;
HDMIrstn = 1'b1;
end
always #4 clk = ~clk;

wire       m_axis_video_tready;   // output        s_axis_video_tready, 
wire [23:0] m_axis_video_tdata ;   // input  [23:0] s_axis_video_tdata , 
reg        m_axis_video_tvalid;   // input         s_axis_video_tvalid, 
reg        m_axis_video_tuser ;   // input         s_axis_video_tuser , 
reg        m_axis_video_tlast ;   // input         s_axis_video_tlast , 

reg [17:0] data;
always @(posedge clk or negedge rstn)
    if (!rstn) data <= 18'h00000;
     else if (m_axis_video_tvalid) data <= data + 1;
assign m_axis_video_tdata = {data[17:12],2'b00,data[11:6],2'b00,data[5:0],2'b00};      
//assign m_axis_video_tdata = data;      
initial begin 
m_axis_video_tvalid = 0;   // input         s_axis_video_tvalid, 
m_axis_video_tuser  = 0;   // input         s_axis_video_tuser , 
m_axis_video_tlast  = 0;   // input         s_axis_video_tlast , 
@(posedge rstn);
#100;
repeat (3)begin 
        wrLine(1);
        repeat (479) wrLine(0);
        repeat (500000) @(posedge clk);
    end
#10000000;    
$finish;    
end



wire SerilsClk;
wire PixelClk ;

clkDiv clkDiv_inst(
.clk125(clk ),
.rstn  (rstn),
.SerilsClk(SerilsClk),
.PixelClk (PixelClk )
    );

/*
wire tuser;
wire tlast;
wire Orjtuser;
wire Orjtlast;
wire Orjtvalid;
wire [23 : 0] tuser_count;
wire [15 : 0] tlast_count;
wire [15 : 0] Num_valid;
wire [15 : 0] Line;
*/

 wire [23 : 0] Ms_axis_video_tdata  = m_axis_video_tdata ; //input  wire [23 : 0] s_axis_video_tdata    , 
 wire          Ms_axis_video_tready    ; //output wire s_axis_video_tready            , 
 wire          Ms_axis_video_tvalid = m_axis_video_tvalid ; //input  wire s_axis_video_tvalid            , 
 wire          Ms_axis_video_tlast  = m_axis_video_tlast ; //input  wire s_axis_video_tlast             , 
 wire          Ms_axis_video_tuser  = m_axis_video_tuser ; //input  wire s_axis_video_tuser         ,     
 wire [23 : 0] Mm_axis_video_tdata    ; //output wire [23 : 0] m_axis_video_tdata    , 
 wire          Mm_axis_video_tvalid   ; //output wire m_axis_video_tvalid            , 
 wire          Mm_axis_video_tready   ;// = 1'b1; //input  wire m_axis_video_tready            , 
 wire          Mm_axis_video_tlast    ; //output wire m_axis_video_tlast             , 
 wire          Mm_axis_video_tuser    ; //output wire m_axis_video_tuser               
 
// wire [23 : 0] BRm_axis_video_tdata    ; //output wire [23 : 0] m_axis_video_tdata    , 
// wire          BRm_axis_video_tvalid   ; //output wire m_axis_video_tvalid            , 
// wire          BRm_axis_video_tready = 1'b1; //input  wire m_axis_video_tready            , 
// wire          BRm_axis_video_tlast    ; //output wire m_axis_video_tlast             , 
// wire          BRm_axis_video_tuser    ; //output wire m_axis_video_tuser               
 
// MyYCbCr
 MyYCbCr MyYCbCr_inst(
 .clk (clk )                          ,
 .rstn(rstn)        ,
 .Sel(1'b0)                  ,
 .s_axis_video_tdata   (Ms_axis_video_tdata )   ,
 .s_axis_video_tready  (Ms_axis_video_tready)   ,
 .s_axis_video_tvalid  (Ms_axis_video_tvalid)   ,
 .s_axis_video_tlast   (Ms_axis_video_tlast )   ,
 .s_axis_video_tuser   (Ms_axis_video_tuser )   ,
 .m_axis_video_tdata   (Mm_axis_video_tdata )   ,
 .m_axis_video_tvalid  (Mm_axis_video_tvalid)   ,
 .m_axis_video_tready  (Mm_axis_video_tready)   ,
 .m_axis_video_tlast   (Mm_axis_video_tlast )   ,
 .m_axis_video_tuser   (Mm_axis_video_tuser ) 
     );
/*
MyRGB MyRGB_inst(
.clk (clk )                          ,
.rstn(rstn)                          ,
.s_axis_video_tdata   (Mm_axis_video_tdata )   ,
.s_axis_video_tready  (Mm_axis_video_tready)   ,
.s_axis_video_tvalid  (Mm_axis_video_tvalid)   ,
.s_axis_video_tlast   (Mm_axis_video_tlast )   ,
.s_axis_video_tuser   (Mm_axis_video_tuser )   ,
.m_axis_video_tdata   (BRm_axis_video_tdata )   ,
.m_axis_video_tvalid  (BRm_axis_video_tvalid)   ,
.m_axis_video_tready  (BRm_axis_video_tready)   ,
.m_axis_video_tlast   (BRm_axis_video_tlast )   ,
.m_axis_video_tuser   (BRm_axis_video_tuser )   
    );
 */ 

wire HVsync                     ;                        // input HVsync,                      
wire FraimSync;
wire HMemRead                   ;                      // input HMemRead,                    
wire  [23:0] HDMIdata_Slant     ;   // output [11:0] HDMIdata             
wire [23 : 0] Out_pData;
wire Out_pHSync;
wire pVDE;
  
SlantMem SlantMem_inst(
.Cclk               (clk),                       // input Cclk,                        
.rstn               (rstn),                      // input rstn,                        

.Mem_cont           (4'hf),
.s_axis_video_tready(Mm_axis_video_tready),       // output        s_axis_video_tready, 
.s_axis_video_tdata (Mm_axis_video_tdata ),       // input  [23:0] s_axis_video_tdata , 
.s_axis_video_tvalid(Mm_axis_video_tvalid),       // input         s_axis_video_tvalid, 
.s_axis_video_tuser (Mm_axis_video_tuser ),       // input         s_axis_video_tuser , 
.s_axis_video_tlast (Mm_axis_video_tlast ),       // input         s_axis_video_tlast , 

.FraimSync          (FraimSync          ),
.Hclk               (PixelClk           ),       // input Hclk,                        

.HVsync             (HVsync             ),       // input HVsync,                      
.HMemRead           (HMemRead           ),       // input HMemRead,         
.pVDE               (pVDE               ),       // output        Out_pVDE  ,
.HDMIdata           (HDMIdata_Slant     )        // output [11:0] HDMIdata             
    );

wire [31 : 0] Deb_Vsync_counter;
wire [15 : 0] Deb_Hsync_counter;
wire [15 : 0] Deb_Line_counter;
    

  HDMIdebug HDMIdebug_inst (
    .clk(PixelClk),
    .rstn(HDMIrstn),
    .Out_pData(Out_pData),
    .Out_pVSync(HVsync),
    .Out_pHSync(Out_pHSync),
    .Out_pVDE(pVDE),
    .FraimSync(FraimSync),
    .Mem_Read(HMemRead),
    .Mem_Data(HDMIdata_Slant),
    .Deb_Vsync_counter(Deb_Vsync_counter),
    .Deb_Hsync_counter(Deb_Hsync_counter),
    .Deb_Line_counter(Deb_Line_counter)
  );

task wr4fix;
begin 
m_axis_video_tvalid = 1'b1;   
repeat (4) @(posedge clk);
#1;
m_axis_video_tvalid = 1'b0;   
repeat (3) @(posedge clk);
#1;
end 
endtask

task wr4fix_frame;
input frame;
begin 
m_axis_video_tvalid = 1'b1;   
m_axis_video_tuser  = 1'b0;
m_axis_video_tlast  = 1'b0;
repeat (2) @(posedge clk);
#1;
 m_axis_video_tlast  = 1'b1;
@(posedge clk);#1;
m_axis_video_tlast  = 1'b0;
if (frame)m_axis_video_tuser  = 1'b1;
@(posedge clk);#1;
m_axis_video_tvalid = 1'b0;   
repeat (3) @(posedge clk);
#1;
m_axis_video_tuser  = 1'b0;
repeat (3) wr4fix;
end 
endtask

task wr16pix;
begin 
repeat (7) @(posedge clk);
#1;
repeat (4) wr4fix;
end 
endtask

task wrLine;
input frame;
begin 
wr4fix_frame(frame);
repeat (39) wr16pix;
repeat (1750) @(posedge clk);
#1;
end
endtask

endmodule
