module mac_4x4 (
    input clk,
    input rst,
    input en,                   // enable new multiply-accumulate
    input [3:0] a, b,           // 4-bit inputs
    output reg [15:0] mac_out  // Accumulator output
);

    wire [7:0] product;

    // Instantiate pipelined multiplier
    wallace_4x4_pipelined mul (
        .clk(clk),
        .rst(rst),
        .a(a),
        .b(b),
        .prod(product)
    );

    // Pipeline delay tracking
    reg [2:0] valid_shift;
    always @(posedge clk) begin
        if (rst) begin
            valid_shift <= 3'b000;
        end else begin
            valid_shift <= {valid_shift[1:0], en};  // Delay enable signal to align with multiplier
        end
    end

    // Accumulate the product after 3 cycles (multiplier latency)
    always @(posedge clk) begin
        if (rst) begin
            mac_out <= 0;
        end else if (valid_shift[2]) begin
            mac_out <= mac_out + product;
        end
    end

endmodule

