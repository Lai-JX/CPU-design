`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/30 11:42:16
// Design Name: 
// Module Name: LOAD
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


module LOAD(
    input [31:0] RD,
    input [2:0] funct3,
    input [31:0] alu_c,
    output reg[31:0] ram_wb

    );
    always @(*)begin
        if(alu_c % 3'd4 == 2'd2)begin
            case(funct3)
                3'b000: ram_wb = {{24{RD[23]}},RD[23:16]};     // lb
                3'b100: ram_wb = RD[23:16];                   // lbu
                3'b001: ram_wb = {{16{RD[31]}},RD[31:16]};     // lh
                3'b101: ram_wb = RD[31:16];                   // lhu
            endcase
        end
        else if(alu_c % 3'd4 == 2'd1)begin
            case(funct3)
                3'b000: ram_wb = {{24{RD[15]}},RD[15:8]};     // lb
                3'b100: ram_wb = RD[15:8];                   // lbu
                3'b001: ram_wb = {{16{RD[15]}},RD[23:8]};     // lh
                3'b101: ram_wb = RD[23:8];                   // lhu
            endcase
        end
        else if(alu_c % 3'd4 == 2'd3)begin
            case(funct3)
                3'b000: ram_wb = {{24{RD[31]}},RD[31:24]};     // lbu
                3'b100: ram_wb = RD[31:24];                   // lb
            endcase
        end
        else if(alu_c % 3'd4 == 2'd0)begin
            case(funct3)
                3'b000: ram_wb = {{24{RD[7]}},RD[7:0]};     // lb
                3'b100: ram_wb = RD[7:0];                   // lbu
                3'b001: ram_wb = {{16{RD[15]}},RD[15:0]};     // lh
                3'b101: ram_wb = RD[15:0];                   // lhu
                3'b010: ram_wb = RD;
            endcase
        end
    end
endmodule
