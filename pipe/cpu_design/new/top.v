`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/08 14:23:50
// Design Name: 
// Module Name: top
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


module top(
    input  wire clk,
    input  wire rst_i,
    input  wire[23:0] switch,
    output wire[7:0] led_en_o,
    output wire[7:0] led_c_o,
    output wire[23:0] led
    );
    
//    reg clk_g=0;                                          // �ı���ʱ���ź�
    wire clk_g;
    wire rst_n = !rst_i;
    wire [31:0]alu_c_from_cpu;                          // ����cpu�ķô��ַ
    wire [31:0]RD_to_cpu;                               // д��cpu������
    wire dram_we_from_cpu;                              // ����cpu��дʹ���ź�
    wire [31:0]rD2_from_cpu;                            // ����cpu��д����
    wire locked;
//     ʱ��ip25MHz
     cpuclk u_cpuclk (
         .clk_in1    (clk),
         .clk_out1    (clk_g),
         .locked     (locked)
     );
        
//    reg [3:0]cnt = 0;
//    always @(posedge clk) begin
//        if(cnt== 4'd1)begin
//            cnt = 0;
//            clk_g = ~clk_g;
//        end
//        else cnt = cnt+1;
//    end
//always @(*) clk_g = clk;

    // cpu
    cpu_top u_cpu_top(
        .clk        (clk_g),
        .rst_n      (rst_n),
        .RD_in      (RD_to_cpu),
        .alu_c_out  (alu_c_from_cpu),
        .dram_en_out(dram_we_from_cpu),
        .rD2_out    (rD2_from_cpu)
    );

    wire [31:0]addr_from_bus;               // �������ߵĵ�ַ
    wire [31:0]wdata_from_bus;              // �������ߵ�д����
    wire dram_en;                           // dramдʹ���ź�
    wire led_api_en;                        // ��дʹ���ź�
    wire led_digit_api_en;                  // �����дʹ���ź�
    wire switch_api_en;                     // ���뿪��дʹ���ź�
    wire [31:0] dram_rdata;                 // ��dram��������
    wire [31:0] led_rdata;                  // ��led��������
    wire [31:0] led_digit_rdata;            // ������ܶ�������
    wire [31:0] switch_rdata;               // �Ӳ��뿪�ض�������

    Bus u_Bus (
        .clk            (clk_g),                        // input wire clk_g
        .rst_n          (rst_n),
        .addr           (alu_c_from_cpu),               // input wire [13:0] addra
        .rdata          (RD_to_cpu),                  // output wire [31:0] douta
        .wen            (dram_we_from_cpu),            // input wire [0:0] wea
        .wdata          (rD2_from_cpu),              // input wire [31:0] dina
        .dram_rdata     (dram_rdata),
        .led_rdata      (led_digit_rdata),
        .led_digit_rdata(led_digit_rdata),
        .switch_rdata   (switch_rdata),
        .dram_en        (dram_en),
        .led_api_en     (led_api_en),
        .led_digit_api_en(led_digit_api_en),
        .switch_api_en  (switch_api_en),
        .wdata_out      (wdata_from_bus),
        .addr_out       (addr_from_bus)
    );


    // ���ݴ洢��
    DRAM u_DRAM(
        .clk    (clk_g),
        .a      (addr_from_bus),
        .spo    (dram_rdata),
        .we     (dram_en),
        .d      (wdata_from_bus)
    );

    // ���裬�����
    led_digit u_led_digit(
        .wen        (led_digit_api_en),
        .clk        (clk_g),
        .rst_n      (rst_n),
        .wdata      (wdata_from_bus),
        .led_en_o   (led_en_o),
        .led_c_o    (led_c_o)

    );

    // ���裬���뿪��
    Switch u_Switch(
        .clk    (clk_g),
        .switch (switch),
        .rdata  (switch_rdata)
    );

    // ���裬��
    Led u_Led(
        .wen        (led_api_en),
        .clk        (clk_g),
        .rst_n      (rst_n),
        .wdata      (wdata_from_bus),
        .led        (led)

    );
endmodule
