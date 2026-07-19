`timescale 1ns / 1ps

// =====================================================
// MAC UNIT MODULE
// =====================================================
module mac_unit (
    input clk,
    input reset,
    input start,
    input clear,

    input signed [31:0] input_data,
    input signed [31:0] weight,

    output reg signed [63:0] acc_out,
    output reg done
);

    wire signed [63:0] product;

    assign product = $signed(input_data) * $signed(weight);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            acc_out <= 64'sd0;
            done    <= 1'b0;
        end
        else begin
            done <= 1'b0;

            if (clear) begin
                acc_out <= 64'sd0;
                done    <= 1'b0;
            end
            else if (start) begin
                acc_out <= acc_out + product;
                done    <= 1'b1;
            end
        end
    end

endmodule


// =====================================================
// TESTBENCH
// =====================================================
module tb_mac_unit_selfcontained;

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

        // Clear accumulator
        clear = 1;
        #10;
        clear = 0;

        // acc = 0 + 2*3 = 6
        input_data = 32'sd2;
        weight     = 32'sd3;
        start      = 1;
        #10;
        start      = 0;
        #10;

        // acc = 6 + 4*5 = 26
        input_data = 32'sd4;
        weight     = 32'sd5;
        start      = 1;
        #10;
        start      = 0;
        #10;

        // acc = 26 + (-1)*10 = 16
        input_data = -32'sd1;
        weight     = 32'sd10;
        start      = 1;
        #10;
        start      = 0;
        #10;

        // Clear accumulator
        clear = 1;
        #10;
        clear = 0;
        #10;

        // acc = 0 + 7*8 = 56
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