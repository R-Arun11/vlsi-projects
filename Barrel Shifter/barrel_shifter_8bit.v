// 8-bit Barrel Shifter
// Modes: 00 = LSL, 01 = RSL, 10 = ASL, 11 = ASR

module barrel_shifter_8bit #(parameter WIDTH = 8)(
	input [WIDTH-1:0] data_in,
	input [$clog2(WIDTH)-1:0] smt,
	input [1:0] mode,
	output [WIDTH-1:0] data_out
);

wire [WIDTH-1:0] stage0, stage1, stage2;

//stage0: Shift by 1
assign stage0 = (mode == 2'b00)? (smt[0]? {data_in[WIDTH-2:0], 1'b0} : data_in): //LSL
		(mode == 2'b01)? (smt[0]? {1'b0, data_in[WIDTH-1:1]} : data_in): //LSR
		(mode == 2'b10)? (smt[0]? {data_in[WIDTH-2:0], 1'b0} : data_in): //ASL (same as LSL)
		(smt[0]? {data_in[WIDTH-1], data_in[WIDTH-1:1]} : data_in);      //ASR
				
//stage1: Shift by 2
assign stage1 = (mode == 2'b00)? (smt[1]? {stage0[WIDTH-3:0], 2'b00} : stage0): //LSL
		(mode == 2'b01)? (smt[1]? {2'b00, stage0[WIDTH-1:2]} : stage0): //LSR
		(mode == 2'b10)? (smt[1]? {stage0[WIDTH-3:0], 2'b00} : stage0): //ASL (same as LSL)
				 (smt[1]? {{2{stage0[WIDTH-1]}}, stage0[WIDTH-1:2]} : stage0);   //ASR
				
//stage2: Shift by 4
assign stage2 = (mode == 2'b00)? (smt[2]? {stage1[WIDTH-5:0], 4'b0000} : stage1): //LSL
		(mode == 2'b01)? (smt[2]? {4'b0000, stage1[WIDTH-1:4]} : stage1): //LSR
		(mode == 2'b10)? (smt[2]? {stage1[WIDTH-5:0], 4'b0000} : stage1): //ASL (same as LSL)
				 (smt[2]? {{4{stage1[WIDTH-1]}}, stage1[WIDTH-1:4]} : stage1);   //ASR
				
assign data_out = stage2;

endmodule
