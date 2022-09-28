`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/24 18:26:05
// Design Name: 
// Module Name: RF
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


module RF(
	input clk,
	input [4:0] rR1,
	input [4:0] rR2,
	input [4:0] WR,
	input [31:0] WD,
	input rf_we,	//???????д???
	output reg[31:0] RD1,
	output reg[31:0] RD2
	);
    (*mark_debug = "true"*)reg [31:0] regts[1:31];


	// 用组合逻辑读取寄存器堆
	// 读取第一个操作数
	always @(*)	
	begin
		if(rR1==5'b00000)	
		begin
			RD1=32'b0;
		end
		else
		begin
			RD1=regts[rR1];
		end 
	end
	
	// 读取第二个操作数
	always @(*)
	begin
	   if(rR2==5'b00000)	
		begin
			RD2=32'b0;
		end
		else
		begin
			RD2=regts[rR2];
		end
	end
	
	// 用时序逻辑写入数据到寄存器堆
	always @(posedge clk)	
	begin
		if( (rf_we==1'b1) && (WR!=5'b00000) ) 	
		begin	
			regts[WR]<=WD;
		end
    end

endmodule
