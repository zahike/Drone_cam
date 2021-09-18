`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.09.2021 11:03:52
// Design Name: 
// Module Name: YCbCr_tb
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


module YCbCr_tb();
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
wire [23:0] m_axis_video_tdata ;   // input  [23:0] s_axis_video_tdata , 
reg        m_axis_video_tvalid;   // input         s_axis_video_tvalid, 
reg        m_axis_video_tuser ;   // input         s_axis_video_tuser , 
reg        m_axis_video_tlast ;   // input         s_axis_video_tlast , 

reg Reg_on;
always @(posedge clk or negedge rstn) 
    if (!rstn) Reg_on <= 1'b0;
     else if (m_axis_video_tvalid && m_axis_video_tuser) Reg_on <= 1'b1;
wire On =  m_axis_video_tuser || Reg_on;  
reg [17:0] data;
always @(posedge clk or negedge rstn)
    if (!rstn) data <= 18'h00000;
     else if (On && m_axis_video_tvalid) data <= data + 1;
//assign m_axis_video_tdata = {2'b00,data,4'h0,2'b00,data,4'h0,2'b00,data,4'h0,2'b00};      
//assign m_axis_video_tdata = {2'b00,data[11:8],4'h0,2'b00,data[7:4],4'h0,2'b00,data[3:0],4'h0,2'b00};      
assign m_axis_video_tdata = {data[17:12],2'b00,data[11:6],2'b00,data[5:0],2'b00};      
//assign m_axis_video_tdata = data;      
initial begin 
m_axis_video_tvalid = 0;   // input         s_axis_video_tvalid, 
m_axis_video_tuser  = 0;   // input         s_axis_video_tuser , 
m_axis_video_tlast  = 0;   // input         s_axis_video_tlast , 
@(posedge rstn);
#100;
repeat (1)begin 
        wrLine(1);
        repeat (479) wrLine(0);
        repeat (500000) @(posedge clk);
    end
//$finish;    
end

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

wire [23 : 0] BRm_axis_video_tdata    ; //output wire [23 : 0] m_axis_video_tdata    , 
wire          BRm_axis_video_tvalid   ; //output wire m_axis_video_tvalid            , 
wire          BRm_axis_video_tready = 1'b1; //input  wire m_axis_video_tready            , 
wire          BRm_axis_video_tlast    ; //output wire m_axis_video_tlast             , 
wire          BRm_axis_video_tuser    ; //output wire m_axis_video_tuser               

// MyYCbCr
MyYCbCr MyYCbCr_inst(
.clk (clk )                          ,
.rstn(rstn)                          ,
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
wire [7:0] LR;
wire [7:0] LB;
wire [7:0] SR;
wire [7:0] SB;

wire [23:0] Test;
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

//.LR(LR),
//.LB(LB),
//.SR(SR),
//.SB(SB)

    );




// Xilinx
wire [23 : 0] Rs_axis_video_tdata  = m_axis_video_tdata;      // input wire [23 : 0] s_axis_video_tdata  
wire          Rs_axis_video_tready    ;                       // output wire s_axis_video_tready         
wire          Rs_axis_video_tvalid = m_axis_video_tvalid;     // input wire s_axis_video_tvalid          
wire          Rs_axis_video_tlast  = m_axis_video_tlast;      // input wire s_axis_video_tlast           
wire          Rs_axis_video_tuser  = m_axis_video_tuser;      // input wire s_axis_video_tuser_sof       
wire [23 : 0] Ym_axis_video_tdata    ;                        // output wire [23 : 0] m_axis_video_tdata 
wire          Ym_axis_video_tvalid   ;                        // output wire m_axis_video_tvalid         
wire          Ym_axis_video_tready   ;                        // input wire m_axis_video_tready          
wire          Ym_axis_video_tlast    ;                        // output wire m_axis_video_tlast          
wire          Ym_axis_video_tuser    ;                        // output wire m_axis_video_tuser_sof      
//----------- Begin Cut here for INSTANTIATION Template ---// INST_TAG
v_rgb2ycrcb_0 rgb2ycrcb_inst (
  .aclk(clk),                                      // input wire aclk
  .aclken(1'b1),                                  // input wire aclken
  .aresetn(rstn),                                // input wire aresetn
  .s_axis_video_tdata    (Rs_axis_video_tdata),          // input wire [23 : 0] s_axis_video_tdata
  .s_axis_video_tready   (Rs_axis_video_tready),        // output wire s_axis_video_tready
  .s_axis_video_tvalid   (Rs_axis_video_tvalid),        // input wire s_axis_video_tvalid
  .s_axis_video_tlast    (Rs_axis_video_tlast),          // input wire s_axis_video_tlast
  .s_axis_video_tuser_sof(Rs_axis_video_tuser),  // input wire s_axis_video_tuser_sof
  .m_axis_video_tdata    (Ym_axis_video_tdata),          // output wire [23 : 0] m_axis_video_tdata
  .m_axis_video_tvalid   (Ym_axis_video_tvalid),        // output wire m_axis_video_tvalid
  .m_axis_video_tready   (Ym_axis_video_tready),        // input wire m_axis_video_tready
  .m_axis_video_tlast    (Ym_axis_video_tlast),          // output wire m_axis_video_tlast
  .m_axis_video_tuser_sof(Ym_axis_video_tuser)   // output wire m_axis_video_tuser_sof
);

wire [23 : 0] Xm_axis_video_tdata       ;   // output wire [23 : 0] m_axis_video_tdata 
wire          Xm_axis_video_tvalid      ;   // output wire m_axis_video_tvalid         
wire          Xm_axis_video_tready = 1'b1;    // input wire m_axis_video_tready          
wire          Xm_axis_video_tlast       ;   // output wire m_axis_video_tlast          
wire          Xm_axis_video_tuser       ;   // output wire m_axis_video_tuser_sof      

//----------- Begin Cut here for INSTANTIATION Template ---// INST_TAG
v_ycrcb2rgb_0 ycrcb2rgb_inst (
  .aclk(clk),                                      // input wire aclk
  .aclken(1'b1),                                  // input wire aclken
  .aresetn(rstn),                                // input wire aresetn
  .s_axis_video_tdata    (Ym_axis_video_tdata),          // input wire [23 : 0] s_axis_video_tdata
  .s_axis_video_tready   (Ym_axis_video_tready),        // output wire s_axis_video_tready
  .s_axis_video_tvalid   (Ym_axis_video_tvalid),        // input wire s_axis_video_tvalid
  .s_axis_video_tlast    (Ym_axis_video_tlast),          // input wire s_axis_video_tlast
  .s_axis_video_tuser_sof(Ym_axis_video_tuser),  // input wire s_axis_video_tuser_sof
  .m_axis_video_tdata    (Xm_axis_video_tdata),          // output wire [23 : 0] m_axis_video_tdata
  .m_axis_video_tvalid   (Xm_axis_video_tvalid),        // output wire m_axis_video_tvalid
  .m_axis_video_tready   (Xm_axis_video_tready),        // input wire m_axis_video_tready
  .m_axis_video_tlast    (Xm_axis_video_tlast),          // output wire m_axis_video_tlast
  .m_axis_video_tuser_sof(Xm_axis_video_tuser)   // output wire m_axis_video_tuser_sof
);

integer i,f;  
integer Yi,Yf;  
integer SRi,SRf;  
integer Ri,Rf;  
reg signed Ydiff, Cbdiff,Crdiff;
reg signed Rdiff, Gdiff,Bdiff;

reg [23:0] MyYCbCR [0:262143];
reg [23:0] XilYCbCR [0:262143];
reg [17:0] YMyAdd;
reg [17:0] YXilAdd;
reg YWriteData;
/*
always @(posedge clk or negedge rstn)
    if (!rstn) YMyAdd <= 18'h00000;
     else if (!On) YMyAdd <= 18'h00000;
     else if (Mm_axis_video_tvalid) YMyAdd <= YMyAdd + 1;
always @(posedge clk or negedge rstn)
    if (!rstn) YXilAdd <= 18'h00000;
     else if (!On) YXilAdd <= 18'h00000;
     else if (Ym_axis_video_tvalid) YXilAdd <= YXilAdd + 1;

always @(posedge clk) 
    if (Mm_axis_video_tvalid) MyYCbCR[YMyAdd] <= Mm_axis_video_tdata;
always @(posedge clk) 
    if (Ym_axis_video_tvalid) XilYCbCR[YXilAdd] <= Ym_axis_video_tdata;

initial begin
YWriteData = 1'b0;
@((YXilAdd == 18'h00003) && Ym_axis_video_tvalid)
YWriteData = 1'b1;
@((YXilAdd == 18'h00030) && Ym_axis_video_tvalid)
YWriteData = 1'b0;
@((YXilAdd == 18'h3ffff) && Ym_axis_video_tvalid)
YWriteData = 1'b1;
    $display ("Collect data \n");
Yf = $fopen("MyYCbCrVSXilYCbCr.csv","w");
$fwrite(Yf,"Num, Xil Y, My Y, Diff, Xil Cb, My Cb, Diff, Xil Cr, My Cr, Diff \n",i,XilYCbCR[i],MyYCbCR[i]);
for (Yi=0;Yi<18'h3ffff;Yi=Yi+1)begin
    Ydiff  = XilYCbCR[Yi][7:0]  -MyYCbCR[Yi][7:0]    ;
    Cbdiff = XilYCbCR[Yi][15:8] -MyYCbCR[Yi][15:8]  ;
    Crdiff = XilYCbCR[Yi][23:16]-MyYCbCR[Yi][23:16];
    if (Ydiff ) Ydiff <= (-1)*Ydiff ;
    if (Cbdiff) Cbdiff<= (-1)*Cbdiff;
    if (Crdiff) Crdiff<= (-1)*Crdiff;

    $display ("display Num %h", Yi);
    $fwrite(Yf,"%h, ",Yi);
    $fwrite(Yf,"%h, %h, %d, ",  XilYCbCR[Yi][7:0],  MyYCbCR[Yi][7:0],      Ydiff );
    $fwrite(Yf,"%h, %h, %d, ",  XilYCbCR[Yi][15:8], MyYCbCR[Yi][15:8],    Cbdiff);
    $fwrite(Yf,"%h, %h, %d, \n",XilYCbCR[Yi][23:16],MyYCbCR[Yi][23:16],Crdiff);
end
$fclose(Yf);  
end 


reg [15:0] LongRGB  [0:262143];
reg [15:0] ShortRGB [0:262143];
reg [17:0] SRMyAdd;
reg SRWriteData;
always @(posedge clk or negedge rstn)
    if (!rstn) SRMyAdd <= 18'h00000;
     else if (!On) SRMyAdd <= 18'h00000;
     else if (BRm_axis_video_tvalid) SRMyAdd <= SRMyAdd + 1;

always @(posedge clk) 
    if (BRm_axis_video_tvalid) LongRGB[SRMyAdd]  <= {LR,LB};
always @(posedge clk)                             
    if (BRm_axis_video_tvalid) ShortRGB[SRMyAdd] <= {SR,SB};

initial begin
SRWriteData = 1'b0;
@((SRMyAdd == 18'h00003) && BRm_axis_video_tvalid)
SRWriteData = 1'b1;
@((SRMyAdd == 18'h00030) && BRm_axis_video_tvalid)
SRWriteData = 1'b0;
@((SRMyAdd == 18'h3ffff) && BRm_axis_video_tvalid)
SRWriteData = 1'b1;
    $display ("Collect data \n");
SRf = $fopen("LongShortRGB.csv","w");
$fwrite(SRf,"Num, LongR, ShortR, Diff-R, LongB, ShortB, Diff-B, \n");
for (SRi=0;SRi<18'h3ffff;SRi=SRi+1)begin
    Bdiff  = LongRGB[SRi][7:0] -ShortRGB[SRi][7:0]   ;
    Rdiff  = LongRGB[SRi][15:8]-ShortRGB[SRi][15:8]  ;
    if (Bdiff) Bdiff <= (-1)*Bdiff;
    if (Rdiff) Rdiff <= (-1)*Rdiff;

    $display ("display Num %h", SRi);
    $fwrite(SRf,"%h, ",SRi);
    $fwrite(SRf,"%h, %h, %d, ",  LongRGB[SRi][15:8],ShortRGB[SRi][15:8],Rdiff);
    $fwrite(SRf,"%h, %h, %d, \n",LongRGB[SRi][7:0], ShortRGB[SRi][7:0],Bdiff);
end
$fclose(SRf);  
end 


reg [23:0] MyRGB [0:262143];
reg [23:0] XilRGB [0:262143];
reg [17:0] RMyAdd;
reg [17:0] RXilAdd;
reg RWriteData;
always @(posedge clk or negedge rstn)
    if (!rstn) RMyAdd <= 18'h00000;
     else if (!On) RMyAdd <= 18'h00000;
     else if (BRm_axis_video_tvalid) RMyAdd <= RMyAdd + 1;
always @(posedge clk or negedge rstn)
    if (!rstn) RXilAdd <= 18'h00000;
     else if (!On) RXilAdd <= 18'h00000;
     else if (Xm_axis_video_tvalid) RXilAdd <= RXilAdd + 1;

always @(posedge clk) 
    if (BRm_axis_video_tvalid) MyRGB[RMyAdd] <= BRm_axis_video_tdata;
always @(posedge clk) 
    if (Xm_axis_video_tvalid) XilRGB[RXilAdd] <= Xm_axis_video_tdata;

initial begin
RWriteData = 1'b0;
@((RXilAdd == 18'h00003) && Xm_axis_video_tvalid)
RWriteData = 1'b1;
@((RXilAdd == 18'h00030) && Xm_axis_video_tvalid)
RWriteData = 1'b0;
@((RXilAdd == 18'h3ffff) && Xm_axis_video_tvalid)
RWriteData = 1'b1;
    $display ("Collect data \n");
Rf = $fopen("MyRGBVSXilRGB.csv","w");
$fwrite(Rf,"Num, Xil Y, My Y, Diff, Xil Cb, My Cb, Diff, Xil Cr, My Cr, Diff \n");
for (Ri=0;Ri<18'h3ffff;Ri=Ri+1)begin
    Gdiff  = XilRGB[Ri][7:0]  -MyRGB[Ri][7:0]  ;
    Bdiff =  XilRGB[Ri][15:8] -MyRGB[Ri][15:8] ;
    Rdiff =  XilRGB[Ri][23:16]-MyRGB[Ri][23:16];
    if (Gdiff<0) Gdiff<= (-1)*Gdiff;
    if (Bdiff<0) Bdiff<= (-1)*Bdiff;
    if (Rdiff<0) Rdiff<= (-1)*Rdiff;

    $display ("display Num %h", i);
    $fwrite(Rf,"%h, ",Ri);
    $fwrite(Rf,"%h, %h, %d, ",  XilRGB[Ri][7:0]  ,MyRGB[Ri][7:0],  Gdiff);
    $fwrite(Rf,"%h, %h, %d, ",  XilRGB[Ri][15:8] ,MyRGB[Ri][15:8], Bdiff);
    $fwrite(Rf,"%h, %h, %d, \n",XilRGB[Ri][23:16],MyRGB[Ri][23:16],Rdiff);
end
$fclose(Rf);  
end 
*/


integer Ti,Tf;  
integer  TRdiff, TGdiff,TBdiff;

reg [23:0] inRGB  [0:262143];
reg [23:0] outRGB [0:262143];
reg [17:0] inAdd;
reg [17:0] outAdd;
reg TopWriteData;

reg Reg_onOut;
always @(posedge clk or negedge rstn) 
    if (!rstn) Reg_onOut <= 1'b0;
     else if (BRm_axis_video_tvalid && BRm_axis_video_tuser) Reg_onOut <= 1'b1;
wire OnOut =  BRm_axis_video_tuser || Reg_onOut;  

reg [18:0] ReadAdd;

reg[23:0] ReadIn;
reg[23:0] ReadOut;
always @(posedge clk or negedge rstn)
    if (!rstn) inAdd <= 18'h00000;
     else if (!On) inAdd <= 18'h00000;
     else if (m_axis_video_tvalid) inAdd <= inAdd + 1;
always @(posedge clk or negedge rstn)
    if (!rstn) outAdd <= 18'h00000;
     else if (!OnOut) outAdd <= 18'h00000;
     else if (BRm_axis_video_tvalid) outAdd <= outAdd + 1;

always @(posedge clk) 
    if (m_axis_video_tvalid) inRGB[inAdd] <= m_axis_video_tdata;
always @(posedge clk) 
    if (BRm_axis_video_tvalid) outRGB[outAdd] <= BRm_axis_video_tdata;
reg collect;
initial begin
TopWriteData = 1'b0;
@((outAdd == 18'h00003) && BRm_axis_video_tvalid)
TopWriteData = 1'b1;
@((outAdd == 18'h00030) && BRm_axis_video_tvalid)
TopWriteData = 1'b0;
@((outAdd == 18'h3ffff) && BRm_axis_video_tvalid)
TopWriteData = 1'b1;
    $display ("Collect data \n");
Tf = $fopen("TopRGB.csv","w");
$fwrite(Tf,"Num, Out G, In G, Diff G, Out B, In B, Diff B, Out R, In R, Diff R\n",i,XilYCbCR[i],MyYCbCR[i]);
ReadAdd = 19'h00000;
while (ReadAdd < 19'h40000)begin
//for (Ti=0;Ti<18'h3ffff;Ti=Ti+1)begin
    ReadIn  =  inRGB[ReadAdd];
    ReadOut = outRGB[ReadAdd];
    TGdiff = ReadOut[7:0]  - ReadIn[7:0]    ;
    TBdiff = ReadOut[15:8] - ReadIn[15:8]  ;
    TRdiff = ReadOut[23:16]- ReadIn[23:16];
    if (TGdiff < 0) TGdiff = (-1)*TGdiff;
    if (TBdiff < 0) TBdiff = (-1)*TBdiff;
    if (TRdiff < 0) TRdiff = (-1)*TRdiff;

//    $display ("display Num %h", ReadAdd);
    $fwrite(Tf,"%h, ",ReadAdd);
    $fwrite(Tf,"%h, %h, %d, ",  ReadOut[7:0],  ReadIn[7:0],  TGdiff);
    $fwrite(Tf,"%h, %h, %d, ",  ReadOut[15:8], ReadIn[15:8], TBdiff);
    $fwrite(Tf,"%h, %h, %d, \n",ReadOut[23:16],ReadIn[23:16],TRdiff);
    @(clk);    
    ReadAdd = ReadAdd + 1;
end
$fclose(Tf);  
$finish;
end 



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
