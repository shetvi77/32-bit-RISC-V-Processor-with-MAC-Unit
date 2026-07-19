`timescale 1ns / 1ps

module tb_control_unit;

    reg [6:0] opcode;

    wire RegWrite;
    wire [1:0] ImmSrc;
    wire ALUSrc;
    wire MemWrite;
    wire [1:0] ResultSrc;
    wire Branch;
    wire [1:0] ALUOp;

    control_unit uut (
        .opcode(opcode),
        .RegWrite(RegWrite),
        .ImmSrc(ImmSrc),
        .ALUSrc(ALUSrc),
        .MemWrite(MemWrite),
        .ResultSrc(ResultSrc),
        .Branch(Branch),
        .ALUOp(ALUOp)
    );

    initial begin

        // R-type
        opcode = 7'b0110011;
        #10;

        // addi
        opcode = 7'b0010011;
        #10;

        // lw
        opcode = 7'b0000011;
        #10;

        // sw
        opcode = 7'b0100011;
        #10;

        // beq
        opcode = 7'b1100011;
        #10;

        // lui
        opcode = 7'b0110111;
        #10;

        $stop;
    end

endmodule