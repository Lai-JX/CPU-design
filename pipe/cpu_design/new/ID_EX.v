`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/12 10:13:43
// Design Name: 
// Module Name: ID_EX
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


module ID_EX(
        input clk,
        input rst_n,
        input [31:0]inst_id,
        input load_stop,
        input is_branch,
        input [31:0]pc_id,
        input [1:0]id_npc_op,
        input [0:0]is_load_id,
        input [31:0]id_rD1,
        input [31:0]id_rD2,
        input [1:0]id_wd_sel,
        input [3:0]id_alu_op,
        input [0:0]id_dram_we,
        input [0:0]id_rf_we,
        input [0:0]alub_sel,
        input [31:0]id_imm,
        input [31:0]rdata1_f,
        input [31:0]rdata2_f,
        input [0:0]rd1_sel,
        input [0:0]rd2_sel,
        output reg[31:0]pc_ex,
        output reg[1:0]ex_npc_op,
        output reg[0:0]is_load_ex,
        output reg[31:0]ex_A,
        output reg[31:0]ex_B,
        output reg[4:0]ex_WR,
        output reg[31:0]ex_rd2,
        output reg[1:0]ex_wd_sel,
        output reg[3:0]ex_alu_op,
        output reg[0:0]ex_dram_we,
        output reg[31:0]ex_imm,
        output reg[0:0]ex_rf_we,
        output reg[31:0]inst_ex
    );


    // pc_ex
    always @(posedge clk or negedge rst_n) begin
        if(~rst_n)              pc_ex <= 'h0;
        else if(load_stop)      pc_ex <= pc_ex;
        else if(is_branch)      pc_ex <= 'h0;
        else                    pc_ex <= pc_id;
    end

    // ex_npc_op
    always @(posedge clk or negedge rst_n) begin
        if(~rst_n)              ex_npc_op <= 'h0;
        else if(load_stop)      ex_npc_op <= ex_alu_op;
        else if(is_branch)      ex_npc_op <= 'h0;
        else                    ex_npc_op <= id_npc_op;
    end

    // is_load_ex
    always @(posedge clk or negedge rst_n) begin
        if(~rst_n)              is_load_ex <= 'h0;
        else if(load_stop)      is_load_ex <= 'h0;              // 上一次暂停，这次就不需要暂停了
        else if(is_branch)      is_load_ex <= 'h0;              // 如果分支预测失败，则清零
        else                    is_load_ex <= is_load_id;
    end 

    // ex_A
    always @(posedge clk or negedge rst_n)begin
        if(~rst_n)              ex_A <= 'h0;
        else if(load_stop)      ex_A <= ex_A;
        else if(is_branch)      ex_A <= 'h0;
        else                    ex_A <= rd1_sel ? rdata1_f : id_rD1;
    end

    // ex_B
    always @(posedge clk or negedge rst_n)begin
        if(~rst_n)              ex_B <= 'h0;
        else if(load_stop)      ex_B <= ex_B;
        else if(is_branch)      ex_B <= 'h0;
        else                    ex_B <= alub_sel ? id_imm : 
                                         rd2_sel ? rdata2_f : id_rD2;
//        else                    ex_B <= rd2_sel ? rdata2_f : 
//                                        alub_sel ? id_imm : id_rD2;
    end

    // ex_WR
    // always @(posedge clk or negedge rst_n)begin
    //     if(~rst_n)              ex_WR <= 'h0;
    //     else if(load_stop)      ex_WR <= ex_WR;
    //     else if(is_branch)      ex_WR <= 'h0;
    //     else                    ex_WR <= id_WR;
    // end

    // ex_rd2
    always @(posedge clk or negedge rst_n)begin
        if(~rst_n)              ex_rd2 <= 'h0;
        else if(load_stop)      ex_rd2 <= ex_rd2;
        else if(is_branch)      ex_rd2 <= 'h0;
        else                    ex_rd2 <= rd2_sel ? rdata2_f : id_rD2;
    end

    // ex_wd_sel
    always @(posedge clk or negedge rst_n)begin
        if(~rst_n)              ex_wd_sel <= 'h0;
        else if(load_stop)      ex_wd_sel <= ex_wd_sel;
        else if(is_branch)      ex_wd_sel <= 'h0;
        else                    ex_wd_sel <= id_wd_sel;
    end

    // ex_alu_op
    always @(posedge clk or negedge rst_n)begin
        if(~rst_n)              ex_alu_op <= 'h0;
        else if(load_stop)      ex_alu_op <= ex_alu_op;
        else if(is_branch)      ex_alu_op <= 'h0;
        else                    ex_alu_op <= id_alu_op;
    end

    // ex_dram_we
    always @(posedge clk or negedge rst_n)begin
        if(~rst_n)              ex_dram_we <= 'h0;
        else if(load_stop)      ex_dram_we <= ex_dram_we;
        else if(is_branch)      ex_dram_we <= 'h0;
        else                    ex_dram_we <= id_dram_we;
    end

    // ex_imm
    always @(posedge clk or negedge rst_n)begin
        if(~rst_n)              ex_imm <= 'h0;
        else if(load_stop)      ex_imm <= ex_imm;
        else if(is_branch)      ex_imm <= 'h0;
        else                    ex_imm <= id_imm;
    end

    // ex_rf_we
    always @(posedge clk or negedge rst_n)begin
        if(~rst_n)              ex_rf_we <= 'h0;
        else if(load_stop)      ex_rf_we <= ex_rf_we;
        else if(is_branch)      ex_rf_we <= 'h0;
        else                    ex_rf_we <= id_rf_we;
    end

    // inst_ex
    always @(posedge clk or negedge rst_n)begin
        if(~rst_n)              inst_ex <= 'h0;
        else if(load_stop)      inst_ex <= inst_ex;
        else if(is_branch)      inst_ex <= 'h0;
        else                    inst_ex <= inst_id;
    end
endmodule
