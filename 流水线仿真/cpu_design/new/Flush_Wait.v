`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/12 10:29:00
// Design Name: 
// Module Name: Flush_wait
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


module Flush_wait(
    input wire[31:0] npc,                   // 下一地址
    input wire[31:0] pc,                    // 当前地址
    // input wire is_load,                     // 是否为load指令
    // input wire is_load_stop,                // load型指令是否暂停次数是否完毕 
    output wire is_branch                  // 是分支
    // output wire load_stop                   // 是load型指令
    );

    assign is_branch = (npc != pc+3'd4) ? 1'b1 : 1'b0;
    // assign load_stop = (is_load) ? 1'b1 : 1'b0;
    
endmodule
