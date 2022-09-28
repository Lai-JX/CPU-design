`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/12 10:13:00
// Design Name: 
// Module Name: Forward
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


module Forward(
    input [31:0]wdata_ex,
    input [31:0]wdata_mem,
    input [4:0]ex_rd,
    input [4:0]mem_rd,
    // input [4:0]wb_rd,
    input [4:0]rs1,
    input [4:0]rs2,
    input ex_rf_we,
    input mem_rf_we,
    input is_load_ex,
    input is_load_mem,
    output [31:0]rdata1_f,
    output [31:0]rdata2_f,
    output [0:0]rd1_sel,
    output [0:0]rd2_sel,
    output load_stop
    );

    // ex数据冒险
    wire rs1_id_wb_ex_con = (ex_rd == rs1) && ex_rf_we && ex_rd!=0;
    wire rs2_id_wb_ex_con = (ex_rd == rs2) && ex_rf_we && ex_rd!=0;
    // assign rdata1_f = wdata_ex;
    // assign rdata2_f = wdata_ex;
    // assign rd1_sel = rs1_id_wb_ex_con;
    // assign rd2_sel = rs2_id_wb_ex_con; 

    
    // mem数据冒险
    wire rs1_id_wb_mem_con =(~rs1_id_wb_ex_con || is_load_mem) && (mem_rd == rs1) && mem_rf_we && mem_rd!=0;
    wire rs2_id_wb_mem_con =(~rs2_id_wb_ex_con || is_load_mem) && (mem_rd == rs2) && mem_rf_we && mem_rd!=0;

    assign rdata1_f = (rs1_id_wb_mem_con ) ? wdata_mem : wdata_ex;
    assign rdata2_f = (rs2_id_wb_mem_con ) ? wdata_mem : wdata_ex;

//    assign rdata1_f = (rs1_id_wb_ex_con ) ? ((is_load_mem) ? wdata_mem : wdata_ex) : wdata_mem;
//    assign rdata2_f = (rs2_id_wb_ex_con ) ? ((is_load_mem) ? wdata_mem : wdata_ex) : wdata_mem;
    
    assign rd1_sel = rs1_id_wb_mem_con ? rs1_id_wb_mem_con : rs1_id_wb_ex_con ? rs1_id_wb_ex_con : 1'b0;
    assign rd2_sel = rs2_id_wb_mem_con ? rs2_id_wb_mem_con : rs2_id_wb_ex_con ? rs2_id_wb_ex_con : 1'b0;
    
    // load数据冒险
    // 若为load指令在ex发生数据冒险则需停顿1次
    assign load_stop = (is_load_ex && (rs1_id_wb_ex_con || rs2_id_wb_ex_con  || rs2_id_wb_mem_con || rs2_id_wb_mem_con));

endmodule
