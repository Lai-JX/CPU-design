`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/24 11:01:16
// Design Name: 
// Module Name: NPC
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


module NPC(
    input wire[31:0] imm_ext,
    input wire[31:0] ALU_C,
    input wire[31:0] pc,
    input wire[1:0] npc_op,
    output wire[31:0] npc,
    output wire[31:0] pc4,
    output wire[31:0] auipc
    );
    assign pc4 = pc + 3'd4;
    assign auipc = pc + imm_ext;
    assign npc = (npc_op == 2'b00) ? (pc+3'd4) :
                  (npc_op == 2'b01) ? ALU_C :
                  (npc_op == 2'b10) ? (pc+imm_ext) :
                  (npc_op == 2'b11) ? ((ALU_C == 1'b1) ? (pc+imm_ext): (pc+(3'd4))): 1'b0;
    
    
    
    
    
    
    
    
endmodule
