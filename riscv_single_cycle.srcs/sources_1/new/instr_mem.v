module instr_mem (
    input  [31:0] A,
    output [31:0] RD
);

    reg [31:0] mem [0:255];
    integer i;

    initial begin
        // Initialize all instruction memory locations with NOP
        // NOP = addi x0, x0, 0
        for (i = 0; i < 256; i = i + 1) begin
            mem[i] = 32'h00000013;
        end

        // -----------------------------------------------------
        // Memory-Mapped MAC / Neuron Test Program
        // -----------------------------------------------------
        // Goal:
        // Y = X0*W0 + X1*W1 + X2*W2 + X3*W3 + BIAS
        //
        // X0 = 2, W0 = 3
        // X1 = 4, W1 = 5
        // X2 = 1, W2 = 6
        // X3 = 3, W3 = 2
        // BIAS = 1
        //
        // Y = 2*3 + 4*5 + 1*6 + 3*2 + 1
        // Y = 6 + 20 + 6 + 6 + 1
        // Y = 39
        //
        // Memory Map:
        // 0x100 = START
        // 0x104 = DONE
        // 0x108 = RESULT_LO
        // 0x10C = RESULT_HI
        // 0x110 = X0
        // 0x114 = X1
        // 0x118 = X2
        // 0x11C = X3
        // 0x120 = W0
        // 0x124 = W1
        // 0x128 = W2
        // 0x12C = W3
        // 0x130 = BIAS
        // 0x134 = ACTIVATION_OUT
        // -----------------------------------------------------

        mem[0]  = 32'h00200093; // addi x1, x0, 2
        mem[1]  = 32'h10102823; // sw   x1, 0x110(x0)   X0 = 2

        mem[2]  = 32'h00400093; // addi x1, x0, 4
        mem[3]  = 32'h10102A23; // sw   x1, 0x114(x0)   X1 = 4

        mem[4]  = 32'h00100093; // addi x1, x0, 1
        mem[5]  = 32'h10102C23; // sw   x1, 0x118(x0)   X2 = 1

        mem[6]  = 32'h00300093; // addi x1, x0, 3
        mem[7]  = 32'h10102E23; // sw   x1, 0x11C(x0)   X3 = 3

        mem[8]  = 32'h00300093; // addi x1, x0, 3
        mem[9]  = 32'h12102023; // sw   x1, 0x120(x0)   W0 = 3

        mem[10] = 32'h00500093; // addi x1, x0, 5
        mem[11] = 32'h12102223; // sw   x1, 0x124(x0)   W1 = 5

        mem[12] = 32'h00600093; // addi x1, x0, 6
        mem[13] = 32'h12102423; // sw   x1, 0x128(x0)   W2 = 6

        mem[14] = 32'h00200093; // addi x1, x0, 2
        mem[15] = 32'h12102623; // sw   x1, 0x12C(x0)   W3 = 2

        mem[16] = 32'h00100093; // addi x1, x0, 1
        mem[17] = 32'h12102823; // sw   x1, 0x130(x0)   BIAS = 1

        mem[18] = 32'h00100093; // addi x1, x0, 1
        mem[19] = 32'h10102023; // sw   x1, 0x100(x0)   START = 1

        // Wait one instruction cycle
        mem[20] = 32'h00000013; // nop

        // Read MAC/neuron result
        mem[21] = 32'h10802283; // lw   x5, 0x108(x0)   x5 = RESULT_LO
        mem[22] = 32'h10402303; // lw   x6, 0x104(x0)   x6 = DONE
        mem[23] = 32'h13402383; // lw   x7, 0x134(x0)   x7 = ACTIVATION_OUT
        mem[24] = 32'h10C02403; // lw   x8, 0x10C(x0)   x8 = RESULT_HI

    end

    // PC is byte address, but memory is word address
    // PC = 0  -> mem[0]
    // PC = 4  -> mem[1]
    // PC = 8  -> mem[2]
    assign RD = mem[A[31:2]];

endmodule