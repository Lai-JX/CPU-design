`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/06 09:43:24
// Design Name: 
// Module Name: DRAM
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


module DRAM(
    input clk,
    input [31:0]a,
    input we,
    input [31:0]d,
    output [31:0]spo
    );

// ????ip??¡¤???dram 
    wire [31:0] waddr_temp = a- 16'h4000;


            dram u_dram(
                .clk    (clk),
                .a      (waddr_temp >> 2),
                .spo    (spo),
                .we     (we),
                .d      (d)
            );





endmodule
