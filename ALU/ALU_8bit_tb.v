module ALU_8bit_tb;
reg [7:0] operand1, operand2;
reg [3:0] opcode;
wire [15:0] result;
wire flagC, flagZ;

reg [3:0] count;

ALU_8bit uut (
	.operand1(operand1),
	.operand2(operand2),
	.opcode(opcode),
	.result(result),
	.flagC(flagC),
	.flagZ(flagZ)
);

initial begin
	opcode = 4'd0;
	operand1 = 8'd0;
	operand2 = 8'd0;
	
	#5;
	
	operand1 = 8'hAA;
	operand2 = 8'H55;

	for (count = 0; count < 16; count = count + 1'b1) begin
		opcode = count;
		#10;
	end

	$finish;

end

endmodule

