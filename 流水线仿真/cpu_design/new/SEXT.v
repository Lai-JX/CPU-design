`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/24 13:15:27
// Design Name: 
// Module Name: SEXT
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


module SEXT(
    input wire[31:0] inst,
    output wire[31:0] imm
    );

    assign imm = ((inst[14:12] == 3'b001 || inst[14:12] == 3'b101)&&(inst[6:0]==7'b0010011)) ? inst[24:20] : //移位指令
                  (inst[6:0]==7'b0010011 || inst[6:0]==7'b0000011 || inst[6:0]==7'b1100111) ? {{20{inst[31]}}, inst[31:20]} : // 其它I型指令
                  (inst[6:0]==7'b0100011) ? {{20{inst[31]}}, inst[31:25], inst[11:7]} :                                    // S型指令
                  (inst[6:0]==7'b1100011) ? {{20{inst[31]}},inst[7],inst[30:25], inst[11:8],1'b0} :                              // B型指令
                  (inst[6:0]==7'b0110111 || inst[6:0]==7'b0010111) ? {inst[31:12], 12'b0} :                                                         // lui
                  (inst[6:0]==7'b1101111) ? {{12{inst[31]}},inst[31],inst[19:12],inst[20], inst[30:21],1'b0} :  1'b0;                     // jal
                  
    
    
    
    
    
endmodule
