module data_mem (
    input         clk,
    input         MemWrite,
    input  [31:0] A,
    input  [31:0] WD,
    output [31:0] RD
);

    reg [31:0] mem [0:255];
    integer i;

    initial begin
        for (i = 0; i < 256; i = i + 1) begin
            mem[i] = 32'b0;
        end
    end

    assign RD = mem[A[31:2]];

    always @(posedge clk) begin
        if (MemWrite) begin
            mem[A[31:2]] <= WD;
        end
    end

endmodule