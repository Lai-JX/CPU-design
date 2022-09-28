`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/24 10:59:37
// Design Name: 
// Module Name: PC
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


module PC(
    input wire clk,
    input wire rst_n,
    input wire[31:0] npc,
    output reg[31:0] pc         
    );
    reg flag = 1'b0;
    reg rst_n_bf;

    always @(posedge clk or posedge rst_n)begin
        rst_n_bf <= rst_n;

        if(rst_n != rst_n_bf)begin
            pc <= 1'b0;
            flag <= 1'b0;
        end
        else begin
            if(flag && rst_n) begin
                pc <= npc;
            end
            else if(!flag)begin
                pc <= 1'b0;
                flag <= 1'b1;
            end
        end

        

        
    end
    
endmodule
