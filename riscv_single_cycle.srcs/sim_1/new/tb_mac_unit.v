`timescale 1ns / 1ps

module tb_mac_unit;

    reg clk;
    reg reset;
    reg start;
    reg clear;

    reg signed [31:0] input_data;
    reg signed [31:0] weight;

    wire signed [63:0] acc_out;
    wire done;

    mac_unit uut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .clear(clear),
        .input_data(input_data),
        .weight(weight),
        .acc_out(acc_out),
        .done(done)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        start = 0;
        clear = 0;
        input_data = 32'sd0;
        weight = 32'sd0;

        #12;
        reset = 0;

        clear = 1;
        #10;
        clear = 0;

        input_data = 32'sd2;
        weight     = 32'sd3;
        start      = 1;
        #10;
        start      = 0;
        #10;

        input_data = 32'sd4;
        weight     = 32'sd5;
        start      = 1;
        #10;
        start      = 0;
        #10;

        input_data = -32'sd1;
        weight     = 32'sd10;
        start      = 1;
        #10;
        start      = 0;
        #10;

        clear = 1;
        #10;
        clear = 0;
        #10;

        input_data = 32'sd7;
        weight     = 32'sd8;
        start      = 1;
        #10;
        start      = 0;
        #10;

        $display("Final accumulator value = %d", acc_out);

        $stop;
    end

endmodule