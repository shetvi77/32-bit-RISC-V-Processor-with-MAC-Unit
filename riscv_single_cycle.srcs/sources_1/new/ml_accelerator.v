module ml_accelerator (
    input clk,
    input reset,
    input MemWrite,
    input [31:0] A,
    input [31:0] WD,
    output reg [31:0] RD
);

    reg signed [31:0] X0, X1, X2, X3;
    reg signed [31:0] W0, W1, W2, W3;
    reg signed [31:0] BIAS;

    reg signed [63:0] result;
    reg done;
    reg activation_out;

    wire signed [63:0] mac_result;

    assign mac_result = ($signed(X0) * $signed(W0)) +
                        ($signed(X1) * $signed(W1)) +
                        ($signed(X2) * $signed(W2)) +
                        ($signed(X3) * $signed(W3)) +
                        $signed(BIAS);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            X0 <= 32'sd0;
            X1 <= 32'sd0;
            X2 <= 32'sd0;
            X3 <= 32'sd0;

            W0 <= 32'sd0;
            W1 <= 32'sd0;
            W2 <= 32'sd0;
            W3 <= 32'sd0;

            BIAS <= 32'sd0;
            result <= 64'sd0;
            done <= 1'b0;
            activation_out <= 1'b0;
        end
        else begin
            if (MemWrite) begin
                case (A)

                    32'h00000100: begin
                        if (WD[0] == 1'b1) begin
                            result <= mac_result;
                            done <= 1'b1;

                            if (mac_result >= 0)
                                activation_out <= 1'b1;
                            else
                                activation_out <= 1'b0;
                        end
                    end

                    32'h00000110: X0 <= WD;
                    32'h00000114: X1 <= WD;
                    32'h00000118: X2 <= WD;
                    32'h0000011C: X3 <= WD;

                    32'h00000120: W0 <= WD;
                    32'h00000124: W1 <= WD;
                    32'h00000128: W2 <= WD;
                    32'h0000012C: W3 <= WD;

                    32'h00000130: BIAS <= WD;

                    default: begin
                    end

                endcase
            end
        end
    end

    always @(*) begin
        case (A)

            32'h00000104: RD = {31'b0, done};
            32'h00000108: RD = result[31:0];
            32'h0000010C: RD = result[63:32];

            32'h00000110: RD = X0;
            32'h00000114: RD = X1;
            32'h00000118: RD = X2;
            32'h0000011C: RD = X3;

            32'h00000120: RD = W0;
            32'h00000124: RD = W1;
            32'h00000128: RD = W2;
            32'h0000012C: RD = W3;

            32'h00000130: RD = BIAS;
            32'h00000134: RD = {31'b0, activation_out};

            default: RD = 32'b0;

        endcase
    end

endmodule