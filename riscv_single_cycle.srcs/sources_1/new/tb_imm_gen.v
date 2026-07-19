`timescale 1ns / 1ps

module tb_imm_gen;

    reg  [31:0] Instr;
    reg  [1:0]  ImmSrc;
    wire [31:0] ImmExt;

    imm_gen uut (
        .Instr(Instr),
        .ImmSrc(ImmSrc),
        .ImmExt(ImmExt)
    );

    initial begin

        // --------------------------------------------------
        // I-type test: addi x1, x0, 5
        // Instruction = 0x00500093
        // Immediate should be 5
        // --------------------------------------------------
        Instr  = 32'h00500093;
        ImmSrc = 2'b00;
        #10;

        // --------------------------------------------------
        // I-type negative immediate test
        // addi x1, x0, -4
        // Immediate should be FFFFFFFC
        // --------------------------------------------------
        Instr  = 32'hFFC00093;
        ImmSrc = 2'b00;
        #10;

        // --------------------------------------------------
        // S-type test: sw x3, 8(x0)
        // Immediate should be 8
        // --------------------------------------------------
        Instr  = 32'h00302423;
        ImmSrc = 2'b01;
        #10;

        // --------------------------------------------------
        // S-type test: sw x6, -4(x9)
        // Immediate should be FFFFFFFC
        // --------------------------------------------------
        Instr  = 32'hFE64AE23;
        ImmSrc = 2'b01;
        #10;

        // --------------------------------------------------
        // B-type test: beq x3, x4, +8
        // Immediate should be 8
        // --------------------------------------------------
        Instr  = 32'h00418463;
        ImmSrc = 2'b10;
        #10;

        // --------------------------------------------------
        // U-type test: lui x5, 0x12345
        // Immediate should be 12345000
        // --------------------------------------------------
        Instr  = 32'h123452B7;
        ImmSrc = 2'b11;
        #10;

        $stop;
    end

endmodule