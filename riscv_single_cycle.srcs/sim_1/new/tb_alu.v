`timescale 1ns / 1ps

module tb_alu;

    reg  [31:0] A;
    reg  [31:0] B;
    reg  [2:0]  ALUControl;
    wire [31:0] Result;
    wire Zero;

    alu uut (
        .A(A),
        .B(B),
        .ALUControl(ALUControl),
        .Result(Result),
        .Zero(Zero)
    );

    initial begin
        // ADD test: 5 + 7 = 12
        A = 32'd5;
        B = 32'd7;
        ALUControl = 3'b000;
        #10;

        // SUB test: 10 - 4 = 6
        A = 32'd10;
        B = 32'd4;
        ALUControl = 3'b001;
        #10;

        // AND test
        A = 32'h0000000F;
        B = 32'h00000003;
        ALUControl = 3'b010;
        #10;

        // OR test
        A = 32'h0000000C;
        B = 32'h00000003;
        ALUControl = 3'b011;
        #10;

        // SLT test: 3 < 9, result = 1
        A = 32'd3;
        B = 32'd9;
        ALUControl = 3'b101;
        #10;

        // Zero test: 5 - 5 = 0, Zero = 1
        A = 32'd5;
        B = 32'd5;
        ALUControl = 3'b001;
        #10;

        $stop;
    end

endmodule