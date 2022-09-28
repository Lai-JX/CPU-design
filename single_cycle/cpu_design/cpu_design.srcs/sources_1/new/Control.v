`include "param.v"
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/24 11:39:04
// Design Name: 
// Module Name: Control
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


module Control(
    input wire[6:0] opcode,
    input wire[2:0] funct3,
    input wire[6:0] funct7,
    input wire inst30,
    output wire[1:0] npc_op,
    output wire alub_sel,
    output reg[3:0] alu_op,
    output wire[1:0] wd_sel,
    output wire dram_we,
    output wire rf_we
    );

   
   //ѡ����һ��ַ�Ŀ����źţ�01��ʾnpc=rs1+offset��10��ʾnpc=pc+offset��00��ʾpc+4
    assign npc_op[1:0] = (opcode==7'b1100111) ? (2'b01) :                                // jalr
                     (opcode==7'b1101111) ? (2'b10) :                               // J��ָ��
                     (opcode==7'b1100011) ? (2'b11) : (2'b00);// B�ͻ� ��������
    // �ڶ�����������ѡ���źţ�I/S/U��ָ��ѡ��������������ѡ��rs2                 
    assign alub_sel = (opcode==7'b0010011 || opcode==7'b0000011 || opcode==7'b1100111 || opcode==7'b0100011 || opcode==7'b0110111) ? 1'b1 : 1'b0;

    always @(*)begin
        // R��ָ��
        if(opcode == 7'b0110011)begin
            case(funct3)
                3'b000: alu_op = (inst30==1'b0) ? `ADD : `SUB;
                3'b001: alu_op = `SLL;
                3'b100: alu_op = `XOR;
                3'b101: alu_op = (inst30==1'b0) ? `SRL : `SRA;   
                3'b110: alu_op = `OR;    
                3'b111: alu_op = `AND; 
                3'b010: alu_op = `BLT_SLT;       
                3'b011: alu_op = `SLTU;    
            endcase   
        end
        // I��ָ��
        else if(opcode == 7'b0010011)begin
            case(funct3)
                3'b000: alu_op = `ADD;
                3'b001: alu_op = `SLL;
                3'b100: alu_op = `XOR;
                3'b101: alu_op = (inst30==1'b0) ? `SRL : `SRA;   
                3'b110: alu_op = `OR;    
                3'b111: alu_op = `AND;     
                3'b010: alu_op = `BLT_SLT;   
                3'b011: alu_op = `SLTU;        
            endcase   
        end
        else if(opcode == 7'b0000011 || opcode == 7'b1100111 || opcode == 7'b0100011)begin //load jalr S��
            alu_op = 4'b0000;
        end
        else if(opcode == 7'b1100011)begin                                                  // B��
            case(funct3)
                3'b000: alu_op = `BEQ;
                3'b001: alu_op = `BNE;
                3'b100: alu_op = `BLT_SLT;
                3'b101: alu_op = `BGE;
                3'b110: alu_op = `BLTU;
                3'b111: alu_op = `BGEU;             
            endcase
        end
        else if(opcode == 7'b0110111)begin
            alu_op = `LUI;
        end
    end    
    // д�ؼĴ��������ݿ����ź�
    assign wd_sel = (opcode==7'b0000011) ? 2'b01 :  //loadָ��
                    (opcode == 7'b1101111 || opcode == 7'b1100111) ? 2'b10 :  // jalָ�jalrָ��
                    (opcode == 7'b0010111) ? 2'b11 : 2'b00; // auipc������ָ��
    
    // �洢��дʹ���ź�
    assign dram_we = (opcode == 7'b0100011) ? 1'b1 : 1'b0;  //   sw��ramдʹ���ź�Ϊ1������Ϊ0
    
    // �Ĵ���дʹ���ź�
    assign rf_we = (opcode == 7'b0100011 || opcode == 7'b1100011) ? 1'b0 :1'b1; // B�ͺ�S�ͼĴ���дʹ���ź�Ϊ0������Ϊ1
    

    
    
    
    
    
    
    
    
    
    
endmodule
