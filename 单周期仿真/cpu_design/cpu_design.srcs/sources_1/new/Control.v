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

   
   //选择下一地址的控制信号，01表示npc=rs1+offset，10表示npc=pc+offset，00表示pc+4
    assign npc_op[1:0] = (opcode==7'b1100111) ? (2'b01) :                                // jalr
                     (opcode==7'b1101111) ? (2'b10) :                               // J型指令
                     (opcode==7'b1100011) ? (2'b11) : (2'b00);// B型或 其它类型
    // 第二个操作数的选择信号，I/S/U型指令选择立即数，其余选择rs2                 
    assign alub_sel = (opcode==7'b0010011 || opcode==7'b0000011 || opcode==7'b1100111 || opcode==7'b0100011 || opcode==7'b0110111) ? 1'b1 : 1'b0;

    always @(*)begin
        // R型指令
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
        // I型指令
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
        else if(opcode == 7'b0000011 || opcode == 7'b1100111 || opcode == 7'b0100011)begin //load jalr S型
            alu_op = 4'b0000;
        end
        else if(opcode == 7'b1100011)begin                                                  // B型
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
    // 写回寄存器的数据控制信号
    assign wd_sel = (opcode==7'b0000011) ? 2'b01 :  //load指令
                    (opcode == 7'b1101111 || opcode == 7'b1100111) ? 2'b10 :  // jal指令、jalr指令
                    (opcode == 7'b0010111) ? 2'b11 : 2'b00; // auipc，其它指令
    
    // 存储器写使能信号
    assign dram_we = (opcode == 7'b0100011) ? 1'b1 : 1'b0;  //   sw的ram写使能信号为1，其它为0
    
    // 寄存器写使能信号
    assign rf_we = (opcode == 7'b0100011 || opcode == 7'b1100011) ? 1'b0 :1'b1; // B型和S型寄存器写使能信号为0，其余为1
    

    
    
    
    
    
    
    
    
    
    
endmodule
