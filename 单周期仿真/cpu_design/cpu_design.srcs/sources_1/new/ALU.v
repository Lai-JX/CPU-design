`include "param.v"

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/24 11:55:12
// Design Name: 
// Module Name: ALU
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



module ALU(
    input wire [31:0] RD1,
    input wire [31:0] RD2,
    input wire alub_sel,
    input wire [31:0] imm_ext,
    input wire [3:0] alu_op,
    output reg [31:0] alu_c

    );

//    `include "param.v"
//    parameter ADD = 4'b0000;
//    parameter SUB = 4'b0001;
//    parameter AND = 4'b0010;
//    parameter OR = 4'b0011;
//    parameter XOR = 4'b0100;
//    parameter SLL =4'b0101;
//    parameter SRL = 4'b0110;
//    parameter SRA = 4'b0111;
//    parameter BEQ = 4'b1000;
//    parameter BNE = 4'b1001;
//    parameter BLT = 4'b1010;
//    parameter BGE = 4'b1011;
//    parameter LUI = 4'b1100;
//    reg temp[31:0];
    always @(*) begin
        case(alu_op)
            `ADD: alu_c = RD1 + (alub_sel ? imm_ext : RD2);
            `SUB: alu_c = RD1-RD2;
            `AND: alu_c = RD1 & (alub_sel ? imm_ext : RD2);
            `OR : alu_c = RD1 | (alub_sel ? imm_ext : RD2);
            `XOR: alu_c = RD1 ^ (alub_sel ? imm_ext : RD2);
            `SLL: alu_c = RD1 << (alub_sel ? imm_ext : RD2%32);
            `SRL: alu_c = RD1 >> (alub_sel ? imm_ext : RD2%32);
            `SRA: begin
                if(alub_sel)begin
                    alu_c = ( $signed(RD1) ) >>> imm_ext;
                end
                else begin
                    alu_c = ( $signed(RD1) ) >>> RD2%32;
                end
            end
            `BEQ: alu_c = (RD1==RD2) ? 1 :0;
            `BNE: alu_c = (RD1==RD2) ? 0 :1;
            `BLT_SLT: alu_c = (($signed(RD1))<($signed(alub_sel ? imm_ext : RD2))) ? 1 :0;
            `BLTU: alu_c = (RD1<RD2) ? 1 :0;
            `BGE: alu_c = (($signed(RD1))>=($signed(RD2))) ? 1 :0;
            `BGEU: alu_c = (RD1>=RD2) ? 1 :0;
            `LUI: alu_c = imm_ext;
            `SLTU: alu_c = (RD1<(alub_sel ? imm_ext : RD2)) ? 1 :0;
            
        endcase
    end
endmodule
