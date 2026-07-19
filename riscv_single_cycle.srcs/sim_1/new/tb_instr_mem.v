`timescale 1ns / 1ps

module tb_instr_mem;

    reg  [31:0] A;
    wire [31:0] RD;

    instr_mem uut (
        .A(A),
        .RD(RD)
    );

    initial begin
        // PC = 0, should read mem[0]
        A = 32'd0;
        #10;

        // PC = 4, should read mem[1]
        A = 32'd4;
        #10;

        // PC = 8, should read mem[2]
        A = 32'd8;
        #10;

        // PC = 12, should read mem[3]
        A = 32'd12;
        #10;

        // PC = 16, should read mem[4]
        A = 32'd16;
        #10;

        // PC = 20, should read mem[5]
        A = 32'd20;
        #10;

        // PC = 24, should read mem[6]
        A = 32'd24;
        #10;

        // PC = 28, should read mem[7]
        A = 32'd28;
        #10;

        $stop;
    end

endmodule