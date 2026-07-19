`timescale 1ns / 1ps

module tb_reg_file;

    reg clk;
    reg RegWrite;
    reg [4:0] rs1, rs2, rd;
    reg [31:0] WriteData;
    wire [31:0] RD1, RD2;

    reg_file uut (
        .clk(clk),
        .RegWrite(RegWrite),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .WriteData(WriteData),
        .RD1(RD1),
        .RD2(RD2)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;

        // Initial values
        RegWrite = 0;
        rs1 = 5'd0;
        rs2 = 5'd0;
        rd = 5'd0;
        WriteData = 32'd0;
        #10;

        // Write 25 into x1
        RegWrite = 1;
        rd = 5'd1;
        WriteData = 32'd25;
        #10;

        // Write 40 into x2
        rd = 5'd2;
        WriteData = 32'd40;
        #10;

        // Read x1 and x2
        RegWrite = 0;
        rs1 = 5'd1;
        rs2 = 5'd2;
        #10;

        // Try writing 99 into x0
        RegWrite = 1;
        rd = 5'd0;
        WriteData = 32'd99;
        #10;

        // Read x0 and x1
        RegWrite = 0;
        rs1 = 5'd0;
        rs2 = 5'd1;
        #10;

        $display("x0 = %d", uut.registers[0]);
        $display("x1 = %d", uut.registers[1]);
        $display("x2 = %d", uut.registers[2]);
        $display("RD1 = %d", RD1);
        $display("RD2 = %d", RD2);

        $stop;
    end

endmodule