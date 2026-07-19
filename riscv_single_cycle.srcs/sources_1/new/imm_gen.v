module imm_gen (
    input  [31:0] Instr,
    input  [1:0]  ImmSrc,
    output reg [31:0] ImmExt
);

    always @(*) begin
        case (ImmSrc)

            // I-type immediate: addi, lw
            // imm[11:0] = Instr[31:20]
            2'b00: begin
                ImmExt = {{20{Instr[31]}}, Instr[31:20]};
            end

            // S-type immediate: sw
            // imm[11:5] = Instr[31:25]
            // imm[4:0]  = Instr[11:7]
            2'b01: begin
                ImmExt = {{20{Instr[31]}}, Instr[31:25], Instr[11:7]};
            end

            // B-type immediate: beq
            // imm[12]   = Instr[31]
            // imm[11]   = Instr[7]
            // imm[10:5] = Instr[30:25]
            // imm[4:1]  = Instr[11:8]
            // imm[0]    = 0
            2'b10: begin
                ImmExt = {{19{Instr[31]}}, Instr[31], Instr[7],
                          Instr[30:25], Instr[11:8], 1'b0};
            end

            // U-type immediate: lui
            // imm[31:12] = Instr[31:12]
            // imm[11:0]  = 0
            2'b11: begin
                ImmExt = {Instr[31:12], 12'b0};
            end

            default: begin
                ImmExt = 32'b0;
            end

        endcase
    end

endmodule