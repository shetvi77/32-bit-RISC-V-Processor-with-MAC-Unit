`timescale 1ns / 1ps

module tb_alu_control;

    reg [1:0] ALUOp;
    reg [2:0] funct3;
    reg       funct7_5;

    wire [2:0] ALUControl;

    alu_control uut (
        .ALUOp(ALUOp),
        .funct3(funct3),
        .funct7_5(funct7_5),
        .ALUControl(ALUControl)
    );

    initial begin
        // lw, sw, addi: ADD
        ALUOp = 2'b00;
        funct3 = 3'b000;
        funct7_5 = 1'b0;
        #10;

        // beq: SUB
        ALUOp = 2'b01;
        funct3 = 3'b000;
        funct7_5 = 1'b0;
        #10;

        // R-type ADD
        ALUOp = 2'b10;
        funct3 = 3'b000;
        funct7_5 = 1'b0;
        #10;

        // R-type SUB
        ALUOp = 2'b10;
        funct3 = 3'b000;
        funct7_5 = 1'b1;
        #10;

        // R-type AND
        ALUOp = 2'b10;
        funct3 = 3'b111;
        funct7_5 = 1'b0;
        #10;

        // R-type OR
        ALUOp = 2'b10;
        funct3 = 3'b110;
        funct7_5 = 1'b0;
        #10;

        // R-type SLT
        ALUOp = 2'b10;
        funct3 = 3'b010;
        funct7_5 = 1'b0;
        #10;

        $stop;
    end

endmodule