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

        // I-type: addi x1, x0, 5
        // Expected ImmExt = 00000005
        Instr  = 32'h00500093;
        ImmSrc = 2'b00;
        #10;

        // I-type: addi x1, x0, -4
        // Expected ImmExt = FFFFFFFC
        Instr  = 32'hFFC00093;
        ImmSrc = 2'b00;
        #10;

        // S-type: sw x3, 8(x0)
        // Expected ImmExt = 00000008
        Instr  = 32'h00302423;
        ImmSrc = 2'b01;
        #10;

        // B-type: beq x3, x4, +8
        // Expected ImmExt = 00000008
        Instr  = 32'h00418463;
        ImmSrc = 2'b10;
        #10;

        // U-type: lui x5, 0x12345
        // Expected ImmExt = 12345000
        Instr  = 32'h123452B7;
        ImmSrc = 2'b11;
        #10;

        $stop;
    end

endmodule