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
initial begin 
clk = 1'b0;
rstn = 1'b0;
#100;
rstn = 1'b1;
end
always #4 clk = ~clk;

wire       m_axis_video_tready;   // output        s_axis_video_tready, 
reg [31:0] m_axis_video_tdata ;   // input  [23:0] s_axis_video_tdata , 
reg        m_axis_video_tvalid;   // input         s_axis_video_tvalid, 
reg        m_axis_video_tuser ;   // input         s_axis_video_tuser , 
reg        m_axis_video_tlast ;   // input         s_axis_video_tlast , 


initial begin 
m_axis_video_tdata  = 0;   // input  [23:0] s_axis_video_tdata , 
m_axis_video_tvalid = 0;   // input         s_axis_video_tvalid, 
m_axis_video_tuser  = 0;   // input         s_axis_video_tuser , 
m_axis_video_tlast  = 0;   // input         s_axis_video_tlast , 
@(posedge rstn);
#100;
@(posedge clk);
m_axis_video_tuser  = 1'b1;   
m_axis_video_tvalid = 1'b1;   
@(posedge clk);
m_axis_video_tuser  = 1'b1;   
m_axis_video_tvalid = 1'b0; 
repeat (3) @(posedge clk);  
m_axis_video_tuser  = 1'b0;   
repeat (3) wr4fix;
repeat (39) wr16pix;
end

task wr4fix;
begin 
m_axis_video_tvalid = 1'b1;   
repeat (4) @(posedge clk);
m_axis_video_tvalid = 1'b0;   
repeat (3) @(posedge clk);
end 
endtask

task wr16pix;
begin 
repeat (7) @(posedge clk);
repeat (4) wr4fix;
end 
endtask




wire SerilsClk;
wire PixelClk ;

clkDiv clkDiv_inst(
.clk125(clk ),
.rstn  (rstn),
.SerilsClk(SerilsClk),
.PixelClk (PixelClk )
    );

wire        mg_axis_video_tready; 
wire [23:0] mg_axis_video_tdata ; 
wire        mg_axis_video_tvalid; 
wire        mg_axis_video_tuser ; 
wire        mg_axis_video_tlast ; 

wire tuser;
wire tlast;
wire Orjtuser;
wire Orjtlast;
wire Orjtvalid;
wire [23 : 0] tuser_count;
wire [15 : 0] tlast_count;
wire [15 : 0] Num_valid;
wire [15 : 0] Line;



wire HVsync                     ;                        // input HVsync,                      
wire HMemRead                   ;                      // input HMemRead,                    
wire  [11:0] HDMIdata           ;   // output [11:0] HDMIdata             

  GammDebug inst (
    .clk(clk),
    .rstn(rstn),
    .s_axis_video_tready(m_axis_video_tready),
    .s_axis_video_tdata (m_axis_video_tdata),
    .s_axis_video_tvalid(m_axis_video_tvalid),
    .s_axis_video_tuser (m_axis_video_tuser),
    .s_axis_video_tlast (m_axis_video_tlast),
    .m_axis_video_tready(mg_axis_video_tready),
    .m_axis_video_tdata (mg_axis_video_tdata),
    .m_axis_video_tvalid(mg_axis_video_tvalid),
    .m_axis_video_tuser (mg_axis_video_tuser),
    .m_axis_video_tlast (mg_axis_video_tlast),
    .tuser(tuser),
    .tlast(tlast),
    .Orjtuser(Orjtuser),
    .Orjtlast(Orjtlast),
    .Orjtvalid(Orjtvalid),
    .tuser_count(tuser_count),
    .tlast_count(tlast_count),
    .Num_valid(Num_valid),
    .Line(Line)
  );


MemBlock MemBlock_inst(
.Cclk               (clk),                       // input Cclk,                        
.rstn               (rstn),                      // input rstn,                        

.s_axis_video_tready(mg_axis_video_tready),       // output        s_axis_video_tready, 
.s_axis_video_tdata (mg_axis_video_tdata ),       // input  [23:0] s_axis_video_tdata , 
.s_axis_video_tvalid(mg_axis_video_tvalid),       // input         s_axis_video_tvalid, 
.s_axis_video_tuser (mg_axis_video_tuser ),       // input         s_axis_video_tuser , 
.s_axis_video_tlast (mg_axis_video_tlast ),       // input         s_axis_video_tlast , 

.Hclk               (PixelClk           ),       // input Hclk,                        

.HVsync             (HVsync             ),       // input HVsync,                      
.HMemRead           (HMemRead           ),       // input HMemRead,                    
.HDMIdata           (HDMIdata           )        // output [11:0] HDMIdata             

    );

endmodule
