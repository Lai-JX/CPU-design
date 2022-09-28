`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/06 09:42:50
// Design Name: 
// Module Name: Bus
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


module Bus(
    input clk,
    input rst_n,
    (*mark_debug = "true"*)input [31:0]addr,
    (*mark_debug = "true"*)input wen,
    (*mark_debug = "true"*)input [31:0]wdata,
    input [31:0] dram_rdata,
    input [31:0] led_rdata,
    input [31:0] led_digit_rdata,
    input [31:0] switch_rdata,
    (*mask_debug = "true"*)output [31:0]rdata,
    output reg dram_en,
    output reg led_api_en,
    output reg led_digit_api_en,
    output reg switch_api_en,
    output [31:0]wdata_out,
    output [31:0]addr_out
    );

    //  reg dram_en=0;
    //  reg led_api_en=0;
    //  reg led_digit_api_en=0;
    //  reg switch_api_en=0;
    //  reg button_api_en=0;

//     assign   ena = {dram_en,led_digit_api_en,led_api_en,switch_api_en,button_api_en};
//      assign ena = (addr < 32'hFFFFF000) ? 5'b10000 :
//                  (addr >= 32'hFFFFF000 && addr < 32'hFFFFF010) ? 5'b01000 :
//                  (addr >= 32'hFFFFF060 && addr < 32'hFFFFF070) ? 5'b00100 :
//                  (addr >= 32'hFFFFF070 && addr < 32'hFFFFF078) ? 5'b00010 :
//                  (addr == 32'hFFFFF078) ? 5'b00001 : 5'b00000;
    always @(*) begin
        dram_en=0;
        led_api_en=0;
        led_digit_api_en=0;
        switch_api_en=0;
//        button_api_en=0;
        if(addr < 32'hFFFFF000) begin
            dram_en = wen;
        end
        else if(addr >= 32'hFFFFF000 && addr < 32'hFFFFF010) begin
            led_digit_api_en = wen;
        end
        else if(addr >= 32'hFFFFF060 && addr < 32'hFFFFF070) begin
            led_api_en = wen;
        end
        else if(addr >= 32'hFFFFF070 && addr < 32'hFFFFF078) begin
            switch_api_en = wen;
        end
        // else if(addr == 32'hFFFFF078) begin
        //     button_api_en = 1;
        // end
    
    end

    

   
    assign rdata =  (addr < 32'hFFFFF000) ? dram_rdata :
                     (addr >= 32'hFFFFF000 && addr < 32'hFFFFF010) ? led_digit_rdata :
                     (addr >= 32'hFFFFF060 && addr < 32'hFFFFF070) ? led_rdata :
                     (addr >= 32'hFFFFF070 && addr < 32'hFFFFF078) ? switch_rdata :0;
//                     (addr == 32'hFFFFF078) ? button_rdata : 'b00000;

    assign wdata_out = wdata;
    assign addr_out = addr;
    








    // // ??????????бу?????????????????????????
    // Button u_Button(
    //     .clk    (clk),
    //     .button (button),
    //     .rdata  (button_rdata)
    // );


endmodule
