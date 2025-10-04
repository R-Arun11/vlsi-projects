module wallace_4x4_pipelined_tb;

    reg clk, rst;
    reg [3:0] a, b;
    reg [3:0] a_reg, b_reg;
    wire [7:0] prod;

    //Instantiate the pipelined Wallace multiplier
    wallace_4x4_pipelined uut (
        .clk(clk),
        .rst(rst),
        .a(a),
        .b(b),
        .prod(prod)
    );

    //Clock generation: 10 ps period
    initial clk = 0;
    always #5 clk = ~clk;

    //Pipeline delay queue: holds expected values
    reg [7:0] expected_queue[0:2];

    //Counters
    integer i = 0, j = 0, cycle = 0;

    initial begin
        
        a = 0; b = 0;
        a_reg = 0; b_reg = 0;
        rst = 1;

        expected_queue[0] = 0;
        expected_queue[1] = 0;
        expected_queue[2] = 0;

        #12 rst = 0; //Release reset after some time

        $display("Cycle |  a   b  | prod  | expected | PASS/FAIL");
        $display("----------------------------------------------");
    end

    //Test logic runs on clock
    always @(posedge clk) begin
        if (!rst) begin
            // Shift the expected results
            expected_queue[0] <= expected_queue[1];
            expected_queue[1] <= expected_queue[2];
            expected_queue[2] <= a * b;

            //Update the display registers for a and b
            a_reg <= a;
            b_reg <= b;

            //Apply next inputs
            a <= i[3:0];
            b <= j[3:0];

            //Print result after pipeline latency
            if (cycle >= 3) begin
                $display(" %3d  | %2d  %2d |  %3d   |   %3d    | %s",
                    cycle, a_reg, b_reg, prod, expected_queue[0],
                    (prod == expected_queue[0]) ? "PASS" : "FAIL");
            end

            // Move to next input pair
            if (j < 15) begin
                j = j + 1;
            end 
			else begin
                j = 0;
                i = i + 1;
            end

            // End simulation after all input combinations + flush
            if (i == 16 && j == 0 && cycle > 20) begin
                $display("Testbench completed.");
                $finish;
            end

            cycle = cycle + 1;
        end
    end

endmodule

