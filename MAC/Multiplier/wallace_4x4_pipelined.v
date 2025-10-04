module wallace_4x4_pipelined (
    input clk,
    input rst,
    input [3:0] a, b,
    output reg [7:0] prod
);

    //Stage 1: Partial Products
    reg [3:0] pp0_reg, pp1_reg, pp2_reg, pp3_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pp0_reg <= 0;
            pp1_reg <= 0;
            pp2_reg <= 0;
            pp3_reg <= 0;
        end else begin
            pp0_reg <= a & {4{b[0]}};
            pp1_reg <= a & {4{b[1]}};
            pp2_reg <= a & {4{b[2]}};
            pp3_reg <= a & {4{b[3]}};
        end
    end

    //Stage 2: Wallace Tree Reduction
    wire s1, s2, s3, s4, s5, s6;
    wire c1, c2, c3, c4, c5, c6;

    half_adder ha1(pp0_reg[2], pp1_reg[1], s1, c1);
    full_adder fa1(pp0_reg[3], pp1_reg[2], pp2_reg[1], s2, c2);
    full_adder fa2(pp1_reg[3], pp2_reg[2], pp3_reg[1], s3, c3);
    half_adder ha2(s2, pp3_reg[0], s4, c4);
    half_adder ha3(s3, c2, s5, c5);
    full_adder fa3(pp2_reg[3], pp3_reg[2], c3, s6, c6);

    // Registers after Wallace Tree
    reg [7:0] rowA_reg, rowB_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            rowA_reg <= 0;
            rowB_reg <= 0;
        end else begin
            rowA_reg <= {1'b0, pp3_reg[3], s6, s5, s4, s1, pp0_reg[1], pp0_reg[0]};
            rowB_reg <= {1'b0, c6, c5, c4, c1, pp2_reg[0], pp1_reg[0], 1'b0};
        end
    end

    //Stage 3: Final CLA Addition
    wire [7:0] sum;
    wire cout;

    cla_8bit cla_final(
        .a(rowA_reg),
        .b(rowB_reg),
        .cin(1'b0),
        .sum(sum),
        .cout(cout)
    );

    always @(posedge clk or posedge rst) begin
        if (rst)
            prod <= 8'b0;
        else
            prod <= sum;
    end

endmodule

