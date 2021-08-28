`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.08.2021 17:46:09
// Design Name: 
// Module Name: SCCB_tb
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


module SCCB_tb();
reg clk ;
reg rstn;
initial begin 
clk  = 1'b0;
rstn = 1'b0;
#100;
rstn = 1'b1;
end
always #10 clk = ~clk;

reg Start        ;          
reg [3:0] WR     ;       
reg [31:0] DataIn;   

initial begin 
Start  = 0;
WR     = 0;
DataIn = 0;
@(posedge rstn);
#100;
@(posedge clk);
Start  = 1'b0;
WR     = 4'h5;
DataIn = 32'h78300a00;
@(posedge clk);
Start  = 1'b1;
@(posedge clk);
Start  = 1'b0;
#25000;
@(posedge clk);
Start  = 1'b0;
WR     = 4'h6;
DataIn = 32'h78300a00;
@(posedge clk);
Start  = 1'b1;
@(posedge clk);
Start  = 1'b0;

end

wire [15:0] ClkDiv = 16'h0010;       
wire [15:0] NegDel = 16'h0000;       
  
wire Busy          ;          
wire [7:0] ReadData;       

wire sccb_clk      ;          
wire sccb_clk_en   ;          
wire sccb_data_out ;          
wire sccb_data_in  ;          
wire sccb_data_en  ;         

wire cam_iic_scl_io;
wire cam_iic_sda_io;
wire sccb_data_in_0;


SCCB SCCB_inst(
.clk          (clk          ),                // input clk,             
.rstn         (rstn         ),               // input rstn,            

.ClkDiv       (ClkDiv       ),         // input [15:0] ClkDiv,   
.NegDel       (NegDel       ),         // input [15:0] NegDel,   

.Start        (Start        ),              // input Start,           
.WR           (WR           ),              // input [3:0] WR,        
.DataIn       (DataIn       ),           // input [31:0] DataIn,   
.Busy         (Busy         ),              // output Busy,           
.ReadData     (ReadData     ),       // output [7:0] ReadData, 

.sccb_clk     (sccb_clk     ),          // output sccb_clk,       
.sccb_clk_en  (sccb_clk_en  ),       // output sccb_clk_en,    
.sccb_data_out(sccb_data_out),     // output sccb_data_out,  
.sccb_data_in (sccb_data_in ),      // input  sccb_data_in,   
.sccb_data_en (sccb_data_en )      // output sccb_data_en    
);

assign cam_iic_scl_io  = (sccb_clk_en) ? sccb_clk : 1'b1;
assign cam_iic_sda_io = (~sccb_data_en) ? sccb_data_out : 1'bz;
assign sccb_data_in_0 = cam_iic_sda_io;

endmodule
