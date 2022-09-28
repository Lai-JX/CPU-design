`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/06 11:17:32
// Design Name: 
// Module Name: led_digit
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


module led_digit(
    input clk,
    input rst_n,
    input wen,
    input [31:0] wdata,
    output reg[7:0] led_en_o,
    output reg[7:0] led_c_o 
);
    reg [2:0] led_cnt;
    reg[17:0]cnt;
    (*mark_debug = "true"*) reg [31:0] wdata_reg;
    // assign wdata = wdata_reg;

    // wire show_ena = (addr == 32'hFFFFF000);
    always @(posedge clk)begin
        if(wen == 1'b1)wdata_reg = wdata;
    end

    always @(posedge clk or negedge rst_n)begin
        if (~rst_n)    cnt <= 3'h0;
        // else if (busy) led_cnt <= 3'h0;
        else begin
            if(cnt == 'd9999) cnt <= 'b0;
            else cnt <= cnt + 3'h1;
        end
    end

    always @ (posedge clk or negedge rst_n) begin
        if (~rst_n)    led_cnt <= 3'h0;
        // else if (busy) led_cnt <= 3'h0;
        else if(cnt == 'd9999)           led_cnt <= led_cnt + 3'h1;
    end

    wire led0_en_d = ~(led_cnt == 3'h0);
    wire led1_en_d = ~(led_cnt == 3'h1);
    wire led2_en_d = ~(led_cnt == 3'h2);
    wire led3_en_d = ~(led_cnt == 3'h3);
    wire led4_en_d = ~(led_cnt == 3'h4);
    wire led5_en_d = ~(led_cnt == 3'h5);
    wire led6_en_d = ~(led_cnt == 3'h6);
    wire led7_en_d = ~(led_cnt == 3'h7);

    always @ (posedge clk or negedge rst_n) begin
        if (~rst_n) led_en_o <= 8'b11111111;
        else        led_en_o <= {led0_en_d,led1_en_d,led2_en_d,led3_en_d,led4_en_d,led5_en_d,led6_en_d,led7_en_d};
    end

    

    reg [3:0] led_display;

    always @ (*) begin
        case (led_cnt)
            3'h7 : led_display = wdata_reg[31:28];
            3'h6 : led_display = wdata_reg[27:24];
            3'h5 : led_display = wdata_reg[23:20];
            3'h4 : led_display = wdata_reg[19:16]; 
            3'h3 : led_display = wdata_reg[15:12];
            3'h2 : led_display = wdata_reg[11:8];
            3'h1 : led_display = wdata_reg[7:4];
            3'h0 : led_display = wdata_reg[3:0];
            default : led_display <= 4'h0;
        endcase
    end
    wire eq0 = (led_display == 4'h0);
    wire eq1 = (led_display == 4'h1);
    wire eq2 = (led_display == 4'h2);
    wire eq3 = (led_display == 4'h3);
    wire eq4 = (led_display == 4'h4);
    wire eq5 = (led_display == 4'h5);
    wire eq6 = (led_display == 4'h6);
    wire eq7 = (led_display == 4'h7);
    wire eq8 = (led_display == 4'h8);
    wire eq9 = (led_display == 4'h9);
    wire eqa = (led_display == 4'ha);
    wire eqb = (led_display == 4'hb);
    wire eqc = (led_display == 4'hc);
    wire eqd = (led_display == 4'hd);
    wire eqe = (led_display == 4'he);
    wire eqf = (led_display == 4'hf);

    wire led_ca_d = ~(eq0 | eq2 | eq3 | eq5 | eq6 | eq7 | eq8 | eq9 | eqa | eqc | eqe | eqf);
    wire led_cb_d = ~(eq0 | eq1 | eq2 | eq3 | eq4 | eq7 | eq8 | eq9 | eqa | eqd);
    wire led_cc_d = ~(eq0 | eq1 | eq3 | eq4 | eq5 | eq6 | eq7 | eq8 | eq9 | eqa | eqb | eqd);
    wire led_cd_d = ~(eq0 | eq2 | eq3 | eq5 | eq6 | eq8 | eq9 | eqb | eqc | eqd | eqe);
    wire led_ce_d = ~(eq0 | eq2 | eq6 | eq8 | eqa | eqb | eqc | eqd | eqe | eqf);
    wire led_cf_d = ~(eq0 | eq4 | eq5 | eq6 | eq8 | eq9 | eqa | eqb | eqc | eqe | eqf);
    wire led_cg_d = ~(eq2 | eq3 | eq4 | eq5 | eq6 | eq8 | eq9 | eqa | eqb | eqd | eqe | eqf);
    wire led_dp_d = 1; 

    always @ (posedge clk or negedge rst_n) begin
        if (~rst_n) led_c_o <= 8'b00000000;
        else        led_c_o <= {led_ca_d,led_cb_d,led_cc_d,led_cd_d,led_ce_d,led_cf_d,led_cg_d,led_dp_d};
    end
    
endmodule
