`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.09.2021 20:05:47
// Design Name: 
// Module Name: Drone_Cam_Trans_tb
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


module Drone_Cam_Trans_tb();
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

//clkDiv clkDiv_inst(
//.clk125(clk ),
//.rstn  (rstn),
//.SerilsClk(SerilsClk),
//.PixelClk (PixelClk )
//    );


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

wire HVsync                     ;                        // input HVsync,                      
wire FraimSync;
wire HMemRead                   ;                      // input HMemRead,                    
wire  [23:0] HDMIdata_Slant     ;   // output [11:0] HDMIdata             
wire [23 : 0] Out_pData;
wire Out_pHSync;
wire pVDE;

wire  TransValid;
wire [7:0] Trans0Data;
wire [7:0] Trans1Data;
wire [7:0] Trans2Data;
wire [7:0] Trans3Data;
  
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
.PixelClk           (PixelClk           ),       // input Hclk,                        

.HVsync             (HVsync             ),       // input HVsync,                      
.HMemRead           (HMemRead           ),       // input HMemRead,         
.pVDE               (pVDE               ),       // output        Out_pVDE  ,
.HDMIdata           (HDMIdata_Slant     ),        // output [11:0] HDMIdata    

.TransValid(TransValid),
.Trans0Data(Trans0Data),//output [7:0] Trans0Data,
.Trans1Data(Trans1Data),//output [7:0] Trans1Data,
.Trans2Data(Trans2Data),//output [7:0] Trans2Data,
.Trans3Data(Trans3Data) //output [7:0] Trans3Data,         
    );
    
reg [3:0] Test;

initial begin
force  DDS_cont_inst.Send = 1'b1;
force  DDS_cont_inst.WR = 1'b0;
@(posedge rstn);
Test = 4'h0;
#100000;
Test = 4'h1;
#100000;
Test = 4'h4;
#100000;
Test = 4'h6;
#100000;
end
                                 
wire         S_APB_0_axiclk     ;
wire         S_APB_0_aresetn    ;
wire  [31:0] S_APB_0_paddr      ;
wire         S_APB_0_penable    ;
wire  [31:0] S_APB_0_prdata     ;
wire         S_APB_0_pready     ;
wire         S_APB_0_psel       ;
wire         S_APB_0_pslverr    ;
wire  [31:0] S_APB_0_pwdata     ;
wire         S_APB_0_pwrite     ;

                                 
wire DDS_PCLK                  ;
wire DDS_IOup                  ;
wire DDS_CSn                   ;
wire DDS_RWn                   ;
wire DDS_ReadEn                ;
wire [7:0] DDS_DataOut         ;
wire [7:0] DDS_DataIn          ;

DDS_cont DDS_cont_inst(
.clk (clk )                      ,
.rstn(rstn)                      ,
                          
.S_APB_0_axiclk (S_APB_0_axiclk )    ,
.S_APB_0_aresetn(S_APB_0_aresetn)    ,
.S_APB_0_paddr  (S_APB_0_paddr  )    ,
.S_APB_0_penable(S_APB_0_penable)    ,
.S_APB_0_prdata (S_APB_0_prdata )    ,
.S_APB_0_pready (S_APB_0_pready )    ,
.S_APB_0_psel   (S_APB_0_psel   )    ,
.S_APB_0_pslverr(S_APB_0_pslverr)    ,
.S_APB_0_pwdata (S_APB_0_pwdata )    ,
.S_APB_0_pwrite (S_APB_0_pwrite )    ,

.Test(Test),

.TransValid(TransValid)                ,
.Trans0Data(Trans0Data)           ,
.Trans1Data(Trans1Data)           ,
.Trans2Data(Trans2Data)           ,
.Trans3Data(Trans3Data)           ,
                           
.DDS_PCLK   (DDS_PCLK   ),
.DDS_IOup   (DDS_IOup   ),
.DDS_CSn    (DDS_CSn    ),
.DDS_RWn    (DDS_RWn    ),
.DDS_ReadEn (DDS_ReadEn ),
.DDS_DataOut(DDS_DataOut),
.DDS_DataIn (DDS_DataIn )
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

SlantReceiver SlantReceiver_inst(
.clk (clk ),
.rstn(rstn),

.Receive0Data(Trans0Data),
.Receive1Data(Trans1Data),
.Receive2Data(Trans2Data),
.Receive3Data(Trans3Data)
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
