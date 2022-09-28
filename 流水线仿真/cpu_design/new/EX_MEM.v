`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/12 10:14:07
// Design Name: 
// Module Name: EX_MEM
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


module EX_MEM(
    input clk,
    input rst_n,
    input is_load_ex,
    input [31:0]inst_ex,
    input [31:0]ex_rd2,
    input [1:0]ex_wd_sel,
    input [0:0]ex_dram_we,
    input [31:0]ex_alu_c,
    input [31:0]ex_auipc,
    input [31:0]pc_ex,
    input [0:0]ex_rf_we,
    output reg[31:0]mem_rd2,
    output reg[1:0]mem_wd_sel,
    output reg[0:0]mem_dram_we,
    output reg[31:0]mem_alu_c,
    output reg[31:0]mem_auipc,
    output reg[31:0]pc_mem,
    output reg[0:0]mem_rf_we,
    output reg[31:0]inst_mem,
    output reg is_load_mem
    );
    // mem_rd2
    always @(posedge clk or negedge rst_n)begin
        if(~rst_n)              mem_rd2 <= 'h0;
        else                    mem_rd2 <= ex_rd2;
    end

    // mem_WR
    // always @(posedge clk or negedge rst_n)begin
    //     if(~rst_n)              mem_WR <= 'h0;
    //     else                    mem_WR <= ex_WR;
    // end

    // mem_wd_sel
    always @(posedge clk or negedge rst_n)begin
        if(~rst_n)              mem_wd_sel <= 'h0;
        else                    mem_wd_sel <= ex_wd_sel;
    end

    // mem_dram_we
    always @(posedge clk or negedge rst_n)begin
        if(~rst_n)              mem_dram_we <= 'h0;
        else                    mem_dram_we <= ex_dram_we;
    end

    // mem_alu_c
    always @(posedge clk or negedge rst_n)begin
        if(~rst_n)              mem_alu_c <= 'h0;
        else                    mem_alu_c <= ex_alu_c;
    end

    // pc_mem
    always @(posedge clk or negedge rst_n)begin
        if(~rst_n)              pc_mem <= 'h0;
        else                    pc_mem <= pc_ex;
    end

    // mem_auipc
    always @(posedge clk or negedge rst_n)begin
        if(~rst_n)              mem_auipc <= 'h0;
        else                    mem_auipc <= ex_auipc;
    end

    // mem_rf_we
    always @(posedge clk or negedge rst_n)begin
        if(~rst_n)              mem_rf_we <= 'h0;
        else                    mem_rf_we <= ex_rf_we;
    end

    // inst_mem
    always @(posedge clk or negedge rst_n)begin
        if(~rst_n)              inst_mem <= 'h0;
        else                    inst_mem <= inst_ex;
    end

    // is_load_mem
    always @(posedge clk or negedge rst_n)begin
        if(~rst_n)              is_load_mem <= 'h0;
        else                    is_load_mem <= is_load_ex;
    end
endmodule
