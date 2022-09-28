`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/12 10:14:27
// Design Name: 
// Module Name: MEM_WB
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


module MEM_WB(
    input clk,
    input rst_n,
    input [31:0]inst_mem,
    input [1:0]mem_wd_sel,
    input [0:0]mem_rf_we,
    input [31:0]mem_alu_c,
    input [31:0]mem_auipc,
    input [31:0]pc_mem,
    input [31:0]mem_ram_wb,
    output reg wb_rf_we,
    output reg[31:0]wb_data,
    output reg[4:0]wb_WR
    );
    // wb_data
    always @(*)begin
        if(~rst_n)              wb_data <= 'h0;
        else begin
		    if(mem_wd_sel == 2'b00)begin
		        wb_data<=mem_alu_c;
		    end
		    else if(mem_wd_sel == 2'b01)begin
		        wb_data<=mem_ram_wb;
		    end
		    else if(mem_wd_sel == 2'b10)begin
		        wb_data<=pc_mem+3'd4;
		    end
			else if(mem_wd_sel == 2'b11)begin
		        wb_data<=mem_auipc;
		    end
		    else begin
		    end
        end

    end
    // wb_rf_we
    always @(*)begin
        if(~rst_n)              wb_rf_we <= 'h0;
        else                    wb_rf_we <= mem_rf_we;
    end
    // wb_WR
    always @(*)begin
        if(~rst_n)              wb_WR <= 'h0;
        else                    wb_WR <= inst_mem[11:7];
    end
endmodule
