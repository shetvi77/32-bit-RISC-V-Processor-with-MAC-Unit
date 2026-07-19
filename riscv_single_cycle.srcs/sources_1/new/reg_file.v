module reg_file (
    input         clk,
    input         RegWrite,
    input  [4:0]  rs1,
    input  [4:0]  rs2,
    input  [4:0]  rd,
    input  [31:0] WriteData,
    output [31:0] RD1,
    output [31:0] RD2
);

    reg [31:0] registers [0:31];

    integer i;

    initial begin
        for (i = 0; i < 32; i = i + 1)
            registers[i] = 32'b0;
    end

    assign RD1 = (rs1 == 5'b00000) ? 32'b0 : registers[rs1];
    assign RD2 = (rs2 == 5'b00000) ? 32'b0 : registers[rs2];

    always @(posedge clk) begin
        if (RegWrite && rd != 5'b00000) begin
            registers[rd] <= WriteData;
        end
    end

endmodule