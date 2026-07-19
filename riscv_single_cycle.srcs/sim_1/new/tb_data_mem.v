`timescale 1ns / 1ps

module tb_data_mem;

    reg clk;
    reg MemWrite;
    reg [31:0] A;
    reg [31:0] WD;
    wire [31:0] RD;

    data_mem uut (
        .clk(clk),
        .MemWrite(MemWrite),
        .A(A),
        .WD(WD),
        .RD(RD)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        MemWrite = 0;
        A = 32'd0;
        WD = 32'd0;

        // Initially memory[0] should be 0
        #10;

        // Write 12 to address 0
        A = 32'd0;
        WD = 32'd12;
        MemWrite = 1;
        #10;

        // Stop writing and read address 0
        MemWrite = 0;
        A = 32'd0;
        #10;

        // Write 25 to address 4, which maps to mem[1]
        A = 32'd4;
        WD = 32'd25;
        MemWrite = 1;
        #10;

        // Read address 4
        MemWrite = 0;
        A = 32'd4;
        #10;

        // Read address 0 again
        A = 32'd0;
        #10;

        $stop;
    end

endmodule