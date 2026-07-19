module riscv_core (
    input clk,
    input reset,

    // Debug outputs for waveform checking
    output [31:0] PC_out,
    output [31:0] Instr_out,
    output [31:0] ALUResult_out,
    output [31:0] WriteData_out,
    output [31:0] ReadData_out,
    output        MemWrite_out,
    output        RegWrite_out,
    output        PCSrc_out
);

    // Program Counter wires
    wire [31:0] PC;
    wire [31:0] PCNext;
    wire [31:0] PCPlus4;
    wire [31:0] PCTarget;

    // Instruction wire
    wire [31:0] Instr;

    // Register fields
    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [4:0] rd;

    // Register file wires
    wire [31:0] RD1;
    wire [31:0] RD2;
    wire [31:0] WriteData;

    // Immediate wire
    wire [31:0] ImmExt;

    // Control signals
    wire       RegWrite;
    wire [1:0] ImmSrc;
    wire       ALUSrc;
    wire       MemWrite;
    wire [1:0] ResultSrc;
    wire       Branch;
    wire [1:0] ALUOp;

    // ALU control and ALU wires
    wire [2:0] ALUControl;
    wire [31:0] SrcB;
    wire [31:0] ALUResult;
    wire Zero;

    // Memory and MAC read wires
    wire [31:0] ReadData;
    wire [31:0] DataMemReadData;
    wire [31:0] MACReadData;

    // Address decoder wires
    wire mac_sel;
    wire data_mem_write;
    wire mac_write;

    // Branch decision
    wire PCSrc;

    // Extract instruction fields
    assign rs1 = Instr[19:15];
    assign rs2 = Instr[24:20];
    assign rd  = Instr[11:7];

    // PC logic
    assign PCPlus4  = PC + 32'd4;
    assign PCTarget = PC + ImmExt;
    assign PCSrc    = Branch & Zero;
    assign PCNext   = PCSrc ? PCTarget : PCPlus4;

    // MAC address range: 0x100 to 0x134
    assign mac_sel = (ALUResult >= 32'h00000100) && (ALUResult <= 32'h00000134);

    assign data_mem_write = MemWrite & ~mac_sel;
    assign mac_write      = MemWrite & mac_sel;

    // Read data mux
    assign ReadData = mac_sel ? MACReadData : DataMemReadData;

    // ALU second input MUX
    assign SrcB = ALUSrc ? ImmExt : RD2;

    // Write-back MUX
    assign WriteData = (ResultSrc == 2'b00) ? ALUResult :
                       (ResultSrc == 2'b01) ? ReadData  :
                       (ResultSrc == 2'b10) ? ImmExt    :
                       ALUResult;

    // Program Counter
    pc pc_inst (
        .clk(clk),
        .reset(reset),
        .PCNext(PCNext),
        .PC(PC)
    );

    // Instruction Memory
    instr_mem instr_mem_inst (
        .A(PC),
        .RD(Instr)
    );

    // Register File
    reg_file reg_file_inst (
        .clk(clk),
        .RegWrite(RegWrite),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .WriteData(WriteData),
        .RD1(RD1),
        .RD2(RD2)
    );

    // Immediate Generator
    imm_gen imm_gen_inst (
        .Instr(Instr),
        .ImmSrc(ImmSrc),
        .ImmExt(ImmExt)
    );

    // Main Control Unit
    control_unit control_unit_inst (
        .opcode(Instr[6:0]),
        .RegWrite(RegWrite),
        .ImmSrc(ImmSrc),
        .ALUSrc(ALUSrc),
        .MemWrite(MemWrite),
        .ResultSrc(ResultSrc),
        .Branch(Branch),
        .ALUOp(ALUOp)
    );

    // ALU Control Unit
    alu_control alu_control_inst (
        .ALUOp(ALUOp),
        .funct3(Instr[14:12]),
        .funct7_5(Instr[30]),
        .ALUControl(ALUControl)
    );

    // ALU
    alu alu_inst (
        .A(RD1),
        .B(SrcB),
        .ALUControl(ALUControl),
        .Result(ALUResult),
        .Zero(Zero)
    );

    // Normal Data Memory
    data_mem data_mem_inst (
        .clk(clk),
        .MemWrite(data_mem_write),
        .A(ALUResult),
        .WD(RD2),
        .RD(DataMemReadData)
    );

    // Separate Memory-Mapped MAC / ML Accelerator
    ml_accelerator ml_accelerator_inst (
        .clk(clk),
        .reset(reset),
        .MemWrite(mac_write),
        .A(ALUResult),
        .WD(RD2),
        .RD(MACReadData)
    );

    // Debug output assignments
    assign PC_out        = PC;
    assign Instr_out     = Instr;
    assign ALUResult_out = ALUResult;
    assign WriteData_out = WriteData;
    assign ReadData_out  = ReadData;
    assign MemWrite_out  = MemWrite;
    assign RegWrite_out  = RegWrite;
    assign PCSrc_out     = PCSrc;

endmodule