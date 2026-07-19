`timescale 1ns / 1ps

module tb_riscv_core;

    reg clk;
    reg reset;

    wire [31:0] PC_out;
    wire [31:0] Instr_out;
    wire [31:0] ALUResult_out;
    wire [31:0] WriteData_out;
    wire [31:0] ReadData_out;
    wire        MemWrite_out;
    wire        RegWrite_out;
    wire        PCSrc_out;

    riscv_core uut (
        .clk(clk),
        .reset(reset),
        .PC_out(PC_out),
        .Instr_out(Instr_out),
        .ALUResult_out(ALUResult_out),
        .WriteData_out(WriteData_out),
        .ReadData_out(ReadData_out),
        .MemWrite_out(MemWrite_out),
        .RegWrite_out(RegWrite_out),
        .PCSrc_out(PCSrc_out)
    );

    // Clock generation
    // Clock period = 10 ns
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;

        // Keep reset active for some time
        #12;
        reset = 0;

        // Run processor for enough cycles
        #400;

        // Display important final values
        $display("Final Register and Memory Values:");
        $display("x1 = %d", uut.reg_file_inst.registers[1]);
        $display("x2 = %d", uut.reg_file_inst.registers[2]);
        $display("x3 = %d", uut.reg_file_inst.registers[3]);
        $display("x4 = %d", uut.reg_file_inst.registers[4]);
        $display("x5 = %d", uut.reg_file_inst.registers[5]);
        $display("x6 = %d", uut.reg_file_inst.registers[6]);
        $display("mem[0] = %d", uut.data_mem_inst.mem[0]);
        $display("MAC RESULT_LO in x5 = %d", uut.reg_file_inst.registers[5]);
        $display("MAC DONE in x6      = %d", uut.reg_file_inst.registers[6]);
        $display("MAC ACTIVATION x7   = %d", uut.reg_file_inst.registers[7]);
        $display("MAC RESULT_HI in x8 = %d", uut.reg_file_inst.registers[8]);

        $display("Internal MAC result = %d", uut.data_mem_inst.result);
        $display("Internal MAC done   = %d", uut.data_mem_inst.done);
        $display("Activation output   = %d", uut.data_mem_inst.activation_out);
        $stop;
    end

endmodule