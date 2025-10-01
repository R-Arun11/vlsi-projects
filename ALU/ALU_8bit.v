module ALU_8bit(
	input [7:0] operand1, operand2,
	input [3:0] opcode,
	output reg [15:0] result,
	output reg flagC, flagZ
);

always@(*) begin
	case(opcode)
		4'b0000: begin 
			result = operand1 + operand2; //Addition
			flagC = result[8];
			flagZ = (result == 16'b0);
		end
		4'b0001: begin
			result = operand1 - operand2; //Subtraction
			flagC = result[8];
			flagZ = (result == 16'b0);
		end
		4'b0010: begin
			result = operand1 * operand2; //Multiplication
			flagZ = (result == 16'b0);
		end
		4'b0011: begin 
			result = operand1 / operand2; //Division
			flagZ = (result == 16'b0);
		end
		4'b0100: begin 
			result = operand1 << 1; //Logical Shift Left
			flagZ = (result == 16'b0);
		end
		4'b0101: begin 
			result = operand1 >> 1; //Logical Shift Right
			flagZ = (result == 16'b0);
		end
		4'b0110: begin 
			result = {operand1[6:0], operand1[7]}; //Rotate Left
			flagZ = (result == 16'b0);
		end
		4'b0111: begin
			result = {operand1[0], operand1[7:1]}; //Rotate Right
			flagZ = (result == 16'b0);
		end
		4'b1000: begin
			result = operand1 & operand2; //Logical And
			flagZ = (result == 16'b0);
		end
		4'b1001: begin
			result = operand1 | operand2; //Logical Or
			flagZ = (result == 16'b0);
		end
		4'b1010: begin
			result = operand1 ^ operand2; //Logical Xor
			flagZ = (result == 16'b0);
		end
		4'b1011: begin
			result = ~(operand1 & operand2); //Logical Nand
			flagZ = (result == 16'b0);
		end
		4'b1100: begin
			result = ~(operand1 | operand2); //Logical Nor
			flagZ = (result == 16'b0);
		end
		4'b1101: begin 
			result = ~(operand1 ^ operand2); //Logical Xnor
			flagZ = (result == 16'b0);
		end
		4'b1110: begin 
			result = (operand1 > operand2)? 16'b1: 16'b0; //Greater Comparison
			flagZ = (result == 16'b0);
		end
		4'b1111: begin
			result = (operand1 == operand2)? 16'b1: 16'b0; //Equal Comparison
		end
		default: begin
			result = 16'b0;
			flagC = 1'b0;
			flagZ = 1'b0;
		end
	endcase
end

endmodule