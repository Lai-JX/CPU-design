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
    wire[31:0] npc;                                     // 下一PC地址

    (*mark_debug = "true"*)wire[31:0] pc;               // 当前PC

    (*mark_debug = "true"*)wire[31:0] inst;             // 当前指令
    wire[31:0] immediate;                               // 扩展后的立即数
    wire[1:0] npc_op;                                   // 控制下一PC地址的操作信号
    wire alub_sel;                                      // 第二个操作数的选择信号
    wire[3:0] alu_op;                                   // ALU部件的控制信号
    wire[1:0] wd_sel;                                   // 写回寄存器的控制信号
    wire dram_we;                                       // 数据存储器的写使能信号
    wire rf_we;                                         // 寄存器堆的写使能信号
    (*mark_debug = "true"*)wire[31:0] alu_c;            // ALU的计算结果
    wire[31:0] pc4;                                     // pc+4
    wire[31:0] auipc;                                   // pc+imm_ext
    wire[31:0] RD;                                      // 从RAM读取的数据
    wire[31:0] rD1;                                     // 从寄存器堆读出的第一个操作数
    wire[31:0] rD2;                                     // 从寄存器堆读出的第二个操作数

    wire[31:0] ram_wb;                                  // Load型指令下，要写回寄存器堆的数据
    
    // 连线，获取数据存储器数据或外设数据RD
    assign RD = RD_in;
    // 连线，连接输出信号
    assign alu_c_out = alu_c;
    assign dram_en_out = dram_we;
    assign rD2_out = rD2;


    // LOAD模块，输入load型指令下从RAM读取的数据，输出要写回寄存器堆的数据
    LOAD u_LOAD(
        .funct3     (inst[14:12]),
        .RD         (RD),
        .ram_wb     (ram_wb),
        .alu_c      (alu_c)
    );
    // PC模块，控制PC的更新
    PC u_PC(
        .clk    (clk),
        .rst_n  (rst_n),
        .npc    (npc),
        .pc     (pc)
    );
    
    // SEXT模块，用于立即数扩展
    SEXT u_SEXT(
        .inst   (inst),
        .imm    (immediate)
    );
    
    // ALU模块，用于各种运算
    ALU u_ALU (
        .RD1    (rD1),
        .RD2    (rD2),
        .alub_sel   (alub_sel),
        .imm_ext    (immediate),
        .alu_op     (alu_op),
        .alu_c      (alu_c)
    );
    
    // Control模块，用于生成各控制信号
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
    
    // NPC模块，用于生成下一指令地址
    NPC u_NPC(
        .imm_ext     (immediate),
        .ALU_C      (alu_c),
        .pc         (pc),
        .npc_op     (npc_op),
        .npc        (npc),
        .pc4        (pc4),
        .auipc      (auipc)
    );
    
    //RF模块，实现寄存器堆的功能
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

    // 获取指令
    prgrom U0_irom (
        .a      (pc >> 2),   // input wire [13:0] a
        .spo    (inst)   // output wire [31:0] spo
    );

    

endmodule
