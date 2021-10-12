`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/12/2021 09:36:41 AM
// Design Name: 
// Module Name: DDS_tb
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


module DDS_tb();
reg clk ;
reg aclk;
reg rstn;
initial begin 
clk  = 1'b0;
aclk = 1'b0;
rstn = 1'b0;
#100;
rstn = 1'b1;
end

always #4 clk = ~clk;
always #10 aclk = ~aclk;

reg [31:0]  S_APB_0_paddr    ; // input  [31:0] S_APB_0_paddr      ,
reg         S_APB_0_penable  ; // input         S_APB_0_penable    ,
wire [31:0] S_APB_0_prdata   ;  // output [31:0] S_APB_0_prdata     ,
wire        S_APB_0_pready   ;  // output        S_APB_0_pready     ,
reg         S_APB_0_psel     ; // input         S_APB_0_psel       ,
wire        S_APB_0_pslverr  ;  // output        S_APB_0_pslverr    ,
reg [31:0]  S_APB_0_pwdata   ; // input  [31:0] S_APB_0_pwdata     ,
reg         S_APB_0_pwrite   ; // input         S_APB_0_pwrite     ,

initial begin 
@(posedge rstn);
WriteAXI(32'h43c30008,32'h04120514);
WriteAXI(32'h43c30010,32'h00000000);
WriteAXI(32'h43c30000,32'h00000001);
while (|S_APB_0_prdata)begin
    ReadAXI(32'h43c30004);
end
#100;
WriteAXI(32'h43c30008,32'h04120514);
WriteAXI(32'h43c30010,32'h00000001);
WriteAXI(32'h43c30000,32'h00000001);
while (|S_APB_0_prdata)begin
    ReadAXI(32'h43c30004);
end
    ReadAXI(32'h43c3000c);
#100;
#1000;
$finish;    

end

wire DDS_PCLK               ;  // output DDS_PCLK                  ,
wire DDS_IOup               ;  // output DDS_IOup                  ,
wire DDS_CSn                ;  // output DDS_CSn                   ,
wire DDS_RWn                ;  // output DDS_RWn                   ,
wire DDS_ReadEn             ;  // output DDS_ReadEn                ,
wire [7:0] DDS_DataOut      ;  // output [7:0] DDS_DataOut         ,
wire [7:0] DDS_DataIn = 8'h55       ;  // input  [7:0] DDS_DataIn          

DDS_cont DDS_cont_inst(
.clk               (clk )        ,
.rstn              (rstn)        ,

.S_APB_0_axiclk    (aclk ) ,// input         S_APB_0_axiclk     ,
.S_APB_0_aresetn   (rstn) ,// input         S_APB_0_aresetn    ,
.S_APB_0_paddr     (S_APB_0_paddr  ) ,// input  [31:0] S_APB_0_paddr      ,
.S_APB_0_penable   (S_APB_0_penable) ,// input         S_APB_0_penable    ,
.S_APB_0_prdata    (S_APB_0_prdata ) ,// output [31:0] S_APB_0_prdata     ,
.S_APB_0_pready    (S_APB_0_pready ) ,// output        S_APB_0_pready     ,
.S_APB_0_psel      (S_APB_0_psel   ) ,// input         S_APB_0_psel       ,
.S_APB_0_pslverr   (S_APB_0_pslverr) ,// output        S_APB_0_pslverr    ,
.S_APB_0_pwdata    (S_APB_0_pwdata ) ,// input  [31:0] S_APB_0_pwdata     ,
.S_APB_0_pwrite    (S_APB_0_pwrite ) ,// input         S_APB_0_pwrite     ,

.DDS_PCLK    (DDS_PCLK  )        ,// output DDS_PCLK                  ,
.DDS_IOup    (DDS_IOup  )        ,// output DDS_IOup                  ,
.DDS_CSn     (DDS_CSn   )        ,// output DDS_CSn                   ,
.DDS_RWn     (DDS_RWn   )        ,// output DDS_RWn                   ,
.DDS_ReadEn  (DDS_ReadEn)        ,// output DDS_ReadEn                ,
.DDS_DataOut (DDS_DataOut )        ,// output [7:0] DDS_DataOut         ,
.DDS_DataIn  (DDS_DataIn  )         // input  [7:0] DDS_DataIn          
    );

//////////////////////////////////////////////////
/////////////// Read/write tasks /////////////////
//////////////////////////////////////////////////

task ReadAXI;
input [31:0] addr;
begin 
    S_APB_0_paddr    = 0; // input  [31:0] S_APB_0_paddr      ,
    S_APB_0_penable  = 0; // input         S_APB_0_penable    ,
    S_APB_0_psel     = 0; // input         S_APB_0_psel       ,
    S_APB_0_pwdata   = 0; // input  [31:0] S_APB_0_pwdata     ,
    S_APB_0_pwrite   = 0; // input         S_APB_0_pwrite     ,
    @(posedge aclk);
    S_APB_0_paddr   = addr;
    S_APB_0_psel    = 1'b1;
    @(posedge aclk);
    S_APB_0_penable    = 1'b1;
    while (~S_APB_0_pready) begin
        @(posedge aclk);    
        if (S_APB_0_pready) begin 
                S_APB_0_psel  = 1'b0;
                S_APB_0_penable  = 1'b0;
                end
    end
end 
endtask 


task WriteAXI;
input [31:0] addr;
input [31:0] data;
begin 
    S_APB_0_paddr    = 0; // input  [31:0] S_APB_0_paddr      ,
    S_APB_0_penable  = 0; // input         S_APB_0_penable    ,
    S_APB_0_psel     = 0; // input         S_APB_0_psel       ,
    S_APB_0_pwdata   = 0; // input  [31:0] S_APB_0_pwdata     ,
    S_APB_0_pwrite   = 0; // input         S_APB_0_pwrite     ,


    @(posedge aclk);
    S_APB_0_paddr   = addr;
    S_APB_0_pwdata  = data;
    S_APB_0_pwrite  = 1'b1;
    S_APB_0_psel    = 1'b1;
    @(posedge aclk);
    S_APB_0_penable  = 1'b1;
    while (~S_APB_0_pready) begin
        @(posedge aclk);    
        if (S_APB_0_pready) begin 
                S_APB_0_psel  = 1'b0;
                S_APB_0_penable  = 1'b0;
                end
    end
end 
endtask 

endmodule
