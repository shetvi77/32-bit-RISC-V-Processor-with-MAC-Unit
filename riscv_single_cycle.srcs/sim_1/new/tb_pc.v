`timescale 1ns / 1ps

module tb_pc;

    reg clk;
    reg reset;
    reg [31:0] PCNext;
    wire [31:0] PC;

    pc uut (
        .clk(clk),
        .reset(reset),
        .PCNext(PCNext),
        .PC(PC)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        PCNext = 32'd0;

        // Reset test
        #10;
        reset = 0;

        // PC should update to 4
        PCNext = 32'd4;
        #10;

        // PC should update to 8
        PCNext = 32'd8;
        #10;

        // PC should update to 12
        PCNext = 32'd12;
        #10;

        // Branch-like test: PC jumps to 40
        PCNext = 32'd40;
        #10;

        // Reset again, PC should become 0
        reset = 1;
        #10;

        reset = 0;
        PCNext = 32'd44;
        #10;

        $stop;
    end

endmodule