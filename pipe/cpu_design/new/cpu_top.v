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
    // IF_ID
    (*mark_debug = "true"*)wire[31:0] pc_if;            
    (*mark_debug = "true"*)wire[31:0] inst_if;         
    wire[31:0] pc_id;   
    wire[31:0] inst_id;

    // Flush_waitģ�����
    wire is_branch;                                     // ��֧�Ƿ������ת
    wire load_stop;                                     // ����loadָ����ͣһ������

    // ID_EX
    wire [31:0]inst_ex;
    wire[31:0] id_imm;                                  // ��չ���������
    wire[1:0] id_npc_op;                                // ������һPC��ַ�Ĳ����ź�
    wire is_load_id;
    wire id_alub_sel;                                      // �ڶ�����������ѡ���ź�
    wire[3:0] id_alu_op;                                   // ALU�����Ŀ����ź�
    wire[1:0] id_wd_sel;                                   // д�ؼĴ����Ŀ����ź�
    wire id_dram_we;                                       // ���ݴ洢����дʹ���ź�
    wire id_rf_we;                                         // �Ĵ����ѵ�дʹ���ź�
    wire[31:0] id_rD1;                                     // �ӼĴ����Ѷ����ĵ�һ��������
    wire[31:0] id_rD2;                                     // �ӼĴ����Ѷ����ĵڶ���������
    wire [3:0]ex_alu_op;
    wire [31:0]pc_ex;
    wire is_load_ex;
    wire [1:0]ex_npc_op;
    wire [31:0]ex_A;
    wire [31:0]ex_B;
    wire [31:0]ex_rd2;
    wire [1:0]ex_wd_sel;
    wire ex_dram_we;
    wire [31:0]ex_imm;
    wire ex_rf_we;
    wire [31:0]ex_alu_c;
    
    // EX_MEM
    wire [31:0]inst_mem;
    wire[31:0] npc;                                     // ��һPC��ַ
    wire [31:0]ex_auipc;
    wire [31:0]mem_rd2;
    wire [1:0]mem_wd_sel;
    wire [0:0]mem_dram_we;
    wire [31:0]mem_alu_c;
    wire [31:0]mem_auipc;
    wire [31:0]pc_mem;
    wire [0:0]mem_rf_we;
    wire[31:0] mem_ram_wb;                                  // Load��ָ���£�Ҫд�ؼĴ����ѵ�����
    wire is_load_mem;

    
    wire[31:0] RD;                                      // ��RAM��ȡ������


    // Forward
    wire [31:0]rdata1_f;
    wire [31:0]rdata2_f;
    wire [0:0]rd1_sel;
    wire [0:0]rd2_sel;

    // MEM_WB
    wire wb_rf_we;
    wire [31:0]wb_data;
    wire [4:0]wb_WR;

    // ���ߣ���ȡ���ݴ洢�����ݻ���������RD
    assign RD = RD_in;
    // ���ߣ���������ź�
    assign alu_c_out = mem_alu_c;
    assign dram_en_out = mem_dram_we;
    assign rD2_out = mem_rd2;


    
    // PCģ�飬����PC�ĸ���
    PC u_PC(
        .clk    (clk),
        .rst_n  (rst_n),
        .npc    (npc),
        .pc     (pc_if),
        .load_stop(load_stop),
        .is_branch(is_branch)
    );

    // ��ȡָ��
    prgrom U0_irom (
        .a      (pc_if[15:2]),   // input wire [13:0] a
        .spo    (inst_if)   // output wire [31:0] spo
    );

    IF_ID u_IF_ID(
        .clk        (clk),
        .rst_n      (rst_n),
        .load_stop  (load_stop),
        .is_branch  (is_branch),
        .inst_if    (inst_if),
        .pc_if      (pc_if),
        .inst_id    (inst_id),
        .pc_id      (pc_id)
    );


    // SEXTģ�飬������������չ
    SEXT u_SEXT(
        .inst   (inst_id),
        .imm    (id_imm)
    );
    
    ID_EX u_ID_EX(
        .clk            (clk),
        .rst_n          (rst_n),
        .inst_id        (inst_id),
        .load_stop      (load_stop),
        .is_branch      (is_branch),
        .pc_id          (pc_id),
        .id_npc_op      (id_npc_op),
        .is_load_id     (is_load_id),
        .id_rD1         (id_rD1),
        .id_rD2         (id_rD2),
        .id_wd_sel      (id_wd_sel),
        .id_alu_op      (id_alu_op),
        .id_dram_we     (id_dram_we),
        .id_rf_we       (id_rf_we),
        .alub_sel       (id_alub_sel),
        .id_imm         (id_imm),
        .rdata1_f       (rdata1_f),
        .rdata2_f       (rdata2_f),
        .rd1_sel        (rd1_sel),
        .rd2_sel        (rd2_sel),
        .pc_ex          (pc_ex),
        .ex_npc_op      (ex_npc_op),
        .is_load_ex     (is_load_ex),
        .ex_A           (ex_A),
        .ex_B           (ex_B),
        .ex_rd2         (ex_rd2),
        .ex_wd_sel      (ex_wd_sel),
        .ex_alu_op      (ex_alu_op),
        .ex_dram_we     (ex_dram_we),
        .ex_imm         (ex_imm),
        .ex_rf_we       (ex_rf_we),
        .inst_ex        (inst_ex)
    );
    
    // Controlģ�飬�������ɸ������ź�
    Control u_Control(
        .opcode     (inst_id[6:0]),
        .funct3     (inst_id[14:12]),
        .funct7     (inst_id[31:25]),
        .inst30     (inst_id[30]),   
        .npc_op     (id_npc_op),
        .alub_sel   (id_alub_sel),
        .alu_op     (id_alu_op),
        .wd_sel     (id_wd_sel),
        .dram_we    (id_dram_we),
        .rf_we      (id_rf_we),
        .is_load    (is_load_id)
    );
    
    //RFģ�飬ʵ�ּĴ����ѵĹ���
    RF u_RF (
        .clk        (clk),
        .rR1        (inst_id[19:15]),
        .rR2        (inst_id[24:20]),
        .WR         (wb_WR),
        .WD         (wb_data),
        .rf_we      (wb_rf_we),
        .RD1        (id_rD1),
        .RD2        (id_rD2)

    );

    
    // ALUģ�飬���ڸ�������
    ALU u_ALU (
        .RD1    (ex_A),
        .RD2    (ex_B),
        // .alub_sel   (alub_sel),
        .imm_ext    (ex_imm),
        .alu_op     (ex_alu_op),
        .alu_c      (ex_alu_c)
    );

    // NPCģ�飬����������һָ���ַ
    NPC u_NPC(
        .imm_ext     (ex_imm),
        .ALU_C      (ex_alu_c),
        .pc         (pc_ex),
        .npc_op     (ex_npc_op),
        .npc        (npc),
        // .pc4        (pc4),
        .auipc      (ex_auipc)
    );

    // EX_MEM
    EX_MEM u_EX_MEM(
        .clk            (clk),
        .rst_n          (rst_n),
        .inst_ex        (inst_ex),
        .is_load_ex     (is_load_ex),
        .ex_rd2         (ex_rd2),
        .ex_wd_sel      (ex_wd_sel),
        .ex_dram_we     (ex_dram_we),
        .ex_alu_c       (ex_alu_c),
        .ex_auipc       (ex_auipc),
        .pc_ex          (pc_ex),
        .ex_rf_we       (ex_rf_we),
        .mem_rd2        (mem_rd2),
        .mem_wd_sel     (mem_wd_sel),
        .mem_dram_we    (mem_dram_we),
        .mem_alu_c      (mem_alu_c),
        .mem_auipc      (mem_auipc),
        .pc_mem         (pc_mem),
        .mem_rf_we      (mem_rf_we),
        .inst_mem       (inst_mem),
        .is_load_mem    (is_load_mem)
    );

    // MEM_WB
    MEM_WB u_MEN_WB(
        .clk        (clk),
        .rst_n      (rst_n),
        .inst_mem     (inst_mem),
        .mem_wd_sel (mem_wd_sel),
        .mem_rf_we  (mem_rf_we),
        .mem_alu_c  (mem_alu_c),
        .pc_mem     (pc_mem),
        .mem_ram_wb (mem_ram_wb),
        .wb_rf_we   (wb_rf_we),
        .wb_data    (wb_data),
        .wb_WR      (wb_WR)
    );

    Flush_wait u_Flush_wait(
        .npc    (npc),
        .pc     (pc_ex),
        // .is_load(is_load_ex),
        .is_branch(is_branch)
        // .load_stop(load_stop)
    );

    wire [31:0]wdata_mem = is_load_mem ? mem_ram_wb : mem_alu_c;
    wire [31:0]wdata_ex = ex_wd_sel == 2'b11 ? ex_auipc : 
                           ex_wd_sel == 2'b10 ? (pc_ex+3'd4) : ex_alu_c;
    Forward u_Forward(
        .wdata_ex       (wdata_ex),
        .wdata_mem      (wdata_mem),
        .ex_rd          (inst_ex[11:7]),
        .mem_rd         (inst_mem[11:7]),
        .rs1            (inst_id[19:15]),
        .rs2            (inst_id[24:20]),
        .ex_rf_we       (ex_rf_we),
        .mem_rf_we      (mem_rf_we),
        .is_load_ex        (is_load_ex),
        .is_load_mem       (is_load_mem),
        .rdata1_f       (rdata1_f),
        .rdata2_f       (rdata2_f),
        .rd1_sel        (rd1_sel),
        .rd2_sel        (rd2_sel),
        .load_stop      (load_stop)
    );

    // LOADģ�飬����load��ָ���´�RAM��ȡ�����ݣ����Ҫд�ؼĴ����ѵ�����
    LOAD u_LOAD(
        .funct3     (inst_mem[14:12]),
        .RD         (RD),
        .ram_wb     (mem_ram_wb),
        .alu_c      (mem_alu_c)
    );
    
 
    

endmodule
