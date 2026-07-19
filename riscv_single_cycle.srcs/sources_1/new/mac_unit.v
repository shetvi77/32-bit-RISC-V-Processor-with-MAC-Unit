module mac_unit (
    input clk,
    input reset,
    input start,
    input clear,

    input signed [31:0] input_data,
    input signed [31:0] weight,

    output reg signed [63:0] acc_out,
    output reg done
);

    wire signed [63:0] product;

    assign product = $signed(input_data) * $signed(weight);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            acc_out <= 64'sd0;
            done    <= 1'b0;
        end
        else begin
            done <= 1'b0;

            if (clear) begin
                acc_out <= 64'sd0;
                done    <= 1'b0;
            end
            else if (start) begin
                acc_out <= acc_out + product;
                done    <= 1'b1;
            end
        end
    end

endmodule