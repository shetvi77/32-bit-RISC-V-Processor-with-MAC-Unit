module alu (
    input  [31:0] A,
    input  [31:0] B,
    input  [2:0]  ALUControl,
    output reg [31:0] Result,
    output Zero
);

    always @(*) begin
        case (ALUControl)
            3'b000: Result = A + B;                         // ADD
            3'b001: Result = A - B;                         // SUB
            3'b010: Result = A & B;                         // AND
            3'b011: Result = A | B;                         // OR
            3'b101: Result = ($signed(A) < $signed(B)) ? 32'b1 : 32'b0; // SLT
            default: Result = 32'b0;
        endcase
    end

    assign Zero = (Result == 32'b0);

endmodule