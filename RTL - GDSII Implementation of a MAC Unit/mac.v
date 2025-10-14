module mac_8x8 (
    input clk,
    input rst,
    input en,                   // enable new multiply-accumulate
    input [7:0] A, B,           // 8-bit inputs
    output reg [31:0] mac_out  // Accumulator output
);

    wire [15:0] Result;

    // Instantiate pipelined multiplier
    dedda_8x8 mul (.clk(clk), .rst(rst), .A(A), .B(B), .Result(Result));

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
            mac_out <= mac_out + Result;
        end
    end

endmodule

module dedda_8x8 (
	input clk, rst,
	input [7:0] A, B,
	output reg [15:0] Result
);
	
	// Stage 1: Partial Products
	reg [7:0] PP0, PP1, PP2, PP3, PP4, PP5, PP6, PP7;

	always @(posedge clk or posedge rst) begin
        if (rst) begin
            PP0 <= 0;
			PP1 <= 0;
			PP2 <= 0;
			PP3 <= 0;
			PP4 <= 0;
			PP5 <= 0;
			PP6 <= 0;
			PP7 <= 0;
        end 
		else begin
            PP0 <= A & {8{B[0]}};
			PP1 <= A & {8{B[1]}};
			PP2 <= A & {8{B[2]}};
			PP3 <= A & {8{B[3]}};
			PP4 <= A & {8{B[4]}};
			PP5 <= A & {8{B[5]}};
			PP6 <= A & {8{B[6]}};
			PP7 <= A & {8{B[7]}};
        end
    end

	// Stage 2: Dedda Tree Reduction
	
	// Intermediate wires for Dedda Tree Reduction
	wire s11, c11, s12, c12, s13, c13, s14, c14;
	wire s21, c21, s22, c22;
	wire s31, c31, s32, c32, s33, c33, s34, c34, s35, c35, s36, c36, s37, c37, s38, c38;
	wire s41, c41, s42, c42, s43, c43, s44, c44, s45, c45, s46, c46;
	wire s51, c51, s52, c52, s53, c53, s54, c54, s55, c55, s56, c56, s57, c57, s58, c58, s59, c59, s510, c510;
	wire s61, c61, s62, c62, s63, c63, s64, c64, s65, c65, s66, c66, s67, c67, s68, c68, s69, c69, s610, c610, s611, c611, s612, c612;

	//Level 1
	half_adder h1(PP0[6],PP1[5],s11,c11);
	full_adder f1(PP0[7],PP1[6],PP2[5],s12,c12);
	full_adder f2(PP1[7],PP2[6],PP3[5],s13,c13);
	full_adder f3(PP2[7],PP3[6],PP4[5],s14,c14);

	half_adder h2(PP3[4],PP4[3],s21,c21);
	half_adder h3(PP4[4],PP5[3],s22,c22);	

	//Level 2
	half_adder h4(PP0[4],PP1[3],s31,c31);
	full_adder f4(PP0[5],PP1[4],PP2[3],s32,c32);
	full_adder f5(s11,PP2[4],PP3[3],s33,c33);
	full_adder f6(s12,c11,s21,s34,c34);
	full_adder f7(s13,c12,s22,s35,c35);
	full_adder f8(s14,c13,c22,s36,c36);
	full_adder f9(c14,PP3[7],PP4[6],s37,c37);
	full_adder f10(PP4[7],PP5[6],PP6[5],s38,c38);
	
	half_adder h5(PP3[2],PP4[1],s41,c41);
	full_adder f11(PP4[2],PP5[1],PP6[0],s42,c42);
	full_adder f12(PP5[2],PP6[1],PP7[0],s43,c43);
	full_adder f13(c21,PP6[2],PP7[1],s44,c44);
	full_adder f14(PP5[4],PP6[3],PP7[2],s45,c45);
	full_adder f15(PP5[5],PP6[4],PP7[3],s46,c46);
	
	//Level 3
	half_adder h6(PP0[3],PP1[2],s51,c51);
	full_adder f16(s31,PP2[2],PP3[1],s52,c52);
	full_adder f17(s32,c31,s41,s53,c53);
	full_adder f18(s33,c32,c41,s54,c54);
	full_adder f19(s34,c33,c42,s55,c55);
	full_adder f20(s35,c34,c43,s56,c56);
	full_adder f21(s36,c35,c44,s57,c57);
	full_adder f22(s37,c36,c45,s58,c58);
	full_adder f23(s38,c37,PP7[4],s59,c59);
	full_adder f24(c38,PP5[7],PP6[6],s510,c510);
	
	//Level 4
	half_adder h7(PP0[2],PP1[1],s61,c61);
	full_adder f25(s51,PP2[1],PP3[0],s62,c62);
	full_adder f26(s52,c51,PP4[0],s63,c63);
	full_adder f27(s53,c52,PP5[0],s64,c64);
	full_adder f28(s54,c53,s42,s65,c65);
	full_adder f29(s55,c54,s43,s66,c66);
	full_adder f30(s56,c55,s44,s67,c67);
	full_adder f31(s57,c56,s45,s68,c68);
	full_adder f32(s58,c57,s46,s69,c69);
	full_adder f33(s59,c58,c46,s610,c610);
	full_adder f34(s510,c59,PP7[5],s611,c611);
	full_adder f35(c510,PP7[6],PP6[7],s612,c612);
	
	// Registers after Dedda Tree
    reg [15:0] rowA, rowB;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            rowA <= 0;
            rowB <= 0;
        end 
		else begin
            rowA <= {1'b0, PP7[7], s612, s611, s610, s69, s68, s67, s66, s65, s64, s63, s62, s61, PP0[1], PP0[0]};
            rowB <= {1'b0, c612, c611, c610, c69, c68, c67, c66, c65, c64, c63, c62, c61, PP2[0], PP1[0], 1'b0};
        end
    end
	
	// Stage 3: Final CLA Addition
    wire [15:0] Sum;
    wire Cout;

    cla_16bit cla_final(.A(rowA), .B(rowB), .Cin(1'b0), .Sum(Sum), .Cout(Cout)); 

    always @(posedge clk or posedge rst) begin
        if (rst)
            Result <= 16'b0;
        else
            Result <= Sum;
    end

endmodule

module cla_16bit (
    input  [15:0] A, B,
    input Cin,
    output [15:0] Sum,
    output Cout
);

    wire [15:0] G, P;  // Generate and Propagate
    wire [15:0] C;     // Internal carry signals

    // Generate and Propagate
    assign G = A & B;
    assign P = A ^ B;

    // Carry Lookahead Logic
    assign C[0] = Cin;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & (G[0] | (P[0] & C[0])));
    assign C[3] = G[2] | (P[2] & (G[1] | (P[1] & (G[0] | (P[0] & C[0])))));
    assign C[4] = G[3] | (P[3] & (G[2] | (P[2] & (G[1] | (P[1] & (G[0] | (P[0] & C[0])))))));
    assign C[5] = G[4] | (P[4] & (G[3] | (P[3] & (G[2] | (P[2] & (G[1] | (P[1] & (G[0] | (P[0] & C[0])))))))));
    assign C[6] = G[5] | (P[5] & (G[4] | (P[4] & (G[3] | (P[3] & (G[2] | (P[2] & (G[1] | (P[1] & (G[0] | (P[0] & C[0])))))))))));
    assign C[7] = G[6] | (P[6] & (G[5] | (P[5] & (G[4] | (P[4] & (G[3] | (P[3] & (G[2] | (P[2] & (G[1] | (P[1] & (G[0] | (P[0] & C[0])))))))))))));
    assign C[8] = G[7] | (P[7] & (G[6] | (P[6] & (G[5] | (P[5] & (G[4] | (P[4] & (G[3] | (P[3] & (G[2] | (P[2] & (G[1] | (P[1] & (G[0] | (P[0] & C[0])))))))))))))));
    assign C[9] = G[8] | (P[8] & (G[7] | (P[7] & (G[6] | (P[6] & (G[5] | (P[5] & (G[4] | (P[4] & (G[3] | (P[3] & (G[2] | (P[2] & (G[1] | (P[1] & (G[0] | (P[0] & C[0])))))))))))))))));
    assign C[10] = G[9] | (P[9] & (G[8] | (P[8] & (G[7] | (P[7] & (G[6] | (P[6] & (G[5] | (P[5] & (G[4] | (P[4] & (G[3] | (P[3] & (G[2] | (P[2] & (G[1] | (P[1] & (G[0] | (P[0] & C[0])))))))))))))))))));
    assign C[11] = G[10] | (P[10] & (G[9] | (P[9] & (G[8] | (P[8] & (G[7] | (P[7] & (G[6] | (P[6] & (G[5] | (P[5] & (G[4] | (P[4] & (G[3] | (P[3] & (G[2] | (P[2] & (G[1] | (P[1] & (G[0] | (P[0] & C[0])))))))))))))))))))));
    assign C[12] = G[11] | (P[11] & (G[10] | (P[10] & (G[9] | (P[9] & (G[8] | (P[8] & (G[7] | (P[7] & (G[6] | (P[6] & (G[5] | (P[5] & (G[4] | (P[4] & (G[3] | (P[3] & (G[2] | (P[2] & (G[1] | (P[1] & (G[0] | (P[0] & C[0])))))))))))))))))))))));
    assign C[13] = G[12] | (P[12] & (G[11] | (P[11] & (G[10] | (P[10] & (G[9] | (P[9] & (G[8] | (P[8] & (G[7] | (P[7] & (G[6] | (P[6] & (G[5] | (P[5] & (G[4] | (P[4] & (G[3] | (P[3] & (G[2] | (P[2] & (G[1] | (P[1] & (G[0] | (P[0] & C[0])))))))))))))))))))))))));
    assign C[14] = G[13] | (P[13] & (G[12] | (P[12] & (G[11] | (P[11] & (G[10] | (P[10] & (G[9] | (P[9] & (G[8] | (P[8] & (G[7] | (P[7] & (G[6] | (P[6] & (G[5] | (P[5] & (G[4] | (P[4] & (G[3] | (P[3] & (G[2] | (P[2] & (G[1] | (P[1] & (G[0] | (P[0] & C[0])))))))))))))))))))))))))));
    assign C[15] = G[14] | (P[14] & (G[13] | (P[13] & (G[12] | (P[12] & (G[11] | (P[11] & (G[10] | (P[10] & (G[9] | (P[9] & (G[8] | (P[8] & (G[7] | (P[7] & (G[6] | (P[6] & (G[5] | (P[5] & (G[4] | (P[4] & (G[3] | (P[3] & (G[2] | (P[2] & (G[1] | (P[1] & (G[0] | (P[0] & C[0])))))))))))))))))))))))))))));
	
    // Final Carry Out
    assign Cout = G[15] | (P[15] & (G[14] | (P[14] & (G[13] | (P[13] & (G[12] | (P[12] & (G[11] | (P[11] & (G[10] | (P[10] & (G[9] | (P[9] & (G[8] | (P[8] & (G[7] | (P[7] & (G[6] | (P[6] & (G[5] | (P[5] & (G[4] | (P[4] & (G[3] | (P[3] & (G[2] | (P[2] & (G[1] | (P[1] & (G[0] | (P[0] & C[0])))))))))))))))))))))))))))))));
	
    // FInal Sum
    assign Sum = P ^ C;
	
endmodule

module full_adder (
    input  A,
    input  B,
    input  Cin,
    output Sum,
    output Cout
);
    assign Sum  = A ^ B ^ Cin; // Sum is XOR of inputs and carry-in
    assign Cout = (A & B) | (B & Cin) | (A & Cin); // Carry-out logic
endmodule

module half_adder (
    input  A,
    input  B,
    output Sum,
    output Cout
);
    assign Sum  = A ^ B;   // XOR for sum
    assign Cout = A & B;   // AND for carry
endmodule