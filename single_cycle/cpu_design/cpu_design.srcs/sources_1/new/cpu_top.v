`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/24 11:42:17
// Design Name: 
// Module Name: cpu_top
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


//module cpu_top(
//    input wire clk,
//    input wire rst_n 
//    );
module cpu_top (
    input  wire clk,
    input  wire rst_n,
    input  [31:0] RD_in,
    output [31:0] alu_c_out,
    output  wire dram_en_out,
    output [31:0] rD2_out
);

    wire locked;            
    wire[31:0] npc;                                     // ��һPC��ַ

    (*mark_debug = "true"*)wire[31:0] pc;               // ��ǰPC

    (*mark_debug = "true"*)wire[31:0] inst;             // ��ǰָ��
    wire[31:0] immediate;                               // ��չ���������
    wire[1:0] npc_op;                                   // ������һPC��ַ�Ĳ����ź�
    wire alub_sel;                                      // �ڶ�����������ѡ���ź�
    wire[3:0] alu_op;                                   // ALU�����Ŀ����ź�
    wire[1:0] wd_sel;                                   // д�ؼĴ����Ŀ����ź�
    wire dram_we;                                       // ���ݴ洢����дʹ���ź�
    wire rf_we;                                         // �Ĵ����ѵ�дʹ���ź�
    (*mark_debug = "true"*)wire[31:0] alu_c;            // ALU�ļ�����
    wire[31:0] pc4;                                     // pc+4
    wire[31:0] auipc;                                   // pc+imm_ext
    wire[31:0] RD;                                      // ��RAM��ȡ������
    wire[31:0] rD1;                                     // �ӼĴ����Ѷ����ĵ�һ��������
    wire[31:0] rD2;                                     // �ӼĴ����Ѷ����ĵڶ���������

    wire[31:0] ram_wb;                                  // Load��ָ���£�Ҫд�ؼĴ����ѵ�����
    
    // ���ߣ���ȡ���ݴ洢�����ݻ���������RD
    assign RD = RD_in;
    // ���ߣ���������ź�
    assign alu_c_out = alu_c;
    assign dram_en_out = dram_we;
    assign rD2_out = rD2;


    // LOADģ�飬����load��ָ���´�RAM��ȡ�����ݣ����Ҫд�ؼĴ����ѵ�����
    LOAD u_LOAD(
        .funct3     (inst[14:12]),
        .RD         (RD),
        .ram_wb     (ram_wb),
        .alu_c      (alu_c)
    );
    // PCģ�飬����PC�ĸ���
    PC u_PC(
        .clk    (clk),
        .rst_n  (rst_n),
        .npc    (npc),
        .pc     (pc)
    );
    
    // SEXTģ�飬������������չ
    SEXT u_SEXT(
        .inst   (inst),
        .imm    (immediate)
    );
    
    // ALUģ�飬���ڸ�������
    ALU u_ALU (
        .RD1    (rD1),
        .RD2    (rD2),
        .alub_sel   (alub_sel),
        .imm_ext    (immediate),
        .alu_op     (alu_op),
        .alu_c      (alu_c)
    );
    
    // Controlģ�飬�������ɸ������ź�
    Control u_Control(
        .opcode     (inst[6:0]),
        .funct3     (inst[14:12]),
        .funct7     (inst[31:25]),
        .inst30     (inst[30]),   
        .npc_op     (npc_op),
        .alub_sel   (alub_sel),
        .alu_op     (alu_op),
        .wd_sel     (wd_sel),
        .dram_we    (dram_we),
        .rf_we      (rf_we)
    );
    
    // NPCģ�飬����������һָ���ַ
    NPC u_NPC(
        .imm_ext     (immediate),
        .ALU_C      (alu_c),
        .pc         (pc),
        .npc_op     (npc_op),
        .npc        (npc),
        .pc4        (pc4),
        .auipc      (auipc)
    );
    
    //RFģ�飬ʵ�ּĴ����ѵĹ���
    RF u_RF (
        .clk        (clk),
        .rR1        (inst[19:15]),
        .rR2        (inst[24:20]),
        .WR         (inst[11:7]),
        .WD0         (alu_c),
        .WD1         (ram_wb),
        .WD2         (pc4),
        .WD3        (auipc),  
        .wd_sel     (wd_sel),
        .rf_we      (rf_we),
        .RD1        (rD1),
        .RD2        (rD2)

    );

    // ��ȡָ��
    prgrom U0_irom (
        .a      (pc >> 2),   // input wire [13:0] a
        .spo    (inst)   // output wire [31:0] spo
    );

    

endmodule
