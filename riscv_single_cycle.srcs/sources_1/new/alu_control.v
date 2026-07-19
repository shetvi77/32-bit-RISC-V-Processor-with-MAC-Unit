module alu_control (
    input  [1:0] ALUOp,
    input  [2:0] funct3,
    input        funct7_5,
    output reg [2:0] ALUControl
);

    always @(*) begin
        case (ALUOp)

            2'b00: begin
                // lw, sw, addi
                ALUControl = 3'b000; // ADD
            end

            2'b01: begin
                // beq
                ALUControl = 3'b001; // SUB
            end

            2'b10: begin
                // R-type instructions
                case (funct3)

                    3'b000: begin
                        if (funct7_5)
                            ALUControl = 3'b001; // SUB
                        else
                            ALUControl = 3'b000; // ADD
                    end

                    3'b111: begin
                        ALUControl = 3'b010; // AND
                    end

                    3'b110: begin
                        ALUControl = 3'b011; // OR
                    end

                    3'b010: begin
                        ALUControl = 3'b101; // SLT
                    end

                    default: begin
                        ALUControl = 3'b000;
                    end

                endcase
            end

            default: begin
                ALUControl = 3'b000;
            end

        endcase
    end

endmodule