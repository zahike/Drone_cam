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
#2500000;
#300;
HDMIrstn = 1'b1;
end
always #4 clk = ~clk;

wire        m_axis_video_tready;   // output        s_axis_video_tready, 
wire [31:0] m_axis_video_tdata ;   // input  [23:0] s_axis_video_tdata , 
reg         m_axis_video_tvalid;   // input         s_axis_video_tvalid, 
reg         m_axis_video_tuser ;   // input         s_axis_video_tuser , 
reg         m_axis_video_tlast ;   // input         s_axis_video_tlast , 

reg [5:0] Gdata;
always @(posedge clk or negedge rstn)
    if (!rstn) Gdata <= 6'h00;
     else if (m_axis_video_tuser) Gdata <= 6'h00;
     else if (m_axis_video_tvalid) Gdata <= Gdata + 1;
wire [5:0] Bdata;     
wire [5:0] Rdata;     
//assign m_axis_video_tdata = {2'b00,Rdata,5'h00,Bdata,5'h00,Gdata,5'h00};      
//assign m_axis_video_tdata = data;     


SyntPic SyntPic_inst(
.clk (clk ),
.rstn(rstn),

.SelStat(1'b1),

.s_axis_video_tdata  (32'h00000000)       ,
.s_axis_video_tready (m_axis_video_tready),
.s_axis_video_tvalid (m_axis_video_tvalid),
.s_axis_video_tlast  (m_axis_video_tlast) ,
.s_axis_video_tuser  (m_axis_video_tuser) ,
.m_axis_video_tdata  (m_axis_video_tdata) ,
.m_axis_video_tvalid ()                   ,
.m_axis_video_tready (1'b1)               ,
.m_axis_video_tlast  ()                   ,
.m_axis_video_tuser  ()     
    );
 
initial begin 
m_axis_video_tvalid = 0;   // input         s_axis_video_tvalid, 
m_axis_video_tuser  = 0;   // input         s_axis_video_tuser , 
m_axis_video_tlast  = 0;   // input         s_axis_video_tlast , 
@(posedge rstn);
#100;
repeat (3)begin 
        wrLine(1);
        repeat (479) wrLine(0);
//        repeat (1000000) @(posedge clk);
        #4620608;
        @(posedge clk);
    end
#10000000;    
$finish;    
end



wire SerilsClk;
wire TxPixelClk ;
wire RxPixelClk ;

 wire [31 : 0] Ms_axis_video_tdata  = m_axis_video_tdata ; //input  wire [23 : 0] s_axis_video_tdata    , 
 wire          Ms_axis_video_tready    ; //output wire s_axis_video_tready            , 
 wire          Ms_axis_video_tvalid = m_axis_video_tvalid ; //input  wire s_axis_video_tvalid            , 
 wire          Ms_axis_video_tlast  = m_axis_video_tlast ; //input  wire s_axis_video_tlast             , 
 wire          Ms_axis_video_tuser  = m_axis_video_tuser ; //input  wire s_axis_video_tuser         ,     
 wire [23 : 0] Mm_axis_video_tdata    ; //output wire [23 : 0] m_axis_video_tdata    , 
 wire          Mm_axis_video_tvalid   ; //output wire m_axis_video_tvalid            , 
 wire          Mm_axis_video_tready   ;// = 1'b1; //input  wire m_axis_video_tready            , 
 wire          Mm_axis_video_tlast    ; //output wire m_axis_video_tlast             , 
 wire          Mm_axis_video_tuser    ; //output wire m_axis_video_tuser               
  
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
wire TxFraimSync;
wire RxFraimSync;
wire HMemRead                   ;                      // input HMemRead,                    
wire  [23:0] TxHDMIdata_Slant     ;   // output [11:0] HDMIdata             
wire  [23:0] RxHDMIdata_Slant     ;   // output [11:0] HDMIdata             
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

.FraimSync          (TxFraimSync          ),
.PixelClk           (TxPixelClk           ),       // input Hclk,                        

.HVsync             (HVsync             ),       // input HVsync,                      
.HMemRead           (HMemRead           ),       // input HMemRead,         
.pVDE               (pVDE               ),       // output        Out_pVDE  ,
.HDMIdata           (TxHDMIdata_Slant     ),        // output [11:0] HDMIdata    

.TransValid(TransValid),
.Trans0Data(Trans0Data),//output [7:0] Trans0Data,
.Trans1Data(Trans1Data),//output [7:0] Trans1Data,
.Trans2Data(Trans2Data),//output [7:0] Trans2Data,
.Trans3Data(Trans3Data) //output [7:0] Trans3Data,         
    );
/*    
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
*/
reg SelHDMI;
initial SelHDMI = 1'b1;
always @(TxFraimSync) SelHDMI = ~SelHDMI;
  HDMIdebug HDMIdebug_inst (
    .Txclk(TxPixelClk),
    .Rxclk(RxPixelClk),
    .rstn(HDMIrstn),
    .SelHDMI(SelHDMI),
    .Out_pData(Out_pData),
    .Out_pVSync(HVsync),
    .Out_pHSync(Out_pHSync),
    .Out_pVDE(pVDE),
    .TxFraimSync(TxFraimSync),
    .RxFraimSync(RxFraimSync),
    .Mem_Read(HMemRead),
    .TxMem_Data(TxHDMIdata_Slant),
    .RxMem_Data(RxHDMIdata_Slant)
  );

SlantReceiver SlantReceiver_inst(
.clk (clk ),
.rstn(rstn),

.Receive0Data(Trans0Data),
.Receive1Data(Trans1Data),
.Receive2Data(Trans2Data),
.Receive3Data(Trans3Data),

.FraimSync(RxFraimSync),
.FraimSel(2'b00),

.PixelClk(RxPixelClk),

.HVsync             (HVsync             ),       // input HVsync,                      
.HMemRead           (HMemRead           ),       // input HMemRead,         
.pVDE               (pVDE               ),       // output        Out_pVDE  ,
.HDMIdata           (RxHDMIdata_Slant)        // output [11:0] HDMIdata    

    );
////////////////////////////// mem test //////////////////////////////
reg [4:0] Txmem[0:38399];
reg [3:0] TxWEnslant;
reg       TxDel_Valid;
reg       TxValid_odd;
reg [4:0] TXDelYData;
//(WEnslant[0] && Del_Valid && Valid_odd)

reg [4:0]  Rxmem[0:38399];
reg        RxFrame0_received;
reg [7:0]  RxBitTime0Counter;
reg [17:0] RXadd0;
reg [5:0]  RxReceive0Data;
//if (Frame0_received && (BitTime0Counter == 8'h14) && !RXadd0[0]) YMem0[RXadd0[17:1]] <= Receive0Data;

////////////////////////////// End Of mem test //////////////////////////////
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
