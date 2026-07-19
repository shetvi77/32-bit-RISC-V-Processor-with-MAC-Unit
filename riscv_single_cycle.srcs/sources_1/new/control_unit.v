module control_unit (
    input  [6:0] opcode,
    output reg       RegWrite,
    output reg [1:0] ImmSrc,
    output reg       ALUSrc,
    output reg       MemWrite,
    output reg [1:0] ResultSrc,
    output reg       Branch,
    output reg [1:0] ALUOp
);

    always @(*) begin
        // Default values
        RegWrite  = 1'b0;
        ImmSrc    = 2'b00;
        ALUSrc    = 1'b0;
        MemWrite  = 1'b0;
        ResultSrc = 2'b00;
        Branch    = 1'b0;
        ALUOp     = 2'b00;

        case (opcode)

            7'b0110011: begin
                // R-type: add, sub, and, or, slt
                RegWrite  = 1'b1;
                ImmSrc    = 2'b00;
                ALUSrc    = 1'b0;
                MemWrite  = 1'b0;
                ResultSrc = 2'b00;
                Branch    = 1'b0;
                ALUOp     = 2'b10;
            end

            7'b0010011: begin
                // addi
                RegWrite  = 1'b1;
                ImmSrc    = 2'b00;
                ALUSrc    = 1'b1;
                MemWrite  = 1'b0;
                ResultSrc = 2'b00;
                Branch    = 1'b0;
                ALUOp     = 2'b00;
            end

            7'b0000011: begin
                // lw
                RegWrite  = 1'b1;
                ImmSrc    = 2'b00;
                ALUSrc    = 1'b1;
                MemWrite  = 1'b0;
                ResultSrc = 2'b01;
                Branch    = 1'b0;
                ALUOp     = 2'b00;
            end

            7'b0100011: begin
                // sw
                RegWrite  = 1'b0;
                ImmSrc    = 2'b01;
                ALUSrc    = 1'b1;
                MemWrite  = 1'b1;
                ResultSrc = 2'b00;
                Branch    = 1'b0;
                ALUOp     = 2'b00;
            end

            7'b1100011: begin
                // beq
                RegWrite  = 1'b0;
                ImmSrc    = 2'b10;
                ALUSrc    = 1'b0;
                MemWrite  = 1'b0;
                ResultSrc = 2'b00;
                Branch    = 1'b1;
                ALUOp     = 2'b01;
            end

            7'b0110111: begin
                // lui
                RegWrite  = 1'b1;
                ImmSrc    = 2'b11;
                ALUSrc    = 1'b1;
                MemWrite  = 1'b0;
                ResultSrc = 2'b10;
                Branch    = 1'b0;
                ALUOp     = 2'b00;
            end

        endcase
    end

endmodule