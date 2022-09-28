`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/06 11:49:52
// Design Name: 
// Module Name: Led
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


module Led(
    input wen,
    input clk,
    input rst_n,
    input [31:0] wdata,
    output reg[23:0]led
    );
    // wire show_ena = (addr == 32'hFFFFF060);
    always @(posedge clk or negedge rst_n)begin
        if (~rst_n)    led <= 24'h0;
        else if(wen==1'b1)  led <= wdata[23:0];
    end
endmodule
