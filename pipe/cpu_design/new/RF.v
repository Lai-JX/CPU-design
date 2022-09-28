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
	input rf_we,	//???????��???
	output reg[31:0] RD1,
	output reg[31:0] RD2
	);
    (*mark_debug = "true"*)reg [31:0] regts[1:31];


	// ������߼���ȡ�Ĵ�����
	// ��ȡ��һ��������
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
	
	// ��ȡ�ڶ���������
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
	
	// ��ʱ���߼�д�����ݵ��Ĵ�����
	always @(posedge clk)	
	begin
		if( (rf_we==1'b1) && (WR!=5'b00000) ) 	
		begin	
			regts[WR]<=WD;
		end
    end

endmodule
