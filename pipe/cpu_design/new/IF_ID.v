`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/12 10:13:26
// Design Name: 
// Module Name: IF_ID
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


module IF_ID(
    input clk,
    input rst_n,
    input load_stop,
    input is_branch,
    input [31:0]inst_if,
    input [31:0]pc_if,
    output reg[31:0]pc_id,
    output reg[31:0]inst_id
    );

    // load ÷∏¡Ó‘›Õ£
    always @(posedge clk or negedge rst_n) begin
        if(~rst_n)              inst_id <= 32'h0;
        else if(load_stop)      inst_id <= inst_id;
        else if(is_branch)      inst_id <= 32'h0;
        else                    inst_id <= inst_if;
    end
    always @(posedge clk or negedge rst_n) begin
        if(~rst_n)              pc_id <= 32'h0;
        else if(load_stop)      pc_id <= pc_id;
        else if(is_branch)      pc_id <= 32'h0;
        else                    pc_id <= pc_if;
    end


endmodule
