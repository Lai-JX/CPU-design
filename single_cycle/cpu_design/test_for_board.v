`timescale 1ns / 1ps

module test_for_board(
    );

    reg clk;
    reg rst;
    reg [23:0] device_sw;
 
    initial begin
        clk   = 0;
        rst   = 1;
        device_sw = 24'b101_00000_00001000_11111110;
        #115;
        rst   = 0;
        #10000
        device_sw = 24'b111_00000_00001000_11111110;
        #10000
        device_sw = 24'b001_00000_00001000_11111110;
        // #20000;
        // $finish;
    end

    always #5 clk = ~clk;

    

    wire led0_en_o;
    wire led1_en_o;
    wire led2_en_o;
    wire led3_en_o;
    wire led4_en_o;
    wire led5_en_o;
    wire led6_en_o;
    wire led7_en_o;
    wire       led_ca;
    wire       led_cb;
    wire       led_cc;
    wire       led_cd;
    wire       led_ce;
    wire       led_cf;
    wire       led_cg;
    wire       led_dp;
    
    wire [7:0]led_en;
//    assign led_en = {led0_en_o,led1_en_o,led2_en_o,led3_en_o,led4_en_o,led5_en_o,led6_en_o,led7_en_o};
    
    wire [7:0]led_c;
//    assign led_c = {led_ca,led_cb,led_cc,led_cd,led_ce,led_cf,led_cg,led_dp};
    
    wire [23:0]led;
    wire [31:0]pc;
    wire [31:0]inst;
    wire [31:0]npc;
    cpu_top U_cpu_top(
        .clk(clk),
        .rst_i(rst),
        .switch(device_sw),  
        .led_en_o(led_en),
        .led_c_o(led_c),
        .led    (led)
    );
endmodule
