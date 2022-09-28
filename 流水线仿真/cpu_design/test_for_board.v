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

    

    
    wire [7:0]led_en;
//    assign led_en = {led0_en_o,led1_en_o,led2_en_o,led3_en_o,led4_en_o,led5_en_o,led6_en_o,led7_en_o};
    
    wire [7:0]led_c;
//    assign led_c = {led_ca,led_cb,led_cc,led_cd,led_ce,led_cf,led_cg,led_dp};
    
    wire [23:0]led;

    top U_top(
        .clk(clk),
        .rst_i(rst),
        .switch(device_sw),  
        .led_en_o(led_en),
        .led_c_o(led_c),
        .led    (led)
    );
endmodule
